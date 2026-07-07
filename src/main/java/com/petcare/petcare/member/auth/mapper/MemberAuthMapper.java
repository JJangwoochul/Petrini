/**
 * 역할: 회원 인증 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/member/auth/MemberAuthMapper.xml
 * namespace: com.petcare.petcare.member.auth.mapper.MemberAuthMapper
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 */

package com.petcare.petcare.member.auth.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.member.auth.vo.MemberAuthVO;
import com.petcare.petcare.member.auth.vo.MemberRegisterVO;

@Mapper
public interface MemberAuthMapper {

    // 2026/07/06 장우철 — login(로그인)

    /** 로그인 ID(이메일)로 TB_MEMBER 1건 조회 — 없으면 null */
    MemberAuthVO selectMemberByLoginId(
            @Param("loginId") String loginId);

    /** 로그인 성공 시 최종 로그인 일시(LAST_LOGIN_DATE) 갱신 */
    int updateLastLoginDate(
            @Param("memberNo") Long memberNo);

    // 2026/07/07 장우철 — join(회원가입)

    /* 이메일 중복 확인 */
    int countMemberByEmail(@Param("email") String email);

    /* 회원 1건 INSERT */
    int insertMember(MemberRegisterVO vo);

    /* 약관 동의 1건 INSERT */
    int insertMemberAgreement(
            @Param("memberNo") Long memberNo,
            @Param("termsType") String termsType,
            @Param("termsVer") String termsVer,
            @Param("agreeYn") String agreeYn);

    /* 반려동물 1건 INSERT */
    int insertPet(MemberRegisterVO vo);
}
