/**
 * 역할: BizHospitalService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: BizHospitalService
 * - 사용: BizHospitalMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.biz.hospital.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.biz.hospital.mapper.BizHospitalMapper;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.MedicalRecordVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;

@Service
public class BizHospitalServiceImpl implements BizHospitalService {
    @Autowired
    private BizHospitalMapper bizHospitalMapper;
    @Autowired
    private KakaoMapService kakaoMapService;
    @Autowired
    private MypageNotifyService mypageNotifyService;

    @Override
    @Transactional(readOnly = true)
    public HospitalVO getHospitalByBizId(String bizId) {
        return bizHospitalMapper.selectHospitalByBizId(bizId);
    }

    // 2026-07-10 장우철 — merge 전 승인 계정 등 TB_HOSPITAL 미생성 시 보정 INSERT
    @Override
    @Transactional
    public HospitalVO resolveHospitalByBizId(String bizId) {
        if (bizId == null || bizId.isBlank()) {
            return null;
        }
        HospitalVO hospital = bizHospitalMapper.selectHospitalByBizId(bizId);
        if (hospital == null) {
            bizHospitalMapper.insertHospital(bizId);
            hospital = bizHospitalMapper.selectHospitalByBizId(bizId);
        }
        return hospital;
    }

    @Override
    @Transactional
    public void updateHospitalInfo(HospitalVO vo) {
        // 2026-07-10 장우철 — 주소 있으면 좌표 변환 (유저 목록 '상세보기'는 LAT 필수)
        if (vo.getAddr() != null && !vo.getAddr().isBlank()) {
            Map<String, Double> coords = kakaoMapService.geocodeAddress(vo.getAddr());
            if (coords != null) {
                vo.setLat(coords.get("lat"));
                vo.setLng(coords.get("lng"));
            }
        }

        bizHospitalMapper.updateHospitalInfo(vo);
    }

    // 2026-07-10 장우철 — 사업자 예약 목록 (F4)
    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getReservationList(Long hospitalId, String tab) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        String safeTab = (tab == null || "all".equals(tab)) ? null : tab;
        return bizHospitalMapper.selectReservationList(hospitalId, safeTab);
    }

    // 2026-07-10 장우철 — 사업자 예약 상세 모달 (F6)
    @Override
    @Transactional(readOnly = true)
    public ReservationVO getReservationDetail(Long hospitalId, Long resvId) throws Exception {
        return bizHospitalMapper.selectReservationDetail(resvId, hospitalId);
    }

    // 2026-07-10 장우철 — 사업자 예약 상태 변경 (F5)
    // 2026/07/11 장우철 — [변경 후] PENDING→CONFIRMED→DONE 전이 + 확정/취소 알림 + 취소 사유
    @Override
    @Transactional
    public void updateReservationStatus(Long hospitalId, Long resvId, String statusCd, String cancelReason)
            throws Exception {
        if (hospitalId == null || resvId == null || statusCd == null || statusCd.isBlank()) {
            throw new IllegalArgumentException("예약 상태 변경 정보가 올바르지 않습니다.");
        }

        String next = statusCd.trim().toUpperCase();
        if (!next.equals("PENDING") && !next.equals("CONFIRMED")
                && !next.equals("DONE") && !next.equals("CANCEL")) {
            throw new IllegalArgumentException("허용되지 않은 예약 상태입니다.");
        }

        ReservationVO current = bizHospitalMapper.selectReservationDetail(resvId, hospitalId);
        if (current == null) {
            throw new IllegalStateException("예약을 찾을 수 없거나 변경할 수 없습니다.");
        }

        String prev = current.getStatusCd() != null ? current.getStatusCd().trim().toUpperCase() : "";
        if (!isAllowedStatusTransition(prev, next)) {
            throw new IllegalStateException("현재 상태에서는 해당 처리가 불가합니다. (현재: " + prev + ")");
        }

        String rejectReason = null;
        if ("CANCEL".equals(next)) {
            if (cancelReason == null || cancelReason.isBlank()) {
                throw new IllegalArgumentException("취소 사유를 입력해 주세요.");
            }
            rejectReason = cancelReason.trim();
            if (rejectReason.length() > 500) {
                rejectReason = rejectReason.substring(0, 500);
            }
        }

        int updated = bizHospitalMapper.updateReservationStatus(resvId, hospitalId, next, rejectReason);
        if (updated == 0) {
            throw new IllegalStateException("예약을 찾을 수 없거나 변경할 수 없습니다.");
        }

        String hospitalName = bizHospitalMapper.selectHospitalNameById(hospitalId);
        if (hospitalName == null || hospitalName.isBlank()) {
            hospitalName = "병원";
        }
        if ("CONFIRMED".equals(next)) {
            mypageNotifyService.sendReserveConfirmNotification(
                    current.getMemberNo(), hospitalName, current.getResvDate(), current.getResvTime(), resvId);
        } else if ("CANCEL".equals(next)) {
            mypageNotifyService.sendReserveCancelNotification(
                    current.getMemberNo(), hospitalName, current.getResvDate(), current.getResvTime(),
                    rejectReason, resvId);
        } else if ("DONE".equals(next)) {
            // 2026/07/13 장우철 — 진료완료 알림 (상세·리뷰 작성으로 이동)
            mypageNotifyService.sendReserveDoneNotification(
                    current.getMemberNo(), hospitalName, current.getResvDate(), current.getResvTime(), resvId);
        }
    }

    /** 2026/07/11 장우철 — PENDING→CONFIRMED/CANCEL, CONFIRMED→DONE/CANCEL 만 허용 */
    private boolean isAllowedStatusTransition(String prev, String next) {
        if ("PENDING".equals(prev)) {
            return "CONFIRMED".equals(next) || "CANCEL".equals(next);
        }
        if ("CONFIRMED".equals(prev)) {
            return "DONE".equals(next) || "CANCEL".equals(next);
        }
        return false;
    }

    // 2026-07-10 장우철 — 사업자 예약 캘린더 (F7)
    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getCalendarReservations(Long hospitalId, String fromDate, String toDate) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return bizHospitalMapper.selectReservationCalendarList(hospitalId, fromDate, toDate);
    }

    // 2026/07/11 장우철 — 사이드바 PENDING 배지
    @Override
    @Transactional(readOnly = true)
    public int countPendingReservations(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return 0;
        }
        return bizHospitalMapper.countPendingReservations(hospitalId);
    }

    // 2026/07/11 장우철 — 사이드바 캘린더 배지 (오늘 CONFIRMED)
    @Override
    @Transactional(readOnly = true)
    public int countTodayConfirmedReservations(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return 0;
        }
        return bizHospitalMapper.countTodayConfirmedReservations(hospitalId);
    }

    // 2026/07/13 장우철 — CONFIRMED 예약 → 진료기록 INSERT + DONE
    @Override
    @Transactional
    public void completeReservationWithRecord(Long hospitalId, MedicalRecordVO record) throws Exception {
        if (hospitalId == null || record == null || record.getResvId() == null) {
            throw new IllegalArgumentException("진료기록 정보가 올바르지 않습니다.");
        }
        if (record.getSymptoms() == null || record.getSymptoms().isBlank()) {
            throw new IllegalArgumentException("주증상을 입력해 주세요.");
        }
        if (record.getDiagnosis() == null || record.getDiagnosis().isBlank()) {
            throw new IllegalArgumentException("진단명을 입력해 주세요.");
        }

        ReservationVO current = bizHospitalMapper.selectReservationDetail(record.getResvId(), hospitalId);
        if (current == null) {
            throw new IllegalStateException("예약을 찾을 수 없습니다.");
        }
        if (!"CONFIRMED".equalsIgnoreCase(current.getStatusCd())) {
            throw new IllegalStateException("예약확정 상태에서만 진료완료·기록 저장이 가능합니다.");
        }
        if (bizHospitalMapper.countMedicalRecordByResvId(record.getResvId()) > 0) {
            throw new IllegalStateException("이미 진료기록이 등록된 예약입니다.");
        }

        record.setHospitalId(hospitalId);
        record.setPetId(current.getPetId());
        record.setMemberNo(current.getMemberNo());
        if (record.getVisitDate() == null) {
            record.setVisitDate(current.getResvDate() != null ? current.getResvDate() : new java.util.Date());
        }
        // 화면 보조항목(유형·체중 등)은 MEMO 앞에 붙여 보관
        record.setMemo(buildRecordMemo(record));

        bizHospitalMapper.insertMedicalRecord(record);
        updateReservationStatus(hospitalId, record.getResvId(), "DONE", null);
    }

    private String buildRecordMemo(MedicalRecordVO record) {
        StringBuilder sb = new StringBuilder();
        if (record.getTreatType() != null && !record.getTreatType().isBlank()) {
            sb.append("[유형:").append(record.getTreatType().trim()).append("] ");
        }
        if (record.getWeight() != null && !record.getWeight().isBlank()) {
            sb.append("[체중:").append(record.getWeight().trim()).append("kg] ");
        }
        if (record.getTemperature() != null && !record.getTemperature().isBlank()) {
            sb.append("[체온:").append(record.getTemperature().trim()).append("℃] ");
        }
        if (record.getHeartRate() != null && !record.getHeartRate().isBlank()) {
            sb.append("[심박:").append(record.getHeartRate().trim()).append("bpm] ");
        }
        if (record.getBreathRate() != null && !record.getBreathRate().isBlank()) {
            sb.append("[호흡:").append(record.getBreathRate().trim()).append("회/분] ");
        }
        if (record.getExamItems() != null && !record.getExamItems().isBlank()) {
            sb.append("[검사:").append(record.getExamItems().trim()).append("] ");
        }
        if (record.getNextVisit() != null && !record.getNextVisit().isBlank()) {
            sb.append("[다음방문:").append(record.getNextVisit().trim()).append("] ");
        }
        if (record.getMemo() != null && !record.getMemo().isBlank()) {
            sb.append(record.getMemo().trim());
        }
        String memo = sb.toString().trim();
        return memo.isEmpty() ? null : memo;
    }

    // 2026/07/13 장우철 — 진료기록 목록
    @Override
    @Transactional(readOnly = true)
    public List<MedicalRecordVO> getMedicalRecords(Long hospitalId, String keyword, Integer periodMonths)
            throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        String kw = (keyword == null || keyword.isBlank()) ? null : keyword.trim();
        return bizHospitalMapper.selectMedicalRecords(hospitalId, kw, periodMonths);
    }

    @Override
    @Transactional(readOnly = true)
    public MedicalRecordVO getMedicalRecordDetail(Long hospitalId, Long recordId) throws Exception {
        if (hospitalId == null || recordId == null) {
            return null;
        }
        return bizHospitalMapper.selectMedicalRecordDetail(hospitalId, recordId);
    }

    // 2026/07/13 장우철 — 진료기록 작성 모달용
    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getConfirmedWithoutRecord(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return bizHospitalMapper.selectConfirmedWithoutRecord(hospitalId);
    }

    // 2026/07/14 장우철 — 사업자 리뷰관리 목록
    @Override
    @Transactional(readOnly = true)
    public List<HospitalReviewVO> getBizHospitalReviews(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return bizHospitalMapper.selectBizHospitalReviews(hospitalId);
    }

    // 2026/07/14 장우철 — 답글 작성/수정 + 회원 알림
    @Override
    @Transactional
    public void saveReviewBizReply(Long hospitalId, Long reviewId, String bizReply) throws Exception {
        if (hospitalId == null || reviewId == null) {
            throw new IllegalArgumentException("리뷰 정보가 올바르지 않습니다.");
        }
        if (bizReply == null || bizReply.isBlank()) {
            throw new IllegalArgumentException("답글 내용을 입력해 주세요.");
        }
        String reply = bizReply.trim();
        if (reply.length() > 2000) {
            reply = reply.substring(0, 2000);
        }

        HospitalReviewVO current = bizHospitalMapper.selectBizHospitalReview(hospitalId, reviewId);
        if (current == null) {
            throw new IllegalStateException("리뷰를 찾을 수 없거나 권한이 없습니다.");
        }

        int updated = bizHospitalMapper.updateReviewBizReply(hospitalId, reviewId, reply);
        if (updated == 0) {
            throw new IllegalStateException("답글 저장에 실패했습니다.");
        }

        String hospitalName = bizHospitalMapper.selectHospitalNameById(hospitalId);
        mypageNotifyService.sendHospitalReviewReplyNotification(
                current.getMemberNo(), hospitalName, current.getResvId(), hospitalId);
    }
}
