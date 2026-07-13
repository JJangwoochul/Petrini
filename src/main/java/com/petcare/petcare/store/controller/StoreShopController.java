/**
 * 역할: 쇼핑몰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: StoreShopService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.store.controller;

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PostMapping;

import com.petcare.petcare.store.service.StoreShopService;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.CartItemVO;
import com.petcare.petcare.store.vo.CouponVO;
import java.util.List;
import com.petcare.petcare.member.vo.MemberVO;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller("storeController")
@RequestMapping("/store")
public class StoreShopController {

    //HYJ 26.07.03 토스결제 api key
    @Value("${toss.client-key}")
    private String tossApiKey;

    //지윤 26.07.06 상품목록 조회용 Service 주입
    @Autowired
    private StoreShopService storeShopService;

    //지윤 26.07.09 로그인 기능 연동: 세션에서 로그인한 회원번호 가져오기 (없으면 null)
    private Long getLoginMemberNo(HttpSession session) {
    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
    return (memberInfo != null) ? memberInfo.getMemberNo() : null;
}

    // ----- 수정 전 원본 -----
    // @GetMapping({"", "/"})
    // public String store(@RequestParam(required = false) String q) {
    //     if (q != null && !q.isBlank()) {
    //         return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);}
    //     return "store/list";}
    // ----- 수정 전 원본 -----
    //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터
    //지윤 26.07.06 카테고리 트리(species/category/age 3단계) 적용
    // 우선순위: age > category > species (더 세부적으로 고른 게 있으면 그걸로 필터링)
    @GetMapping({"", "/"})
    public String store(@RequestParam(required = false) String q,
                         @RequestParam(required = false, defaultValue = "5") Long species,
                         @RequestParam(required = false) Long category,
                         @RequestParam(required = false) Long age,
                         @RequestParam(required = false) String keyword,
                         @RequestParam(required = false, defaultValue = "popular") String sort,
                         @RequestParam(required = false, defaultValue = "1") int page,
                         Model model) {
        if (q != null && !q.isBlank()) {
            return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);
        }
        Long effectiveCategoryId = (age != null) ? age : (category != null ? category : species);

        model.addAttribute("productList", storeShopService.getProductList(effectiveCategoryId, keyword, sort, page));
        model.addAttribute("categoryTree", storeShopService.getCategoryTree());
        model.addAttribute("selectedSpecies", species);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedAge", age);
        model.addAttribute("selectedKeyword", keyword);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", storeShopService.getTotalPages(effectiveCategoryId, keyword));
        return "store/list";
    }

    
    
   //지윤 26.07.07 상품 상세 실데이터 연동
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") Long id, Model model) {
    model.addAttribute("product", storeShopService.getProductDetail(id));
    return "store/detail";
}

//지윤 26.07.08 장바구니 담기 (POST). 로그인 기능 없어서 MEMBER_NO=1 임시 고정
//지윤 26.07.09 수정: 로그인 안 했으면 장바구니 담기 막고 알림 후 로그인페이지로 이동
@PostMapping("/cart/add")
public String addToCart(@RequestParam Long productId,
                         @RequestParam(required = false) String optionId,
                         @RequestParam(defaultValue = "1") int qty,
                         @RequestParam int price,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        redirectAttributes.addFlashAttribute("loginRequired", true);
        return "redirect:/login";
    }
    Long optionIdLong = (optionId == null || optionId.isBlank()) ? null : Long.valueOf(optionId);
    storeShopService.addToCart(memberNo, productId, optionIdLong, qty, price);
    redirectAttributes.addFlashAttribute("cartAddSuccess", true);
    return "redirect:/store/cart";
}

//지윤 26.07.08 장바구니 수량 변경 (AJAX, cart.jsp에서 호출)
@PostMapping("/cart/updateQty")
@ResponseBody
public String updateCartQty(@RequestParam Long cartItemId, @RequestParam int qty) {
    storeShopService.updateCartItemQty(cartItemId, qty);
    return "OK";
}

//지윤 26.07.08 장바구니 항목 삭제 (AJAX, cart.jsp에서 호출)
@PostMapping("/cart/delete")
@ResponseBody
public String deleteCartItem(@RequestParam Long cartItemId) {
    storeShopService.deleteCartItem(cartItemId);
    return "OK";
}

//지윤 26.07.08 장바구니 선택삭제/전체삭제 (AJAX)
@PostMapping("/cart/deleteAll")
@ResponseBody
public String deleteCartItems(@RequestParam java.util.List<Long> cartItemIds) {
    storeShopService.deleteCartItems(cartItemIds);
    return "OK";
}

//지윤 26.07.08 헤더 장바구니 뱃지용 (AJAX, 모든 페이지 로드 시 header에서 호출)
@GetMapping("/cart/count")
@ResponseBody
public int getCartCount(HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) return 0;
    return storeShopService.getCartItemCount(memberNo);
}

    //지윤 26.07.09 장바구니 실데이터 연동 
    @GetMapping("/cart")
    public String cart(Model model, HttpSession session) {
        Long memberNo = getLoginMemberNo(session);
        if (memberNo == null) {
            return "redirect:/login";
        }
        model.addAttribute("cartItems", storeShopService.getCartItems(memberNo));
        return "store/cart";
    }

    /*@GetMapping("/payment")
    public String payment(Model model) {
        //HYJ 26.07.03 결제 api key
        model.addAttribute("tossApiKey", tossApiKey);
        return "store/payment";
    }*/
    //지윤 26.07.10 수정: GET -> POST, 쿠폰/포인트 서버 재검증 후 결제페이지에 실데이터 전달
