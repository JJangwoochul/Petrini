/**
 * 역할: 관리자 쇼핑몰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminStoreService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.store.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.admin.controller.AdminBaseController;
import com.petcare.petcare.admin.store.service.AdminStoreService;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("adminStoreController")
@RequestMapping("/admin/store")
public class AdminStoreController extends AdminBaseController {

    @Autowired
    private AdminStoreService adminStoreService;

    //지윤 26.07.21 추가: 사업자 리뷰 삭제요청 목록 - 사이드바 "리뷰 관리"
    @GetMapping("/review-report")
    public String reviewReport(HttpSession session, Model model) {
        if (getAdmin(session) == null) return redirectToLogin();

        model.addAttribute("reportList", adminStoreService.getPendingReviewReports());
        return "admin/store/review-report";
    }

    //지윤 26.07.21 추가: 삭제요청 승인 - 리뷰 실제 삭제
    @PostMapping("/review-report/{reportId}/approve")
    public String approveReviewReport(@PathVariable Long reportId, @RequestParam Long reviewId,
                                       HttpSession session, RedirectAttributes rttr) {
        MemberVO admin = getAdmin(session);
        if (admin == null) return redirectToLogin();

        adminStoreService.approveReviewReport(reportId, reviewId, admin.getMemberNo());
        rttr.addFlashAttribute("msg", "삭제 요청을 승인했습니다.");
        return "redirect:/admin/store/review-report";
    }

    //지윤 26.07.21 추가: 삭제요청 반려 - 리뷰는 그대로 유지
    @PostMapping("/review-report/{reportId}/reject")
    public String rejectReviewReport(@PathVariable Long reportId, HttpSession session, RedirectAttributes rttr) {
        MemberVO admin = getAdmin(session);
        if (admin == null) return redirectToLogin();

        adminStoreService.rejectReviewReport(reportId, admin.getMemberNo());
        rttr.addFlashAttribute("msg", "삭제 요청을 반려했습니다.");
        return "redirect:/admin/store/review-report";
    }

    // ── ADMIN-02 상품 관리 ─────────────────────────────────
    @GetMapping("/product-list")
    public String productList(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/store/product-list";
    }
    
    // ── ADMIN-02 주문 관리 ─────────────────────────────────
    @GetMapping("/order-list")
    public String orderList(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/store/order-list";
    }  
    
    // ── 상품 카테고리 관리 ─────────────────────────────────
    @GetMapping("/category")
    public String category(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/store/category";
    }

    @GetMapping("/order-detail")
    public String orderDetail(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/store/order-detail";
    }

    @GetMapping("/product-form")
    public String productForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/store/product-form";
    }
}
