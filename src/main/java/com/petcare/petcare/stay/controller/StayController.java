/**
 * 역할: 펫호텔 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: StayStayService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.stay.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.stay.service.StayServiceImpl;
import com.petcare.petcare.stay.vo.StayVO;


@Controller("stayController")
@RequestMapping("/stay")
public class StayController {

    @Autowired
    private KakaoMapService kakaoMapService;
    @Autowired
    private StayServiceImpl stayService;
    @Autowired
    private FileService fileService;

    @GetMapping({"", "/"})
    public String list(Model model) {
        List<StayVO> lodgeList = stayService.getLodgeList();
        model.addAttribute("lodgeList", lodgeList);
        return "stay/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") Long id, Model model) throws Exception {
        StayVO lodge = stayService.getLodgeDetail(id);
        List<FileVO> imgList = fileService.getFileList("LODGE", id);
        
        // 지도 표시 (단일마커 — 숙소 1곳)
        if (lodge != null && lodge.getLat() != null) {
            java.util.List<StayVO> singleList = new java.util.ArrayList<>();
            singleList.add(lodge);
            kakaoMapService.addMapAttributes(model, singleList);
        }

        model.addAttribute("lodge", lodge);
        model.addAttribute("imgList", imgList);
        
        return "stay/detail";
    }

    @GetMapping("/reserve")
    public String reserve(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "stay/reserve";
    }

    @GetMapping("/complete")
    public String complete() {
        return "stay/complete";
    }
}
