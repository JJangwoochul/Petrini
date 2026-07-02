/**
 * 역할: 커뮤니티 게시글 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - community/list.jsp        게시글 목록
 * - community/detail.jsp      게시글 상세
 * - community/write.jsp       게시글 작성
 *
 * 구현할 기능 예시
 * - 게시글 목록 조회 (카테고리·검색)
 * - 게시글 상세 조회
 * - 게시글 등록·수정·삭제
 *
 * 연결
 * - 구현: CommunityPostServiceImpl
 * - 호출: CommunityPostController
 * - DB: CommunityPostMapper
 *
 * 참고 테이블
 * - TB_COMMUNITY_POST
 */

package com.petcare.petcare.community.post.service;

public interface CommunityPostService {}
