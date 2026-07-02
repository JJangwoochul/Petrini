package com.petcare.petcare.biz.store;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.biz.BizBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("bizStoreController")
@RequestMapping("/biz/store")
public class StoreController extends BizBaseController {

    // ── 쇼핑몰 (store) ─────────────────────────────────────────
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
