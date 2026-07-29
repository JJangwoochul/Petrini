package com.petcare.petcare.store.vo;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.07 상품 리뷰(TB_REVIEW) 조회용 VO
// 2026-07-27 박유정 — 스토어 상품 리뷰 목록용 필드만 유지 (미사용 targetId·bizReply·productName 제거)
@Getter @Setter
@ToString
@NoArgsConstructor
public class ReviewVO {
    private Long reviewId;
    private Long memberNo;
    private String nickname;
    private Double rating;
    private String content;
    private Date regDate;
}