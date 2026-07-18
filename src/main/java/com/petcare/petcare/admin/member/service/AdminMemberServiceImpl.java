/**
 * 역할: AdminMemberService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: AdminMemberService
 * - 사용: AdminMemberMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.admin.member.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.petcare.petcare.admin.member.mapper.AdminMemberMapper;
import com.petcare.petcare.admin.member.vo.AdminMemberVO;

@Service
public class AdminMemberServiceImpl implements AdminMemberService {

    private final AdminMemberMapper adminMemberMapper;

    private static final int PAGE_SIZE = 20; // List.jsp "페이지당 20건"

    public AdminMemberServiceImpl(AdminMemberMapper adminMemberMapper) {
        this.adminMemberMapper = adminMemberMapper;
    }

    // 2026-07-16 박유정 — 관리자 회원 목록 (검색·필터·페이징)
    @Override
    public List<AdminMemberVO> getAdminMemberList(String keyword, String statusCd, String roleType, int page) {
        int safePage = page < 1 ? 1 : page;
        int offset = (safePage - 1) * PAGE_SIZE;
        return adminMemberMapper.selectAdminMemberList(keyword, statusCd, roleType, offset, PAGE_SIZE);
    }
    // 2026-07-16 박유정 — 목록 총 건수
    @Override
    public int getAdminMemberCount(String keyword, String statusCd, String roleType) {
        return adminMemberMapper.selectAdminMemberCount(keyword, statusCd, roleType);
    }
    // 2026-07-16 박유정 — 관리자 회원 상세 (기본정보)
    @Override
    public AdminMemberVO getAdminMemberDetail(long memberNo) {
        return adminMemberMapper.selectAdminMemberDetail(memberNo);
    }
}



