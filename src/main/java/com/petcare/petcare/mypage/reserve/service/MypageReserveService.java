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

    // 2026/07/13 장우철 — DONE 예약에 한해 병원 리뷰·별점 등록
    void addHospitalReview(Long memberNo, Long resvId, Double rating, String content);
    
    // HYJ 26.07.20 — DONE 예약에 한해 숙소 리뷰·별점 등록
    void addStayReview(Long memberNo, Long resvId, Double rating, String content);
}
