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

public interface BizHospitalService {}
