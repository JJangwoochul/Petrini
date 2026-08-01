/**
 * 역할: MypageReserveService 구현체 (@Service)
 *
 * 2026/07/11 장우철 — 마이페이지 예약 목록·상세 (2차)
 */

package com.petcare.petcare.mypage.reserve.service;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.common.external.service.TossPaymentService;
import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.mypage.reserve.mapper.MypageReserveMapper;
import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;
import com.petcare.petcare.stay.service.StayCancelFeeCalculator;
import com.petcare.petcare.stay.vo.StayReviewVO;

@Service
public class MypageReserveServiceImpl implements MypageReserveService {

    @Autowired
    private MypageReserveMapper mypageReserveMapper;
    @Autowired
    private MypageNotifyService mypageNotifyService;
    @Autowired
    private TossPaymentService tossPaymentService;

    @Override
    @Transactional(readOnly = true)
    public List<MypageReserveVO> getMyReservationList(Long memberNo, String statusFilter, String typeFilter) {
        if (memberNo == null) {
            return Collections.emptyList();
        }
        // 2026/07/21 장우철 — 상태·유형 필터 정규화 (all/빈값 → null)
        String status = (statusFilter == null || statusFilter.isBlank() || "all".equalsIgnoreCase(statusFilter))
                ? null : statusFilter.trim().toLowerCase();
        String type = (typeFilter == null || typeFilter.isBlank() || "all".equalsIgnoreCase(typeFilter))
                ? null : typeFilter.trim().toLowerCase();
        if (type != null && !"hospital".equals(type) && !"stay".equals(type)) {
            type = null;
        }
        return mypageReserveMapper.selectMyReservationList(memberNo, status, type);
    }

    @Override
    @Transactional(readOnly = true)
    public MypageReserveVO getMyReservationDetail(Long memberNo, Long resvId) {
        if (memberNo == null || resvId == null) {
            return null;
        }
        MypageReserveVO detail = mypageReserveMapper.selectMyReservationDetail(memberNo, resvId);
        if (detail != null) {
            fillStayCancelPreview(detail);
        }
        return detail;
    }

    /** 2026/07/31 장우철 — CONFIRMED 숙소면 취소 수수료 미리보기 채움 */
    private void fillStayCancelPreview(MypageReserveVO detail) {
        if (!"STAY".equalsIgnoreCase(detail.getResvType())
                || !"CONFIRMED".equalsIgnoreCase(detail.getStatusCd())
                || detail.getCheckinDate() == null) {
            detail.setCancelable(false);
            return;
        }
        try {
            StayCancelFeeCalculator.Result fee =
                    StayCancelFeeCalculator.calculate(detail.getTotalAmount(), detail.getCheckinDate());
            detail.setCancelable(true);
            detail.setDaysUntilCheckin(fee.getDaysUntilCheckin());
            detail.setCancelFeeRatePercent(fee.getFeeRatePercent());
            detail.setCancelFeeTierLabel(fee.getTierLabel());
            detail.setCancelFeeAmt(fee.getCancelFeeAmt());
            detail.setRefundAmt(fee.getRefundAmt());
        } catch (IllegalStateException | IllegalArgumentException e) {
            detail.setCancelable(false);
        }
    }

