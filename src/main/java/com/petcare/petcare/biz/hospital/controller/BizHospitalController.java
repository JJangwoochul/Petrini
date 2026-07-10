/**
 * 역할: 사업자 동물병원 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: BizHospitalService
 * - 상속: BizBaseController (사업자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.biz.hospital.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.biz.controller.BizBaseController;
import com.petcare.petcare.biz.hospital.service.BizHospitalService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("bizHospitalController")
@RequestMapping("/biz/hospital")
public class BizHospitalController extends BizBaseController {

    @Autowired
    private BizHospitalService bizHospitalService;
    @Autowired
    private FileService fileService;
    
    // ── 병원 (HOSPITAL) ──────────────────────────────────────
    @GetMapping({"", "/"})
    public String hospitalDashboard(HttpSession session, Model model) {

        MemberVO member = getBizMember(session);
        if (member == null)
            return "redirect:/login";

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        model.addAttribute("hospital", hospital);

        return "biz/hospital/dashboard";
    }

    @GetMapping("/reserve")
    public String hospitalReserve(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/reserve";
    }

    @GetMapping("/calendar")
    public String hospitalCalendar(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/calendar";
    }

    @GetMapping("/treatments")
    public String hospitalTreatments(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/treatments";
    }

    @GetMapping("/patients")
    public String hospitalPatients(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/patients";
    }

    @GetMapping("/records")
    public String hospitalRecords(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/records";
    }

    @GetMapping("/talent")
    public String hospitalTalent(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/talent";
    }

    @GetMapping("/reviews")
    public String hospitalReviews(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/reviews";
    }

    @GetMapping("/contract")
    public String hospitalContract(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/contract";
    }

    // 2026-07-10 장우철 — [변경 후] TB_HOSPITAL 없으면 자동 생성 후 폼 표시
    @GetMapping("/info")
    public String hospitalInfo(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null) {
            return "redirect:/mypage/biz";
        }
        model.addAttribute("hospital", hospital);

        List<FileVO> imgList = java.util.Collections.emptyList();
        if (hospital.getHospitalId() != null) {
            imgList = fileService.getFileList("HOSPITAL", hospital.getHospitalId());
        }
        model.addAttribute("imgList", imgList);
        return "biz/hospital/info";

        /* [변경 전] 2026-07-10 장우철 — 승인 시 INSERT 가정, null 이면 NPE
        HospitalVO hospital = bizHospitalService.getHospitalByBizId(member.getMemberId());
        List<FileVO> imgList = fileService.getFileList("HOSPITAL", hospital.getHospitalId());
        */
    }

    // 2026-07-10 장우철 — 병원 정보(profile.jsp) / 사업자 정보(info.jsp) 각각 별도 진입
    @GetMapping("/profile")
    public String hospitalProfile(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/profile";

        /* [변경 전] 2026-07-10 장우철 — info 로 통합 리다이렉트
        return "redirect:/biz/hospital/info";
        */
    }

    // ── POST: 저장 ──
    @PostMapping("/info")
    public String saveHospitalInfo(HospitalVO vo,
                                   @RequestParam(value = "tagList", required = false) String[] tagList,
                                   @RequestParam(value = "imgList", required = false) MultipartFile[] imgList, 
                                   @RequestParam(value = "deleteFileIds", required = false) Long[] deleteFileIds,
                                   HttpSession session,
                                   RedirectAttributes rttr) throws Exception {

        MemberVO member = getBizMember(session);
        if (member == null)
            return "redirect:/login";

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            rttr.addFlashAttribute("errorMsg", "병원 정보를 불러올 수 없습니다.");
            return "redirect:/biz/hospital/info";
        }
        vo.setHospitalId(hospital.getHospitalId());

        // 태그 체크박스 배열 → 콤마 구분 문자열
        if (tagList != null) {
            vo.setTagList(String.join(",", tagList));
        }

        // 기존 이미지 삭제 처리 ──
        if (deleteFileIds != null) {
            for (Long fileId : deleteFileIds) {
                fileService.deleteFile(fileId);
            }
        }

        // ── 2) 새 이미지 업로드 처리 ──
        if (imgList != null) {
            for (MultipartFile img : imgList) {
                // 빈 파일 슬롯은 건너뛰기 (파일 선택 안 한 input)
                if (img == null || img.isEmpty()) {
                    continue;
                }
                fileService.uploadFile(img, "HOSPITAL", hospital.getHospitalId());
            }
        }

        // ── 3) 병원 기본정보 업데이트 ──
        bizHospitalService.updateHospitalInfo(vo);

        rttr.addFlashAttribute("msg", "저장되었습니다.");
        return "redirect:/biz/hospital/info";
    }
}
