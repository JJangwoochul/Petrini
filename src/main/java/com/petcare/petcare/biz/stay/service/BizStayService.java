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

public interface BizStayService {}
