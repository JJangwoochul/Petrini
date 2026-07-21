/**
 * ??븷: ?쇳븨紐?URL 泥섎━ ??Service ?몄텧 ??JSP 諛섑솚
 *
 * ?곌껐
 * - Service: StoreShopService
 *
 * SQL쨌鍮꾩쫰?덉뒪 濡쒖쭅? ?ｌ? 留?寃???Service濡??꾩엫
 * return 寃쎈줈???대떦 JSP? ?숈씪?섍쾶 留욎텧 寃? */

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

    //HYJ 26.07.03 ?좎뒪寃곗젣 api key
    @Value("${toss.client-key}")
    private String tossApiKey;

    //吏??26.07.06 ?곹뭹紐⑸줉 議고쉶??Service 二쇱엯
    @Autowired
    private StoreShopService storeShopService;

    //吏??26.07.09 濡쒓렇??湲곕뒫 ?곕룞: ?몄뀡?먯꽌 濡쒓렇?명븳 ?뚯썝踰덊샇 媛?몄삤湲?(?놁쑝硫?null)
    private Long getLoginMemberNo(HttpSession session) {
    MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
    return (memberInfo != null) ? memberInfo.getMemberNo() : null;
}

    // ----- ?섏젙 ???먮낯 -----
    // @GetMapping({"", "/"})
    // public String store(@RequestParam(required = false) String q) {
    //     if (q != null && !q.isBlank()) {
    //         return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);}
    //     return "store/list";}
    // ----- ?섏젙 ???먮낯 -----
    //吏??26.07.06 移댄뀒怨좊━/寃?됱뼱/?뺣젹/?섏씠吏?ㅼ씠???뚮씪誘명꽣
    //吏??26.07.06 移댄뀒怨좊━ ?몃━(species/category/age 3?④퀎) ?곸슜
    // ?곗꽑?쒖쐞: age > category > species (???몃??곸쑝濡?怨좊Ⅸ 寃??덉쑝硫?洹멸구濡??꾪꽣留?
   //吏??26.07.12 媛寃⑸?(minPrice/maxPrice)쨌釉뚮옖??brand) ?꾪꽣 ?뚮씪誘명꽣 異붽?
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
        return "store/list";
    }
    
    
   //吏??26.07.07 ?곹뭹 ?곸꽭 ?ㅻ뜲?댄꽣 ?곕룞
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") Long id, Model model) {
    model.addAttribute("product", storeShopService.getProductDetail(id));
    return "store/detail";
}

//吏??26.07.08 ?λ컮援щ땲 ?닿린 (POST). 濡쒓렇??湲곕뒫 ?놁뼱??MEMBER_NO=1 ?꾩떆 怨좎젙
//吏??26.07.09 ?섏젙: 濡쒓렇?????덉쑝硫??λ컮援щ땲 ?닿린 留됯퀬 ?뚮┝ ??濡쒓렇?명럹?댁?濡??대룞
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

//吏??26.07.08 ?λ컮援щ땲 ?섎웾 蹂寃?(AJAX, cart.jsp?먯꽌 ?몄텧)
@PostMapping("/cart/updateQty")
@ResponseBody
public String updateCartQty(@RequestParam Long cartItemId, @RequestParam int qty) {
    storeShopService.updateCartItemQty(cartItemId, qty);
    return "OK";
}

//吏??26.07.08 ?λ컮援щ땲 ??ぉ ??젣 (AJAX, cart.jsp?먯꽌 ?몄텧)
@PostMapping("/cart/delete")
@ResponseBody
public String deleteCartItem(@RequestParam Long cartItemId) {
    storeShopService.deleteCartItem(cartItemId);
    return "OK";
}

//吏??26.07.08 ?λ컮援щ땲 ?좏깮??젣/?꾩껜??젣 (AJAX)
@PostMapping("/cart/deleteAll")
@ResponseBody
public String deleteCartItems(@RequestParam java.util.List<Long> cartItemIds) {
    storeShopService.deleteCartItems(cartItemIds);
    return "OK";
}

