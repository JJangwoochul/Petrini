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

import java.util.Date;
import java.util.List;

import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.stay.vo.StayVO;

public interface StayService {
    public List<StayVO> getStayList();
    public List<StayVO> getStayListBySearch(StayVO searchVO);
    public StayVO getStayById(Long stayId);
    
    // 예약
    public List<HospitalPetVO> getPetList(Long memberNo);
    public Long createStayReservation(ReservationVO vo);
    public ReservationVO getReservationById(Long resvId);

    // HYJ 26.07.20 가용성 체크
    public boolean checkRoomAvailability(Long roomId, Date checkinDate, Date checkoutDate);

    // HYJ 26.07.20 결제 확정
    public void confirmPayment(Long resvId, String tossPaymentKey, String tossOrderId, String payMethod, String kakaoAccessToken);
}
