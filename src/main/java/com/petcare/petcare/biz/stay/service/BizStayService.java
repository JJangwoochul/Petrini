/**
 * 역할: 사업자 펫호텔(숙박) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - biz/stay/dashboard.jsp    대시보드
 * - biz/stay/reserve.jsp      예약 관리
 * - biz/stay/rooms.jsp        객실 관리
 * - biz/stay/calendar.jsp     예약 캘린더
 * - biz/stay/reviews.jsp      리뷰 관리
 * - biz/stay/settlement.jsp   정산
 * - biz/stay/info.jsp         매장 정보
 *
 * 구현할 기능 예시
 * - 예약 목록·상태 변경
 * - 객실 등록·수정
 * - 캘린더 예약 현황 조회
 * - 리뷰·정산 조회
 *
 * 연결
 * - 구현: BizStayServiceImpl
 * - 호출: BizStayController
 * - DB: BizStayMapper
 *
 * 참고 테이블
 * - TB_STAY_ROOM
 * - TB_RESERVATION
 * - TB_REVIEW
 */

package com.petcare.petcare.biz.stay.service;

import java.util.List;

import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.stay.vo.StayRoomVO;
import com.petcare.petcare.stay.vo.StayVO;

public interface BizStayService {
    StayVO getStayByBizId(String bizId);

    // 2026-07-10 장우철 — 승인됐는데 TB_HOSPITAL 없으면 껍데기 생성 후 반환
    StayVO resolveStayByBizId(String bizId);

    void updateStayInfo(StayVO vo);

    void updateStayProfile(StayVO vo);

    // ── 객실 관리 ──
    List<StayRoomVO> getRoomList(Long stayId);

    void insertRoom(StayRoomVO vo);

    void updateRoom(StayRoomVO vo);

    void deleteRoom(Long roomId, Long stayId);

    // ── 2026-07-14 예약 관리 ──
    List<ReservationVO> getReservationList(Long stayId, String tab) throws Exception;

    ReservationVO getReservationDetail(Long stayId, Long resvId) throws Exception;

    void updateReservationStatus(Long stayId, Long resvId, String statusCd, String cancelReason) throws Exception;

    List<ReservationVO> getCalendarReservations(Long stayId, String fromDate, String toDate) throws Exception;

    int countPendingReservations(Long stayId) throws Exception;

    int countTodayConfirmedReservations(Long stayId) throws Exception;
}
