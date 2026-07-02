package com.petcare.petcare.member;

import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.member.vo.InquiryVO;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member/cs")
public class CsController {

    private final InquiryService inquiryService;

    public CsController(InquiryService inquiryService) {
        this.inquiryService = inquiryService;
    }

    @GetMapping("/inquiry")
    public String inquiryList(HttpSession session, Model model) {
        MemberVO member = getMemberOrRedirect(session);
        if (member == null) {
            return "redirect:/login?redirect=/member/cs/inquiry";
        }

        model.addAttribute("inquiries", inquiryService.getListForMember(member.getMemberId()));
        return "member/cs-inquiry-list";
    }

    @GetMapping("/inquiry/write")
    public String inquiryWriteForm(HttpSession session) {
        if (getMemberOrRedirect(session) == null) {
            return "redirect:/login?redirect=/member/cs/inquiry/write";
        }
        return "member/cs-inquiry-write";
    }

    @PostMapping("/inquiry/write")
    public String inquiryWrite(
            @RequestParam String category,
            @RequestParam String title,
            @RequestParam String content,
            HttpSession session) {

        MemberVO member = getMemberOrRedirect(session);
        if (member == null) {
            return "redirect:/login?redirect=/member/cs/inquiry/write";
        }

        if (category == null || category.isBlank()
                || title == null || title.isBlank()
                || content == null || content.isBlank()) {
            return "redirect:/member/cs/inquiry/write?error=empty";
        }

        InquiryVO inquiry = inquiryService.create(member, category, title, content);
        if (inquiry == null) {
            return "redirect:/member/cs/inquiry?error=db";
        }
        return "redirect:/member/cs/inquiry/detail?id=" + inquiry.getId();
    }

    @GetMapping("/inquiry/detail")
    public String inquiryDetail(
            @RequestParam long id,
            HttpSession session,
            Model model) {

        MemberVO member = getMemberOrRedirect(session);
        if (member == null) {
            return "redirect:/login?redirect=/member/cs/inquiry/detail?id=" + id;
        }

        Optional<InquiryVO> inquiry = inquiryService.findForMember(member.getMemberId(), id);
        if (inquiry.isEmpty()) {
            return "redirect:/member/cs/inquiry";
        }

        model.addAttribute("inquiry", inquiry.get());
        return "member/cs-inquiry-detail";
    }

    private MemberVO getMemberOrRedirect(HttpSession session) {
        Object member = session.getAttribute("memberInfo");
        if (member instanceof MemberVO memberVO) {
            return memberVO;
        }
        return null;
    }
}
