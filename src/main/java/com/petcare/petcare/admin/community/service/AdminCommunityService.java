/**
 * 역할: 관리자 커뮤니티 게시글 관리 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - admin/community/list.jsp  게시글 목록
 * - admin/community/detail.jsp 게시글 상세
 *
 * 구현할 기능 예시
 * - 커뮤니티 게시글 목록 조회 (검색·필터)
 * - 게시글 상세 조회
 * - 게시글 숨김·삭제 처리
 * - 신고 게시글 관리
 *
 * 연결
 * - 구현: AdminCommunityServiceImpl
 * - 호출: AdminCommunityController
 * - DB: AdminCommunityMapper
 *
 * 참고 테이블
 * - TB_COMMUNITY_POST
 * - TB_POST_REPORT
 */

package com.petcare.petcare.admin.community.service;

public interface AdminCommunityService {}
