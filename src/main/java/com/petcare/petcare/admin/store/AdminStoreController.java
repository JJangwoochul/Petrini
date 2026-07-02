package com.petcare.petcare.admin.store;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminStoreController")
@RequestMapping("/admin/store")
public class AdminStoreController extends AdminBaseController {

    // ── ADMIN-02 상품 관리 ─────────────────────────────────
    @GetMapping("/product-list")
    public String productList(HttpSession session) {
        if (getAdmin(session) == null) 
            return "redirect:/login";

        return "admin/store/product-list";
    }
    
    // ── ADMIN-02 주문 관리 ─────────────────────────────────
    @GetMapping("/order-list")
    public String orderList(HttpSession session) {
        if (getAdmin(session) == null) 
            return "redirect:/login";

        return "admin/store/order-list";
    }  
    
    // ── 상품 카테고리 관리 ─────────────────────────────────
    @GetMapping("/category")
    public String category(HttpSession session) {
        if (getAdmin(session) == null) 
            return "redirect:/login";

        return "admin/store/category";
    } 
}