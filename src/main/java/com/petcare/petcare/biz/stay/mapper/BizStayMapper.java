/**
 * 역할: 사업자 펫호텔 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/biz/stay/BizStayMapper.xml
 * namespace: com.petcare.petcare.biz.stay.mapper.BizStayMapper
 *
 * 쿼리 예시
 * - selectReservationList
 * - updateReservationStatus
 * - selectRoomList
 * - insertRoom
 * - updateRoom
 *
 * 참고 테이블
 * - TB_STAY_ROOM
 * - TB_RESERVATION
 * - TB_REVIEW
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.biz.stay.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface BizStayMapper {}
