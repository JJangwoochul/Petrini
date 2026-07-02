package com.petcare.petcare.biz.stay;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.biz.BizBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("bizStayController")
@RequestMapping("/biz/stay")
public class StayController extends BizBaseController {

    // ── 숙소 (STAY) ──────────────────────────────────────────
    @GetMapping({"", "/"})
    public String stayDashboard(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/dashboard";
    }
    @GetMapping("/reserve")
    public String stayReserve(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/reserve";
    }
    @GetMapping("/rooms")
    public String stayRooms(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/rooms";
    }
    @GetMapping("/calendar")
    public String stayCalendar(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/calendar";
    }
    @GetMapping("/reviews")
    public String stayReviews(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/reviews";
    }
    @GetMapping("/settlement")
    public String staySettlement(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/settlement";
    }
    @GetMapping("/info")
    public String stayInfo(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/info";
    }    
}
