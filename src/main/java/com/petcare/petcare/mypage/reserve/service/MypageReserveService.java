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
import com.petcare.petcare.mypage.reserve.vo.StayReviewRegisterResult;

public interface MypageReserveService {

    // 2026/07/21 장우철 — typeFilter(전체/병원/숙소) 추가
    List<MypageReserveVO> getMyReservationList(Long memberNo, String statusFilter, String typeFilter);

    MypageReserveVO getMyReservationDetail(Long memberNo, Long resvId);

    // 2026/07/13 장우철 — DONE 예약에 한해 병원 리뷰·별점 등록
    void addHospitalReview(Long memberNo, Long resvId, Double rating, String content);
    
    // 2026/07/31 장우철 — 유저 숙소 취소 (1-4) + 위약금 계산 저장 (1-6)
    // CONFIRMED + 체크인 전만 가능
    void cancelStayReservation(Long memberNo, Long resvId, String cancelReason);

    // HYJ 26.07.20 — DONE 예약에 한해 숙소 리뷰·별점·포인트 등록
    // 2026-07-28 박유정 — 평점 갱신·사업자 알림·포인트 적립 결과 반환
    StayReviewRegisterResult addStayReview(Long memberNo, Long resvId, Double rating, String content,
                                           Long currentPointBalance);
}
