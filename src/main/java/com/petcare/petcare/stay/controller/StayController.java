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

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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

    @Value("${toss.client-key}")
    private String tossApiKey;
    
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
        model.addAttribute("reviewList", stayService.getStayReviews(id));
        
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

    // ── HYJ 26.07.20 가용성 체크 API (AJAX) ──
    @GetMapping("/checkAvailability")
    @ResponseBody
    public Map<String, Object> checkAvailability(
            @RequestParam("roomId") Long roomId,
            @RequestParam("checkinDate") String checkinDate,
            @RequestParam("checkoutDate") String checkoutDate) throws Exception {

        Map<String, Object> result = new HashMap<>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date ciDate = sdf.parse(checkinDate);
        Date coDate = sdf.parse(checkoutDate);

        boolean available = stayService.checkRoomAvailability(roomId, ciDate, coDate);
        result.put("available", available);

        if (!available) {
            result.put("message", "선택한 날짜에 이미 예약이 있습니다.");
        }
        return result;
    }

        
    // ── HYJ 26.07.20 예약 저장 → 결제 페이지로 이동──
    @PostMapping("/reserve")
    public String saveReserve(@ModelAttribute ReservationVO vo,
                              @RequestParam("stayId") Long stayId,
                              HttpSession session,
                              RedirectAttributes rttr) {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        vo.setMemberNo(member.getMemberNo());
        vo.setTargetId(String.valueOf(stayId));

        try {
            Long resvId = stayService.createStayReservation(vo);
            // 결제 페이지로 리다이렉트
            return "redirect:/stay/payment?resvId=" + resvId;
        } catch (RuntimeException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/stay/reserve?id=" + stayId;
        }
    }

    // ── HYJ 26.07.20 결제 페이지 ──
    @GetMapping("/payment")
    public String payment(@RequestParam("resvId") Long resvId,
                            HttpSession session,
                            Model model) {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        ReservationVO reservation = stayService.getReservationById(resvId);
        if (reservation == null) return "redirect:/stay";

        // 본인 예약만 결제 가능
        if (!member.getMemberNo().equals(reservation.getMemberNo())) {
            return "redirect:/stay";
        }

        model.addAttribute("reservation", reservation);
        model.addAttribute("tossApiKey", tossApiKey);
        return "stay/payment";
    }

    // ── HYJ 26.07.20 결제 성공 콜백 (Toss → 여기로 리다이렉트) ──
    @GetMapping("/payment/success")
    public String paymentSuccess(@RequestParam("orderId") String orderId,
                                    @RequestParam("paymentKey") String paymentKey,
                                    @RequestParam("amount") Long amount,
                                    HttpSession session,
                                    Model model) {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        // orderId에서 resvId 추출 (형식: stay-{resvId}-{timestamp})
        String[] parts = orderId.split("-");
        Long resvId = Long.parseLong(parts[1]);

        try {
            // HYJ 26.07.20 예약 CONFIRMED + 결제 정보 INSERT + 카카오톡 알림 발송
            String kakaoToken = (String) session.getAttribute("kakaoAccessToken");
            stayService.confirmPayment(resvId, paymentKey, orderId, null, kakaoToken);
            return "redirect:/stay/complete?resvId=" + resvId;
        } catch (RuntimeException e) {
            model.addAttribute("errorMsg", e.getMessage());
            return "redirect:/stay";
        }
    }

    // ── HYJ 26.07.20 결제 실패 콜백 ──
    @GetMapping("/payment/fail")
    public String paymentFail(@RequestParam(required = false) String code,
                                @RequestParam(required = false) String message,
                                RedirectAttributes rttr) {
        rttr.addFlashAttribute("errorMsg", "결제에 실패했습니다: " + message);
        return "redirect:/stay";
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
