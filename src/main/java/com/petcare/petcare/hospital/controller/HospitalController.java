/**
 * 역할: 동물병원 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: HospitalService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.hospital.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.common.config.controller.CommonConfigController;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.file.mapper.FileMapper;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.hospital.mapper.HospitalMapper;
import com.petcare.petcare.hospital.vo.HospitalVO;

@Controller("hospitalController")
@RequestMapping("/hospital")
public class HospitalController extends CommonConfigController {
    @Autowired
    private KakaoMapService kakaoMapService;

    @Autowired
    private HospitalMapper hospitalMapper;
    @Autowired
    private FileMapper fileMapper;

    @GetMapping({"", "/"})
    public String hospital(Model model) throws Exception {
        List<HospitalVO> hospitalList = hospitalMapper.selectHospitalList();
        // kakaoMapService.addMapAttributes(model, "서울 중구 세종대로 110", "행복 동물병원");
        kakaoMapService.addMapAttributes(model, hospitalList);
        
        model.addAttribute("hospitalList", hospitalList);
        return "hospital/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) throws Exception{
        Long hospitalId = Long.parseLong(id);
        HospitalVO hospital = hospitalMapper.selectHospitalById(Long.parseLong(id));

        FileVO param = new FileVO();
        param.setRefType("HOSPITAL");
        param.setRefId(hospitalId); 
        List<FileVO> imgList = fileMapper.selectFileList(param);

        //지도설정
        kakaoMapService.addMapAttributes(model, hospital.getLat(), hospital.getLng(), hospital.getHospitalName());
        
        model.addAttribute("hospital", hospital);
        model.addAttribute("imgList", imgList);
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
