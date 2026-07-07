/**
 * 역할: 회원 인증(로그인·회원가입) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - member/login.jsp          로그인
 * - member/join.jsp           회원가입
 *
 * 연결
 * - 구현: MemberAuthServiceImpl
 * - 호출: MemberAuthController
 * - DB: MemberAuthMapper
 */

package com.petcare.petcare.member.auth.service;

import com.petcare.petcare.member.auth.vo.EmailCheckResultVO;
import com.petcare.petcare.member.auth.vo.MemberRegisterVO;
import com.petcare.petcare.member.vo.MemberVO;

public interface MemberAuthService {

    // 2026/07/06 장우철 — login(로그인)

    /**
     * 이메일·아이디 로그인 처리
     * @return 성공 시 세션용 MemberVO, 실패 시 null
     */
    MemberVO login(String loginId, String rawPassword);

    // 2026/07/07 장우철 — join(회원가입)

    /**
     * 이메일 중복 확인 — join.jsp [중복 확인] Ajax (GET /join/check-email)
     * @return available=true 이면 가입 가능
     */
    EmailCheckResultVO checkEmail(String email);

    /**
     * 회원가입 처리 — join.jsp [가입 완료] POST /join
     * @return null 이면 성공, 문자열이면 오류 코드 (join.jsp 에서 메시지 분기)
     */
    String register(MemberRegisterVO vo);
}
