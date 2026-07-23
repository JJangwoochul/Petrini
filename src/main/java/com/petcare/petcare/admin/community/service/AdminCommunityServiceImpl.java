/**
 * 역할: AdminCommunityService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: AdminCommunityService
 * - 사용: AdminCommunityMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.admin.community.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.petcare.petcare.admin.community.mapper.AdminCommunityMapper;
import com.petcare.petcare.community.post.vo.CommunityPostVO;

import com.petcare.petcare.community.comment.mapper.CommunityCommentMapper;
import com.petcare.petcare.community.post.mapper.CommunityPostMapper;
import com.petcare.petcare.community.post.service.CommunityPostService;

@Service
public class AdminCommunityServiceImpl implements AdminCommunityService {

    private final AdminCommunityMapper adminCommunityMapper;
    private final CommunityPostMapper communityPostMapper;
    private final CommunityCommentMapper communityCommentMapper;
    private final CommunityPostService communityPostService;

    private static final int PAGE_SIZE = 10;

    public AdminCommunityServiceImpl(AdminCommunityMapper adminCommunityMapper,
                                     CommunityPostMapper communityPostMapper,
                                     CommunityCommentMapper communityCommentMapper,
                                     CommunityPostService communityPostService) {

        this.adminCommunityMapper = adminCommunityMapper;
        this.communityPostMapper = communityPostMapper;
        this.communityCommentMapper = communityCommentMapper;
        this.communityPostService = communityPostService;
    }

    // 2026-07-15 박유정 — 관리자 게시글 목록 (검색·필터·페이징)
    @Override
    public List<CommunityPostVO> getAdminPostList(String keyword, String boardType, String statusCd, int page) {
        int safePage = page < 1 ? 1 : page;
        int offset = (safePage - 1) * PAGE_SIZE;
        return adminCommunityMapper.selectAdminPostList(keyword, boardType, statusCd, offset, PAGE_SIZE);
    }

    // 2026-07-15 박유정 — 목록 총 건수
    @Override
    public int getAdminPostCount(String keyword, String boardType, String statusCd) {
        return adminCommunityMapper.selectAdminPostCount(keyword, boardType, statusCd);
    }

    // 2026-07-15 박유정 — 관리자 상세 (댓글 수·첨부 이미지 포함)
    @Override
    public CommunityPostVO getAdminPostDetail(long postId) {
        CommunityPostVO post = adminCommunityMapper.selectAdminPostDetail(postId);
        if (post == null) {
            return null;
        }
        post.setCommentCount(communityCommentMapper.selectCommentCountByPostId(postId));
        post.setPhotoUrls(communityPostMapper.selectFileUrlsByPostId(postId));
        return post;
    }

    // 2026-07-15 박유정 STEP 7 — 숨김 (STATUS_CD = HIDDEN)
    @Override
    public void hidePost(long postId) {
        int updated = adminCommunityMapper.updatePostStatus(postId, "HIDDEN");
        if (updated == 0) {
            throw new IllegalArgumentException("POST_NOT_FOUND");
        }
    }

    // 2026-07-15 박유정 STEP 7 — 삭제 (STATUS_CD = DELETED)
    // 2026/07/22 장우철 — 삭제 시 첨부 사진 로컬/GCS + TB_FILE 도 정리 (복구 시 이미지는 복원되지 않음)
    @Override
    public void deletePost(long postId) {
        int updated = adminCommunityMapper.updatePostStatus(postId, "DELETED");
        if (updated == 0) {
            throw new IllegalArgumentException("POST_NOT_FOUND");
        }
        communityPostService.deletePhotosByPostId(postId);
    }

    // 2026-07-15 박유정 — 복구 (STATUS_CD = ACTIVE)
    @Override
    public void restorePost(long postId) {
        int updated = adminCommunityMapper.updatePostStatus(postId, "ACTIVE");
        if (updated == 0) {
            throw new IllegalArgumentException("POST_NOT_FOUND");
        }
    }
}