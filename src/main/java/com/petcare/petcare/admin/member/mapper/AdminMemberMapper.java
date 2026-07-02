/**
 * 역할: 관리자 회원 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/admin/member/AdminMemberMapper.xml
 * namespace: com.petcare.petcare.admin.member.mapper.AdminMemberMapper
 *
 * 쿼리 예시
 * - selectMemberList
 * - selectMemberDetail
 * - updateMemberStatus
 *
 * 참고 테이블
 * - TB_MEMBER
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.admin.member.mapper;

public interface AdminMemberMapper {}
