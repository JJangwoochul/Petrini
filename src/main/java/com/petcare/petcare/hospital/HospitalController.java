package com.petcare.petcare.hospital;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.petcare.petcare.common.service.KakaoMapService;

@Controller("hospitalController")
@RequestMapping("/hospital")
public class HospitalController {
    
    @Autowired
    private KakaoMapService kakaoMapService;

    @GetMapping({"", "/"})
    public String hospital(Model model) throws JsonMappingException, JsonProcessingException {
        //test
        kakaoMapService.addMapAttributes(model, "서울 중구 세종대로 110", "행복 동물병원");
        return "hospital/list";
    }

    // ── 병원 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        kakaoMapService.addMapAttributes(model, "서울 중구 세종대로 110", "행복 동물병원");
        
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
