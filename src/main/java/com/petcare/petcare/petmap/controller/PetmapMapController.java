/**
 * 역할: 펫맵 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: PetmapMapService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.petmap.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("petmapController")
@RequestMapping("/petmap")
public class PetmapMapController {

    @GetMapping({"", "/"})
    public String list(Model model) {
        model.addAttribute("lat", 37.5665);
        model.addAttribute("lng", 126.9780);
        return "petmap/list";
    }
}
