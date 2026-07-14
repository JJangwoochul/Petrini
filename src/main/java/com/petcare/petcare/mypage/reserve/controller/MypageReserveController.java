/**
 * 역할: 마이페이지 예약 URL 처리 → Service 호출 → JSP 반환
 *
 * 2026/07/11 장우철 — 예약 내역·상세 DB 연동 (2차)
 */

package com.petcare.petcare.mypage.reserve.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.mypage.reserve.service.MypageReserveService;
import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/mypage")
public class MypageReserveController {

    @Autowired
    private MypageReserveService mypageReserveService;

    @GetMapping("/reserve")
    public String reserve(@RequestParam(value = "status", required = false, defaultValue = "all") String status,
                          HttpSession session,
                          Model model) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null || member.getMemberNo() == null) {
            return "redirect:/login?redirect=/mypage/reserve";
        }
        List<MypageReserveVO> reservationList = mypageReserveService.getMyReservationList(member.getMemberNo(), status);
        model.addAttribute("statusFilter", status);
        model.addAttribute("reservationList", reservationList);
        return "mypage/reserve";
    }

    // 2026/07/11 장우철 — 예약 상세 (/mypage/reserve/detail?resvId=)
    @GetMapping("/reserve/detail")
    public String reserveDetail(@RequestParam("resvId") Long resvId,
                                HttpSession session,
                                Model model) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null || member.getMemberNo() == null) {
            return "redirect:/login?redirect=/mypage/reserve/detail?resvId=" + resvId;
        }

        MypageReserveVO detail =
                mypageReserveService.getMyReservationDetail(member.getMemberNo(), resvId);
        if (detail == null) {
            return "redirect:/mypage/reserve?error=notfound";
        }
        model.addAttribute("reservation", detail);
        return "mypage/reserve-detail";
    }
}
