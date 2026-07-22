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
import com.petcare.petcare.store.vo.OrderTempVO;


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
   //지윤 26.07.12 가격대(minPrice/maxPrice)·브랜드(brand) 필터 파라미터 추가
    @GetMapping({"", "/"})
    public String store(@RequestParam(required = false) String q,
                         @RequestParam(required = false, defaultValue = "5") Long species,
                         @RequestParam(required = false) Long category,
                         @RequestParam(required = false) Long age,
                         @RequestParam(required = false) String keyword,
                         @RequestParam(required = false) Integer minPrice,
                         @RequestParam(required = false) Integer maxPrice,
                         @RequestParam(required = false) String brand,
                         @RequestParam(required = false, defaultValue = "popular") String sort,
                         @RequestParam(required = false, defaultValue = "1") int page,
                         Model model) {
        if (q != null && !q.isBlank()) {
            return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);
        }
        Long effectiveCategoryId = (age != null) ? age : (category != null ? category : species);

        model.addAttribute("productList", storeShopService.getProductList(effectiveCategoryId, keyword, minPrice, maxPrice, brand, sort, page));
        model.addAttribute("categoryTree", storeShopService.getCategoryTree());
        model.addAttribute("brandList", storeShopService.getBrandList(effectiveCategoryId, keyword, minPrice, maxPrice));
        model.addAttribute("selectedSpecies", species);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedAge", age);
        model.addAttribute("selectedKeyword", keyword);
        model.addAttribute("selectedMinPrice", minPrice);
        model.addAttribute("selectedMaxPrice", maxPrice);
        model.addAttribute("selectedBrand", brand);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", storeShopService.getTotalPages(effectiveCategoryId, keyword, minPrice, maxPrice, brand));
        model.addAttribute("totalCount", storeShopService.getTotalCount(effectiveCategoryId, keyword, minPrice, maxPrice, brand));
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

    //지윤 26.07.13 추가: 토스 위젯이 결제 인증 후 우리 서버를 거치지 않고 order-complete로 바로 이동시키기 때문에,
    //그 사이 없어질 주문정보(상품/배송지/쿠폰/포인트)를 세션에 담아뒀다가 order-complete에서 꺼내 씀
    OrderTempVO orderTemp = new OrderTempVO();
    orderTemp.setMemberNo(memberNo);
    orderTemp.setOrderItems(orderItems);
    orderTemp.setProductTotal(productTotal);
    orderTemp.setDeliveryFee(deliveryFee);
    orderTemp.setCouponMemberCouponId((couponId != null && couponId > 0) ? couponId : null);
    orderTemp.setCouponDiscount(couponDiscount);
    orderTemp.setPointUsed((int) pointUsed);
    orderTemp.setTotalDiscount(totalDiscount);
    orderTemp.setFinalTotal(finalTotal);
    orderTemp.setRecvName(recvName);
    orderTemp.setRecvPhone(recvPhone);
    orderTemp.setZipCode(zipCode);
    orderTemp.setAddr1(addr1);
    orderTemp.setAddr2(addr2);
    orderTemp.setDeliveryMemo(deliveryMemo);
    orderTemp.setCartItemIds(cartItemIds);
    session.setAttribute("orderTemp", orderTemp);

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

    //지윤 26.07.13 수정: 하드코딩된 화면 -> 세션에 저장해둔 주문정보로 실제 DB 저장 후 실데이터 표시
    @GetMapping("/order-complete")
    public String orderComplete(@RequestParam(required = false) String orderId,
                                 @RequestParam(required = false) String paymentKey,
                                 @RequestParam(required = false) String paymentType,
                                 HttpSession session, Model model) {
        OrderTempVO orderTemp = (OrderTempVO) session.getAttribute("orderTemp");

        // 새로고침 등으로 세션에 남은 주문정보가 없으면 저장할 게 없다는 안내만 보여줌
        if (orderTemp == null) {
            model.addAttribute("noOrderData", true);
            return "store/order-complete";
        }

        String orderNo = storeShopService.completeOrder(orderTemp, paymentKey, orderId);
        session.removeAttribute("orderTemp"); // 새로고침해도 중복저장 안 되게 바로 비움

        model.addAttribute("orderNo", orderNo);
        model.addAttribute("orderItems", orderTemp.getOrderItems());
        model.addAttribute("payAmount", orderTemp.getFinalTotal());
        model.addAttribute("payMethodLabel", "NORMAL".equals(paymentType) ? "일반결제" : paymentType);
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

//지윤 26.07.10 상품 Q&A 문의 등록 (AJAX)
//지윤 26.07.12 수정: 응답을 "OK:qnaId" 형식으로 변경 (등록 직후 삭제버튼 붙이기 위함)
@PostMapping("/qna/add")
@ResponseBody
public String addQna(@RequestParam Long productId, @RequestParam String question,
                      @RequestParam(required = false) Long optionId, HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "LOGIN_REQUIRED";
    }
    if (question == null || question.isBlank()) {
        return "EMPTY";
    }
    Long qnaId = storeShopService.addProductQna(productId, memberNo, question.trim(), optionId);
    return "OK:" + qnaId;
}

//지윤 26.07.12 상품 Q&A 삭제 (AJAX, 본인 글 + 답변 미완료 건만 삭제 가능)
@PostMapping("/qna/delete")
@ResponseBody
public String deleteQna(@RequestParam Long qnaId, HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "LOGIN_REQUIRED";
    }
    boolean deleted = storeShopService.deleteProductQna(qnaId, memberNo);
    return deleted ? "OK" : "FAILED";
}

//지윤 26.07.21 추가: 유저 리뷰 신고 (AJAX). 이미 신고한 리뷰면 ALREADY 반환
@PostMapping("/review/report")
@ResponseBody
public String reportReview(@RequestParam Long reviewId, @RequestParam(required = false) String reason, HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "LOGIN_REQUIRED";
    }
    boolean ok = storeShopService.reportReview(reviewId, memberNo, reason);
    return ok ? "OK" : "ALREADY";
}

//지윤 26.07.21 추가: 본인이 작성한 상품 리뷰 삭제 (AJAX)
@PostMapping("/review/delete")
@ResponseBody
public String deleteReview(@RequestParam Long reviewId, HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "LOGIN_REQUIRED";
    }
    boolean deleted = storeShopService.deleteProductReview(reviewId, memberNo);
    return deleted ? "OK" : "FAILED";
}
}
