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
import com.petcare.petcare.hospital.vo.HospitalVO;
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
}
