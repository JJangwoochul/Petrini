/**
 * 역할: 마이페이지 회원정보 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MypageAccountService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.account.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.mypage.account.service.MypageAccountService;
import com.petcare.petcare.mypage.account.vo.MypageAccountVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/mypage")
public class MypageAccountController {

    @Autowired
    private MypageAccountService mypageAccountService;

    // 2026-07-28 박유정 — 회원정보 수정 (DB에서 최신 프로필 조회)
    @GetMapping("/edit")
    public String edit(HttpSession session, Model model) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null || member.getMemberNo() == null) {
            return "redirect:/login";
        }

        MypageAccountVO profile = mypageAccountService.getMemberProfile(member.getMemberNo());
        model.addAttribute("profile", profile);

        return "mypage/edit";
    }
}
