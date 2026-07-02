/**
 * 역할: 동물병원 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/hospital/HospitalHospitalMapper.xml
 * namespace: com.petcare.petcare.hospital.mapper.HospitalHospitalMapper
 *
 * 쿼리 예시
 * - selectHospitalList
 * - selectHospitalDetail
 * - insertReservation
 *
 * 참고 테이블
 * - TB_HOSPITAL
 * - TB_RESERVATION
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.hospital.mapper;

public interface HospitalHospitalMapper {}
