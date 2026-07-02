package com.petcare.petcare.store;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("storeController")
@RequestMapping("/store")
public class StoreController {
    
    @GetMapping({"", "/"})
    public String store(@RequestParam(required = false) String q) {
        if (q != null && !q.isBlank()) {
            return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);
        }
        return "store/list";
    }

    // ── 상품 상세 ───────────────────────────────────────────
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "store/detail";
    }

    // ── 장바구니 ────────────────────────────────────────────
    @GetMapping("/cart")
    public String cart() {
        return "store/cart";
    }

    // ── 주문서 작성 (배송지 입력) ───────────────────────────
    @GetMapping("/order")
    public String order() {
        return "store/order";
    }

    // ── 결제 (결제수단 선택) ────────────────────────────────
    @GetMapping("/payment")
    public String payment() {
        return "store/payment";
    }

    // ── 결제 완료 ───────────────────────────────────────────
    @GetMapping("/order-complete")
    public String orderComplete() {
        return "store/order-complete";
    }
}
