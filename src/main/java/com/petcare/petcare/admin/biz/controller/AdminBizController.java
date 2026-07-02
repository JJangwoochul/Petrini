/**
 * 역할: 사업자·재능나눔 승인 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminBizService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.biz.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminBizController")
@RequestMapping("/admin/biz")
public class AdminBizController extends AdminBaseController {
    
    // ── ADMIN-03 사업자 승인 ───────────────────────────────
    @GetMapping("/list")
    public String bizList(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/biz/list";
    }
    
    // ── 재능나눔 승인 ───────────────────────────────
    @GetMapping("/talent")
    public String cmsTalent(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/biz/talent";
    }

    @GetMapping("/detail")
    public String bizDetail(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/biz/detail";
    }
}
