/**
 * 역할: 유기동물 제보 URL 처리 → Service 호출 → JSP 반환
 *
 * - 박유정 / 2026-07-06~07
 *
 * [등록 화면 흐름]
 * 1. GET /give/report/write → 로그인 확인 후 write.jsp
 * 2. POST /give/report/write → giveReportService.insertReport(vo, member, photos)
 * 3. TB_POST INSERT + 사진 로컬 저장(C:/upload/) + TB_FILE INSERT
 * 4. 상세 페이지로 redirect
 *
 * [목록 화면 흐름]
 * 1. GET /give/report/list → giveReportService.getReportList()
 * 2. TB_POST 조회 + TB_FILE 첫 사진을 thumbUrl 로 세팅
 * 3. list.jsp 에 표시
 *
 * [상세 화면 흐름]
 * 1. GET /give/report/detail?id=번호 → giveReportService.getReportDetail()
 * 2. TB_POST + TB_FILE photoUrls 조회
 * 3. detail.jsp 에 표시
 *
 * 연결
 * - Service: GiveReportService
 * - 상속: GiveBaseController
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 */

package com.petcare.petcare.give.report.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.give.controller.GiveBaseController;
import com.petcare.petcare.give.report.service.GiveReportService;
import com.petcare.petcare.give.report.vo.GiveReportVO;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("giveReportController")
@RequestMapping("/give/report")
public class GiveReportController extends GiveBaseController {

    private static final Logger log = LoggerFactory.getLogger(GiveReportController.class);

    private final GiveReportService giveReportService;

    public GiveReportController(GiveReportService giveReportService) {
        this.giveReportService = giveReportService;
    }
    //@GetMapping("/write")   // 주소창 / 링크 클릭 → 화면만 보여줌
    @GetMapping("/list")
    public String reportList(Model model) {
        model.addAttribute("list", giveReportService.getReportList());
        return "give/report/list";
    }

    @GetMapping("/detail")
    public String reportDetail(@RequestParam long id, Model model) {
        GiveReportVO report = giveReportService.getReportDetail(id);
        if (report == null) {
            return "redirect:/give/report/list";
        }
        model.addAttribute("report", report);
        return "give/report/detail";
    }

    @GetMapping("/write")
    public String reportWrite(HttpSession session) {
        if (getMemberOrNull(session) == null) {
            return "redirect:/login?redirect=/give/report/write";
        }
        return "give/report/write";
    }

    //@PostMapping("/write") // form submit → 데이터 저장
    @PostMapping("/write")
    public String reportWriteSubmit(
            @ModelAttribute GiveReportVO vo,
            @RequestParam(value = "photos", required = false) MultipartFile[] photos,
            HttpSession session) {
        MemberVO member = getMemberOrNull(session);
        if (member == null) {
            return "redirect:/login?redirect=/give/report/write";
        }
        try {
            // TB_POST 저장 후 사진 저장 (postId 필요)
            giveReportService.insertReport(vo, member, photos);
            return "redirect:/give/report/detail?id=" + vo.getPostId();
        } catch (IllegalStateException e) {
            if ("MEMBER_NOT_FOUND".equals(e.getMessage())) {
                return "redirect:/give/report/write?error=member";
            }
            if ("LOGIN_REQUIRED".equals(e.getMessage())) {
                return "redirect:/login?redirect=/give/report/write";
            }
            log.error("report write failed", e);
            return "redirect:/give/report/write?error=save";
        } catch (Exception e) {
            log.error("report write failed", e);
            return "redirect:/give/report/write?error=save";
        }
    }

    private MemberVO getMemberOrNull(HttpSession session) {
        Object member = session.getAttribute("memberInfo");
        if (member instanceof MemberVO memberVO) {
            return memberVO;
        }
        return null;
    }
}