    // 2026/07/31 장우철 — 유저 숙소 취소 (1-4) + 위약금(1-6)
    @Override
    @Transactional
    public void cancelStayReservation(Long memberNo, Long resvId, String cancelReason) {
        if (memberNo == null || resvId == null) {
            throw new IllegalArgumentException("예약 정보가 올바르지 않습니다.");
        }
        if (cancelReason == null || cancelReason.isBlank()) {
            throw new IllegalArgumentException("취소 사유를 입력해 주세요.");
        }
        String reason = cancelReason.trim();
        if (reason.length() > 500) {
            reason = reason.substring(0, 500);
        }

        MypageReserveVO detail = mypageReserveMapper.selectMyReservationDetail(memberNo, resvId);
        if (detail == null) {
            throw new IllegalStateException("예약을 찾을 수 없습니다.");
        }
        if (!"STAY".equalsIgnoreCase(detail.getResvType())) {
            throw new IllegalStateException("숙소 예약만 취소할 수 있습니다.");
        }
        if (!"CONFIRMED".equalsIgnoreCase(detail.getStatusCd())) {
            throw new IllegalStateException("예약확정 상태에서만 취소할 수 있습니다.");
        }

        StayCancelFeeCalculator.Result fee =
                StayCancelFeeCalculator.calculate(detail.getTotalAmount(), detail.getCheckinDate());

        // 1) 토스 부분/전액 환불 (환불액 0이면 스킵)
        if (fee.getRefundAmt() > 0) {
            Map<String, Object> payment = mypageReserveMapper.selectDonePaymentByResvId(resvId);
            if (payment != null && payment.get("tossPaymentKey") != null) {
                String paymentKey = String.valueOf(payment.get("tossPaymentKey"));
                // POINT_ONLY 등 비토스 키는 API 호출 스킵
                if (!paymentKey.startsWith("POINT") && !paymentKey.isBlank()
                        && !paymentKey.startsWith("BILLING-")) {
                    long payAmount = 0L;
                    Object payAmtObj = payment.get("payAmount");
                    if (payAmtObj instanceof Number) {
                        payAmount = ((Number) payAmtObj).longValue();
                    }
                    long refundAmt = fee.getRefundAmt();
                    // 전액 환불이면 cancelAmount 생략 (토스 전액취소)
                    Long cancelAmountParam = (payAmount > 0 && refundAmt >= payAmount)
                            ? null
                            : refundAmt;
                    // 2026/08/01 장우철 — BILLING 결제는 billing secret 으로 취소
                    String payMethod = payment.get("payMethod") != null
                            ? String.valueOf(payment.get("payMethod")) : null;
                    boolean billing = TossPaymentService.isBillingPayMethod(payMethod);
                    String tossError = tossPaymentService.cancelPayment(
                            paymentKey, "숙소 예약 취소", cancelAmountParam, billing);
                    if (tossError != null) {
                        throw new IllegalStateException(tossError);
                    }
                }
                mypageReserveMapper.updatePaymentRefundByResvId(resvId, fee.getRefundAmt());
            }
        }

        // 2) 예약 CANCEL + 위약금/환불액 저장
        int updated = mypageReserveMapper.updateStayUserCancel(
                resvId, memberNo, reason, fee.getCancelFeeAmt(), fee.getRefundAmt());
        if (updated == 0) {
            throw new IllegalStateException("예약을 취소할 수 없습니다. 상태를 확인해 주세요.");
        }

        // 3) 알림 (본인)
        String stayName = detail.getHospitalName() != null ? detail.getHospitalName() : "숙소";
        mypageNotifyService.sendReserveCancelNotification(
                memberNo, stayName, detail.getCheckinDate(), null, reason, resvId);
    }

    // 2026/07/13 장우철 — DONE + 미작성 예약만 병원 리뷰 INSERT 후 평점 갱신
    @Override
    @Transactional
    public void addHospitalReview(Long memberNo, Long resvId, Double rating, String content) {
        if (memberNo == null || resvId == null) {
            throw new IllegalArgumentException("리뷰 정보가 올바르지 않습니다.");
        }
        if (rating == null || rating < 1.0 || rating > 5.0) {
            throw new IllegalArgumentException("별점은 1~5점이어야 합니다.");
        }
        if (content == null || content.isBlank()) {
            throw new IllegalArgumentException("리뷰 내용을 입력해 주세요.");
        }

        MypageReserveVO detail = mypageReserveMapper.selectMyReservationDetail(memberNo, resvId);
        if (detail == null) {
            throw new IllegalStateException("예약을 찾을 수 없습니다.");
        }
        if (!"DONE".equalsIgnoreCase(detail.getStatusCd())) {
            throw new IllegalStateException("진료완료된 예약만 리뷰를 작성할 수 있습니다.");
        }
        if ("Y".equalsIgnoreCase(detail.getReviewedYn())
                || mypageReserveMapper.countHospitalReviewByResvId(resvId, memberNo) > 0) {
            throw new IllegalStateException("이미 리뷰를 작성한 예약입니다.");
        }
        if (detail.getTargetId() == null || detail.getTargetId().isBlank()) {
            throw new IllegalStateException("병원 정보가 없습니다.");
        }

        Long hospitalId = Long.parseLong(detail.getTargetId());
        HospitalReviewVO review = new HospitalReviewVO();
        review.setTargetId(hospitalId);
        review.setMemberNo(memberNo);
        review.setResvId(resvId);
        review.setRating(rating);
        review.setContent(content.trim());

        mypageReserveMapper.insertHospitalReview(review);
        mypageReserveMapper.updateHospitalRatingSummary(hospitalId);

        // 2026/07/13 장우철 — 사업자에게 리뷰 등록 알림
        Long bizMemberNo = mypageReserveMapper.selectHospitalMemberNo(hospitalId);
        String nickname = mypageReserveMapper.selectMemberNickname(memberNo);
        mypageNotifyService.sendHospitalReviewToBizNotification(
                bizMemberNo, detail.getHospitalName(), nickname, rating, resvId);
    }

