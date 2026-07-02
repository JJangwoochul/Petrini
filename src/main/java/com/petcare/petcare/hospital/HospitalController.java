package com.petcare.petcare.hospital;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

@Controller("hospitalController")
@RequestMapping("/hospital")
public class HospitalController {
    
    @GetMapping({"", "/"})
    public String hospital(Model model) throws JsonMappingException, JsonProcessingException {
        //test
        model.addAttribute("lat", 37.5665);
        model.addAttribute("lng", 126.9780);
        return "hospital/list";
    }

    // ── 병원 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "hospital/detail";
    }

    // ── 병원 예약 ───────────────────────────────────────────
    @GetMapping("/reserve")
    public String reserve(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "hospital/reserve";
    }

    // ── 예약 완료 ───────────────────────────────────────────
    @GetMapping("/complete")
    public String complete() {
        return "hospital/complete";
    }
}
