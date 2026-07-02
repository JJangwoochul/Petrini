/**
 * 역할: 아이디·비밀번호 찾기 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MemberFindService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.member.find.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MemberFindController {

    @GetMapping("/find/id")
    public String findId() {
        return "member/find-id";
    }

    @GetMapping("/find/pw")
    public String findPw() {
        return "member/find-pw";
    }
}
