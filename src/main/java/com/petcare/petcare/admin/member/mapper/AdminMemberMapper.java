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

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.petcare.petcare.admin.member.vo.AdminMemberVO;

@Mapper
public interface AdminMemberMapper {

    // 2026-07-16 박유정 — 관리자 회원 목록 (검색·필터·페이징)
    List<AdminMemberVO> selectAdminMemberList(
            @Param("keyword") String keyword,
            @Param("statusCd") String statusCd,
            @Param("roleType") String roleType,
            @Param("offset") int offset,
            @Param("limit") int limit);

    // 2026-07-16 박유정 — 목록 총 건수
    int selectAdminMemberCount(
            @Param("keyword") String keyword,
            @Param("statusCd") String statusCd,
            @Param("roleType") String roleType);

    // 2026-07-16 박유정 — 관리자 회원 상세
    AdminMemberVO selectAdminMemberDetail(@Param("memberNo") long memberNo);
}