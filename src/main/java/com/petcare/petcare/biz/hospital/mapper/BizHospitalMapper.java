/**
 * 역할: 사업자 동물병원 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/biz/hospital/BizHospitalMapper.xml
 * namespace: com.petcare.petcare.biz.hospital.mapper.BizHospitalMapper
 *
 * 쿼리 예시
 * - selectReservationList
 * - updateReservationStatus
 * - selectTreatmentList
 * - selectPatientList
 * - selectMedicalRecords
 *
 * 참고 테이블
 * - TB_RESERVATION
 * - TB_TREATMENT
 * - TB_MEDICAL_RECORD
 * - TB_REVIEW
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.biz.hospital.mapper;

public interface BizHospitalMapper {}
