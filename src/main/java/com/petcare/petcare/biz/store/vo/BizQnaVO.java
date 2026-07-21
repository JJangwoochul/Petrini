package com.petcare.petcare.biz.store.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class BizQnaVO {

    private Long qnaId;
    private Long productId;
    private Long memberNo;
    private String question;
    private String answer;      // 답변 없으면 null
    private String regDate;     //지윤 26.07.21 수정: DB에 문자열(YYYY-MM-DD)로 저장되어 있어서 Date -> String

    // 조회용 조인
    private String nickname;    // 질문자
    private String productName;
}