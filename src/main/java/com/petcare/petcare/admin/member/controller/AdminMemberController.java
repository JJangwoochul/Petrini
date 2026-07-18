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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.admin.member.service.AdminMemberService;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.admin.member.vo.AdminMemberVO;

@Controller("adminMemberController")
@RequestMapping("/admin/member")
public class AdminMemberController extends AdminBaseController {
   
    @Autowired
    private AdminMemberService adminMemberService;

    // 2026-07-16 박유정 — 관리자 회원 목록 (DB 연동)
    @GetMapping("/list")
    public String memberList(HttpSession session,
                             @RequestParam(defaultValue = "") String keyword,
                             @RequestParam(defaultValue = "") String statusCd,
                             @RequestParam(defaultValue = "") String roleType,
                             @RequestParam(defaultValue = "1") int page,
                             Model model) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        model.addAttribute("list",
                adminMemberService.getAdminMemberList(keyword, statusCd, roleType, page));
        model.addAttribute("totalCount",
                adminMemberService.getAdminMemberCount(keyword, statusCd, roleType));
        model.addAttribute("keyword", keyword);
        model.addAttribute("statusCd", statusCd);
        model.addAttribute("roleType", roleType);
        model.addAttribute("page", page);

        return "admin/member/list";
    }

    // 2026-07-16 박유정 — 관리자 회원 상세 (기본정보)
    @GetMapping("/detail")
    public String memberDetail(HttpSession session,
                               @RequestParam long id,
                               Model model,
                               RedirectAttributes rttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        AdminMemberVO member = adminMemberService.getAdminMemberDetail(id);
        if (member == null) {
            rttr.addFlashAttribute("errorMsg", "회원을 찾을 수 없습니다.");
            return "redirect:/admin/member/list";
        }
        model.addAttribute("member", member);
        return "admin/member/detail";
    }
}