/**
 * 역할: 관리자 정산 관리 화면 (UI 더미)
 * 2026/07/24 장우철 — 목록·아코디언·확인 팝업만, 지급 API는 추후
 *
 * - GET /admin/settlement
 * - 상속: AdminBaseController
 */

package com.petcare.petcare.admin.settlement.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminSettlementController")
@RequestMapping("/admin/settlement")
public class AdminSettlementController extends AdminBaseController {

    // 2026/07/24 장우철 — 정산 UI (펫샵 탭 더미, 숙소 탭 골격)
    @GetMapping
    public String settlement(HttpSession session,
                             @RequestParam(defaultValue = "STORE") String tab,
                             Model model) {
        if (getAdmin(session) == null) {
            return redirectToLogin();
        }
        model.addAttribute("tab", tab);
        return "admin/settlement/list";
    }
}
