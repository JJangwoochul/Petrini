/**
 * 역할: 마이페이지 알림 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MypageNotifyService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.notify.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MypageNotifyController {

    @GetMapping("/notifications")
    public String notifications(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/notifications";
    }

    @GetMapping("/notifications/detail")
    public String notificationDetail(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/notification-detail";
    }
}
