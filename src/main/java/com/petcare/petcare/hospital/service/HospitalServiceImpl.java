/**
 * 역할: HospitalHospitalService 구현체 (@Service)
 */

package com.petcare.petcare.hospital.service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.hospital.mapper.HospitalMapper;
import com.petcare.petcare.hospital.vo.HospitalDoctorVO;
import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.HospitalResvExceptionVO;
import com.petcare.petcare.hospital.vo.HospitalResvHoldVO;
import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.hospital.vo.HospitalTimeBlockVO;
import com.petcare.petcare.hospital.vo.HospitalTreatTypeVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;

@Service
public class HospitalServiceImpl implements HospitalService {

    private static final ZoneId ZONE = ZoneId.of("Asia/Seoul");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");
    private static final String[] DAY_LABELS = {"월", "화", "수", "목", "금", "토", "일"};
    private static final int HOLD_TTL_MINUTES = 15;

    @Autowired
    private HospitalMapper hospitalMapper;
    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public List<HospitalVO> getHospitalList() throws Exception {
        return hospitalMapper.selectHospitalList();
    }

    @Override
    public List<HospitalVO> getHospitalListBySearch(HospitalVO searchVO) throws Exception {
        return hospitalMapper.selectHospitalListBySearch(searchVO);
    }

    @Override
    public HospitalVO getHospitalById(Long hospitalId) throws Exception {
        return hospitalMapper.selectHospitalById(hospitalId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HospitalPetVO> getPetListForReserve(Long memberNo) throws Exception {
        return hospitalMapper.selectPetListByMemberNo(memberNo);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HospitalDoctorVO> getActiveDoctorsForReserve(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return hospitalMapper.selectActiveDoctorList(hospitalId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HospitalTreatTypeVO> getActiveTreatTypesForReserve(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return hospitalMapper.selectActiveTreatTypeList(hospitalId);
    }

    // 2026/07/16 장우철 — HOURS_JSON·예외·점유 반영 가능 시작시각 목록
    // noRollbackFor: hold 테이블 미존재 등 조회 실패를 catch 해도 트랜잭션 롤백 마킹 방지
    @Override
    @Transactional(readOnly = true, noRollbackFor = Exception.class)
    public List<String> getAvailableReserveTimes(Long hospitalId, Long doctorId, Long treatTypeId,
                                                 Date resvDate) throws Exception {
        validateScheduleParams(hospitalId, doctorId, treatTypeId, resvDate);

        HospitalVO hospital = hospitalMapper.selectHospitalById(hospitalId);
        if (hospital == null) {
            throw new IllegalArgumentException("병원 정보를 찾을 수 없습니다.");
        }
        HospitalTreatTypeVO treatType = hospitalMapper.selectTreatType(hospitalId, treatTypeId);
        if (treatType == null || (treatType.getStatusCd() != null && !"Y".equalsIgnoreCase(treatType.getStatusCd()))) {
            throw new IllegalArgumentException("선택한 진료 유형을 사용할 수 없습니다.");
        }
        HospitalDoctorVO doctor = hospitalMapper.selectDoctor(hospitalId, doctorId);
        if (doctor == null || (doctor.getStatusCd() != null && !"Y".equalsIgnoreCase(doctor.getStatusCd()))) {
            throw new IllegalArgumentException("선택한 의사를 예약할 수 없습니다.");
        }

        Integer durationObj = treatType.getDurationMin();
        if (durationObj == null || durationObj <= 0) {
            throw new IllegalArgumentException("진료 소요 시간 정보가 올바르지 않습니다.");
        }
        int durationMin = durationObj;
        int intervalMin = resolveIntervalMin(hospitalId);
        LocalDate date = toLocalDate(resvDate);

        List<TimeRange> openWindows = resolveOpenWindows(hospital, doctorId, date, intervalMin);
        if (openWindows.isEmpty()) {
            return List.of();
        }

        List<HospitalResvExceptionVO> exceptions = loadExceptionsSafe(hospitalId, resvDate);
        List<TimeRange> closeBlocks = resolveCloseBlocks(exceptions, doctorId);
        List<TimeRange> lunchBlocks = resolveLunchBlocks(hospital, date, exceptions, doctorId);

        List<HospitalTimeBlockVO> occupied = loadOccupiedBlocksSafe(hospitalId, doctorId, resvDate);

        List<String> slots = new ArrayList<>();
        LocalTime nowCutoff = null;
        if (date.equals(LocalDate.now(ZONE))) {
            nowCutoff = LocalTime.now(ZONE);
        }
        for (TimeRange window : openWindows) {
            LocalTime cursor = window.start();
            while (!cursor.plusMinutes(durationMin).isAfter(window.end())) {
                if (nowCutoff != null && !cursor.isAfter(nowCutoff)) {
                    cursor = cursor.plusMinutes(intervalMin);
                    continue;
                }
                String start = formatTime(cursor);
                String end = formatTime(cursor.plusMinutes(durationMin));
                if (!overlapsAny(start, end, lunchBlocks)
                        && !overlapsAny(start, end, closeBlocks)
                        && !overlapsOccupied(start, end, occupied)) {
                    slots.add(start);
                }
                cursor = cursor.plusMinutes(intervalMin);
            }
        }
        return slots;
    }

    // 2026/07/16 장우철 — 펫 단계 이동 시 임시 선점
    @Override
    @Transactional
    public Long createReserveHold(Long hospitalId, Long memberNo, Long doctorId, Long treatTypeId,
                                  Date resvDate, String resvTime) throws Exception {
        cleanupExpiredHoldsSafe();
        validateScheduleParams(hospitalId, doctorId, treatTypeId, resvDate);
        if (resvTime == null || resvTime.isBlank()) {
            throw new IllegalArgumentException("예약 시간을 선택해 주세요.");
        }

        HospitalTreatTypeVO treatType = hospitalMapper.selectTreatType(hospitalId, treatTypeId);
        if (treatType == null || !"Y".equalsIgnoreCase(treatType.getStatusCd())) {
            throw new IllegalArgumentException("선택한 진료 유형을 사용할 수 없습니다.");
        }
        HospitalDoctorVO doctor = hospitalMapper.selectDoctor(hospitalId, doctorId);
        if (doctor == null || !"Y".equalsIgnoreCase(doctor.getStatusCd())) {
            throw new IllegalArgumentException("선택한 의사를 예약할 수 없습니다.");
        }

        String startTime = resvTime.trim();
        int durationMin = treatType.getDurationMin();
        String endTime = calcEndTime(startTime, durationMin);

        List<String> available = getAvailableReserveTimes(hospitalId, doctorId, treatTypeId, resvDate);
        if (!available.contains(startTime)) {
            throw new IllegalStateException("선택한 시간은 더 이상 예약할 수 없습니다. 다시 선택해 주세요.");
        }

        try {
            hospitalMapper.deleteHoldsByMember(hospitalId, memberNo);
        } catch (Exception e) {
            System.out.println("[reserve/hold] 기존 선점 삭제 스킵: " + e.getMessage());
        }

        int overlap = countOverlapSafe(
                hospitalId, doctorId, resvDate, startTime, endTime, null);
        if (overlap > 0) {
            throw new IllegalStateException("선택한 시간에 이미 예약이 있습니다. 다른 시간을 선택해 주세요.");
        }

        HospitalResvHoldVO hold = new HospitalResvHoldVO();
        hold.setHospitalId(hospitalId);
        hold.setDoctorId(doctorId);
        hold.setTreatTypeId(treatTypeId);
        hold.setMemberNo(memberNo);
        hold.setResvDate(resvDate);
        hold.setResvTime(startTime);
        hold.setDurationMin(durationMin);
        hold.setEndTime(endTime);
        hold.setExpireDate(Date.from(
                java.time.LocalDateTime.now(ZONE).plusMinutes(HOLD_TTL_MINUTES)
                        .atZone(ZONE).toInstant()));
        try {
            hospitalMapper.insertResvHold(hold);
        } catch (Exception e) {
            throw new IllegalStateException(
                    "예약 선점 테이블이 없습니다. sql/hospital_resv_alter.sql 을 실행해 주세요.");
        }
        return hold.getHoldId();
    }

    // 2026/07/16 장우철 — 선점 기반 최종 예약 저장
    @Override
    @Transactional
    public Long createHospitalReservation(ReservationVO vo) throws Exception {
        cleanupExpiredHoldsSafe();
        if (vo.getHoldId() != null) {
            return finalizeReservationFromHold(vo);
        }
        return createHospitalReservationDirect(vo);
    }

    private Long finalizeReservationFromHold(ReservationVO vo) throws Exception {
        if (vo.getMemberNo() == null) {
            throw new IllegalArgumentException("로그인이 필요합니다.");
        }
        if (vo.getPetId() == null) {
            throw new IllegalArgumentException("반려동물을 선택해 주세요.");
        }

        HospitalResvHoldVO hold = hospitalMapper.selectResvHoldById(vo.getHoldId());
        if (hold == null || !hold.getMemberNo().equals(vo.getMemberNo())) {
            throw new IllegalStateException("예약 선점이 만료되었습니다. 일정부터 다시 선택해 주세요.");
        }

        vo.setTargetId(String.valueOf(hold.getHospitalId()));
        vo.setResvDate(hold.getResvDate());
        vo.setResvTime(hold.getResvTime());
        vo.setDoctorId(hold.getDoctorId());
        vo.setTreatTypeId(hold.getTreatTypeId());
        vo.setDurationMin(hold.getDurationMin());
        vo.setEndTime(hold.getEndTime());

        int overlap = countOverlapSafe(
                hold.getHospitalId(), hold.getDoctorId(), hold.getResvDate(),
                hold.getResvTime(), hold.getEndTime(), hold.getHoldId());
        if (overlap > 0) {
            try { hospitalMapper.deleteResvHoldById(hold.getHoldId()); } catch (Exception ignore) {}
            throw new IllegalStateException("선택한 시간에 이미 예약이 있습니다. 일정부터 다시 선택해 주세요.");
        }

        vo.setResvType("HOSPITAL");
        vo.setStatusCd("PENDING");
        if (vo.getResvNo() == null || vo.getResvNo().isBlank()) {
            vo.setResvNo(buildResvNo());
        }
        hospitalMapper.insertReservation(vo);
        try { hospitalMapper.deleteResvHoldById(hold.getHoldId()); } catch (Exception ignore) {}
        return vo.getResvId();
    }

    private Long createHospitalReservationDirect(ReservationVO vo) throws Exception {
        if (vo.getTargetId() == null || vo.getTargetId().isBlank()) {
            throw new IllegalArgumentException("병원 정보가 올바르지 않습니다.");
        }
        Long hospitalId = Long.parseLong(vo.getTargetId());

        if (vo.getTreatTypeId() == null) {
            throw new IllegalArgumentException("진료 유형을 선택해 주세요.");
        }
        if (vo.getDoctorId() == null) {
            throw new IllegalArgumentException("의사를 선택해 주세요.");
        }
        if (vo.getResvDate() == null || vo.getResvTime() == null || vo.getResvTime().isBlank()) {
            throw new IllegalArgumentException("예약 날짜·시간을 확인해 주세요.");
        }

        HospitalTreatTypeVO treatType = hospitalMapper.selectTreatType(hospitalId, vo.getTreatTypeId());
        if (treatType == null || !"Y".equalsIgnoreCase(treatType.getStatusCd())) {
            throw new IllegalArgumentException("선택한 진료 유형을 사용할 수 없습니다.");
        }

        HospitalDoctorVO doctor = hospitalMapper.selectDoctor(hospitalId, vo.getDoctorId());
        if (doctor == null || !"Y".equalsIgnoreCase(doctor.getStatusCd())) {
            throw new IllegalArgumentException("선택한 의사를 예약할 수 없습니다.");
        }

        Integer durationMin = treatType.getDurationMin();
        if (durationMin == null || durationMin <= 0) {
            throw new IllegalArgumentException("진료 소요 시간 정보가 올바르지 않습니다.");
        }

        String startTime = vo.getResvTime().trim();
        String endTime = calcEndTime(startTime, durationMin);
        vo.setDurationMin(durationMin);
        vo.setEndTime(endTime);

        int overlap = countOverlapSafe(
                hospitalId, vo.getDoctorId(), vo.getResvDate(), startTime, endTime, null);
        if (overlap > 0) {
            throw new IllegalStateException("선택한 시간에 이미 예약이 있습니다. 다른 시간을 선택해 주세요.");
        }

        vo.setResvType("HOSPITAL");
        vo.setStatusCd("PENDING");
        vo.setResvTime(startTime);
        if (vo.getResvNo() == null || vo.getResvNo().isBlank()) {
            vo.setResvNo(buildResvNo());
        }
        hospitalMapper.insertReservation(vo);
        return vo.getResvId();
    }

    @Override
    @Transactional(readOnly = true)
    public ReservationVO getReservationById(Long resvId) throws Exception {
        return hospitalMapper.selectReservationById(resvId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<HospitalReviewVO> getHospitalReviews(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return hospitalMapper.selectHospitalReviews(hospitalId);
    }

    private int resolveIntervalMin(Long hospitalId) {
        try {
            Integer interval = hospitalMapper.selectResvIntervalMin(hospitalId);
            return interval != null && interval > 0 ? interval : 15;
        } catch (Exception e) {
            // 2026/07/16 장우철 — RESV_INTERVAL_MIN 미적용 DB도 기본 15분으로 동작
            return 15;
        }
    }

    private List<HospitalResvExceptionVO> loadExceptionsSafe(Long hospitalId, Date resvDate) {
        try {
            return hospitalMapper.selectResvExceptionsByDate(hospitalId, resvDate);
        } catch (Exception e) {
            return List.of();
        }
    }

    private List<HospitalTimeBlockVO> loadOccupiedBlocksSafe(Long hospitalId, Long doctorId, Date resvDate) {
        List<HospitalTimeBlockVO> occupied = new ArrayList<>();
        try {
            List<HospitalTimeBlockVO> reservations =
                    hospitalMapper.selectOccupiedReservationBlocks(hospitalId, doctorId, resvDate);
            if (reservations != null) {
                occupied.addAll(reservations);
            }
        } catch (Exception e) {
            // 2026/07/16 장우철 — DOCTOR_ID/END_TIME 미적용 시 점유 없이 슬롯만 표시
            System.out.println("[reserve/times] 예약 점유 조회 실패(스키마 확인): " + e.getMessage());
        }
        try {
            List<HospitalTimeBlockVO> holds =
                    hospitalMapper.selectOccupiedHoldBlocks(hospitalId, doctorId, resvDate);
            if (holds != null) {
                occupied.addAll(holds);
            }
        } catch (Exception e) {
            // 2026/07/16 장우철 — TB_HOSPITAL_RESV_HOLD 미생성 시 무시
            System.out.println("[reserve/times] 선점 점유 조회 실패(hold 테이블 확인): " + e.getMessage());
        }
        return occupied;
    }

    private void cleanupExpiredHoldsSafe() {
        try {
            hospitalMapper.deleteExpiredHolds();
        } catch (Exception e) {
            System.out.println("[reserve] hold 만료 정리 스킵: " + e.getMessage());
        }
    }

    private int countOverlapSafe(Long hospitalId, Long doctorId, Date resvDate,
                                 String resvTime, String endTime, Long excludeHoldId) {
        try {
            return hospitalMapper.countOverlappingWithHolds(
                    hospitalId, doctorId, resvDate, resvTime, endTime, excludeHoldId);
        } catch (Exception e) {
            try {
                return hospitalMapper.countOverlappingReservations(
                        hospitalId, doctorId, resvDate, resvTime, endTime);
            } catch (Exception e2) {
                System.out.println("[reserve] 겹침 조회 스킵: " + e2.getMessage());
                return 0;
            }
        }
    }

    private void validateScheduleParams(Long hospitalId, Long doctorId, Long treatTypeId,
                                        Date resvDate) {
        if (hospitalId == null || doctorId == null || treatTypeId == null || resvDate == null) {
            throw new IllegalArgumentException("일정 정보가 올바르지 않습니다.");
        }
        LocalDate date = toLocalDate(resvDate);
        if (date.isBefore(LocalDate.now(ZONE))) {
            throw new IllegalArgumentException("과거 날짜는 예약할 수 없습니다.");
        }
    }

    // 2026/07/16 장우철 — REPLACE 우선, 없으면 HOURS_JSON 요일
    private List<TimeRange> resolveOpenWindows(HospitalVO hospital, Long doctorId,
                                               LocalDate date, int defaultInterval) throws Exception {
        List<HospitalResvExceptionVO> exceptions = loadExceptionsSafe(hospital.getHospitalId(), toDate(date));

        List<TimeRange> replaceWindows = new ArrayList<>();
        for (HospitalResvExceptionVO exc : exceptions) {
            if (!"REPLACE".equalsIgnoreCase(exc.getExcType())) {
                continue;
            }
            if (exc.getDoctorId() != null && !exc.getDoctorId().equals(doctorId)) {
                continue;
            }
            LocalTime start = parseTime(exc.getStartTime());
            LocalTime end = parseTime(exc.getEndTime());
            if (start != null && end != null && start.isBefore(end)) {
                replaceWindows.add(new TimeRange(start, end));
            }
        }
        if (!replaceWindows.isEmpty()) {
            return replaceWindows;
        }

        JsonNode dayNode = resolveDayHoursNode(hospital.getHoursJson(), date);
        if (dayNode == null || dayNode.isMissingNode() || dayNode.isNull()) {
            // 해당 요일 휴무(JSON에 없음) → 슬롯 없음
            return List.of();
        }
        LocalTime open = parseTime(dayNode.path("open").asText(null));
        LocalTime close = parseTime(dayNode.path("close").asText(null));
        if (open == null || close == null || !open.isBefore(close)) {
            return List.of();
        }
        return List.of(new TimeRange(open, close));
    }

    private List<TimeRange> resolveCloseBlocks(List<HospitalResvExceptionVO> exceptions,
                                               Long doctorId) {
        List<TimeRange> blocks = new ArrayList<>();
        for (HospitalResvExceptionVO exc : exceptions) {
            if (!"CLOSE".equalsIgnoreCase(exc.getExcType())) {
                continue;
            }
            if (exc.getDoctorId() != null && !exc.getDoctorId().equals(doctorId)) {
                continue;
            }
            LocalTime start = parseTime(exc.getStartTime());
            LocalTime end = parseTime(exc.getEndTime());
            if (start != null && end != null && start.isBefore(end)) {
                blocks.add(new TimeRange(start, end));
            }
        }
        return blocks;
    }

    private List<TimeRange> resolveLunchBlocks(HospitalVO hospital, LocalDate date,
                                               List<HospitalResvExceptionVO> exceptions,
                                               Long doctorId) throws Exception {
        if (hasReplaceForDoctor(exceptions, doctorId)) {
            return List.of();
        }
        JsonNode dayNode = resolveDayHoursNode(hospital.getHoursJson(), date);
        if (dayNode == null) {
            return List.of();
        }
        LocalTime lunchStart = parseTime(dayNode.path("lunchStart").asText(null));
        LocalTime lunchEnd = parseTime(dayNode.path("lunchEnd").asText(null));
        if (lunchStart == null || lunchEnd == null || !lunchStart.isBefore(lunchEnd)) {
            return List.of();
        }
        return List.of(new TimeRange(lunchStart, lunchEnd));
    }

    private boolean hasReplaceForDoctor(List<HospitalResvExceptionVO> exceptions, Long doctorId) {
        for (HospitalResvExceptionVO exc : exceptions) {
            if ("REPLACE".equalsIgnoreCase(exc.getExcType())
                    && (exc.getDoctorId() == null || exc.getDoctorId().equals(doctorId))) {
                return true;
            }
        }
        return false;
    }

    private JsonNode resolveDayHoursNode(String hoursJson, LocalDate date) throws Exception {
        if (hoursJson == null || hoursJson.isBlank()) {
            return null;
        }
        JsonNode root = objectMapper.readTree(hoursJson);
        String dayKey = DAY_LABELS[date.getDayOfWeek().getValue() - 1];
        JsonNode dayNode = root.path(dayKey);
        if (!dayNode.isMissingNode() && !dayNode.isNull()) {
            return dayNode;
        }
        return root.path("공휴일");
    }

    private boolean overlapsOccupied(String start, String end, List<HospitalTimeBlockVO> occupied) {
        for (HospitalTimeBlockVO block : occupied) {
            if (block.getStartTime() == null || block.getEndTime() == null) {
                continue;
            }
            if (overlaps(start, end, block.getStartTime(), block.getEndTime())) {
                return true;
            }
        }
        return false;
    }

    private boolean overlapsAny(String start, String end, List<TimeRange> ranges) {
        for (TimeRange range : ranges) {
            if (overlaps(start, end, formatTime(range.start()), formatTime(range.end()))) {
                return true;
            }
        }
        return false;
    }

    private boolean overlaps(String aStart, String aEnd, String bStart, String bEnd) {
        return aStart.compareTo(bEnd) < 0 && aEnd.compareTo(bStart) > 0;
    }

    private LocalTime parseTime(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return LocalTime.parse(value.trim(), DateTimeFormatter.ofPattern("H:mm"));
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private String formatTime(LocalTime time) {
        return time.format(TIME_FMT);
    }

    private LocalDate toLocalDate(Date date) {
        // 2026/07/16 장우철 — 타임존 보정 (java.util.Date 자정 바인딩 → 전날로 밀리는 문제 방지)
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        return LocalDate.of(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DAY_OF_MONTH));
    }

    private Date toDate(LocalDate date) {
        return Date.from(date.atStartOfDay(ZONE).toInstant());
    }

    private String buildResvNo() {
        String datePart = LocalDate.now(ZONE).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        long suffix = System.currentTimeMillis() % 10000;
        return "R" + datePart + String.format("%04d", suffix);
    }

    private String calcEndTime(String startTime, int durationMin) {
        try {
            LocalTime start = LocalTime.parse(startTime, DateTimeFormatter.ofPattern("H:mm"));
            return start.plusMinutes(durationMin).format(TIME_FMT);
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("예약 시간 형식이 올바르지 않습니다.");
        }
    }

    private record TimeRange(LocalTime start, LocalTime end) {}
}
