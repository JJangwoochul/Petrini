/**
 * 역할: 관리자 숙소 환불(1:1) 승인/거절
 * 2026/07/31 장우철 — R2 2-7 / R3 정산 연결
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
     * 승인: 전액 환불 취소 + 기존 정산 ITEM REFUNDED + 문의 DONE
     * 2026/07/31 장우철 — R3-2 DONE 예약·기정산 건 포함
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
                ? "환불 신청이 승인되어 전액 환불 처리되었습니다."
                : answer.trim();

        Long resvId = detail.getRefId();

        // 이미 정산 묶인 건이면 지급 제외(REFUNDED) + 미지급 마스터 재합산
        staySettlementMapper.updateSettlementItemRefundedByResvId(
                resvId, "관리자 환불승인");
        staySettlementMapper.recalcUnpaidSettlementTotalsByResvId(resvId);

        // DONE 포함 전액 환불 취소 (수수료 0 · 정산 대상 아님)
        stayFullCancelService.cancelWithFullRefund(
                resvId, null, "관리자 환불승인: " + msg, "관리자", true);

        int updated = memberInquiryMapper.updateInquiryAnswer(inquiryId, "DONE", msg, adminNo);
        if (updated == 0) {
            throw new IllegalStateException("문의 상태 갱신에 실패했습니다.");
        }
    }

    /**
     * 거절: 예약 유지 + 문의 DONE → 다음 정산 기간에 이월 합산(R3-3)
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
                inquiryId, "DONE", answer.trim(), adminNo);
        if (updated == 0) {
            throw new IllegalStateException("문의 상태 갱신에 실패했습니다.");
        }
    }
}
