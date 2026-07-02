package com.petcare.petcare.admin.main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.AdminBaseController;

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
