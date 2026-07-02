/**
 * 역할: 마이페이지 사업자 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/mypage/biz/MypageBizMapper.xml
 * namespace: com.petcare.petcare.mypage.biz.mapper.MypageBizMapper
 *
 * 쿼리 예시
 * - selectBusinessByMember
 * - insertBusinessApply
 *
 * 참고 테이블
 * - TB_BUSINESS
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.mypage.biz.mapper;

public interface MypageBizMapper {}
