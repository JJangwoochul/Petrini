/**
 * 역할: 관리자 정산 관리 화면
 * 2026/07/24 장우철 — STORE 탭 UI 더미
 * 2026/07/30 장우철 — STAY 탭 3-2~3-5 / 중간요청 4-3~4-4
 *
 * - GET  /admin/settlement
 * - GET  /admin/settlement/stay/items
 * - POST /admin/settlement/stay/pay
 * - POST /admin/settlement/stay/pay-bulk
 * - POST /admin/settlement/stay/request/approve
 * - POST /admin/settlement/stay/request/reject
 */
package com.petcare.petcare.admin.settlement.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petcare.petcare.admin.controller.AdminBaseController;
import com.petcare.petcare.admin.settlement.service.AdminSettlementService;
import com.petcare.petcare.admin.settlement.vo.AdminStayRequestVO;
import com.petcare.petcare.admin.settlement.vo.AdminStaySettlementVO;
import com.petcare.petcare.settlement.vo.StaySettlementItemVO;
import com.petcare.petcare.settlement.vo.StaySettlementVO;

import jakarta.servlet.http.HttpSession;

@Controller("adminSettlementController")
@RequestMapping("/admin/settlement")
public class AdminSettlementController extends AdminBaseController {

    @Autowired
    private AdminSettlementService adminSettlementService;

    @GetMapping
    public String settlement(HttpSession session,
                             @RequestParam(defaultValue = "STORE") String tab,
                             @RequestParam(value = "status", required = false, defaultValue = "all") String status,
                             @RequestParam(value = "reqStatus", required = false, defaultValue = "requested") String reqStatus,
                             Model model) {
        if (getAdmin(session) == null) {
            return redirectToLogin();
        }

        model.addAttribute("tab", tab);

        if ("STAY".equalsIgnoreCase(tab)) {
            model.addAttribute("adminSettlementReady", adminSettlementService.isReady());
            model.addAttribute("staySettlementCount", adminSettlementService.countStaySettlements(null));
            List<AdminStaySettlementVO> staySettlements =
                    adminSettlementService.getStaySettlementList(status);
            model.addAttribute("staySettlements", staySettlements);
            model.addAttribute("filterStatus", status);

            // 4-3 중간정산 요청 목록
            List<AdminStayRequestVO> stayRequests =
                    adminSettlementService.getStayRequestList(reqStatus);
            model.addAttribute("stayRequests", stayRequests);
            model.addAttribute("filterReqStatus", reqStatus);
            model.addAttribute("stayRequestPendingCount",
                    adminSettlementService.countStayMidRequestsRequested());
        }

        return "admin/settlement/list";
    }

    @GetMapping("/stay/items")
    @ResponseBody
    public Map<String, Object> stayItems(HttpSession session,
                                         @RequestParam("settleId") Long settleId) {
        Map<String, Object> result = new HashMap<>();
        if (getAdmin(session) == null) {
            result.put("ok", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        List<StaySettlementItemVO> items = adminSettlementService.getStaySettlementItems(settleId);
        result.put("ok", true);
        result.put("items", items);
        return result;
    }

    @PostMapping("/stay/pay")
    @ResponseBody
    public Map<String, Object> stayPay(HttpSession session,
                                       @RequestBody Map<String, Object> body) {
        Map<String, Object> result = new HashMap<>();
        if (getAdmin(session) == null) {
            result.put("ok", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long settleId = toLong(body.get("settleId"));
        try {
            int updated = adminSettlementService.payStaySettlement(settleId);
            result.put("ok", updated > 0);
            result.put("updated", updated);
            result.put("message", updated > 0
                    ? "정산(더미 지급) 완료 처리되었습니다."
                    : "이미 완료되었거나 대상이 없습니다.");
        } catch (IllegalArgumentException e) {
            result.put("ok", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @PostMapping("/stay/pay-bulk")
    @ResponseBody
    public Map<String, Object> stayPayBulk(HttpSession session,
                                           @RequestBody Map<String, Object> body) {
        Map<String, Object> result = new HashMap<>();
        if (getAdmin(session) == null) {
            result.put("ok", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        @SuppressWarnings("unchecked")
        List<Object> rawIds = (List<Object>) body.get("settleIds");
        List<Long> settleIds = new java.util.ArrayList<>();
        if (rawIds != null) {
            for (Object o : rawIds) {
                Long id = toLong(o);
                if (id != null) {
                    settleIds.add(id);
                }
            }
        }
        try {
            int updated = adminSettlementService.payStaySettlements(settleIds);
            result.put("ok", true);
            result.put("updated", updated);
            result.put("message", "선택 " + settleIds.size() + "건 중 " + updated + "건 정산(더미 지급) 완료.");
        } catch (IllegalArgumentException e) {
            result.put("ok", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /** 4-3/4-4 중간정산 요청 승인 */
    @PostMapping("/stay/request/approve")
    @ResponseBody
    public Map<String, Object> stayRequestApprove(HttpSession session,
                                                  @RequestBody Map<String, Object> body) {
        Map<String, Object> result = new HashMap<>();
        if (getAdmin(session) == null) {
            result.put("ok", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long requestId = toLong(body.get("requestId"));
        try {
            StaySettlementVO saved = adminSettlementService.approveStayMidRequest(requestId);
            result.put("ok", true);
            result.put("settleId", saved.getSettleId());
            result.put("settleAmount", saved.getSettleAmount());
            result.put("itemCount", saved.getItems() == null ? 0 : saved.getItems().size());
            result.put("message", "승인 완료. 정산 마스터 #" + saved.getSettleId()
                    + " 생성 (" + (saved.getItems() == null ? 0 : saved.getItems().size()) + "건)."
                    + " 지급은 정산 목록에서 진행하세요.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            result.put("ok", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /** 4-3 중간정산 요청 거절 */
    @PostMapping("/stay/request/reject")
    @ResponseBody
    public Map<String, Object> stayRequestReject(HttpSession session,
                                                 @RequestBody Map<String, Object> body) {
        Map<String, Object> result = new HashMap<>();
        if (getAdmin(session) == null) {
            result.put("ok", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        Long requestId = toLong(body.get("requestId"));
        String rejectReason = body.get("rejectReason") == null
                ? null : String.valueOf(body.get("rejectReason"));
        try {
            adminSettlementService.rejectStayMidRequest(requestId, rejectReason);
            result.put("ok", true);
            result.put("message", "요청이 거절되었습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            result.put("ok", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    private Long toLong(Object v) {
        if (v == null) {
            return null;
        }
        if (v instanceof Number) {
            return ((Number) v).longValue();
        }
        try {
            return Long.parseLong(String.valueOf(v));
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
