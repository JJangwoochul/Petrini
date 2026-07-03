/**
 * 역할: 사업자 동물병원 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: BizHospitalService
 * - 상속: BizBaseController (사업자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.biz.hospital.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.biz.controller.BizBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("bizHospitalController")
@RequestMapping("/biz/hospital")
public class BizHospitalController extends BizBaseController {

    @GetMapping({"", "/"})
    public String hospitalDashboard(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/dashboard";
    }

    @GetMapping("/reserve")
    public String hospitalReserve(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/reserve";
    }

    @GetMapping("/calendar")
    public String hospitalCalendar(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/calendar";
    }

    @GetMapping("/treatments")
    public String hospitalTreatments(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/treatments";
    }

    @GetMapping("/patients")
    public String hospitalPatients(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/patients";
    }

    @GetMapping("/records")
    public String hospitalRecords(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/records";
    }

    @GetMapping("/talent")
    public String hospitalTalent(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/talent";
    }

    @GetMapping("/reviews")
    public String hospitalReviews(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/reviews";
    }

    @GetMapping("/contract")
    public String hospitalContract(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/contract";
    }

    @GetMapping("/info")
    public String hospitalInfo(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/info";
    }

    @GetMapping("/profile")
    public String hospitalProfile(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/profile";
    }
}
