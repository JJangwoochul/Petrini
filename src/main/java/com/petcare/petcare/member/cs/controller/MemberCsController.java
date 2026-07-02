/**
 * 역할: 고객센터 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MemberCsService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.member.cs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MemberCsController {

    @GetMapping("/member/cs")
    public String cs() {
        return "member/cs";
    }

    @GetMapping("/member/cs/notice")
    public String csNotice(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("noticeId", id);
        return "member/cs-notice";
    }
}
