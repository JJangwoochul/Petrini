/**
 * 역할: 관리자 회원 관리 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - admin/member/list.jsp     회원 목록
 * - admin/member/detail.jsp   회원 상세
 *
 * 구현할 기능 예시
 * - 회원 목록 조회 (검색·필터)
 * - 회원 상세 조회
 * - 회원 상태 변경 (정지·탈퇴)
 *
 * 연결
 * - 구현: AdminMemberServiceImpl
 * - 호출: AdminMemberController
 * - DB: AdminMemberMapper
 *
 * 참고 테이블
 * - TB_MEMBER
 */

package com.petcare.petcare.admin.member.service;

import java.util.List;
import com.petcare.petcare.admin.member.vo.AdminMemberVO;

public interface AdminMemberService {
    
    // 2026-07-16 박유정 — 관리자 회원 목록 (검색·필터·페이징)
    List<AdminMemberVO> getAdminMemberList(String keyword, String statusCd, String roleType, int page);
    // 2026-07-16 박유정 — 목록 총 건수
    int getAdminMemberCount(String keyword, String statusCd, String roleType);
    // 2026-07-16 박유정 — 관리자 회원 상세 (기본정보)
    AdminMemberVO getAdminMemberDetail(long memberNo);
    
}
