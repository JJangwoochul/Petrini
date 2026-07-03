/**
 * 역할: 사업자 펫호텔 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: BizStayService
 * - 상속: BizBaseController (사업자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.biz.stay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.biz.controller.BizBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("bizStayController")
@RequestMapping("/biz/stay")
public class BizStayController extends BizBaseController {

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

    @GetMapping("/contract")
    public String stayContract(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/stay/contract";
    }
/*사업자(상점) 정산관리 추가*/
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
/*사업자 숙소관리 메뉴 0702지윤*/
    @GetMapping("/lodge")
    public String stayLodge(HttpSession session) {
        if (getBizMember(session) == null) 
            return "redirect:/login";

        return "biz/stay/lodge";

    }
}
