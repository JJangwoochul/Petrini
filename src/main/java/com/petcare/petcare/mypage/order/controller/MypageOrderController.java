/**
 * 역할: 마이페이지 주문 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MypageOrderService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.order.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.mypage.order.service.MypageOrderService;

@Controller
@RequestMapping("/mypage")
public class MypageOrderController {

    @Autowired
    private MypageOrderService mypageOrderService;

    //지윤 26.07.20 수정: 하드코딩 -> 실데이터 연동 (상태 탭 필터)
    @GetMapping("/orders")
    public String orders(@RequestParam(required = false) String statusCd, HttpSession session, Model model) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        model.addAttribute("orderList", mypageOrderService.getOrderList(member.getMemberNo(), statusCd));
        model.addAttribute("selectedStatusCd", statusCd);
        return "mypage/orders";
    }
}
