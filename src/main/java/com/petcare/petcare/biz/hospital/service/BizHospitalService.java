/**
 * 역할: 사업자 동물병원 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - biz/hospital/dashboard.jsp 대시보드
 * - biz/hospital/reserve.jsp  예약 관리
 * - biz/hospital/treatments.jsp 진료 항목
 * - biz/hospital/patients.jsp 환자 관리
 * - biz/hospital/records.jsp  진료 기록
 * - biz/hospital/talent.jsp   재능나눔
 * - biz/hospital/reviews.jsp  리뷰 관리
 * - biz/hospital/contract.jsp 계약 관리
 * - biz/hospital/info.jsp     병원 정보
 *
 * 구현할 기능 예시
 * - 예약 목록·상태 변경
 * - 진료 항목·환자·기록 관리
 * - 리뷰·정산·계약 조회
 *
 * 연결
 * - 구현: BizHospitalServiceImpl
 * - 호출: BizHospitalController
 * - DB: BizHospitalMapper
 *
 * 참고 테이블
 * - TB_RESERVATION
 * - TB_TREATMENT
 * - TB_MEDICAL_RECORD
 * - TB_REVIEW
 */

package com.petcare.petcare.biz.hospital.service;

import java.util.List;

import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;

public interface BizHospitalService {

    HospitalVO getHospitalByBizId(String bizId);

    // 2026-07-10 장우철 — 승인됐는데 TB_HOSPITAL 없으면 껍데기 생성 후 반환
    HospitalVO resolveHospitalByBizId(String bizId);

    void updateHospitalInfo(HospitalVO vo);

    // 2026-07-10 장우철 — 병원 예약 1차 (F4~F7) 사업자 Service
    List<ReservationVO> getReservationList(Long hospitalId, String tab) throws Exception;

    ReservationVO getReservationDetail(Long hospitalId, Long resvId) throws Exception;

    void updateReservationStatus(Long hospitalId, Long resvId, String statusCd) throws Exception;

    List<ReservationVO> getCalendarReservations(Long hospitalId, String fromDate, String toDate) throws Exception;
}
