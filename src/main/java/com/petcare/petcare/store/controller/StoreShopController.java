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

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("storeController")
@RequestMapping("/store")
public class StoreShopController {

    @GetMapping({"", "/"})
    public String store(@RequestParam(required = false) String q) {
        if (q != null && !q.isBlank()) {
            return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);
        }
        return "store/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "store/detail";
    }

    @GetMapping("/cart")
    public String cart() {
        return "store/cart";
    }

    @GetMapping("/order")
    public String order() {
        return "store/order";
    }

    @GetMapping("/payment")
    public String payment() {
        return "store/payment";
    }

    @GetMapping("/order-complete")
    public String orderComplete() {
        return "store/order-complete";
    }
}
