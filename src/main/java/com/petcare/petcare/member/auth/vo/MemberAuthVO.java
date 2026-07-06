/**
 * 역할: 로그인 시 TB_MEMBER 조회 결과를 담는 VO
 *
 * 사용 위치
 * - MemberAuthMapper → MemberAuthServiceImpl
 *
 * 참고 테이블: TB_MEMBER
 *
 * ※ 세션(memberInfo)에는 MemberVO를 사용하고, 이 VO는 DB 조회·비밀번호 검증 단계에서만 사용
 */

package com.petcare.petcare.member.auth.vo;

import lombok.Getter;
import lombok.Setter;
/* 2026/07/06 장우철 */
@Getter
@Setter
public class MemberAuthVO {

    private Long memberNo;        // 회원번호 (PK) — TB_MEMBER.MEMBER_NO
    private String memberId;      // 로그인 ID (이메일) — TB_MEMBER.MEMBER_ID
    private String memberPwd;     // 비밀번호 BCrypt 해시 — TB_MEMBER.MEMBER_PWD (세션에 넣지 않음)
    private String memberName;    // 회원 실명 — TB_MEMBER.MEMBER_NAME
    private String nickname;      // 닉네임 — TB_MEMBER.NICKNAME
    private String email;         // 이메일 — TB_MEMBER.EMAIL
    private String statusCd;      // 회원 상태 — TB_MEMBER.STATUS_CD (NORMAL만 로그인 허용)
    private String gradeCd;       // 회원 등급 코드 — TB_MEMBER.GRADE_CD (BRONZE/SILVER/GOLD)
}