@PostMapping("/payment")
public String payment(@RequestParam(required = false) Long productId,
                       @RequestParam(required = false) Long optionId,
                       @RequestParam(defaultValue = "1") int qty,
                       @RequestParam(required = false) List<Long> cartItemIds,
                       @RequestParam(required = false, defaultValue = "0") Long couponId,
                       @RequestParam(required = false, defaultValue = "0") Long point,
                       @RequestParam String recvName,
                       @RequestParam String recvPhone,
                       @RequestParam String zipCode,
                       @RequestParam String addr1,
                       @RequestParam(required = false) String addr2,
                       @RequestParam(required = false) String deliveryMemo,
                       Model model,
                       HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "redirect:/login";
    }
    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");

    // 지윤 26.07.10 주문 아이템은 클라이언트 값 안 믿고 서버에서 다시 조회
    List<CartItemVO> orderItems = (productId != null)
            ? storeShopService.getDirectOrderItem(productId, optionId, qty)
            : storeShopService.getCartOrderItems(cartItemIds);

    int productTotal = 0;
    for (CartItemVO item : orderItems) {
        productTotal += item.getPrice() * item.getQty();
    }
    int deliveryFee = (productTotal == 0 || productTotal >= 50000) ? 0 : 3000;

    // 지윤 26.07.10 쿠폰 재검증: 본인이 실제 보유한(UNUSED) 쿠폰인지 확인
    int couponDiscount = 0;
    String couponName = null;
    if (couponId != null && couponId > 0) {
        for (CouponVO c : storeShopService.getMemberCoupons(memberNo)) {
            if (c.getMemberCouponId().equals(couponId)) {
                if (productTotal >= c.getMinOrderAmt()) {
                    couponDiscount = "RATE".equals(c.getCouponType())
                            ? productTotal * c.getDiscountValue() / 100
                            : c.getDiscountValue();
                    couponName = c.getCouponName();
                }
                break;
            }
        }
    }

    // 지윤 26.07.10 포인트 재검증: 보유 포인트, 결제금액 넘게 사용 못 하도록 제한
    long memberPoint = (memberInfo != null && memberInfo.getPointBalance() != null)
            ? memberInfo.getPointBalance() : 0L;
    long maxUsable = Math.max(0, Math.min(memberPoint, productTotal + deliveryFee - couponDiscount));
    long pointUsed = Math.max(0, Math.min(point == null ? 0 : point, maxUsable));

    int totalDiscount = couponDiscount + (int) pointUsed;
    int finalTotal = Math.max(0, productTotal + deliveryFee - totalDiscount);

    model.addAttribute("orderItems", orderItems);
    model.addAttribute("productTotal", productTotal);
    model.addAttribute("deliveryFee", deliveryFee);
    model.addAttribute("couponName", couponName);
    model.addAttribute("couponDiscount", couponDiscount);
    model.addAttribute("pointUsed", pointUsed);
    model.addAttribute("totalDiscount", totalDiscount);
    model.addAttribute("finalTotal", finalTotal);
    model.addAttribute("recvName", recvName);
    model.addAttribute("recvPhone", recvPhone);
    model.addAttribute("zipCode", zipCode);
    model.addAttribute("addr1", addr1);
    model.addAttribute("addr2", addr2);
    model.addAttribute("deliveryMemo", deliveryMemo);
    //HYJ 26.07.03 결제 api key
    model.addAttribute("tossApiKey", tossApiKey);

    // 2026/07/11 장우철 — 장바구니 주문이면 결제 완료 후 삭제할 cartItemIds 세션에 보관
    // [변경 전] 주문 완료(/order-complete)에서 장바구니 미삭제 → 결제 후에도 동일 상품 잔존
    if (cartItemIds != null && !cartItemIds.isEmpty()) {
        session.setAttribute("pendingOrderCartItemIds", cartItemIds);
    } else {
        session.removeAttribute("pendingOrderCartItemIds");
    }

    return "store/payment";
}

    // HYJ 26.07.03 결제 요청 성공 시 여기로 돌아옴 (아직 승인 API는 호출 안 함)
    @GetMapping("/test/payment/success")
    @ResponseBody
    public String success(@RequestParam String orderId,
                            @RequestParam String amount,
                            @RequestParam String paymentKey) {
        return "결제 요청 성공! orderId=" + orderId + ", amount=" + amount + ", paymentKey=" + paymentKey;
    }

    @GetMapping("/test/payment/fail")
    @ResponseBody
    public String fail(@RequestParam(required = false) String code,
                        @RequestParam(required = false) String message) {
        return "결제 요청 실패: " + code + " - " + message;
    }

    @GetMapping("/order-complete")
    public String orderComplete(HttpSession session) {
        // 2026/07/11 장우철 — 토스 결제 성공 후 진입 시, 주문한 장바구니 항목 삭제
        // [변경 전] 화면만 반환하고 TB_CART_ITEM 미삭제
        Long memberNo = getLoginMemberNo(session);
        @SuppressWarnings("unchecked")
        List<Long> cartItemIds = (List<Long>) session.getAttribute("pendingOrderCartItemIds");
        if (memberNo != null && cartItemIds != null && !cartItemIds.isEmpty()) {
            storeShopService.deleteCartItems(cartItemIds);
            session.removeAttribute("pendingOrderCartItemIds");
        }
        return "store/order-complete";
    }

    //지윤 26.07.09 수정: cartItemIds 파라미터 추가 - 장바구니에서 주문하기로 들어온 경우 처리
