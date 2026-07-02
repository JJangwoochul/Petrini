/**
 * 역할: 펫호텔 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/stay/StayStayMapper.xml
 * namespace: com.petcare.petcare.stay.mapper.StayStayMapper
 *
 * 쿼리 예시
 * - selectStayList
 * - selectStayDetail
 * - insertReservation
 *
 * 참고 테이블
 * - TB_STAY
 * - TB_RESERVATION
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.stay.mapper;

public interface StayStayMapper {}
