package com.petcare.petcare.mypage.order.controller;

import java.util.List;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

 //지윤 26.07.20 수정: 리뷰작성 모달에서 폼 submit + 사진 첨부(최대 5장, 선택). 배송완료 상품만 대상, 중복작성은 서비스에서 막음
 @PostMapping("/orders/review")
 public String writeReview(@RequestParam("orderItemId") Long orderItemId,
                            @RequestParam("rating") Double rating,
                            @RequestParam("content") String content,
                            @RequestParam(value = "images", required = false) List<MultipartFile> images,
                            HttpSession session, RedirectAttributes rttr) throws Exception {
     MemberVO member = (MemberVO) session.getAttribute("memberInfo");
     if (member == null) return "redirect:/login";

     //지윤 26.07.28 수정: earnPoint == 0(등록은 성공했지만 50자 미만이라 포인트만 미지급)과 null(등록 자체 실패)을 구분해서 안내
     Integer earnPoint = mypageOrderService.writeReview(member.getMemberNo(), orderItemId, rating, content, images);
     if (earnPoint != null && earnPoint > 0) {
         rttr.addFlashAttribute("msg", "리뷰가 등록되었습니다. " + earnPoint + "P가 적립되었습니다.");
         //지윤 26.07.23 추가: 세션의 포인트 잔액도 즉시 갱신 (로그아웃 안 해도 마이홈에 바로 반영되게)
         MemberVO sessionMember = (MemberVO) session.getAttribute("memberInfo");
         if (sessionMember != null) {
             long current = sessionMember.getPointBalance() != null ? sessionMember.getPointBalance() : 0L;
             sessionMember.setPointBalance(current + earnPoint);
             session.setAttribute("memberInfo", sessionMember);
         }
     } else if (earnPoint != null) {
         //지윤 26.07.28 추가: earnPoint == 0인 경우 (10자 이상이지만 50자 미만이라 포인트 미지급, 등록 자체는 성공)
         rttr.addFlashAttribute("msg", "리뷰가 등록되었습니다. (50자 미만으로 작성되어 포인트는 지급되지 않았습니다.)");
     } else {
         //지윤 26.07.28 수정: 절대 최소치가 10자로 완화됨에 따라 문구 수정
         rttr.addFlashAttribute("errorMsg", "리뷰는 최소 10자 이상 작성해야 하며, 이미 작성했거나 본인 주문이 아니면 등록할 수 없습니다.");
     }
     return "redirect:/mypage/orders?statusCd=DONE";
 }

    //지윤 26.07.20 추가: 주문상세보기 (결제내역/배송지, 읽기전용 - 리뷰작성은 목록에서 모달로 처리)
    @GetMapping("/orders/detail")
    public String orderDetail(@RequestParam("orderId") Long orderId, HttpSession session, Model model) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        var detail = mypageOrderService.getOrderDetail(member.getMemberNo(), orderId);
        if (detail == null) return "redirect:/mypage/orders?error=notfound";

        model.addAttribute("order", detail);
        return "mypage/orders-detail";
    }

    //지윤 26.07.22 추가: 주문취소 신청 (사유 입력 모달 → 폼 submit, 처리 후 상세페이지로 리다이렉트)
    @PostMapping("/orders/cancel")
    public String cancelOrder(@RequestParam("orderId") Long orderId,
                               @RequestParam("reason") String reason,
                               HttpSession session, RedirectAttributes rttr) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        boolean ok = mypageOrderService.requestCancel(member.getMemberNo(), orderId, reason);
        rttr.addFlashAttribute(ok ? "msg" : "errorMsg",
                ok ? "취소 신청이 접수되었습니다. 사업자 확인 후 처리됩니다." : "취소 신청에 실패했습니다. 이미 배송이 시작되었거나 신청 이력이 있습니다.");
        return "redirect:/mypage/orders/detail?orderId=" + orderId;
    }
    
    //지윤 26.07.23 추가: 구매확정 처리 (배송완료 상태 주문에서 버튼 누르면 결제금액의 % 만큼 적립)
    @PostMapping("/orders/confirm")
    public String confirmPurchase(@RequestParam("orderId") Long orderId, HttpSession session, RedirectAttributes rttr) {
        MemberVO member = (MemberVO) session.getAttribute("memberInfo");
        if (member == null) return "redirect:/login";

        Integer earnPoint = mypageOrderService.confirmPurchase(member.getMemberNo(), orderId);
        if (earnPoint != null) {
            rttr.addFlashAttribute("msg", "구매확정 되었습니다. " + earnPoint + "P가 적립되었습니다.");
            MemberVO sessionMember = (MemberVO) session.getAttribute("memberInfo");
            if (sessionMember != null) {
                long current = sessionMember.getPointBalance() != null ? sessionMember.getPointBalance() : 0L;
                sessionMember.setPointBalance(current + earnPoint);
                session.setAttribute("memberInfo", sessionMember);
            }
        } else {
            rttr.addFlashAttribute("errorMsg", "이미 구매확정했거나 배송완료 상태가 아닙니다.");
        }
        return "redirect:/mypage/orders";
    }
}