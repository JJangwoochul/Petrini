/**
 * 역할: 마이페이지 예약 내역 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - mypage/reserve.jsp         예약 내역
 * - mypage/reserve-detail.jsp  예약 상세
 */

package com.petcare.petcare.mypage.reserve.service;

import java.util.List;

import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;

public interface MypageReserveService {

    List<MypageReserveVO> getMyReservationList(Long memberNo, String statusFilter);

    MypageReserveVO getMyReservationDetail(Long memberNo, Long resvId);
}
