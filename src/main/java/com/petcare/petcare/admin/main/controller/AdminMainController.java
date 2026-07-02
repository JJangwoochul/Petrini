/**
 * 역할: 관리자 대시보드·통계 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminMainService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.main.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminController")
@RequestMapping("/admin")
public class AdminMainController extends AdminBaseController {

    // ── ADMIN-01 대시보드 ──────────────────────────────────
    @GetMapping({"", "/"})
    public String dashboard(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/dashboard";
    }

    // ── ADMIN-04 통계 ──────────────────────────────────────
    @GetMapping("/stats")
    public String stats(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();
        
        return "admin/stats/index";
    }    
}
