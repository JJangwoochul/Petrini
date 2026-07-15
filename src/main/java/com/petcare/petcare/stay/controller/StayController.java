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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.stay.service.StayServiceImpl;
import com.petcare.petcare.stay.vo.StayVO;

import jakarta.servlet.http.HttpSession;


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
    public String list(@ModelAttribute("search") StayVO searchVO, Model model) {
        //List<StayVO> stayList = stayService.getStayList();
        List<StayVO> stayList = stayService.getStayListBySearch(searchVO);
        kakaoMapService.addMapAttributes(model, stayList);
        
        model.addAttribute("stayList", stayList);
        model.addAttribute("skipAutoMarkers", "true");
        return "stay/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") Long id, Model model) throws Exception {
        StayVO stay = stayService.getStayById(id);
        List<FileVO> imgList = fileService.getFileList("STAY", id);
        
        // 지도 표시 (단일마커 — 숙소 1곳)
        if (stay != null && stay.getLat() != null) {
            java.util.List<StayVO> singleList = new java.util.ArrayList<>();
            singleList.add(stay);
            kakaoMapService.addMapAttributes(model, singleList);
        }

        model.addAttribute("stay", stay);
        model.addAttribute("imgList", imgList);
        
        return "stay/detail";
    }

    @GetMapping("/reserve")
    public String reserve(@RequestParam("id") Long id,
                          @RequestParam(value = "roomId", required = false) Long roomId,
                          HttpSession session, 
                          Model model) throws Exception {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        StayVO stay = stayService.getStayById(id);
        if (stay == null) return "redirect:/stay";

        model.addAttribute("stay", stay);
        model.addAttribute("roomId", roomId);
        model.addAttribute("petList", stayService.getPetList(member.getMemberNo()));
        return "stay/reserve";
    }

    // ── 예약 저장 ──
    @PostMapping("/reserve")
    public String saveReserve(@ModelAttribute ReservationVO vo,
                              @RequestParam("stayId") Long stayId,
                              HttpSession session,
                              RedirectAttributes rttr) {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        vo.setMemberNo(member.getMemberNo());
        vo.setTargetId(String.valueOf(stayId));

        Long resvId = stayService.createStayReservation(vo);
        return "redirect:/stay/complete?resvId=" + resvId;
    }

    @GetMapping("/complete")
    public String complete(@RequestParam(value = "resvId", required = false) Long resvId,
                           Model model)  {
        if (resvId != null) {
            ReservationVO reservation = stayService.getReservationById(resvId);
            model.addAttribute("reservation", reservation);
        }
        return "stay/complete";
    }
}
