/**
 * 역할: 관리자 공통 사이드바용 모델 속성
 *
 * 2026/07/11 장우철 — 사업자 승인 대기(PENDING) 건수 배지
 * (사업자센터 예약관리 배지와 동일 UX)
 *
 * 2026-07-14 박유정 — 재능나눔 승인 대기(PENDING) 건수 배지 추가
 * (admin/common/sidebar.jsp 재능나눔 승인 메뉴)
 *
 * 2026-07-24 박유정 — 사업자 리뷰 삭제 요청 대기(PENDING) 건수 배지 추가
 * (admin/common/sidebar.jsp 사업자 리뷰 메뉴)
 *
 * 2026-08-06 박유정 — 배너 신청 대기(PENDING) 건수 배지 추가
 * (admin/common/sidebar.jsp 배너 관리 메뉴)
 *
 * 2026-08-11 박유정 — 1:1 문의·숙소 환불신청 대기(WAIT) 건수 배지 추가
 */

package com.petcare.petcare.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.petcare.petcare.admin.biz.service.AdminBizService;
import com.petcare.petcare.admin.cms.service.AdminCMSService;
import com.petcare.petcare.admin.inquiry.service.AdminInquiryService;
import com.petcare.petcare.admin.settlement.service.AdminSettlementService;
import com.petcare.petcare.admin.review.service.AdminReviewService;
import com.petcare.petcare.give.talent.service.GiveTalentService;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@ControllerAdvice(basePackages = "com.petcare.petcare.admin")
public class AdminSidebarAdvice {

    @Autowired
    private AdminBizService adminBizService;

    // 2026-07-14 박유정 — 재능나눔 승인 대기 건수 (GiveTalentService)
    @Autowired
    private GiveTalentService giveTalentService;

    // 2026/07/30 장우철 — 숙소 중간정산 REQUESTED 건수
    @Autowired
    private AdminSettlementService adminSettlementService;

    // 2026-07-24 박유정 — 사업자 리뷰 삭제 요청 대기 건수 (AdminReviewService)
    @Autowired
    private AdminReviewService adminReviewService;

    // 2026-08-06 박유정 — 배너 신청 대기 건수 (AdminCMSService)
    @Autowired
    private AdminCMSService adminCMSService;

    // 2026-08-11 박유정 — 1:1 문의·숙소 환불신청 대기 건수
    @Autowired
    private AdminInquiryService adminInquiryService;

    // 2026/07/11 장우철 — sidebar 사업자 승인 메뉴 배지 (더미 3 제거)
    @ModelAttribute("pendingBizApproveCount")
    public int pendingBizApproveCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            Integer pending = adminBizService.getBizStatusCounts().get("PENDING");
            return pending != null ? pending : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026-07-14 박유정 — sidebar 재능나눔 승인 메뉴 배지 (장우철 pendingBizApproveCount 패턴 동일)
    @ModelAttribute("pendingTalentApproveCount")
    public int pendingTalentApproveCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            Integer pending = giveTalentService.getTalentStatusCounts().get("PENDING");
            return pending != null ? pending : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026/07/30 장우철 — 숙소+쇼핑 중간정산 REQUESTED 배지
    @ModelAttribute("pendingStaySettleRequestCount")
    public int pendingStaySettleRequestCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            return adminSettlementService.countStayMidRequestsRequested()
                    + adminSettlementService.countStoreMidRequestsRequested();
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026-07-24 박유정 — sidebar 사업자 리뷰 메뉴 배지 (pendingBizApproveCount 패턴 동일)
    @ModelAttribute("pendingReviewDeleteCount")
    public int pendingReviewDeleteCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            return adminReviewService.getPendingReviewDeleteCount();
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026-08-06 박유정 — sidebar 배너 관리 메뉴 배지 (pendingBizApproveCount 패턴 동일)
    @ModelAttribute("pendingBannerCount")
    public int pendingBannerCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            return adminCMSService.getPendingBannerCount();
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026-08-11 박유정 — sidebar 숙소 환불신청 메뉴 배지
    @ModelAttribute("pendingStayRefundCount")
    public int pendingStayRefundCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            return adminInquiryService.countPendingStayRefund();
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026-08-11 박유정 — sidebar 1:1 문의 메뉴 배지
    @ModelAttribute("pendingGeneralInquiryCount")
    public int pendingGeneralInquiryCount(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) {
            return 0;
        }
        try {
            return adminInquiryService.countPendingGeneralInquiry();
        } catch (Exception e) {
            return 0;
        }
    }
}
