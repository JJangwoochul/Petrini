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

    @GetMapping("/payment")
    public String payment(Model model) {
        //HYJ 26.07.03 결제 api key
        model.addAttribute("tossApiKey", tossApiKey);
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
    public String orderComplete() {
        return "store/order-complete";
    }

    @GetMapping("/order")
    public String order(@RequestParam(required = false) Long productId,
                    @RequestParam(required = false) Long optionId,
                    @RequestParam(defaultValue = "1") int qty,
                    Model model,
                    HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "redirect:/login";
    }
    // 바로구매로 들어온 경우: 상품 1개만 주문서에 넘김
    if (productId != null) {
        model.addAttribute("orderItems",
                storeShopService.getDirectOrderItem(productId, optionId, qty));
    }
    // 기존 쿠폰 조회는 그대로 유지
    model.addAttribute("memberCoupons", storeShopService.getMemberCoupons(memberNo));
    return "store/order";
}
}
