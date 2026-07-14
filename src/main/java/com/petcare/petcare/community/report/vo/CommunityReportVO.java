/**
 * 역할: 커뮤니티 게시글 신고 데이터 객체
 *
 * - 박유정 / 2026-07-10
 *
 * 담당 화면
 * - community/detail.jsp   게시글 신고 팝업
 *
 * 참고 테이블
 * - TB_POST_REPORT
 */

package com.petcare.petcare.community.report.vo;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommunityReportVO {

    private Long reportId;       // REPORT_ID
    private Long postId;         // POST_ID
    private Long memberNo;       // MEMBER_NO — 신고자
    private String reasonCd;     // REASON_CD — SPAM / ABUSE / ETC
    private String reasonDetail; // REASON_DETAIL — 상세 사유(선택)
    private String statusCd;     // STATUS_CD — PENDING / DISMISSED / ...
    private LocalDateTime regDate;
}
