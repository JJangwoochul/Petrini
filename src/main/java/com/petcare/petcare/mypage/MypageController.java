package com.petcare.petcare.mypage;

import com.petcare.petcare.member.vo.MemberVO;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("mypageController")
@RequestMapping("/mypage")
public class MypageController {

    /** 마이홈 (대시보드) */
    @GetMapping({"", "/"})
    public String dashboard(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/dashboard";
    }

    /** 주문내역 */
    @GetMapping("/orders")
    public String orders(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/orders";
    }

    /** 예약내역 */
    @GetMapping("/reserve")
    public String reserve(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/reserve";
    }

    /** 포인트/쿠폰 */
    @GetMapping("/points")
    public String points(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/points";
    }

    /** 관심상품 */
    @GetMapping("/wishlist")
    public String wishlist(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/wishlist";
    }

    /** 반려동물 관리 */
    @GetMapping("/pets")
    public String pets(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
            
        return "mypage/pets";
    }

    /** 건강수첩 */
    @GetMapping("/health")
    public String health(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/health";
    }


    /** 알림함 */
    @GetMapping("/notifications")
    public String notifications(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/notifications";
    }

    /** 알림 상세 */
    @GetMapping("/notifications/detail")
    public String notificationDetail(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/notification-detail";
    }

    /** 회원정보 수정 */
    @GetMapping("/edit")
    public String edit(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/edit";
    }

    /** 사업자센터 (BIZ 전용) */
    @GetMapping("/biz")
    public String biz(HttpSession session) {
        MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
        if (memberInfo == null)
            return "redirect:/login";

        if (!"BIZ".equals(memberInfo.getRole())){
            return "redirect:/mypage/biz-apply";
        }

        String url = "";
        switch (memberInfo.getBizType()) {
        case "HOSPITAL":
            url = "redirect:/biz/hospital";
            break;
        case "STAY":
            url = "redirect:/biz/stay";
            break;
        case "RESTAURANT":
            url = "redirect:/biz/restaurant";
            break;
        case "GROOMING":
            url = "redirect:/biz/grooming";
            break;
        case "STUDIO":
            url = "redirect:/biz/studio";
            break;      
        case "STORE":
            url = "redirect:/biz/store";
            break;  
        default:
            url = "mypage/biz";
            break;
        }

        return url;
    }

    /** 사업자 등록 신청 */
    @GetMapping("/biz-apply")
    public String bizApply(HttpSession session) {
        if (session.getAttribute("memberInfo") == null)
            return "redirect:/login";
        return "mypage/biz-apply";
    }
}
