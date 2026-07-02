/**
 * 역할: 마이페이지 사업자 URL 처리 → Service 호출 → JSP/리다이렉트 반환
 *
 * 연결
 * - Service: MypageBizService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.biz.controller;

import com.petcare.petcare.member.vo.MemberVO;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MypageBizController {

    @GetMapping("/biz")
    public String biz(HttpSession session) {
        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
        if (memberInfo == null)
            return "redirect:/login";

        if (!"BIZ".equals(memberInfo.getRole())) {
            return "redirect:/mypage/biz-apply";
        }

        return switch (memberInfo.getBizType()) {
            case "HOSPITAL" -> "redirect:/biz/hospital";
            case "STAY" -> "redirect:/biz/stay";
            case "RESTAURANT" -> "redirect:/biz/restaurant";
            case "GROOMING" -> "redirect:/biz/grooming";
            case "STUDIO" -> "redirect:/biz/studio";
            case "STORE" -> "redirect:/biz/store";
            default -> "mypage/biz";
        };
    }

    @GetMapping("/biz-apply")
    public String bizApply(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/biz-apply";
    }
}
