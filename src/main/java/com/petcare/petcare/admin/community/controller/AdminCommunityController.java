/**
 * 역할: 관리자 커뮤니티 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: AdminCommunityService
 * - 상속: AdminBaseController (관리자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.admin.community.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.admin.controller.AdminBaseController;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.admin.community.service.AdminCommunityService;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.petcare.petcare.community.post.vo.CommunityPostVO;

import org.springframework.web.bind.annotation.PostMapping;

@Controller("adminCommunityController")
@RequestMapping("/admin/community")
public class AdminCommunityController extends AdminBaseController {
    // ── ADMIN-03 커뮤니티 관리 ────────────────────────────
    
    @Autowired
    private AdminCommunityService adminCommunityService;

    // 2026-07-15 박유정 — 관리자 게시글 목록 (DB 연동)
    @GetMapping("/list")
    public String communityList(HttpSession session,
                                @RequestParam(defaultValue = "") String keyword,
                                @RequestParam(defaultValue = "") String boardType,
                                @RequestParam(defaultValue = "") String statusCd,
                                @RequestParam(defaultValue = "1") int page,
                                Model model) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        model.addAttribute("list",
                adminCommunityService.getAdminPostList(keyword, boardType, statusCd, page));
        model.addAttribute("totalCount",
                adminCommunityService.getAdminPostCount(keyword, boardType, statusCd));
        model.addAttribute("keyword", keyword);
        model.addAttribute("boardType", boardType);
        model.addAttribute("statusCd", statusCd);
        model.addAttribute("page", page);

        return "admin/community/list";
    }

    // 2026-07-15 박유정 — 관리자 게시글 상세
    @GetMapping("/detail")
    public String communityDetail(HttpSession session,
                                  @RequestParam long id,
                                  Model model,
                                  RedirectAttributes rttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();
        CommunityPostVO post = adminCommunityService.getAdminPostDetail(id);
        if (post == null) {
            rttr.addFlashAttribute("errorMsg", "게시글을 찾을 수 없습니다.");
            return "redirect:/admin/community/list";
        }
        model.addAttribute("post", post);
        return "admin/community/detail";
    }

    // 2026-07-15 박유정 STEP 7 — 게시글 숨김
    @PostMapping("/hide")
    public String hidePost(HttpSession session,
                           @RequestParam long postId,
                           RedirectAttributes rttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        try {
            adminCommunityService.hidePost(postId);
            rttr.addFlashAttribute("successMsg", "게시글이 숨김 처리되었습니다.");
            return "redirect:/admin/community/list?statusCd=HIDDEN";
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", "게시글을 찾을 수 없습니다.");
            return "redirect:/admin/community/detail?id=" + postId;
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "숨김 처리 중 오류가 발생했습니다.");
            return "redirect:/admin/community/detail?id=" + postId;
        }
    }

    // 2026-07-15 박유정 STEP 7 — 게시글 삭제
    @PostMapping("/delete")
    public String deletePost(HttpSession session,
                             @RequestParam long postId,
                             RedirectAttributes rttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        try {
            adminCommunityService.deletePost(postId);
            rttr.addFlashAttribute("successMsg", "게시글이 삭제되었습니다.");
            return "redirect:/admin/community/list?statusCd=DELETED";
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", "게시글을 찾을 수 없습니다.");
            return "redirect:/admin/community/detail?id=" + postId;
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "삭제 처리 중 오류가 발생했습니다.");
            return "redirect:/admin/community/detail?id=" + postId;
        }
    }

    // 2026-07-15 박유정 — 복구 (숨김·삭제 → ACTIVE, POST /restore)
    @PostMapping("/restore")
    public String restorePost(HttpSession session,
                              @RequestParam long postId,
                              RedirectAttributes rttr) {
        if (getAdmin(session) == null)
            return redirectToLogin();

        try {
            adminCommunityService.restorePost(postId);
            rttr.addFlashAttribute("successMsg", "게시글이 다시 게시되었습니다.");
            return "redirect:/admin/community/list?statusCd=ACTIVE";
        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", "게시글을 찾을 수 없습니다.");
            return "redirect:/admin/community/detail?id=" + postId;
        } catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", "복구 처리 중 오류가 발생했습니다.");
            return "redirect:/admin/community/detail?id=" + postId;
        }
    }
}
