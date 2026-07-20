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

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.biz.controller.BizBaseController;
import com.petcare.petcare.biz.hospital.service.BizHospitalService;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.hospital.vo.HospitalDoctorVO;
import com.petcare.petcare.hospital.vo.HospitalResvExceptionVO;
import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.hospital.vo.HospitalTreatTypeVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.MedicalRecordVO;
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
    @Autowired
    private ObjectMapper objectMapper;

    // 2026/07/11 장우철 — 모든 병원 사업자 화면에 PENDING 배지 건수 전달
    // [변경 전] sidebar_hospital.jsp 에 더미 5 고정
    @ModelAttribute("pendingReserveCount")
    public int pendingReserveCount(HttpSession session) {
        try {
            MemberVO member = getBizMember(session);
            if (member == null || member.getMemberId() == null) {
                return 0;
            }
            HospitalVO hospital = bizHospitalService.getHospitalByBizId(member.getMemberId());
            if (hospital == null || hospital.getHospitalId() == null) {
                return 0;
            }
            return bizHospitalService.countPendingReservations(hospital.getHospitalId());
        } catch (Exception e) {
            return 0;
        }
    }

    // 2026/07/11 장우철 — 캘린더 메뉴: 오늘 예약확정(CONFIRMED) 건수
    @ModelAttribute("todayConfirmedCount")
    public int todayConfirmedCount(HttpSession session) {
        try {
            MemberVO member = getBizMember(session);
            if (member == null || member.getMemberId() == null) {
                return 0;
            }
            HospitalVO hospital = bizHospitalService.getHospitalByBizId(member.getMemberId());
            if (hospital == null || hospital.getHospitalId() == null) {
                return 0;
            }
            return bizHospitalService.countTodayConfirmedReservations(hospital.getHospitalId());
        } catch (Exception e) {
            return 0;
        }
    }

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
    // 2026/07/11 장우철 — cancelReason: CANCEL 시 필수
    @PostMapping("/reserve/status")
    public String updateReservationStatus(@RequestParam("resvId") Long resvId,
                                          @RequestParam("statusCd") String statusCd,
                                          @RequestParam(value = "cancelReason", required = false) String cancelReason,
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

        try {
            bizHospitalService.updateReservationStatus(
                    hospital.getHospitalId(), resvId, statusCd, cancelReason);
            rttr.addFlashAttribute("msg", "예약 상태가 변경되었습니다.");
        } catch (IllegalStateException | IllegalArgumentException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
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

    // 2026/07/16 장우철 고도화작업 — 병원 스케줄 화면
    @GetMapping("/schedule")
    public String hospitalSchedule(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/schedule";
    }

    // 2026/07/16 장우철 고도화작업 — 스케줄 API 공통: 로그인·병원 해석
    private HospitalVO requireScheduleHospital(HttpSession session) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null || member.getMemberId() == null) {
            return null;
        }
        return bizHospitalService.resolveHospitalByBizId(member.getMemberId());
    }

    private Map<String, Object> scheduleFail(String msg) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("ok", false);
        m.put("message", msg);
        return m;
    }

    private Map<String, Object> scheduleOk(Object data) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("ok", true);
        m.put("data", data);
        return m;
    }

    @GetMapping("/schedule/treat-types")
    @ResponseBody
    public Map<String, Object> listTreatTypes(HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        return scheduleOk(bizHospitalService.getTreatTypeList(hospital.getHospitalId()));
    }

    @PostMapping("/schedule/treat-types/save")
    @ResponseBody
    public Map<String, Object> saveTreatType(@RequestBody HospitalTreatTypeVO vo,
                                             HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            bizHospitalService.saveTreatType(hospital.getHospitalId(), vo);
            return scheduleOk(bizHospitalService.getTreatTypeList(hospital.getHospitalId()));
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    @PostMapping("/schedule/treat-types/delete")
    @ResponseBody
    public Map<String, Object> deleteTreatType(@RequestParam("treatTypeId") Long treatTypeId,
                                               HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            bizHospitalService.deleteTreatType(hospital.getHospitalId(), treatTypeId);
            return scheduleOk(bizHospitalService.getTreatTypeList(hospital.getHospitalId()));
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    @GetMapping("/schedule/doctors")
    @ResponseBody
    public Map<String, Object> listDoctors(HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        return scheduleOk(bizHospitalService.getDoctorList(hospital.getHospitalId()));
    }

    @PostMapping("/schedule/doctors/save")
    @ResponseBody
    public Map<String, Object> saveDoctor(@RequestBody HospitalDoctorVO vo,
                                          HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            bizHospitalService.saveDoctor(hospital.getHospitalId(), vo);
            return scheduleOk(bizHospitalService.getDoctorList(hospital.getHospitalId()));
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    @PostMapping("/schedule/doctors/delete")
    @ResponseBody
    public Map<String, Object> deleteDoctor(@RequestParam("doctorId") Long doctorId,
                                            HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            bizHospitalService.deleteDoctor(hospital.getHospitalId(), doctorId);
            return scheduleOk(bizHospitalService.getDoctorList(hospital.getHospitalId()));
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    // 2026/07/16 장우철 고도화작업 — RESV_RULE 제거, 예약 시작 간격만 병원 컬럼으로
    @GetMapping("/schedule/interval")
    @ResponseBody
    public Map<String, Object> getInterval(HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("resvIntervalMin", bizHospitalService.getResvIntervalMin(hospital.getHospitalId()));
        return scheduleOk(data);
    }

    @PostMapping("/schedule/interval/save")
    @ResponseBody
    public Map<String, Object> saveInterval(@RequestBody Map<String, Object> body,
                                            HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            Integer intervalMin = null;
            if (body.get("resvIntervalMin") != null && !String.valueOf(body.get("resvIntervalMin")).isBlank()) {
                intervalMin = Integer.valueOf(String.valueOf(body.get("resvIntervalMin")));
            }
            bizHospitalService.saveResvIntervalMin(hospital.getHospitalId(), intervalMin);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("resvIntervalMin", bizHospitalService.getResvIntervalMin(hospital.getHospitalId()));
            return scheduleOk(data);
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    @GetMapping("/schedule/exceptions")
    @ResponseBody
    public Map<String, Object> listExceptions(
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate,
            HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        return scheduleOk(bizHospitalService.getResvExceptionList(hospital.getHospitalId(), fromDate, toDate));
    }

    @PostMapping("/schedule/exceptions/save")
    @ResponseBody
    public Map<String, Object> saveException(@RequestBody Map<String, Object> body,
                                             HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            HospitalResvExceptionVO vo = new HospitalResvExceptionVO();
            if (body.get("excId") != null && !String.valueOf(body.get("excId")).isBlank()) {
                vo.setExcId(Long.valueOf(String.valueOf(body.get("excId"))));
            }
            Object doctorId = body.get("doctorId");
            if (doctorId != null && !String.valueOf(doctorId).isBlank()
                    && !"null".equalsIgnoreCase(String.valueOf(doctorId))
                    && !"common".equalsIgnoreCase(String.valueOf(doctorId))) {
                vo.setDoctorId(Long.valueOf(String.valueOf(doctorId)));
            }
            String dateStr = body.get("excDate") == null ? null : String.valueOf(body.get("excDate"));
            if (dateStr != null && !dateStr.isBlank()) {
                vo.setExcDate(new SimpleDateFormat("yyyy-MM-dd").parse(dateStr));
            }
            vo.setExcType(body.get("excType") == null ? null : String.valueOf(body.get("excType")));
            vo.setStartTime(body.get("startTime") == null ? null : String.valueOf(body.get("startTime")));
            vo.setEndTime(body.get("endTime") == null ? null : String.valueOf(body.get("endTime")));
            vo.setMemo(body.get("memo") == null ? null : String.valueOf(body.get("memo")));
            vo.setStatusCd(body.get("statusCd") == null ? "Y" : String.valueOf(body.get("statusCd")));

            bizHospitalService.saveResvException(hospital.getHospitalId(), vo);
            return scheduleOk(bizHospitalService.getResvExceptionList(hospital.getHospitalId(), null, null));
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    @PostMapping("/schedule/exceptions/delete")
    @ResponseBody
    public Map<String, Object> deleteException(@RequestParam("excId") Long excId,
                                               HttpSession session) throws Exception {
        HospitalVO hospital = requireScheduleHospital(session);
        if (hospital == null || hospital.getHospitalId() == null) {
            return scheduleFail("로그인이 필요합니다.");
        }
        try {
            bizHospitalService.deleteResvException(hospital.getHospitalId(), excId);
            return scheduleOk(bizHospitalService.getResvExceptionList(hospital.getHospitalId(), null, null));
        } catch (IllegalArgumentException | IllegalStateException e) {
            return scheduleFail(e.getMessage());
        }
    }

    @GetMapping("/records")
    public String hospitalRecords(@RequestParam(value = "keyword", required = false) String keyword,
                                  @RequestParam(value = "period", required = false) Integer period,
                                  HttpSession session,
                                  Model model) throws Exception {
        // 2026/07/13 장우철 — 진료기록 목록 DB 연동
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }
        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return "redirect:/mypage/biz";
        }
        model.addAttribute("hospital", hospital);
        model.addAttribute("keyword", keyword);
        model.addAttribute("period", period);
        model.addAttribute("recordList",
                bizHospitalService.getMedicalRecords(hospital.getHospitalId(), keyword, period));
        // 2026/07/13 장우철 — 작성 모달: 확정·미기록 예약 선택
        model.addAttribute("writableReserves",
                bizHospitalService.getConfirmedWithoutRecord(hospital.getHospitalId()));
        return "biz/hospital/records";
    }

    // 2026/07/13 장우철 — 예약확정 → 진료기록 저장 + DONE
    @PostMapping("/records/complete")
    public String completeWithRecord(@RequestParam("resvId") Long resvId,
                                     @RequestParam("symptoms") String symptoms,
                                     @RequestParam("diagnosis") String diagnosis,
                                     @RequestParam(value = "prescription", required = false) String prescription,
                                     @RequestParam(value = "memo", required = false) String memo,
                                     @RequestParam(value = "vetName", required = false) String vetName,
                                     @RequestParam(value = "treatType", required = false) String treatType,
                                     @RequestParam(value = "weight", required = false) String weight,
                                     @RequestParam(value = "temperature", required = false) String temperature,
                                     @RequestParam(value = "examItems", required = false) String examItems,
                                     @RequestParam(value = "heartRate", required = false) String heartRate,
                                     @RequestParam(value = "breathRate", required = false) String breathRate,
                                     @RequestParam(value = "nextVisit", required = false) String nextVisit,
                                     @RequestParam(value = "redirect", required = false) String redirect,
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

        MedicalRecordVO record = new MedicalRecordVO();
        record.setResvId(resvId);
        record.setSymptoms(symptoms);
        record.setDiagnosis(diagnosis);
        record.setPrescription(prescription);
        record.setMemo(memo);
        record.setVetName(vetName);
        record.setTreatType(treatType);
        record.setWeight(weight);
        record.setTemperature(temperature);
        record.setExamItems(examItems);
        record.setHeartRate(heartRate);
        record.setBreathRate(breathRate);
        record.setNextVisit(nextVisit);

        try {
            bizHospitalService.completeReservationWithRecord(hospital.getHospitalId(), record);
            rttr.addFlashAttribute("msg", "진료완료 및 진료기록이 저장되었습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        // 2026/07/13 장우철 — 기록관리에서 작성 시 기록 목록으로, 아니면 예약관리로
        if ("records".equals(redirect)) {
            return "redirect:/biz/hospital/records";
        }
        return "redirect:/biz/hospital/reserve";
    }

    @GetMapping("/talent")
    public String hospitalTalent(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/hospital/talent";
    }

    // 2026/07/14 장우철 — 사업자 리뷰관리 (DB 목록)
    @GetMapping("/reviews")
    public String hospitalReviews(HttpSession session, Model model) throws Exception {
        MemberVO member = getBizMember(session);
        if (member == null) {
            return "redirect:/login";
        }
        HospitalVO hospital = bizHospitalService.resolveHospitalByBizId(member.getMemberId());
        if (hospital == null || hospital.getHospitalId() == null) {
            return "redirect:/mypage/biz";
        }

        List<HospitalReviewVO> reviewList =
                bizHospitalService.getBizHospitalReviews(hospital.getHospitalId());
        // JS 렌더용 JSON (날짜 문자열·신고 플래그는 2단계에서 연동)
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        List<Map<String, Object>> rows = new ArrayList<>();
        for (HospitalReviewVO r : reviewList) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", r.getReviewId());
            row.put("author", (r.getNickname() != null && !r.getNickname().isBlank())
                    ? r.getNickname() : "회원");
            row.put("date", r.getRegDate() != null ? df.format(r.getRegDate()) : "");
            row.put("rating", r.getRating() != null ? r.getRating() : 0);
            row.put("content", r.getContent() != null ? r.getContent() : "");
            row.put("reply", r.getBizReply());
            row.put("reported", false);
            rows.add(row);
        }

        model.addAttribute("hospital", hospital);
        model.addAttribute("reviewListJson", objectMapper.writeValueAsString(rows));
        return "biz/hospital/reviews";
    }

    // 2026/07/14 장우철 — 리뷰 답글 작성/수정
    @PostMapping("/reviews/reply")
    public String saveReviewReply(@RequestParam("reviewId") Long reviewId,
                                  @RequestParam("bizReply") String bizReply,
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
        try {
            bizHospitalService.saveReviewBizReply(hospital.getHospitalId(), reviewId, bizReply);
            rttr.addFlashAttribute("msg", "답글이 저장되었습니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/biz/hospital/reviews";
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
