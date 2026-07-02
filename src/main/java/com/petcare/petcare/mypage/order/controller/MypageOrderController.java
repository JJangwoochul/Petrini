/**
 * 역할: 마이페이지 주문 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MypageOrderService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.order.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class MypageOrderController {

    @GetMapping("/orders")
    public String orders(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/orders";
    }
}
