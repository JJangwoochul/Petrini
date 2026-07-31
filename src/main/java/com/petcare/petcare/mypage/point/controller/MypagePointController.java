/**
 * 역할: 마이페이지 포인트 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: MypagePointService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.mypage.point.controller;

import jakarta.servlet.http.HttpSession;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.coupon.service.CouponService;
import com.petcare.petcare.store.vo.CouponVO;
import com.petcare.petcare.member.vo.MemberVO;

@Controller
@RequestMapping("/mypage")
public class MypagePointController {

    @Autowired
    private CouponService couponService;

    @GetMapping("/points")
    public String points(HttpSession session, Model model) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        // 보유 쿠폰 목록
        List<CouponVO> myCoupons = couponService.getMyCoupons(member.getMemberNo());
        model.addAttribute("myCoupons", myCoupons);
        
        // 사용 가능 쿠폰 개수
        int usableCouponCount = couponService.countUsableCoupons(member.getMemberNo());
        model.addAttribute("usableCouponCount", usableCouponCount);

        return "mypage/points";
    }
}
