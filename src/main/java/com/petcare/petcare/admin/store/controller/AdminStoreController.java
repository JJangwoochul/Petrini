/**
 * 역할: 관리자 쇼핑몰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminStoreService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.store.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminStoreController")
@RequestMapping("/admin/store")
public class AdminStoreController extends AdminBaseController {

    // ── ADMIN-02 상품 관리 ─────────────────────────────────
    @GetMapping("/product-list")
    public String productList(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/store/product-list";
    }
    
    // ── ADMIN-02 주문 관리 ─────────────────────────────────
    @GetMapping("/order-list")
    public String orderList(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/store/order-list";
    }  
    
    // ── 상품 카테고리 관리 ─────────────────────────────────
    @GetMapping("/category")
    public String category(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/store/category";
    }

    @GetMapping("/order-detail")
    public String orderDetail(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/store/order-detail";
    }

    @GetMapping("/product-form")
    public String productForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/store/product-form";
    }
}
