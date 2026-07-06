/**
 * 역할: 회원 인증(로그인·회원가입) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - member/login.jsp          로그인
 * - member/join.jsp           회원가입 (추후)
 *
 * 연결
 * - 구현: MemberAuthServiceImpl
 * - 호출: MemberAuthController
 * - DB: MemberAuthMapper
 *
 * 참고 테이블: TB_MEMBER
 */

package com.petcare.petcare.member.auth.service;

import com.petcare.petcare.member.vo.MemberVO;

public interface MemberAuthService {

    // 이메일·아이디 로그인 처리 — 성공 시 세션용 MemberVO, 실패 시 null
    MemberVO login(
            String loginId,      // 로그인 아이디 (TB_MEMBER.MEMBER_ID 또는 EMAIL과 매칭)
            String rawPassword   // 사용자가 입력한 평문 비밀번호
    );
}
