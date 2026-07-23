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
import com.petcare.petcare.stay.vo.ReservationVO;
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
    public String list(@ModelAttribute("search") StayVO searchVO, Model model) throws Exception {
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
    public Map<String, Object> checkAvailability(@RequestParam("roomId") Long roomId,
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
                              RedirectAttributes rttr) throws Exception {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        vo.setMemberNo(member.getMemberNo());
        vo.setTargetId(String.valueOf(stayId));

        try {
            
            //HYJ 26.07.23 결제 없이 예약버튼만 눌러도 예약처리됨 -> 수정필요
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
                            Model model) throws Exception {

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
                                    Model model) throws Exception {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        // orderId 형식: stay-{resvId}-{usedPoint}-{timestamp}
        String[] parts = orderId.split("-");
        Long resvId = Long.parseLong(parts[1]);
        long usedPoint = parts.length >= 4 ? Long.parseLong(parts[2]) : 0;

        try {
            String kakaoToken = (String) session.getAttribute("kakaoAccessToken");
            stayService.confirmPayment(resvId, paymentKey, orderId, null, kakaoToken, member.getMemberNo(), usedPoint);

            // 세션 포인트 갱신
            if (usedPoint > 0) {
                long currentBalance = (member.getPointBalance() != null) ? member.getPointBalance() : 0;
                member.setPointBalance(currentBalance - usedPoint);
                session.setAttribute("memberInfo", member);
            }

            return "redirect:/stay/complete?resvId=" + resvId;
        } catch (RuntimeException e) {
            model.addAttribute("errorMsg", e.getMessage());
            return "redirect:/stay";
        }
    }

    // ── HYJ 26.07.21 전액 포인트 결제 (Toss 없이 직접 처리) ──
    @GetMapping("/payment/point-only")
    public String paymentPointOnly(@RequestParam("resvId") Long resvId,
                                    @RequestParam("usedPoint") Long usedPoint,
                                    HttpSession session,
                                    RedirectAttributes rttr) throws Exception {

        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        try {
            String kakaoToken = (String) session.getAttribute("kakaoAccessToken");
            stayService.confirmPayment(resvId, "POINT_ONLY", "point-" + resvId + "-" + System.currentTimeMillis(),
                    "POINT", kakaoToken, member.getMemberNo(), usedPoint);

            // 세션 포인트 갱신
            long currentBalance = (member.getPointBalance() != null) ? member.getPointBalance() : 0;
            member.setPointBalance(currentBalance - usedPoint);
            session.setAttribute("memberInfo", member);

            return "redirect:/stay/complete?resvId=" + resvId;
        } catch (RuntimeException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/stay/payment?resvId=" + resvId;
        }
    }

    // ── HYJ 26.07.20 결제 실패 콜백 ──
    @GetMapping("/payment/fail")
    public String paymentFail(@RequestParam(required = false) String code,
                                @RequestParam(required = false) String message,
                                RedirectAttributes rttr) throws Exception {
        rttr.addFlashAttribute("errorMsg", "결제에 실패했습니다: " + message);
        return "redirect:/stay";
    }

    @GetMapping("/complete")
    public String complete(@RequestParam(value = "resvId", required = false) Long resvId,
                           Model model) throws Exception {
        if (resvId != null) {
            ReservationVO reservation = stayService.getReservationById(resvId);
            model.addAttribute("reservation", reservation);
        }
        return "stay/complete";
    }
}
