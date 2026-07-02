/**
 * 역할: 쿠폰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: EventCouponService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.event.coupon.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/event")
public class EventCouponController {

    @GetMapping("/coupon")
    public String coupon() {
        return "event/coupon";
    }
}
