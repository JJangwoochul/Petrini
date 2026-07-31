/**
 * 역할: 관리자 숙소 환불 신청 URL (2-7)
 * 2026/07/31 장우철
 */
package com.petcare.petcare.admin.inquiry.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.admin.controller.AdminBaseController;
import com.petcare.petcare.admin.inquiry.service.AdminInquiryService;
import com.petcare.petcare.member.inquiry.vo.MemberInquiryVO;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("adminInquiryController")
@RequestMapping("/admin/inquiry")
public class AdminInquiryController extends AdminBaseController {

    @Autowired
    private AdminInquiryService adminInquiryService;

    @GetMapping({ "", "/stay-refund" })
    public String stayRefundList(HttpSession session,
                                 @RequestParam(value = "status", required = false, defaultValue = "WAIT") String status,
                                 Model model) {
        if (getAdmin(session) == null) {
            return redirectToLogin();
        }
        model.addAttribute("list", adminInquiryService.getStayRefundList(status));
        model.addAttribute("status", status);
        return "admin/inquiry/stay-refund-list";
    }

    @GetMapping("/stay-refund/detail")
    public String stayRefundDetail(HttpSession session,
                                   @RequestParam("inquiryId") Long inquiryId,
                                   Model model,
                                   RedirectAttributes rttr) {
        if (getAdmin(session) == null) {
            return redirectToLogin();
        }
        MemberInquiryVO detail = adminInquiryService.getStayRefundDetail(inquiryId);
        if (detail == null) {
            rttr.addFlashAttribute("errorMsg", "신청을 찾을 수 없습니다.");
            return "redirect:/admin/inquiry/stay-refund";
        }
        model.addAttribute("inquiry", detail);
        return "admin/inquiry/stay-refund-detail";
    }

    @PostMapping("/stay-refund/approve")
    public String approve(HttpSession session,
                          @RequestParam("inquiryId") Long inquiryId,
                          @RequestParam(value = "answer", required = false) String answer,
                          RedirectAttributes rttr) {
        MemberVO admin = getAdmin(session);
        if (admin == null) {
            return redirectToLogin();
        }
        try {
            adminInquiryService.approveStayRefund(inquiryId, null, answer);
            rttr.addFlashAttribute("successMsg", "환불을 승인하고 전액 환불 취소 처리했습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "승인 처리 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/inquiry/stay-refund/detail?inquiryId=" + inquiryId;
    }

    @PostMapping("/stay-refund/reject")
    public String reject(HttpSession session,
                         @RequestParam("inquiryId") Long inquiryId,
                         @RequestParam("answer") String answer,
                         RedirectAttributes rttr) {
        MemberVO admin = getAdmin(session);
        if (admin == null) {
            return redirectToLogin();
        }
        try {
            adminInquiryService.rejectStayRefund(inquiryId, null, answer);
            rttr.addFlashAttribute("successMsg", "환불 신청을 거절했습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/admin/inquiry/stay-refund/detail?inquiryId=" + inquiryId;
    }
}
