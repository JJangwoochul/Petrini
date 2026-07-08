/**
 * 역할: 커뮤니티 게시글 데이터 객체
 *
 * - 박유정 / 2026-07-08
 * - give/report 의 GiveReportVO 에서 LOST 전용 필드 제외하고 참고
 *
 * 참고 테이블
 * - TB_POST (BOARD_TYPE = TOWN / SHARE / LIFE)
 * - TB_FILE (사진, REF_TYPE = 'POST')
 *
 * DB 컬럼명은 팀 VO 규칙(camelCase)에 맞게 작성
 */

package com.petcare.petcare.community.post.vo;

import java.time.LocalDateTime;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommunityPostVO {

    // ── TB_POST 컬럼 ──────────────────────────────────────────

    private Long postId;           // POST_ID — 게시글 ID
    private Long memberNo;         // MEMBER_NO — 작성자 회원번호
    private String boardType;      // BOARD_TYPE — TOWN(집사생활) / SHARE(무료나눔) / LIFE(수의사상담)
    private String title;          // TITLE — 제목
    private String body;           // BODY — 본문
    private Integer viewCount;     // VIEW_COUNT — 조회수
    private Integer likeCnt;       // LIKE_CNT — 좋아요 수
    private String statusCd;       // STATUS_CD — 게시 상태 (ACTIVE 등)
    private LocalDateTime regDate; // REG_DATE — 등록일
    private String tags;           // TAGS — 태그
    private String region;         // REGION — 지역

    // ── 조회 전용 (DB 컬럼 아님, Service·JOIN 으로 채움) ──

    private String authorName;         // 작성자 닉네임 (TB_MEMBER JOIN, 추후)
    private String thumbUrl;           // 목록 썸네일 — TB_FILE 첫 사진 URL
    private List<String> photoUrls;    // 상세 사진 목록 (STEP 5)
}
