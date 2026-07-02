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

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminCMSController")
@RequestMapping("/admin/cms")
public class AdminCMSController extends AdminBaseController {
    // ── ADMIN-03 CMS ───────────────────────────────────────
    @GetMapping("/banner")
    public String cmsBanner(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/cms/banner";
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
