package com.petcare.petcare.event;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("eventController")
@RequestMapping("/event")
public class EventController {

    // ── 이벤트/혜택 목록 ────────────────────────────────────
    @GetMapping({"", "/"})
    public String list() {
        return "event/list";
    }

    // ── 쿠폰함 ──────────────────────────────────────────────
    @GetMapping("/coupon")
    public String coupon() {
        return "event/coupon";
    }
}