//吏??26.07.08 ?ㅻ뜑 ?λ컮援щ땲 諭껋???(AJAX, 紐⑤뱺 ?섏씠吏 濡쒕뱶 ??header?먯꽌 ?몄텧)
@GetMapping("/cart/count")
@ResponseBody
public int getCartCount(HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) return 0;
    return storeShopService.getCartItemCount(memberNo);
}

//吏??26.07.09 ?λ컮援щ땲 ?ㅻ뜲?댄꽣 ?곕룞 
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
    //HYJ 26.07.03 寃곗젣 api key
    model.addAttribute("tossApiKey", tossApiKey);
    return "store/payment";
}*/
//吏??26.07.10 ?섏젙: GET -> POST, 荑좏룿/?ъ씤???쒕쾭 ?ш?利???寃곗젣?섏씠吏???ㅻ뜲?댄꽣 ?꾨떖
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

    // 吏??26.07.10 二쇰Ц ?꾩씠?쒖? ?대씪?댁뼵??媛???誘욧퀬 ?쒕쾭?먯꽌 ?ㅼ떆 議고쉶
    List<CartItemVO> orderItems = (productId != null)
            ? storeShopService.getDirectOrderItem(productId, optionId, qty)
            : storeShopService.getCartOrderItems(cartItemIds);

    int productTotal = 0;
    for (CartItemVO item : orderItems) {
        productTotal += item.getPrice() * item.getQty();
    }
    int deliveryFee = (productTotal == 0 || productTotal >= 50000) ? 0 : 3000;

    // 吏??26.07.10 荑좏룿 ?ш?利? 蹂몄씤???ㅼ젣 蹂댁쑀??UNUSED) 荑좏룿?몄? ?뺤씤
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

    // 吏??26.07.10 ?ъ씤???ш?利? 蹂댁쑀 ?ъ씤?? 寃곗젣湲덉븸 ?섍쾶 ?ъ슜 紐??섎룄濡??쒗븳
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
    //HYJ 26.07.03 寃곗젣 api key
    model.addAttribute("tossApiKey", tossApiKey);

    //吏??26.07.13 異붽?: ?좎뒪 ?꾩젽??寃곗젣 ?몄쬆 ???곕━ ?쒕쾭瑜?嫄곗튂吏 ?딄퀬 order-complete濡?諛붾줈 ?대룞?쒗궎湲??뚮Ц??
    //洹??ъ씠 ?놁뼱吏?二쇰Ц?뺣낫(?곹뭹/諛곗넚吏/荑좏룿/?ъ씤??瑜??몄뀡???댁븘??ㅺ? order-complete?먯꽌 爰쇰궡 ?
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

    // HYJ 26.07.03 寃곗젣 ?붿껌 ?깃났 ???ш린濡??뚯븘??(?꾩쭅 ?뱀씤 API???몄텧 ????
    @GetMapping("/test/payment/success")
    @ResponseBody
    public String success(@RequestParam String orderId,
                            @RequestParam String amount,
                            @RequestParam String paymentKey) {
        return "寃곗젣 ?붿껌 ?깃났! orderId=" + orderId + ", amount=" + amount + ", paymentKey=" + paymentKey;
    }

    @GetMapping("/test/payment/fail")
    @ResponseBody
    public String fail(@RequestParam(required = false) String code,
                        @RequestParam(required = false) String message) {
        return "寃곗젣 ?붿껌 ?ㅽ뙣: " + code + " - " + message;
    }

    //吏??26.07.13 ?섏젙: ?섎뱶肄붾뵫???붾㈃ -> ?몄뀡????ν빐??二쇰Ц?뺣낫濡??ㅼ젣 DB ??????ㅻ뜲?댄꽣 ?쒖떆
    @GetMapping("/order-complete")
    public String orderComplete(@RequestParam(required = false) String orderId,
                                 @RequestParam(required = false) String paymentKey,
                                 @RequestParam(required = false) String paymentType,
                                 HttpSession session, Model model) {
        OrderTempVO orderTemp = (OrderTempVO) session.getAttribute("orderTemp");

        // ?덈줈怨좎묠 ?깆쑝濡??몄뀡???⑥? 二쇰Ц?뺣낫媛 ?놁쑝硫???ν븷 寃??녿떎???덈궡留?蹂댁뿬以?        if (orderTemp == null) {
            model.addAttribute("noOrderData", true);
            return "store/order-complete";
        }

        String orderNo = storeShopService.completeOrder(orderTemp, paymentKey, orderId);
        session.removeAttribute("orderTemp"); // ?덈줈怨좎묠?대룄 以묐났??????섍쾶 諛붾줈 鍮꾩?

        model.addAttribute("orderNo", orderNo);
        model.addAttribute("orderItems", orderTemp.getOrderItems());
        model.addAttribute("payAmount", orderTemp.getFinalTotal());
        model.addAttribute("payMethodLabel", "NORMAL".equals(paymentType) ? "?쇰컲寃곗젣" : paymentType);
        return "store/order-complete";
    }

    //吏??26.07.09 ?섏젙: cartItemIds ?뚮씪誘명꽣 異붽? - ?λ컮援щ땲?먯꽌 二쇰Ц?섍린濡??ㅼ뼱??寃쎌슦 泥섎━
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

