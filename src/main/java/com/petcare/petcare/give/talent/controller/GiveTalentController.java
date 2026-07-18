/**
 * 역할: 재능나눔 URL 처리 → JSP 반환 (가족찾기 Give 모듈)
 *
 * - 박유정 / 2026-07-13~14
 *
 * 담당 화면
 * - give/talent/list.jsp   APPROVED 재능나눔 목록
 * - give/talent/detail.jsp APPROVED 재능나눔 상세
 *
 * 연결
 * - Service: GiveTalentService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.give.talent.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.give.talent.service.GiveTalentService;
import com.petcare.petcare.give.talent.vo.GiveTalentVO;

@Controller("giveTalentController")
@RequestMapping("/give/talent")
public class GiveTalentController {

    private final GiveTalentService giveTalentService;

    public GiveTalentController(GiveTalentService giveTalentService) {
        this.giveTalentService = giveTalentService;
    }

    /**
     * 재능나눔 목록 — APPROVED(승인)만 노출
     * talentType: GROOMING / HOSPITAL / PHOTO / TRANSPORT / ETC (빈값=전체)
     * 2026-07-13 박유정 — admin 승인 후 TB_TALENT STATUS_CD=APPROVED 건만 조회
     */
    @GetMapping("/list")
    public String talentList(
            @RequestParam(defaultValue = "") String talentType,
            Model model) {

        String type = talentType != null ? talentType.trim() : "";

        model.addAttribute("list", giveTalentService.getApprovedTalentList(type));
        model.addAttribute("talentType", type);

        return "give/talent/list";
    }

    /**
     * 재능나눔 상세 — APPROVED(승인) 글만 노출 (목록과 동일)
     */
    @GetMapping("/detail")
    public String talentDetail(@RequestParam long id, Model model) {
        GiveTalentVO talent = giveTalentService.getTalentDetail(id);
        if (talent == null
                || talent.getStatusCd() == null
                || !"APPROVED".equalsIgnoreCase(talent.getStatusCd().trim())) {
            return "redirect:/give/talent/list";
        }
        model.addAttribute("talent", talent);
        return "give/talent/detail";
    }
}