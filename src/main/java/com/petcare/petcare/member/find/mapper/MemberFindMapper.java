/**
 * 역할: 회원 찾기 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/member/find/MemberFindMapper.xml
 * namespace: com.petcare.petcare.member.find.mapper.MemberFindMapper
 *
 * 쿼리 예시
 * - selectMemberByEmail
 * - updatePassword
 *
 * 참고 테이블
 * - TB_MEMBER
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.member.find.mapper;

public interface MemberFindMapper {}
