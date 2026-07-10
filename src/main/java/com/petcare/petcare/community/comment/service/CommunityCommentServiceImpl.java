/**
 * 역할: CommunityCommentService 구현체 (@Service)
 *
 * - 박유정 / 2026-07-09~10
 *
 * [getCommentList — 댓글 목록]
 * 1. TB_POST_COMMENT 전체 조회 (일반 + 대댓글)
 * 2. PARENT_ID 가 null → 최상위 댓글, 나머지는 replies 에 묶음
 *
 * [insertComment — 댓글·대댓글 등록]
 * 1. 로그인 확인 + 본문 검증
 * 2. parentId 있으면 → 같은 글의 일반댓글인지 검증
 * 3. TB_POST_COMMENT INSERT (PARENT_ID)
 *
 * [deleteComment — 댓글 삭제]
 * 1. 작성자 본인 확인 (memberNo)
 * 2. softDeleteComment → IS_DELETED='Y'
 */

package com.petcare.petcare.community.comment.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.petcare.petcare.community.comment.mapper.CommunityCommentMapper;
import com.petcare.petcare.community.comment.vo.CommunityCommentVO;
import com.petcare.petcare.member.vo.MemberVO;

@Service
public class CommunityCommentServiceImpl implements CommunityCommentService {

    private final CommunityCommentMapper communityCommentMapper;

    public CommunityCommentServiceImpl(CommunityCommentMapper communityCommentMapper) {
        this.communityCommentMapper = communityCommentMapper;
    }

    @Override
    public List<CommunityCommentVO> getCommentList(long postId) {
        List<CommunityCommentVO> parents = communityCommentMapper.selectCommentList(postId);
        List<CommunityCommentVO> replies = communityCommentMapper.selectRepliesByPostId(postId);

        Map<Long, CommunityCommentVO> parentMap = new LinkedHashMap<>();
        for (CommunityCommentVO comment : parents) {
            comment.setReplies(new ArrayList<>());
            if (comment.getCommentId() != null) {
                parentMap.put(comment.getCommentId(), comment);
            }
        }
        for (CommunityCommentVO reply : replies) {
            if (reply.getParentId() == null) {
                continue;
            }
            CommunityCommentVO parent = parentMap.get(reply.getParentId());
            if (parent != null) {
                parent.getReplies().add(reply);
            }
        }
        return parents;
    }

    @Override
    public int getCommentCount(long postId) {
        int count = 0;
        for (CommunityCommentVO parent : getCommentList(postId)) {
            count++;
            if (parent.getReplies() != null) {
                count += parent.getReplies().size();
            }
        }
        return count;
    }

    @Override
    public void insertComment(long postId, String body, MemberVO loginMember) {
        insertComment(postId, body, loginMember, null);
    }

    @Override
    public void insertComment(long postId, String body, MemberVO loginMember, Long parentId) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }
        if (body == null || body.isBlank()) {
            throw new IllegalArgumentException("EMPTY_BODY");
        }

        Long memberNo = lookupMemberNo(loginMember);
        if (memberNo == null) {
            throw new IllegalStateException("MEMBER_NOT_FOUND");
        }

        if (parentId != null) {
            validateParentComment(postId, parentId);
        }

        CommunityCommentVO vo = new CommunityCommentVO();
        vo.setPostId(postId);
        vo.setParentId(parentId);
        vo.setMemberNo(memberNo);
        vo.setBody(body.trim());

        communityCommentMapper.insertComment(vo);
    }

    private void validateParentComment(long postId, long parentId) {
        CommunityCommentVO parent = communityCommentMapper.selectCommentById(parentId);
        if (parent == null || !Long.valueOf(postId).equals(parent.getPostId())) {
            throw new IllegalArgumentException("INVALID_PARENT");
        }
        if (parent.getParentId() != null) {
            throw new IllegalArgumentException("INVALID_PARENT");
        }
    }

    private Long lookupMemberNo(MemberVO loginMember) {
        // memberId / email 로 DB 조회 우선 (testUser 등 세션만 있는 경우 대비)
        if (loginMember.getMemberId() != null && !loginMember.getMemberId().isBlank()) {
            Long no = communityCommentMapper.selectMemberNoByMemberId(loginMember.getMemberId().trim());
            if (no != null) {
                return no;
            }
        }
        if (loginMember.getEmail() != null && !loginMember.getEmail().isBlank()) {
            Long no = communityCommentMapper.selectMemberNoByEmail(loginMember.getEmail().trim());
            if (no != null) {
                return no;
            }
        }
        if (loginMember.getMemberNo() != null) {
            return loginMember.getMemberNo();
        }
        return null;
    }

    @Override
    public void deleteComment(long commentId, long postId, MemberVO loginMember) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }

        CommunityCommentVO comment = communityCommentMapper.selectCommentById(commentId);
        if (comment == null || !Long.valueOf(postId).equals(comment.getPostId())) {
            throw new IllegalArgumentException("COMMENT_NOT_FOUND");
        }

        Long loginMemberNo = lookupMemberNo(loginMember);
        if (loginMemberNo == null || !loginMemberNo.equals(comment.getMemberNo())) {
            throw new IllegalStateException("FORBIDDEN");
        }

        communityCommentMapper.softDeleteComment(commentId);
    }

    @Override
    public void updateComment(long commentId, long postId, String body, MemberVO loginMember) {
        if (loginMember == null) {
            throw new IllegalStateException("LOGIN_REQUIRED");
        }
        if (body == null || body.isBlank()) {
            throw new IllegalArgumentException("EMPTY_BODY");
        }

        CommunityCommentVO comment = communityCommentMapper.selectCommentById(commentId);
        if (comment == null || !Long.valueOf(postId).equals(comment.getPostId())) {
            throw new IllegalArgumentException("COMMENT_NOT_FOUND");
        }

        Long loginMemberNo = lookupMemberNo(loginMember);
        if (loginMemberNo == null || !loginMemberNo.equals(comment.getMemberNo())) {
            throw new IllegalStateException("FORBIDDEN");
        }

        communityCommentMapper.updateCommentBody(commentId, body.trim());
    }

    @Override
    public Long resolveLoginMemberNo(MemberVO loginMember) {
        if (loginMember == null) {
            return null;
        }
        return lookupMemberNo(loginMember);
    }

    @Override
    public CommunityCommentVO getFirstTopComment(long postId) {
        List<CommunityCommentVO> parents = communityCommentMapper.selectCommentList(postId);
        if (parents == null || parents.isEmpty()) {
            return null;
        }
        return parents.get(0);
    }
}

