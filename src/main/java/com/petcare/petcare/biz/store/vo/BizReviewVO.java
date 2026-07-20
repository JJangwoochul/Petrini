package com.petcare.petcare.biz.store.vo;

import java.util.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class BizReviewVO {

    private Long reviewId;
    private Long productId;      // TARGET_ID
    private Long memberNo;
    private Double rating;
    private String content;
    private String bizReply;
    private Date regDate;

    // 조회용 조인
    private String nickname;
    private String productName;

    // 삭제요청 상태 (TB_REVIEW_REPORT.STATUS_CD, 요청 없으면 null)
    private String reportStatus;
}