    // HYJ 26.07.20 — DONE + 미작성 예약만 숙소 리뷰 INSERT
    @Override
    @Transactional
    public void addStayReview(Long memberNo, Long resvId, Double rating, String content) {
        if (memberNo == null || resvId == null) {
            throw new IllegalArgumentException("리뷰 정보가 올바르지 않습니다.");
        }
        if (rating == null || rating < 1.0 || rating > 5.0) {
            throw new IllegalArgumentException("별점은 1~5점이어야 합니다.");
        }
        if (content == null || content.isBlank()) {
            throw new IllegalArgumentException("리뷰 내용을 입력해 주세요.");
        }

        MypageReserveVO detail = mypageReserveMapper.selectMyReservationDetail(memberNo, resvId);
        if (detail == null) {
            throw new IllegalStateException("예약을 찾을 수 없습니다.");
        }
        if (!"DONE".equalsIgnoreCase(detail.getStatusCd())) {
            throw new IllegalStateException("숙박 완료된 예약만 리뷰를 작성할 수 있습니다.");
        }
        if (!"STAY".equalsIgnoreCase(detail.getResvType())) {
            throw new IllegalStateException("숙소 예약이 아닙니다.");
        }
        if ("Y".equalsIgnoreCase(detail.getReviewedYn())
                || mypageReserveMapper.countStayReviewByResvId(resvId, memberNo) > 0) {
            throw new IllegalStateException("이미 리뷰를 작성한 예약입니다.");
        }
        if (detail.getTargetId() == null || detail.getTargetId().isBlank()) {
            throw new IllegalStateException("숙소 정보가 없습니다.");
        }

        Long stayId = Long.parseLong(detail.getTargetId());
        StayReviewVO review = new StayReviewVO();
        review.setTargetId(stayId);
        review.setMemberNo(memberNo);
        review.setResvId(resvId);
        review.setRating(rating);
        review.setContent(content.trim());

        // 1. 리뷰 INSERT
        mypageReserveMapper.insertStayReview(review);

        // 2. 포인트 적립 — 결제 금액의 3% (소수점 버림)
        if (detail.getTotalAmount() != null && detail.getTotalAmount() > 0) {
            long pointAmount = (long) Math.floor(detail.getTotalAmount() * 0.03);
            if (pointAmount > 0) {
                // 잔액 먼저 증가
                Map<String, Object> balanceParam = new HashMap<>();
                balanceParam.put("memberNo", memberNo);
                balanceParam.put("pointAmount", pointAmount);
                mypageReserveMapper.addMemberPointBalance(balanceParam);

                // 증가 후 잔액 조회
                Long balanceAfter = mypageReserveMapper.selectMemberPointBalance(memberNo);

                // 포인트 이력 INSERT
                Map<String, Object> pointParam = new HashMap<>();
                pointParam.put("memberNo", memberNo);
                pointParam.put("pointAmount", String.valueOf(pointAmount));
                pointParam.put("balanceAfter", String.valueOf(balanceAfter));
                pointParam.put("refType", "STAY_REVIEW");
                pointParam.put("refId", String.valueOf(review.getReviewId()));
                mypageReserveMapper.insertReviewPoint(pointParam);
            }
        }
    }
}
