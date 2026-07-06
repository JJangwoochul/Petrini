/**
 * 역할: 회원 인증 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/member/auth/MemberAuthMapper.xml
 * namespace: com.petcare.petcare.member.auth.mapper.MemberAuthMapper
 *
 * 참고 테이블: TB_MEMBER
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 */

package com.petcare.petcare.member.auth.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.member.auth.vo.MemberAuthVO;

@Mapper
public interface MemberAuthMapper {

    // 로그인 ID(이메일)로 TB_MEMBER 1건 조회 — 없으면 null
    MemberAuthVO selectMemberByLoginId(
            @Param("loginId") String loginId);  // login.jsp에서 넘어온 로그인 아이디

    // 로그인 성공 시 최종 로그인 일시(LAST_LOGIN_DATE) 갱신
    int updateLastLoginDate(
            @Param("memberNo") Long memberNo);  // 회원번호 PK
}
