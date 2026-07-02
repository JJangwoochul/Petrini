/**
 * 역할: 회원 인증(로그인·회원가입) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - member/login.jsp          로그인
 * - member/join.jsp           회원가입
 *
 * 구현할 기능 예시
 * - 로그인·로그아웃 처리
 * - 회원가입·중복 검사
 * - 세션 관리
 *
 * 연결
 * - 구현: MemberAuthServiceImpl
 * - 호출: MemberAuthController
 * - DB: MemberAuthMapper
 *
 * 참고 테이블
 * - TB_MEMBER
 */

package com.petcare.petcare.member.auth.service;

public interface MemberAuthService {}
