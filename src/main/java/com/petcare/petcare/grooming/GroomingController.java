package com.petcare.petcare.grooming;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

@Controller("groomingController")
@RequestMapping("/grooming")
public class GroomingController {

    // ── 애견미용실 목록 ─────────────────────────────────────
    @GetMapping({"", "/"})
    public String list(Model model) throws JsonMappingException, JsonProcessingException {
        //test
        model.addAttribute("lat", 37.5665);
        model.addAttribute("lng", 126.9780);
        return "grooming/list";
    }

    // ── 애견미용실 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "grooming/detail";
    }

    // ── 미용 예약 ───────────────────────────────────────────
    @GetMapping("/reserve")
    public String reserve(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "grooming/reserve";
    }

    // ── 예약 완료 ───────────────────────────────────────────
    @GetMapping("/complete")
    public String complete() {
        return "grooming/complete";
    }
}
