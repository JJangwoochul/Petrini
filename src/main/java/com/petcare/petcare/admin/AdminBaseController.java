package com.petcare.petcare.admin;

import com.petcare.petcare.member.vo.MemberVO;
import jakarta.servlet.http.HttpSession;
// import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.RequestMapping;

// @Controller("adminController")
// @RequestMapping("/admin")
public class AdminBaseController {

    /** 관리자 권한 체크 헬퍼 */
    public MemberVO getAdmin(HttpSession session) {
        MemberVO m = (MemberVO) session.getAttribute("memberInfo");
        if (m == null || !"ADMIN".equals(m.getRole())) 
            return null;

        return m;
    }

    protected String redirectToLogin() {
        return "redirect:/admin/login";
    }

    protected boolean isAdminAccount(String loginId) {
        if (loginId == null) {
            return false;
        }
        String id = loginId.trim();
        return "admin".equalsIgnoreCase(id) || "admin@petcare.com".equalsIgnoreCase(id);
    }
}
