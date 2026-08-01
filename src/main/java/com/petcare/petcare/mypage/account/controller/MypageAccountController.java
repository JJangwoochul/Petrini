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

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petcare.petcare.mypage.account.service.MypageAccountService;
import com.petcare.petcare.member.vo.MemberVO;

@Controller
@RequestMapping("/mypage")
public class MypageAccountController {

    private final MypageAccountService mypageAccountService;

    public MypageAccountController(MypageAccountService mypageAccountService) {
        this.mypageAccountService = mypageAccountService;
    }

    @GetMapping("/edit")
    public String edit(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/edit";
    }

    // HYJ 2026/07/29 — 회원 탈퇴
    /** 탈퇴 페이지 (GET /mypage/withdraw) */
    @GetMapping("/withdraw")
    public String withdraw(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/withdraw";
    }

    /** 탈퇴 처리 (POST /mypage/withdraw) */
    @PostMapping("/withdraw")
    @ResponseBody
    public String withdrawPost(@RequestParam String password, HttpSession session) {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) {
            return "ERROR:로그인이 필요합니다.";
        }

        String error = mypageAccountService.withdraw(member.getMemberNo(), password);
        if (error != null) {
            return "ERROR:" + error;
        }

        // 탈퇴 성공 → 세션 제거
        session.invalidate();
        return "OK";
    }
}
