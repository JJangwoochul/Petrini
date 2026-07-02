/**
 * 역할: 사업자 쇼핑몰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: BizStoreService
 * - 상속: BizBaseController (사업자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.biz.store.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.biz.controller.BizBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("bizStoreController")
@RequestMapping("/biz/store")
public class BizStoreController extends BizBaseController {

    @GetMapping({"", "/"})
    public String storeDashboard(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/dashboard";
    }

    @GetMapping("/products")
    public String storeProducts(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/products";
    }

    @GetMapping("/inventory")
    public String storeInventory(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/inventory";
    }

    @GetMapping("/orders")
    public String storeOrders(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/orders";
    }

    @GetMapping("/delivery")
    public String storeDelivery(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/delivery";
    }

    @GetMapping("/reviews")
    public String storeReviews(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/reviews";
    }

    @GetMapping("/settlement")
    public String storeSettlement(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/settlement";
    }

    @GetMapping("/info")
    public String storeInfo(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/info";
    }
}
