package com.petcare.petcare.stay;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.common.service.KakaoMapService;

@Controller("stayController")
@RequestMapping("/hotel")
public class StayController {

    @Autowired
    private KakaoMapService kakaoMapService;

    @GetMapping({"", "/"})
    public String stay() {
        return "hotel/list";
    }

    // ── 숙소 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        kakaoMapService.addMapAttributes(model, "서울 중구 세종대로 110", "행복 동물병원");
        return "stay/detail";
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
