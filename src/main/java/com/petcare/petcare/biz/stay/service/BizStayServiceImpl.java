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
import com.petcare.petcare.hospital.vo.ReviewDeleteRequestVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.stay.vo.ReservationVO;
import com.petcare.petcare.stay.vo.StayReviewVO;
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
    // 2026-07-28 박유정 — 사이드바 예약관리 배지 (PENDING + CONFIRMED)
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

    // 2026-07-27 박유정  — 사업자 숙소 리뷰 목록
    @Override
    @Transactional(readOnly = true)
    public List<StayReviewVO> getBizStayReviews(Long stayId) throws Exception {
        if (stayId == null) {
            return List.of();
        }
        return bizStayMapper.selectBizStayReviews(stayId);
    }

    // 2026-07-27 박유정  — 숙소 답글 저장 
    @Override
    @Transactional
    public void saveReviewBizReply(Long stayId, Long reviewId, String bizReply) throws Exception {
        if (stayId == null || reviewId == null) {
            throw new IllegalArgumentException("리뷰 정보가 올바르지 않습니다.");
        }
        if (bizReply == null || bizReply.isBlank()) {
            throw new IllegalArgumentException("답글 내용을 입력해 주세요.");
        }
        String reply = bizReply.trim();
        if (reply.length() > 2000) {
            reply = reply.substring(0, 2000);
        }

        StayReviewVO current = bizStayMapper.selectBizStayReview(stayId, reviewId);
        if (current == null) {
            throw new IllegalStateException("리뷰를 찾을 수 없거나 권한이 없습니다.");
        }

        int updated = bizStayMapper.updateReviewBizReply(stayId, reviewId, reply);
        if (updated == 0) {
            throw new IllegalStateException("답글 저장에 실패했습니다.");
        }

        String stayName = bizStayMapper.selectStayNameById(stayId);
        mypageNotifyService.sendStayReviewReplyNotification(
        current.getMemberNo(), stayName, current.getResvId(), stayId);
    }

    // 2026-07-27 박유정  — 리뷰 삭제 요청
    @Override
    @Transactional
    public void requestReviewDelete(Long stayId, Long bizNo, Long reviewId, String requestReason) throws Exception {
        if (stayId == null || bizNo == null || reviewId == null) {
            throw new IllegalArgumentException("요청 정보가 올바르지 않습니다.");
        }
        if (requestReason == null || requestReason.isBlank()) {
            throw new IllegalArgumentException("삭제 요청 사유를 입력해 주세요.");
        }
        String reason = requestReason.trim();
        if (reason.length() > 500) {
            reason = reason.substring(0, 500);
        }

        StayReviewVO current = bizStayMapper.selectBizStayReview(stayId, reviewId);
        if (current == null) {
            throw new IllegalStateException("리뷰를 찾을 수 없거나 권한이 없습니다.");
        }

        if (bizStayMapper.countPendingReviewDeleteRequest(reviewId, bizNo) > 0) {
            throw new IllegalStateException("이미 삭제 요청이 접수된 리뷰입니다.");
        }

        ReviewDeleteRequestVO vo = new ReviewDeleteRequestVO();
        vo.setReviewId(reviewId);
        vo.setReviewType("STAY");
        vo.setTargetId(stayId);
        vo.setBizNo(bizNo);
        vo.setRequestReason(reason);
        vo.setStatusCd("PENDING");
        int inserted = bizStayMapper.insertReviewDeleteRequest(vo);
        if (inserted == 0) {
            throw new IllegalStateException("삭제 요청 접수에 실패했습니다.");
        }
    }

    // 2026-07-27 박유정 — 삭제요청 탭 목록
    @Override
    @Transactional(readOnly = true)
    public List<ReviewDeleteRequestVO> getBizReviewDeleteRequests(Long stayId, Long bizNo) throws Exception {
        if (stayId == null || bizNo == null) {
            return List.of();
        }
        return bizStayMapper.selectBizReviewDeleteRequests(stayId, bizNo);
    }
}
