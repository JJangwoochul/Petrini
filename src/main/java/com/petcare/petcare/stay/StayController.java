package com.petcare.petcare.stay;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("stayController")
@RequestMapping("/hotel")
public class StayController {

    @GetMapping({"", "/"})
    public String stay() {
        return "hotel/list";
    }

    // ── 숙소 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "hotel/detail";
    }

    // ── 숙소 예약 ───────────────────────────────────────────
    @GetMapping("/reserve")
    public String reserve(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "hotel/reserve";
    }

    // ── 예약 완료 ───────────────────────────────────────────
    @GetMapping("/complete")
    public String complete() {
        return "hotel/complete";
    }
}
