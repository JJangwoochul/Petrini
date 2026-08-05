/**
 * 역할: 마이페이지 회원정보 URL 처리 → Service 호출 → JSP 반환
 *
 * - 2026-08-04 박유정 — 회원정보 수정 POST /mypage/edit (프로필 사진 업로드·세션 갱신)
 *
 * 연결
 * - Service: MypageAccountService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.account.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.mypage.account.service.MypageAccountService;
import com.petcare.petcare.mypage.account.vo.MypageAccountVO;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/mypage")
public class MypageAccountController {

    private final MypageAccountService mypageAccountService;

    public MypageAccountController(MypageAccountService mypageAccountService) {
        this.mypageAccountService = mypageAccountService;
    }

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

    // 2026-08-04 박유정 — 회원정보 수정 저장 (프로필 사진)
    @PostMapping("/edit")
    public String editSubmit(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            HttpSession session,
            RedirectAttributes rttr) {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null || member.getMemberNo() == null) {
            return "redirect:/login";
        }

        // 2026-08-04 박유정 — 파일 선택 시에만 저장 (사진 미변경 시 redirect만)
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                String url = mypageAccountService.updateProfileImage(member.getMemberNo(), profileImage);
                // 2026-08-04 박유정 — 사이드바 즉시 반영을 위해 세션 memberInfo 갱신
                member.setProfileImgUrl(url);
                session.setAttribute("memberInfo", member);
                rttr.addFlashAttribute("msg", "프로필 사진이 변경되었습니다.");
            } catch (IllegalArgumentException e) {
                rttr.addFlashAttribute("errorMsg", e.getMessage());
            } catch (Exception e) {
                rttr.addFlashAttribute("errorMsg", "사진 저장에 실패했습니다.");
            }
        }

        return "redirect:/mypage/edit";
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
