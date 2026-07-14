/**
 * 역할: 사업자·재능나눔 승인 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminBizService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 */

package com.petcare.petcare.admin.biz.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.admin.biz.service.AdminBizService;
import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

@Controller("adminBizController")
@RequestMapping("/admin/biz")
public class AdminBizController extends AdminBaseController {

    // 2026-07-09 장우철 — 사업자 승인 Service 주입
    // 이유: 목록/상세/승인·반려는 Controller 가 아닌 Service·Mapper 에서 처리
    @Autowired
    private AdminBizService adminBizService;

    // ── ADMIN-03 사업자 승인 ───────────────────────────────
    @GetMapping("/list")
    public String bizList(HttpSession session,
                          @RequestParam(defaultValue = "PENDING") String status,
                          Model model) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        // 2026-07-09 장우철 — [변경 전] JSP 더미 카드만 반환
        // return "admin/biz/list";

        // 2026-07-09 장우철 — [변경 후] 상태 탭별 실데이터 목록 + 탭 건수
        // 이유: USER 사업자 신청(TB_BUSINESS PENDING)을 관리자가 검토하는 화면
        model.addAttribute("list", adminBizService.getBizApplyList(status));
        model.addAttribute("status", status);
        model.addAttribute("statusCounts", adminBizService.getBizStatusCounts());
        return "admin/biz/list";
    }

    // ── 재능나눔 승인 ───────────────────────────────
    @GetMapping("/talent")
    public String cmsTalent(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/biz/talent";
    }

    @GetMapping("/detail")
    public String bizDetail(HttpSession session,
                            @RequestParam Long bizNo,
                            Model model,
                            RedirectAttributes redirectAttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        // 2026-07-09 장우철 — [변경 전] JSP 더미 상세만 반환
        // return "admin/biz/detail";

        // 2026-07-09 장우철 — [변경 후] bizNo 기준 상세 + 제출 서류
        var biz = adminBizService.getBizApplyDetail(bizNo);
        if (biz == null) {
            redirectAttr.addFlashAttribute("errorMsg", "신청 정보를 찾을 수 없습니다.");
            return "redirect:/admin/biz/list";
        }
        model.addAttribute("biz", biz);
        model.addAttribute("authFiles", adminBizService.getBizAuthFiles(bizNo));
        model.addAttribute("licenseFiles", adminBizService.getBizLicenseFiles(bizNo));
        return "admin/biz/detail";
    }

    // 2026-07-09 장우철 — 사업자 승인 POST
    // 이유: detail/list 에서 form submit 으로 TB_BUSINESS·TB_BUSINESS_AUTH 를 APPROVED 로 변경
    @PostMapping("/approve")
    public String approveBiz(HttpSession session,
                             @RequestParam Long bizNo,
                             RedirectAttributes redirectAttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        try {
            adminBizService.approveBiz(bizNo);
            redirectAttr.addFlashAttribute("successMsg", "사업자 신청이 승인되었습니다.");
            return "redirect:/admin/biz/list?status=APPROVED";
        } catch (IllegalStateException e) {
            if ("BIZ_NOT_PENDING".equals(e.getMessage())) {
                redirectAttr.addFlashAttribute("errorMsg", "이미 처리된 신청입니다.");
            } else {
                redirectAttr.addFlashAttribute("errorMsg", "승인 처리 중 오류가 발생했습니다.");
            }
        } catch (Exception e) {
            redirectAttr.addFlashAttribute("errorMsg", "승인 처리 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/biz/detail?bizNo=" + bizNo;
    }

    // 2026-07-09 장우철 — 사업자 반려 POST
    @PostMapping("/reject")
    public String rejectBiz(HttpSession session,
                            @RequestParam Long bizNo,
                            @RequestParam String rejectReason,
                            RedirectAttributes redirectAttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        try {
            adminBizService.rejectBiz(bizNo, rejectReason);
            redirectAttr.addFlashAttribute("successMsg", "사업자 신청이 반려되었습니다.");
            return "redirect:/admin/biz/list?status=REJECTED";
        } catch (IllegalArgumentException e) {
            if ("REJECT_REASON_REQUIRED".equals(e.getMessage())) {
                redirectAttr.addFlashAttribute("errorMsg", "반려 사유를 입력해 주세요.");
            } else if ("BIZ_NOT_FOUND".equals(e.getMessage())) {
                redirectAttr.addFlashAttribute("errorMsg", "신청 정보를 찾을 수 없습니다.");
            } else {
                redirectAttr.addFlashAttribute("errorMsg", "반려 처리 중 오류가 발생했습니다.");
            }
        } catch (IllegalStateException e) {
            if ("BIZ_NOT_PENDING".equals(e.getMessage())) {
                redirectAttr.addFlashAttribute("errorMsg", "이미 처리된 신청입니다.");
            } else {
                redirectAttr.addFlashAttribute("errorMsg", "반려 처리 중 오류가 발생했습니다.");
            }
        } catch (Exception e) {
            redirectAttr.addFlashAttribute("errorMsg", "반려 처리 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/biz/detail?bizNo=" + bizNo;
    }
}
