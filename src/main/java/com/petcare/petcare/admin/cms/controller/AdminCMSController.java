/**
 * 역할: 관리자 CMS URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminCMSService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.cms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petcare.petcare.admin.cms.service.AdminCMSService;
import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/cms")
public class AdminCMSController extends AdminBaseController {
    @Autowired
    private AdminCMSService adminCMSService;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  관리자: 배너 목록 (기존 AdminCMSController의 /admin/cms/banner 대체)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @GetMapping("/banner")
    public String adminBannerList(HttpSession session, Model model) {
        if (getAdmin(session) == null) return "redirect:/admin/login";

        model.addAttribute("bannerList", adminCMSService.getAllBannerList());
        model.addAttribute("adminPage", "cms-banner");
        return "admin/cms/banner";
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  관리자: 배너 승인
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @PostMapping("/banner/approve")
    @ResponseBody
    public String adminBannerApprove(@RequestParam Long bannerId,
                                     HttpSession session) {
        if (getAdmin(session) == null) return "LOGIN_REQUIRED";
        adminCMSService.approveBanner(bannerId);
        return "OK";
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  관리자: 배너 반려
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @PostMapping("/banner/reject")
    @ResponseBody
    public String adminBannerReject(@RequestParam Long bannerId,
                                    @RequestParam String rejectReason,
                                    HttpSession session) {
        if (getAdmin(session) == null) return "LOGIN_REQUIRED";
        adminCMSService.rejectBanner(bannerId, rejectReason);
        return "OK";
    }
    
    @GetMapping("/notice")
    public String cmsNotice(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/cms/notice";
    }

    @GetMapping("/faq")
    public String cmsFaq(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/cms/faq";
    }

    @GetMapping("/banner/form")
    public String bannerForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/cms/banner-form";
    }

    @GetMapping("/notice/form")
    public String noticeForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/cms/notice-form";
    }

    @GetMapping("/faq/form")
    public String faqForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/cms/faq-form";
    }
}
