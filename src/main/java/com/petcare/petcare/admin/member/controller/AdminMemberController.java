/**
 * 역할: 관리자 회원 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminMemberService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.member.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminMemberController")
@RequestMapping("/admin/member")
public class AdminMemberController extends AdminBaseController {
    
    // ── ADMIN-02 회원 관리 ─────────────────────────────────
    @GetMapping("/list")
    public String memberList(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/member/list";
    }

    @GetMapping("/detail")
    public String memberDetail(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/member/detail";
    }
}
