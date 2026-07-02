/**
 * 역할: 이벤트 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/event/event/EventEventMapper.xml
 * namespace: com.petcare.petcare.event.event.mapper.EventEventMapper
 *
 * 쿼리 예시
 * - selectEventList
 * - selectEventDetail
 *
 * 참고 테이블
 * - TB_EVENT
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.event.event.mapper;

public interface EventEventMapper {}
