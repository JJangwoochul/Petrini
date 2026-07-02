package com.petcare.petcare.admin.biz;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.AdminBaseController;

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
