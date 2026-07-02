/**
 * 역할: 마이페이지 홈 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - mypage/dashboard.jsp      대시보드
 * - mypage/pets.jsp           반려동물
 * - mypage/health.jsp         건강 관리
 *
 * 구현할 기능 예시
 * - 마이페이지 요약 조회
 * - 반려동물 목록 조회
 * - 건강 기록 요약 조회
 *
 * 연결
 * - 구현: MypageHomeServiceImpl
 * - 호출: MypageHomeController
 * - DB: MypageHomeMapper
 *
 * 참고 테이블
 * - TB_MEMBER
 * - TB_PET
 * - TB_PET_HEALTH
 */

package com.petcare.petcare.mypage.home.service;

public interface MypageHomeService {}
