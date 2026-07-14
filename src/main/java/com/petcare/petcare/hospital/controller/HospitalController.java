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

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.common.config.controller.CommonConfigController;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.hospital.service.HospitalService;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("hospitalController")
@RequestMapping("/hospital")
public class HospitalController extends CommonConfigController {

    @Autowired
    private KakaoMapService kakaoMapService;
    @Autowired
    private HospitalService hospitalService;
    @Autowired
    private FileService fileService;

    @GetMapping({"", "/"})
    public String hospital(Model model) throws Exception {
        List<HospitalVO> hospitalList = hospitalService.getHospitalList();
        kakaoMapService.addMapAttributes(model, hospitalList);
        
        model.addAttribute("hospitalList", hospitalList);
        model.addAttribute("skipAutoMarkers", "true");
        return "hospital/list";
    }

    // ── 병원 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam String id, Model model) throws Exception {
        Long hospitalId = Long.parseLong(id);
        HospitalVO hospital = hospitalService.getHospitalById(Long.parseLong(id));
        List<FileVO> imgList = fileService.getFileList("HOSPITAL", hospitalId);

        if (hospital != null && hospital.getLat() != null) {
            List<HospitalVO> singleList = new ArrayList<>();
            singleList.add(hospital); 
            kakaoMapService.addMapAttributes(model, singleList);
            // → markersJson에 1개만 들어감 → kakaomap.jsp가 상세모드로 자동 동작
        }

        model.addAttribute("hospital", hospital);
        model.addAttribute("imgList", imgList);
        // 2026/07/13 장우철 — 더미 리뷰 대신 DB 리뷰 목록
        model.addAttribute("reviewList", hospitalService.getHospitalReviews(hospitalId));

        return "hospital/detail";
    }

    // 2026-07-10 장우철 — 병원 예약 폼 (F1~F2) hospitalId 필수 + 펫 목록
    @GetMapping("/reserve")
    public String reserve(@RequestParam("id") String id,
                          HttpSession session,
                          Model model) throws Exception {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) {
            return "redirect:/login";
        }

        Long hospitalId = Long.parseLong(id);
        HospitalVO hospital = hospitalService.getHospitalById(hospitalId);
        if (hospital == null) {
            return "redirect:/hospital";
        }

        model.addAttribute("hospitalId", hospitalId);
        model.addAttribute("hospital", hospital);
        model.addAttribute("petList", hospitalService.getPetListForReserve(member.getMemberNo()));
        return "hospital/reserve";

        /* [변경 전] 2026-07-10 장우철 — id 하드코딩·목업만
        model.addAttribute("id", id);
        */
    }

    // 2026-07-10 장우철 — 병원 예약 저장 (F2)
    // 2026-07-11 장우철 — resvDate 는 VO @DateTimeFormat 으로 바인딩 (별도 String 파싱 제거)
    @PostMapping("/reserve")
    public String saveReserve(@ModelAttribute ReservationVO vo,
                              @RequestParam("hospitalId") Long hospitalId,
                              HttpSession session,
                              RedirectAttributes rttr) throws Exception {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) {
            return "redirect:/login";
        }

        vo.setMemberNo(member.getMemberNo());
        vo.setTargetId(String.valueOf(hospitalId));

        Long resvId = hospitalService.createHospitalReservation(vo);
        return "redirect:/hospital/complete?resvId=" + resvId;
    }

    // 2026-07-10 장우철 — 예약 완료 (F3)
    @GetMapping("/complete")
    public String complete(@RequestParam("resvId") Long resvId, Model model) throws Exception {
        ReservationVO reservation = hospitalService.getReservationById(resvId);
        model.addAttribute("reservation", reservation);
        return "hospital/complete";
    }
}
