/**
 * 역할: BizStayService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: BizStayService
 * - 사용: BizStayMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.biz.stay.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.biz.stay.mapper.BizStayMapper;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.stay.vo.ReservationVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.stay.vo.StayRoomVO;
import com.petcare.petcare.stay.vo.StayVO;

@Service
public class BizStayServiceImpl implements BizStayService {
    @Autowired
    private BizStayMapper bizStayMapper;
    @Autowired
    private KakaoMapService kakaoMapService;
    @Autowired
    private MypageNotifyService mypageNotifyService;
    
    @Override
    public StayVO getStayByBizId(String bizId) {
        return bizStayMapper.selectStayByBizId(bizId);
    }
    @Override
    public StayVO resolveStayByBizId(String bizId) {
        if (bizId == null || bizId.isBlank()) {
            return null;
        }
        StayVO stay = bizStayMapper.selectStayByBizId(bizId);
        if (stay == null) {
            bizStayMapper.insertStay(bizId);
            stay = bizStayMapper.selectStayByBizId(bizId);
        }
        return stay;
    }
    @Override
    public void updateStayInfo(StayVO vo) {
        // 2026-07-10 장우철 — 주소 있으면 좌표 변환 (유저 목록 '상세보기'는 LAT 필수)
        if (vo.getAddr() != null && !vo.getAddr().isBlank()) {
            Map<String, Double> coords = kakaoMapService.geocodeAddress(vo.getAddr());
            if (coords != null) {
                vo.setLat(coords.get("lat"));
                vo.setLng(coords.get("lng"));
            }
        }

        bizStayMapper.updateStayInfo(vo);
    }

    @Override
    public void updateStayProfile(StayVO vo) {
        if (vo.getAddr() != null && !vo.getAddr().isBlank()) {
            Map<String, Double> coords = kakaoMapService.geocodeAddress(vo.getAddr());
            if (coords != null) {
                vo.setLat(coords.get("lat"));
                vo.setLng(coords.get("lng"));
            }
        }
        
        bizStayMapper.updateStayProfile(vo);
    }

    // ── 객실 관리 ──
    @Override
    public List<StayRoomVO> getRoomList(Long stayId) {
        return bizStayMapper.selectRoomList(stayId);
    }

    @Override
    public void insertRoom(StayRoomVO vo) {
        bizStayMapper.insertRoom(vo);
    }

    @Override
    public void updateRoom(StayRoomVO vo) {
        bizStayMapper.updateRoom(vo);
    }

    @Override
    public void deleteRoom(Long roomId, Long stayId) {
        bizStayMapper.deleteRoom(roomId, stayId);
    }

    // ── 2026-07-14 예약 관리 ──

    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getReservationList(Long stayId, String tab) throws Exception {
        if (stayId == null) {
            return List.of();
        }
        String safeTab = (tab == null || "all".equals(tab)) ? null : tab;
        return bizStayMapper.selectReservationList(stayId, safeTab);
    }

    @Override
    @Transactional(readOnly = true)
    public ReservationVO getReservationDetail(Long stayId, Long resvId) throws Exception {
        return bizStayMapper.selectReservationDetail(resvId, stayId);
    }

    @Override
    @Transactional
    public void updateReservationStatus(Long stayId, Long resvId, String statusCd, String cancelReason)
            throws Exception {
        if (stayId == null || resvId == null || statusCd == null || statusCd.isBlank()) {
            throw new IllegalArgumentException("예약 상태 변경 정보가 올바르지 않습니다.");
        }

        String next = statusCd.trim().toUpperCase();
        if (!next.equals("PENDING") && !next.equals("CONFIRMED")
                && !next.equals("DONE") && !next.equals("CANCEL")) {
            throw new IllegalArgumentException("허용되지 않은 예약 상태입니다.");
        }

        ReservationVO current = bizStayMapper.selectReservationDetail(resvId, stayId);
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

        int updated = bizStayMapper.updateReservationStatus(resvId, stayId, next, rejectReason);
        if (updated == 0) {
            throw new IllegalStateException("예약을 찾을 수 없거나 변경할 수 없습니다.");
        }

        // 알림 발송
        String stayName = bizStayMapper.selectStayNameById(stayId);
        if (stayName == null || stayName.isBlank()) {
            stayName = "숙소";
        }
        if ("CONFIRMED".equals(next)) {
            mypageNotifyService.sendReserveConfirmNotification(
                    current.getMemberNo(), stayName, current.getCheckinDate(), null, resvId);
        } else if ("CANCEL".equals(next)) {
            mypageNotifyService.sendReserveCancelNotification(
                    current.getMemberNo(), stayName, current.getCheckinDate(), null,
                    rejectReason, resvId);
        }
    }

    /** PENDING→CONFIRMED/CANCEL, CONFIRMED→DONE/CANCEL 만 허용 */
    private boolean isAllowedStatusTransition(String prev, String next) {
        if ("PENDING".equals(prev)) {
            return "CONFIRMED".equals(next) || "CANCEL".equals(next);
        }
        if ("CONFIRMED".equals(prev)) {
            return "DONE".equals(next) || "CANCEL".equals(next);
        }
        return false;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getCalendarReservations(Long stayId, String fromDate, String toDate) throws Exception {
        if (stayId == null) {
            return List.of();
        }
        return bizStayMapper.selectReservationCalendarList(stayId, fromDate, toDate);
    }

    @Override
    @Transactional(readOnly = true)
    public int countPendingReservations(Long stayId) throws Exception {
        if (stayId == null) {
            return 0;
        }
        return bizStayMapper.countPendingReservations(stayId);
    }

    @Override
    @Transactional(readOnly = true)
    public int countTodayConfirmedReservations(Long stayId) throws Exception {
        if (stayId == null) {
            return 0;
        }
        return bizStayMapper.countTodayConfirmedReservations(stayId);
    }
}
