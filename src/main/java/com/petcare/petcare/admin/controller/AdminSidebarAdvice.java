/**
 * 역할: 관리자 공통 사이드바용 모델 속성
 *
 * 2026/07/11 장우철 — 사업자 승인 대기(PENDING) 건수 배지
 * (사업자센터 예약관리 배지와 동일 UX)
 */

package com.petcare.petcare.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.petcare.petcare.admin.biz.service.AdminBizService;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@ControllerAdvice(basePackages = "com.petcare.petcare.admin")
public class AdminSidebarAdvice {

    @Autowired
    private AdminBizService adminBizService;

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
}
