/**
 * 역할: 관리자 CMS URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminCMSService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 *
 * 2026-08-06 박유정 — 배너 관리 API 확장
 * - GET  /banner?tab=&category=  목록(대분류+중분류)
 * - POST /banner/hold             대기(노출예정)
 * - POST /banner/period|activate|deactivate|delete
 */

package com.petcare.petcare.admin.cms.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.admin.cms.service.AdminCMSService;
import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/admin/cms")
public class AdminCMSController extends AdminBaseController {
    @Autowired
    private AdminCMSService adminCMSService;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  관리자: 배너 목록 (기존 AdminCMSController의 /admin/cms/banner 대체)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 2026-08-06 박유정 — 배너 목록 (대분류 category + 중분류 tab)
    @GetMapping("/banner")
    public String adminBannerList(@RequestParam(defaultValue = "pending") String tab,
                                  @RequestParam(defaultValue = "main") String category,
                                  HttpSession session,
                                  Model model) {
        if (getAdmin(session) == null) return "redirect:/admin/login";

        model.addAttribute("bannerList", adminCMSService.getBannerListByTabAndCategory(tab, category));
        model.addAttribute("tabCounts", adminCMSService.getBannerTabCounts(category));
        model.addAttribute("categoryCounts", adminCMSService.getBannerCategoryCounts(tab));
        model.addAttribute("currentTab", tab);
        model.addAttribute("currentCategory", category);
        model.addAttribute("adminPage", "cms-banner");
        return "admin/cms/banner";
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  관리자: 배너 승인
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @PostMapping("/banner/approve")
    @ResponseBody
    public String adminBannerApprove(@RequestParam Long bannerId,
                                     HttpSession session) {
        if (getAdmin(session) == null) return "LOGIN_REQUIRED";
        try {
            String msg = adminCMSService.approveBanner(bannerId);
            return "OK:" + msg;
        } catch (IllegalArgumentException e) {
            return "ERR:" + e.getMessage();
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //  관리자: 배너 반려
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    @PostMapping("/banner/reject")
    @ResponseBody
    public String adminBannerReject(@RequestParam Long bannerId,
                                    @RequestParam String rejectReason,
                                    HttpSession session) {
        if (getAdmin(session) == null) return "LOGIN_REQUIRED";
        try {
            adminCMSService.rejectBanner(bannerId, rejectReason);
            return "OK";
        } catch (IllegalArgumentException e) {
            return "ERR:" + e.getMessage();
        }
    }

    // 2026-08-06 박유정 — 배너 대기 (PENDING → HOLD, 사유 입력)
    @PostMapping("/banner/hold")
    @ResponseBody
    public String adminBannerHold(@RequestParam Long bannerId,
                                  @RequestParam String holdReason,
                                  HttpSession session) {
        if (getAdmin(session) == null) return "LOGIN_REQUIRED";
        try {
            adminCMSService.holdBanner(bannerId, holdReason);
            return "OK";
        } catch (IllegalArgumentException e) {
            return "ERR:" + e.getMessage();
        }
    }

    // 2026-08-06 박유정 — 배너 상세 (기간 변경·올리기/내리기)
    @GetMapping("/banner/detail")
    public String adminBannerDetail(@RequestParam Long bannerId,
                                    HttpSession session,
                                    Model model) {
        if (getAdmin(session) == null) return "redirect:/admin/login";
        try {
            model.addAttribute("banner", adminCMSService.getBannerDetail(bannerId));
            model.addAttribute("adminPage", "cms-banner");
            return "admin/cms/banner-detail";
        } catch (IllegalArgumentException e) {
            return "redirect:/admin/cms/banner";
        }
    }

    @PostMapping("/banner/period")
    public String adminBannerUpdatePeriod(@RequestParam Long bannerId,
                                          @RequestParam String startDate,
                                          @RequestParam String endDate,
                                          HttpSession session,
                                          RedirectAttributes rttr) {
        if (getAdmin(session) == null) return "redirect:/admin/login";
        try {
            adminCMSService.updateBannerPeriod(bannerId, startDate, endDate);
            rttr.addFlashAttribute("msg", "광고 기간이 변경되었습니다.");
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/admin/cms/banner/detail?bannerId=" + bannerId;
    }

    // 2026-08-07 박유정 — 관리자 배너 정보 수정 (제목·링크·이미지, POST /banner/update)
    @PostMapping("/banner/update")
    public String adminBannerUpdateInfo(@RequestParam Long bannerId,
                                        @RequestParam String title,
                                        @RequestParam(required = false) String linkUrl,
                                        @RequestParam(required = false) MultipartFile bannerImage,
                                        HttpSession session,
                                        RedirectAttributes rttr) {
        if (getAdmin(session) == null) return "redirect:/admin/login";
        try {
            adminCMSService.updateBannerInfo(bannerId, title, linkUrl, bannerImage);
            rttr.addFlashAttribute("msg", "배너 정보가 저장되었습니다.");
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "배너 정보 저장 중 오류가 발생했습니다.");
        }
        return "redirect:/admin/cms/banner/detail?bannerId=" + bannerId;
    }

    @PostMapping("/banner/deactivate")
    public String adminBannerDeactivate(@RequestParam Long bannerId,
                                        HttpSession session,
                                        RedirectAttributes rttr) {
        if (getAdmin(session) == null) return "redirect:/admin/login";
        try {
            adminCMSService.deactivateBanner(bannerId);
            rttr.addFlashAttribute("msg", "광고 상태가 '미노출'로 변경되었습니다.");
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/admin/cms/banner/detail?bannerId=" + bannerId;
    }

    @PostMapping("/banner/activate")
    public String adminBannerActivate(@RequestParam Long bannerId,
                                      HttpSession session,
                                      RedirectAttributes rttr) {
        if (getAdmin(session) == null) return "redirect:/admin/login";
        try {
            String msg = adminCMSService.activateBanner(bannerId);
            rttr.addFlashAttribute("msg", msg);
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/admin/cms/banner/detail?bannerId=" + bannerId;
    }

    @PostMapping("/banner/delete")
    public String adminBannerDelete(@RequestParam Long bannerId,
                                    HttpSession session,
                                    RedirectAttributes rttr) {
        if (getAdmin(session) == null) return "redirect:/admin/login";
        try {
            adminCMSService.deleteBanner(bannerId);
            rttr.addFlashAttribute("msg", "배너가 삭제되었습니다.");
            return "redirect:/admin/cms/banner";
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/admin/cms/banner/detail?bannerId=" + bannerId;
        }
    }
    
    @GetMapping("/notice")
    public String cmsNotice(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/cms/notice";
    }

    @GetMapping("/faq")
    public String cmsFaq(HttpSession session) {
        if (getAdmin(session) == null) 
            return redirectToLogin();

        return "admin/cms/faq";
    }

    @GetMapping("/banner/form")
    public String bannerForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/cms/banner-form";
    }

    @GetMapping("/notice/form")
    public String noticeForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/cms/notice-form";
    }

    @GetMapping("/faq/form")
    public String faqForm(HttpSession session) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        return "admin/cms/faq-form";
    }
}
