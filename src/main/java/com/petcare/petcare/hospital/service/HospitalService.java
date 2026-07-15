/**
 * 역할: 동물병원(사용자) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - hospital/list.jsp         병원 목록
 * - hospital/detail.jsp       병원 상세
 * - hospital/reserve.jsp      예약
 * - hospital/complete.jsp     예약 완료
 *
 * 구현할 기능 예시
 * - 병원 목록 조회 (지역·검색)
 * - 병원 상세 조회
 * - 예약 등록
 *
 * 연결
 * - 구현: HospitalServiceImpl
 * - 호출: HospitalController
 * - DB: HospitalMapper
 *
 * 참고 테이블
 * - TB_HOSPITAL
 * - TB_RESERVATION
 */

package com.petcare.petcare.hospital.service;

import java.util.List;

import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;

public interface HospitalService {
    List<HospitalVO> getHospitalList() throws Exception;
    List<HospitalVO> getHospitalListBySearch(HospitalVO searchVO) throws Exception;
    HospitalVO getHospitalById(Long hospitalId) throws Exception;

    // 2026-07-10 장우철 — 병원 예약 1차 (F2~F3)
    List<HospitalPetVO> getPetListForReserve(Long memberNo) throws Exception;
    Long createHospitalReservation(ReservationVO vo) throws Exception;
    ReservationVO getReservationById(Long resvId) throws Exception;
}
