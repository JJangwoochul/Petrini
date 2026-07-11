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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.biz.controller.BizBaseController;
import com.petcare.petcare.biz.hospital.service.BizHospitalService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
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

    // 2026-07-10 장우철 — 사업자 예약 관리 (F4)
    @GetMapping("/reserve")
    public String hospitalReserve(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return "redirect:/mypage/biz";
        }

        model.addAttribute("hospital", hospital);
        model.addAttribute("reservationList",
                bizHospitalService.getReservationList(hospital.getHospitalId(), "all"));
        return "biz/hospital/reserve";
    }

    // 2026-07-10 장우철 — 사업자 예약 상태 변경 (F5)
    @PostMapping("/reserve/status")
    public String updateReservationStatus(@RequestParam("resvId") Long resvId,
                                          @RequestParam("statusCd") String statusCd,
                                          HttpSession session,
                                          RedirectAttributes rttr) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return "redirect:/mypage/biz";
        }

        bizHospitalService.updateReservationStatus(hospital.getHospitalId(), resvId, statusCd);
        rttr.addFlashAttribute("msg", "예약 상태가 변경되었습니다.");
        return "redirect:/biz/hospital/reserve";
    }

    // 2026-07-10 장우철 — 사업자 예약 상세 모달 API (F6)
    @GetMapping("/reserve/detail")
    @ResponseBody
    public ReservationVO reservationDetail(@RequestParam("resvId") Long resvId,
                                           HttpSession session) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return null;
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return null;
        }

        return bizHospitalService.getReservationDetail(hospital.getHospitalId(), resvId);
    }

    // 2026-07-10 장우철 — 사업자 예약 캘린더 (F7)
    @GetMapping("/calendar")
    public String hospitalCalendar(@RequestParam(value = "from", required = false) String fromDate,
                                   @RequestParam(value = "to", required = false) String toDate,
                                   HttpSession session,
                                   Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return "redirect:/mypage/biz";
        }

        if (fromDate == null || fromDate.isBlank()) {
            fromDate = java.time.LocalDate.now().minusMonths(3).toString();
        }
        if (toDate == null || toDate.isBlank()) {
            toDate = java.time.LocalDate.now().plusMonths(6).toString();
        }

        model.addAttribute("hospital", hospital);
        model.addAttribute("calendarReservations",
                bizHospitalService.getCalendarReservations(hospital.getHospitalId(), fromDate, toDate));
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

    // 2026-07-10 장우철+yeju merge — 사업자 정보 조회 (info.jsp, yeju 간소 화면)
    @GetMapping("/info")
    public String hospitalInfo(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null) {
            return "redirect:/mypage/biz";
        }
        model.addAttribute("hospital", hospital);
        return "biz/hospital/info";
    }

    // 2026-07-10 장우철+yeju merge — 병원 정보 등록/수정 (profile.jsp, yeju DB 폼)
    @GetMapping("/profile")
    public String hospitalProfile(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return "redirect:/mypage/biz";
        }
        model.addAttribute("hospital", hospital);

        List<FileVO> imgList = fileService.getFileList("HOSPITAL", hospital.getHospitalId());
        model.addAttribute("imgList", imgList);
        return "biz/hospital/profile";
    }

    // 2026-07-10 장우철+yeju merge — yeju profile.jsp → POST /profile + resolveHospital
    @PostMapping("/profile")
    public String saveProfile(HospitalVO vo,
                              @RequestParam(value = "tagList", required = false) String[] tagList,
                              @RequestParam(value = "imgList", required = false) MultipartFile[] imgList,
                              @RequestParam(value = "deleteFileIds", required = false) Long[] deleteFileIds,
                              HttpSession session,
                              RedirectAttributes rttr) throws Exception {

        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }

        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            rttr.addFlashAttribute("errorMsg", "병원 정보를 불러올 수 없습니다.");
            return "redirect:/biz/hospital/profile";
        }
        vo.setHospitalId(hospital.getHospitalId());

        // 2026-07-10 장우철 — 폼 미전송 필드만 기존값 유지 (주소 있으면 Service에서 지오코딩)
        if (vo.getName() == null || vo.getName().isBlank()) {
            vo.setName(hospital.getName());
        }
        if (vo.getPhone() == null || vo.getPhone().isBlank()) {
            vo.setPhone(hospital.getPhone());
        }
        if (vo.getAddr() == null || vo.getAddr().isBlank()) {
            vo.setAddr(hospital.getAddr());
            if (vo.getLat() == null) {
                vo.setLat(hospital.getLat());
            }
            if (vo.getLng() == null) {
                vo.setLng(hospital.getLng());
            }
        }
        if (vo.getAddrDetail() == null) {
            vo.setAddrDetail(hospital.getAddrDetail());
        }

        // 체크 없으면 빈 문자열로 저장 (미선택 = 태그 없음)
        vo.setTagList(tagList != null ? String.join(",", tagList) : "");

        if (deleteFileIds != null) {
            for (Long fileId : deleteFileIds) {
                fileService.deleteFile(fileId);
            }
        }

        if (imgList != null) {
            for (MultipartFile img : imgList) {
                if (img == null || img.isEmpty()) {
                    continue;
                }
                fileService.uploadFile(img, "HOSPITAL", hospital.getHospitalId());
            }
        }

        bizHospitalService.updateHospitalInfo(vo);

        rttr.addFlashAttribute("msg", "저장되었습니다.");
        return "redirect:/biz/hospital/profile";
    }
}
