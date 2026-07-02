/**
 * 역할: 동물병원 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: HospitalHospitalService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.hospital.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.petcare.petcare.common.external.service.KakaoMapService;

@Controller("hospitalController")
@RequestMapping("/hospital")
public class HospitalHospitalController {

    @Autowired
    private KakaoMapService kakaoMapService;

    @GetMapping({"", "/"})
    public String hospital(Model model) throws JsonMappingException, JsonProcessingException {
        kakaoMapService.addMapAttributes(model, "서울 중구 세종대로 110", "행복 동물병원");
        return "hospital/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        kakaoMapService.addMapAttributes(model, "서울 중구 세종대로 110", "행복 동물병원");
        model.addAttribute("id", id);
        return "hospital/detail";
    }

    @GetMapping("/reserve")
    public String reserve(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "hospital/reserve";
    }

    @GetMapping("/complete")
    public String complete() {
        return "hospital/complete";
    }
}
