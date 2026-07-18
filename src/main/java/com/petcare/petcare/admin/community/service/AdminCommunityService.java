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
 * - 게시글 숨김·삭제·복구 처리 (소프트 삭제, STATUS_CD)
 * - 신고 게시글 관리
 *
 * 연결
 * - 구현: AdminCommunityServiceImpl
 * - 호출: AdminCommunityController
 * - DB: AdminCommunityMapper
 *
 * 참고 테이블
 * - TB_POST
 * - TB_POST_REPORT
 */

package com.petcare.petcare.admin.community.service;  

import java.util.List;
import com.petcare.petcare.community.post.vo.CommunityPostVO;

public interface AdminCommunityService {

    // 2026-07-15 박유정 — 관리자 게시글 목록 (검색·필터·페이징)
    List<CommunityPostVO> getAdminPostList(String keyword, String boardType, String statusCd, int page);

    // 2026-07-15 박유정 — 목록 총 건수
    int getAdminPostCount(String keyword, String boardType, String statusCd);

    // 2026-07-15 박유정 — 관리자 게시글 상세
    CommunityPostVO getAdminPostDetail(long postId);

    // 2026-07-15 박유정 STEP 7 — 숨김 (STATUS_CD = HIDDEN)
    void hidePost(long postId);

    // 2026-07-15 박유정 STEP 7 — 삭제 (STATUS_CD = DELETED, 소프트 삭제)
    void deletePost(long postId);

    // 2026-07-15 박유정 — 복구 (STATUS_CD = ACTIVE)
    void restorePost(long postId);
}