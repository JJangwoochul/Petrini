/**
 * 역할: 커뮤니티 반응(좋아요·신고) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - community/detail.jsp      좋아요·신고 (게시글 상세 내)
 *
 * 구현할 기능 예시
 * - 좋아요 토글
 * - 신고 등록
 * - 좋아요 수 조회
 *
 * 연결
 * - 구현: CommunityReactionServiceImpl
 * - 호출: CommunityReactionController
 * - DB: CommunityReactionMapper
 *
 * 참고 테이블
 * - TB_COMMUNITY_LIKE
 * - TB_COMMUNITY_REPORT
 */

package com.petcare.petcare.community.reaction.service;

public interface CommunityReactionService {}
