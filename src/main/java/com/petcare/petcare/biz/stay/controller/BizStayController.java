/**
 * 역할: 사업자 펫호텔 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: BizStayService
 * - 상속: BizBaseController (사업자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.biz.stay.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.petcare.petcare.biz.controller.BizBaseController;
import com.petcare.petcare.biz.stay.service.BizStayService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.stay.vo.ReservationVO;
import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.stay.vo.StayRoomVO;
import com.petcare.petcare.stay.vo.StayVO;

import jakarta.servlet.http.HttpSession;

@Controller("bizStayController")
@RequestMapping("/biz/stay")
public class BizStayController extends BizBaseController {
    @Autowired
    private BizStayService bizStayService;
    @Autowired
    private FileService fileService;

    // 2026-07-14 — 사이드바 예약관리 배지: PENDING 건수
    @ModelAttribute("pendingReserveCount")
    public int pendingReserveCount(HttpSession session) {
        try {
            MemberVO member = getBizMember(session);
            if (member == null || member.getMemberId() == null) return 0;
            StayVO stay = bizStayService.getStayByBizId(member.getMemberId());
            if (stay == null || stay.getStayId() == null) return 0;
            return bizStayService.countPendingReservations(stay.getStayId());
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026-07-14 — 사이드바 캘린더 배지: 오늘 체크인 CONFIRMED 건수
    @ModelAttribute("todayConfirmedCount")
    public int todayConfirmedCount(HttpSession session) {
        try {
            MemberVO member = getBizMember(session);
            if (member == null || member.getMemberId() == null) return 0;
            StayVO stay = bizStayService.getStayByBizId(member.getMemberId());
            if (stay == null || stay.getStayId() == null) return 0;
            return bizStayService.countTodayConfirmedReservations(stay.getStayId());
        } catch (Exception e) {
            return 0;
        }
    }
    
    @GetMapping({"", "/"})
    public String stayDashboard(HttpSession session, Model model) {
        MemberVO member = getBizMember(session);
        if (member == null) 
            return "redirect:/login";

        // StayVO stay = bizStayService.getStayByBizId(member.getMemberId());
        // model.addAttribute("stay", stay);

        return "biz/stay/dashboard";
    }

    // 2026-07-14 — 사업자 숙소 예약 관리 (DB 연동)
    @GetMapping("/reserve")
    public String stayReserve(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null || stay.getStayId() == null) {
            return "redirect:/mypage/biz";
        }

        List<ReservationVO> reservationList = bizStayService.getReservationList(stay.getStayId(), "all");
        model.addAttribute("stay", stay);
        model.addAttribute("reservationList", reservationList);
        return "biz/stay/reserve";
    }

    // 2026-07-14 — 사업자 숙소 예약 상태 변경
    @PostMapping("/reserve/status")
    public String updateReservationStatus(@RequestParam("resvId") Long resvId,
                                          @RequestParam("statusCd") String statusCd,
                                          @RequestParam(value = "cancelReason", required = false) String cancelReason,
                                          HttpSession session,
                                          RedirectAttributes rttr) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null || stay.getStayId() == null) {
            return "redirect:/mypage/biz";
        }

        try {
            bizStayService.updateReservationStatus(
                    stay.getStayId(), resvId, statusCd, cancelReason);
            rttr.addFlashAttribute("msg", "예약 상태가 변경되었습니다.");
        } catch (IllegalStateException | IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        catch (Exception e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        
        return "redirect:/biz/stay/reserve";
    }

    // 2026-07-14 — 사업자 숙소 예약 상세 모달 API
    @GetMapping("/reserve/detail")
    @ResponseBody
    public ReservationVO reservationDetail(@RequestParam("resvId") Long resvId,
                                           HttpSession session) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) return null;

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null || stay.getStayId() == null) return null;

        return bizStayService.getReservationDetail(stay.getStayId(), resvId);
    }

    // 2026-07-14 — 사업자 숙소 예약 캘린더 (DB 연동)
    @GetMapping("/calendar")
    public String stayCalendar(@RequestParam(value = "from", required = false) String fromDate,
                               @RequestParam(value = "to", required = false) String toDate,
                               HttpSession session,
                               Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null || stay.getStayId() == null) {
            return "redirect:/mypage/biz";
        }

        if (fromDate == null || fromDate.isBlank()) {
            fromDate = java.time.LocalDate.now().minusMonths(3).toString();
        }
        if (toDate == null || toDate.isBlank()) {
            toDate = java.time.LocalDate.now().plusMonths(6).toString();
        }

        List<ReservationVO> calendarReservations = bizStayService.getCalendarReservations(stay.getStayId(), fromDate, toDate);
        model.addAttribute("stay", stay);
        model.addAttribute("calendarReservations", calendarReservations);
        return "biz/stay/calendar";
    }

    @GetMapping("/reviews")
    public String stayReviews(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/stay/reviews";
    }

    @GetMapping("/contract")
    public String stayContract(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/stay/contract";
    }
/*사업자(상점) 정산관리 추가*/
    @GetMapping("/settlement")
    public String staySettlement(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/stay/settlement";
    }

    @GetMapping("/info")
    public String stayInfo(HttpSession session, Model model) {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null) {
            return "redirect:/mypage/biz";
        }
        model.addAttribute("stay", stay);   
        return "biz/stay/info";

    }

    /*사업자 숙소관리 메뉴 0702지윤*/
    @GetMapping("/profile")
    public String stayLodge(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null) return "redirect:/mypage/biz";

        model.addAttribute("stay", stay);

        List<FileVO> imgList = fileService.getFileList("STAY", stay.getStayId());
        model.addAttribute("imgList", imgList);

        return "biz/stay/profile";
    }

    @PostMapping("/profile")
    public String saveProfile(StayVO vo,
                              @RequestParam(value = "facilities", required = false) String[] facilities,
                              @RequestParam(value = "imgList", required = false) MultipartFile[] imgList,
                              @RequestParam(value = "deleteFileIds", required = false) Long[] deleteFileIds,
                              HttpSession session,
                              RedirectAttributes rttr) throws Exception {

        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";
        
        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null || stay.getStayId() == null) {
            rttr.addFlashAttribute("errorMsg", "숙소 정보를 불러올 수 없습니다.");
            return "redirect:/biz/stay/profile";
        }
        vo.setStayId(stay.getStayId());        
        
        // DB에서 stayId 확보 (폼 조작 방지)
        if (vo.getName() == null || vo.getName().isBlank()) {
            vo.setName(vo.getName());
        }
        if (vo.getPhone() == null || vo.getPhone().isBlank()) {
            vo.setPhone(vo.getPhone());
        }
        if (vo.getAddr() == null || stay.getAddr().isBlank()) {
            vo.setAddr(stay.getAddr());
            if (vo.getLat() == null) {
                vo.setLat(stay.getLat());
            }
            if (vo.getLng() == null) {
                vo.setLng(vo.getLng());
            }
        }
        if (vo.getAddrDetail() == null) {
            vo.setAddrDetail(vo.getAddrDetail());
        }

        // 편의시설 체크박스 배열 → 콤마 구분 문자열
        vo.setFacilities(facilities != null ? String.join(",", facilities) : "");

        // 기존 이미지 삭제
        if (deleteFileIds != null) {
            for (Long fileId : deleteFileIds) {
                fileService.deleteFile(fileId);
            }
        }

        // 새 이미지 업로드
        if (imgList != null) {
            for (MultipartFile img : imgList) {
                if (img == null || img.isEmpty()) continue;
                fileService.uploadFile(img, "STAY", stay.getStayId());
            }
        }

        // TB_STAY 운영정보 업데이트
        bizStayService.updateStayProfile(vo);

        rttr.addFlashAttribute("msg", "저장되었습니다.");
        return "redirect:/biz/stay/profile";
    }

    // ── GET: 객실 목록 ──
    @GetMapping("/rooms")
    public String stayRooms(HttpSession session, Model model) {
        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        if (stay == null) return "redirect:/mypage/biz";

        List<StayRoomVO> roomList = bizStayService.getRoomList(stay.getStayId());
        model.addAttribute("roomList", roomList);

        return "biz/stay/rooms";
    }

    // ── POST: 객실 등록/수정 ──
    @PostMapping("/rooms")
    public String saveRoom(StayRoomVO room,
                           HttpSession session,
                           RedirectAttributes rttr) {

        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        room.setStayId(stay.getStayId());

        if (room.getRoomId() == null) {
            // 신규 등록 (승인 없이 바로 등록)
            room.setStatusCd("APPROVE");
            bizStayService.insertRoom(room);
            rttr.addFlashAttribute("msg", "객실이 등록되었습니다.");
        } else {
            // 수정
            bizStayService.updateRoom(room);
            rttr.addFlashAttribute("msg", "객실 정보가 수정되었습니다.");
        }
        return "redirect:/biz/stay/rooms";
    }

    // ── POST: 객실 삭제 ──
    @PostMapping("/rooms/delete")
    public String deleteRoom(@RequestParam Long roomId,
                             HttpSession session,
                             RedirectAttributes rttr) {

        MemberVO member = getBizMember(session);
        if (member == null) return "redirect:/login";

        StayVO stay = bizStayService.resolveStayByBizId(member.getMemberId());
        bizStayService.deleteRoom(roomId, stay.getStayId());

        rttr.addFlashAttribute("msg", "객실이 삭제되었습니다.");
        return "redirect:/biz/stay/rooms";
    }
}