@GetMapping("/order")
public String order(@RequestParam(required = false) Long productId,
                @RequestParam(required = false) Long optionId,
                @RequestParam(defaultValue = "1") int qty,
                @RequestParam(required = false) java.util.List<Long> cartItemIds,
                Model model,
                HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "redirect:/login";
    }

//지윤 26.07.10 보유 포인트 + 기본 배송지 실데이터 연동 (세션의 memberInfo에서 그대로 가져옴)
MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
model.addAttribute("memberPoint", memberInfo != null && memberInfo.getPointBalance() != null ? memberInfo.getPointBalance() : 0L);
model.addAttribute("memberPhone", memberInfo != null && memberInfo.getPhone() != null ? memberInfo.getPhone() : "");
model.addAttribute("memberZipCode", memberInfo != null && memberInfo.getZipcode() != null ? memberInfo.getZipcode() : "");
model.addAttribute("memberAddr1", memberInfo != null && memberInfo.getAddr1() != null ? memberInfo.getAddr1() : "");
model.addAttribute("memberAddr2", memberInfo != null && memberInfo.getAddr2() != null ? memberInfo.getAddr2() : "");

    // 바로구매로 들어온 경우: 상품 1개만 주문서에 넘김
    if (productId != null) {
        model.addAttribute("orderItems",
                storeShopService.getDirectOrderItem(productId, optionId, qty));
    }
    // 장바구니에서 주문하기로 들어온 경우: 체크된 항목들만 주문서에 넘김
    else if (cartItemIds != null && !cartItemIds.isEmpty()) {
        model.addAttribute("orderItems",
                storeShopService.getCartOrderItems(cartItemIds));
    }
    // 기존 쿠폰 조회는 그대로 유지
    model.addAttribute("memberCoupons", storeShopService.getMemberCoupons(memberNo));
    return "store/order";
}
}
