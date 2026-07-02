package com.petcare.petcare.biz.hospital;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.biz.BizBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("bizHospitalController")
@RequestMapping("/biz/hospital")
public class HospitalController extends BizBaseController {

    // ── 병원 (HOSPITAL) ──────────────────────────────────────
    @GetMapping({"", "/"})
    public String hospitalDashboard(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/dashboard";
    }

    //예약관리
    @GetMapping("/reserve")
    public String hospitalReserve(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/reserve";
    }

    //진료항목 관리
    @GetMapping("/treatments")
    public String hospitalTreatments(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/treatments";
    }

    //내원환자 이력
    @GetMapping("/patients")
    public String hospitalPatients(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/patients";
    }

    //진료기록 관리
    @GetMapping("/records")
    public String hospitalRecords(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/records";
    }

    //재능나눔 신청
    @GetMapping("/talent")
    public String hospitalTalent(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/talent";
    }

    //리뷰관리
    @GetMapping("/reviews")
    public String hospitalReviews(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/reviews";
    }

    /*//정산내역
    @GetMapping("/settlement")
    public String hospitalSettlement(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/settlement";
    }*/

     //계약관리
     @GetMapping("/contract")
     public String hospitalContract(HttpSession session) {
         if (getBizMember(session) == null) 
             return "redirect:/login";
 
         return "biz/hospital/contract";
     }
     
    //업체정보
    @GetMapping("/info")
    public String hospitalInfo(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/hospital/info";
    }    
}
