package com.petcare.petcare.admin.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminMemberController")
@RequestMapping("/admin/member")
public class AdminMemberController extends AdminBaseController {
    
    // ── ADMIN-02 회원 관리 ─────────────────────────────────
    @GetMapping("/list")
    public String memberList(HttpSession session) {
        if (getAdmin(session) == null) 
            return "redirect:/login";

        return "admin/member/list";
    }    
}