//吏??26.07.10 蹂댁쑀 ?ъ씤??+ 湲곕낯 諛곗넚吏 ?ㅻ뜲?댄꽣 ?곕룞 (?몄뀡??memberInfo?먯꽌 洹몃?濡?媛?몄샂)
MemberVO memberInfo = (MemberVO) session.getAttribute("memberInfo");
model.addAttribute("memberPoint", memberInfo != null && memberInfo.getPointBalance() != null ? memberInfo.getPointBalance() : 0L);
model.addAttribute("memberPhone", memberInfo != null && memberInfo.getPhone() != null ? memberInfo.getPhone() : "");
model.addAttribute("memberZipCode", memberInfo != null && memberInfo.getZipcode() != null ? memberInfo.getZipcode() : "");
model.addAttribute("memberAddr1", memberInfo != null && memberInfo.getAddr1() != null ? memberInfo.getAddr1() : "");
model.addAttribute("memberAddr2", memberInfo != null && memberInfo.getAddr2() != null ? memberInfo.getAddr2() : "");

    // 諛붾줈援щℓ濡??ㅼ뼱??寃쎌슦: ?곹뭹 1媛쒕쭔 二쇰Ц?쒖뿉 ?섍?
    if (productId != null) {
        model.addAttribute("orderItems",
                storeShopService.getDirectOrderItem(productId, optionId, qty));
    }
    // ?λ컮援щ땲?먯꽌 二쇰Ц?섍린濡??ㅼ뼱??寃쎌슦: 泥댄겕????ぉ?ㅻ쭔 二쇰Ц?쒖뿉 ?섍?
    else if (cartItemIds != null && !cartItemIds.isEmpty()) {
        model.addAttribute("orderItems",
                storeShopService.getCartOrderItems(cartItemIds));
    }
    // 湲곗〈 荑좏룿 議고쉶??洹몃?濡??좎?
    model.addAttribute("memberCoupons", storeShopService.getMemberCoupons(memberNo));
    return "store/order";
}

//吏??26.07.10 ?곹뭹 Q&A 臾몄쓽 ?깅줉 (AJAX)
//吏??26.07.12 ?섏젙: ?묐떟??"OK:qnaId" ?뺤떇?쇰줈 蹂寃?(?깅줉 吏곹썑 ??젣踰꾪듉 遺숈씠湲??꾪븿)
@PostMapping("/qna/add")
@ResponseBody
public String addQna(@RequestParam Long productId, @RequestParam String question, HttpSession session) {
    Long memberNo = getLoginMemberNo(session);
    if (memberNo == null) {
        return "LOGIN_REQUIRED";
    }
    if (question == null || question.isBlank()) {
        return "EMPTY";
    }
    Long qnaId = storeShopService.addProductQna(productId, memberNo, question.trim());
    return "OK:" + qnaId;
}

//吏??26.07.12 ?곹뭹 Q&A ??젣 (AJAX, 蹂몄씤 湲 + ?듬? 誘몄셿猷?嫄대쭔 ??젣 媛??
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
}
