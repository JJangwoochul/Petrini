/**
 * 역할: 펫호텔(사용자) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - stay/list.jsp             숙소 목록
 * - stay/detail.jsp           숙소 상세
 * - stay/reserve.jsp          예약
 * - stay/complete.jsp         예약 완료
 *
 * 구현할 기능 예시
 * - 펫호텔 목록 조회
 * - 호텔 상세·예약 등록
 *
 * 연결
 * - 구현: StayStayServiceImpl
 * - 호출: StayStayController
 * - DB: StayStayMapper
 *
 * 참고 테이블
 * - TB_STAY
 * - TB_RESERVATION
 */

package com.petcare.petcare.stay.service;

import java.util.List;

import com.petcare.petcare.stay.vo.StayVO;

public interface StayService {
    public List<StayVO> getLodgeList();
    public StayVO getLodgeDetail(Long lodgeId);
}
