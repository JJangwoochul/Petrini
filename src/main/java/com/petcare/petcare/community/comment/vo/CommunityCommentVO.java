/**
 * 역할: 게시글 댓글 데이터 객체
 *
 * - 박유정 / 2026-07-09
 *
 * 담당 화면
 * - community/detail.jsp      커뮤니티 게시글 상세 댓글
 * - give/report/detail.jsp   분실·보호 신고 상세 댓글
 *
 * 참고 테이블
 * - TB_POST_COMMENT
 */

package com.petcare.petcare.community.comment.vo;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommunityCommentVO {

    private Long commentId;        // COMMENT_ID
    private Long postId;           // POST_ID
    private Long parentId;         // PARENT_ID (일반댓글 null)
    private Long memberNo;         // MEMBER_NO
    private String body;           // BODY
    private String isDeleted;      // IS_DELETED
    private LocalDateTime regDate; // REG_DATE

    // JOIN TB_MEMBER — 화면 표시용
    private String nickname;

    // 대댓글 목록 — getCommentList() 에서 parentId 기준으로 묶음
    private List<CommunityCommentVO> replies = new ArrayList<>();
}
