package com.petcare.petcare.admin.community;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminCommunityController")
@RequestMapping("/admin/community")
public class AdminCommunityController extends AdminBaseController {
    // ── ADMIN-03 커뮤니티 관리 ────────────────────────────
    @GetMapping("/list")
    public String communityList(HttpSession session) {
        if (getAdmin(session) == null) 
            return "redirect:/login";

        return "admin/community/list";
    }    
}
