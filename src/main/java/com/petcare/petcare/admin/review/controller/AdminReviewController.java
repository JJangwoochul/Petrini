/**
 * 역할: 관리자 리뷰 삭제 요청 URL 처리 → Service 호출 → JSP 반환
 *
 * - 박유정 / 2026-07-24
 */

package com.petcare.petcare.admin.review.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.admin.controller.AdminBaseController;
import com.petcare.petcare.admin.review.service.AdminReviewService;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("adminReviewController")
@RequestMapping("/admin/review")
public class AdminReviewController extends AdminBaseController {

    @Autowired
    private AdminReviewService adminReviewService;

    // 2026-07-24 박유정 — 리뷰 삭제 요청 목록
    @GetMapping("/list")
    public String reviewDeleteRequestList(HttpSession session,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(required = false) String statusCd,
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        if (getAdmin(session) == null)
            return redirectToLogin();

        // 2026-07-24 박유정 — 파라미터 없음=첫 진입(PENDING), ALL/빈값=상태 전체
        if (statusCd == null) {
            statusCd = "PENDING";
        }

        model.addAttribute("list",
                adminReviewService.getReviewDeleteRequestList(keyword, statusCd, page));
        model.addAttribute("totalCount",
                adminReviewService.getReviewDeleteRequestCount(keyword, statusCd));
        model.addAttribute("keyword", keyword);
        model.addAttribute("statusCd", statusCd);
        model.addAttribute("page", page);

        return "admin/review/list";
    }

    // 2026-07-24 박유정 — 삭제 요청 승인 (리뷰 삭제)
    @PostMapping("/approve")
    public String approveReviewDeleteRequest(HttpSession session,
            @RequestParam long requestId,
            RedirectAttributes rttr) {
        MemberVO admin = getAdmin(session);
        if (admin == null)
            return redirectToLogin();

        try {
            adminReviewService.approveReviewDeleteRequest(requestId, admin.getAdminNo());
            rttr.addFlashAttribute("successMsg", "리뷰가 삭제(승인) 처리되었습니다.");
            return "redirect:/admin/review/list?statusCd=APPROVED";
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", "처리할 수 없는 요청입니다.");
            return "redirect:/admin/review/list?statusCd=PENDING";
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "승인 처리 중 오류가 발생했습니다.");
            return "redirect:/admin/review/list?statusCd=PENDING";
        }
    }

    // 2026-07-24 박유정 — 삭제 요청 반려 (반려 사유 필수 + 사업자 알림)
    @PostMapping("/reject")
    public String rejectReviewDeleteRequest(HttpSession session,
            @RequestParam long requestId,
            @RequestParam String rejectReason,
            RedirectAttributes rttr) {
        MemberVO admin = getAdmin(session);
        if (admin == null)
            return redirectToLogin();

        if (rejectReason == null || rejectReason.isBlank()) {
            rttr.addFlashAttribute("errorMsg", "반려 사유를 입력해 주세요.");
            return "redirect:/admin/review/list?statusCd=PENDING";
        }

        try {
            adminReviewService.rejectReviewDeleteRequest(
                    requestId, rejectReason.trim(), admin.getAdminNo());
            rttr.addFlashAttribute("successMsg", "삭제 요청이 반려되었습니다.");
            return "redirect:/admin/review/list?statusCd=REJECTED";
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", "처리할 수 없는 요청입니다.");
            return "redirect:/admin/review/list?statusCd=PENDING";
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "반려 처리 중 오류가 발생했습니다.");
            return "redirect:/admin/review/list?statusCd=PENDING";
        }
    }
}
