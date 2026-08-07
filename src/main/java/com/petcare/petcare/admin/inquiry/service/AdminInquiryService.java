/**
 * 역할: 관리자 숙소 환불(1:1) 승인/거절
 * 2026/07/31 장우철 — R2 2-7 / R3 정산 연결
 * 2026/08/06 장우철 — B: STATUS APPROVED/REJECTED + 승인 시 보상숙박(예약 유지)
 */
package com.petcare.petcare.admin.inquiry.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.member.inquiry.mapper.MemberInquiryMapper;
import com.petcare.petcare.member.inquiry.vo.MemberInquiryVO;
import com.petcare.petcare.settlement.mapper.StaySettlementMapper;
import com.petcare.petcare.stay.service.StayFullCancelService;

@Service
public class AdminInquiryService {

    @Autowired
    private MemberInquiryMapper memberInquiryMapper;
    @Autowired
    private StayFullCancelService stayFullCancelService;
    @Autowired
    private StaySettlementMapper staySettlementMapper;

    @Transactional(readOnly = true)
    public List<MemberInquiryVO> getStayRefundList(String statusCd) {
        String status = (statusCd == null || statusCd.isBlank() || "ALL".equalsIgnoreCase(statusCd))
                ? null : statusCd.trim().toUpperCase();
        List<MemberInquiryVO> list = memberInquiryMapper.selectStayRefundList(status);
        return list != null ? list : Collections.emptyList();
    }

    @Transactional(readOnly = true)
    public MemberInquiryVO getStayRefundDetail(Long inquiryId) {
        if (inquiryId == null) {
            return null;
        }
        return memberInquiryMapper.selectStayRefundDetail(inquiryId);
    }

    /**
     * 승인: 전액 환불 + 예약 이용 유지(보상 숙박) + 정산 REFUNDED + 문의 APPROVED
     * 2026/08/06 장우철 — CANCEL 하지 않음
     */
    @Transactional
    public void approveStayRefund(Long inquiryId, Long adminNo, String answer) throws Exception {
        MemberInquiryVO detail = memberInquiryMapper.selectStayRefundDetail(inquiryId);
        if (detail == null) {
            throw new IllegalStateException("환불 신청을 찾을 수 없습니다.");
        }
        if (!"WAIT".equalsIgnoreCase(detail.getStatusCd())) {
            throw new IllegalStateException("이미 처리된 신청입니다.");
        }
        if (detail.getRefId() == null) {
            throw new IllegalStateException("연결된 예약이 없습니다.");
        }

        String msg = (answer == null || answer.isBlank())
                ? "환불이 승인되었습니다. 결제금은 전액 환불되며, 예약 기간 동안 숙소 이용은 가능합니다(보상 숙박)."
                : answer.trim();

        Long resvId = detail.getRefId();

        staySettlementMapper.updateSettlementItemRefundedByResvId(
                resvId, "관리자 환불승인(이용유지)");
        staySettlementMapper.recalcUnpaidSettlementTotalsByResvId(resvId);

        stayFullCancelService.refundPaymentKeepReservation(resvId, "관리자");

        int updated = memberInquiryMapper.updateInquiryAnswer(inquiryId, "APPROVED", msg, adminNo);
        if (updated == 0) {
            throw new IllegalStateException("문의 상태 갱신에 실패했습니다.");
        }
    }

    /**
     * 거절: 예약 유지 + 문의 REJECTED → 다음 정산 기간에 이월 합산(R3-3)
     * 2026/08/06 장우철 — STATUS_CD = REJECTED (B방식)
     */
    @Transactional
    public void rejectStayRefund(Long inquiryId, Long adminNo, String answer) {
        MemberInquiryVO detail = memberInquiryMapper.selectStayRefundDetail(inquiryId);
        if (detail == null) {
            throw new IllegalStateException("환불 신청을 찾을 수 없습니다.");
        }
        if (!"WAIT".equalsIgnoreCase(detail.getStatusCd())) {
            throw new IllegalStateException("이미 처리된 신청입니다.");
        }
        if (answer == null || answer.isBlank()) {
            throw new IllegalArgumentException("거절 사유를 입력해 주세요.");
        }
        int updated = memberInquiryMapper.updateInquiryAnswer(
                inquiryId, "REJECTED", answer.trim(), adminNo);
        if (updated == 0) {
            throw new IllegalStateException("문의 상태 갱신에 실패했습니다.");
        }
    }
}
