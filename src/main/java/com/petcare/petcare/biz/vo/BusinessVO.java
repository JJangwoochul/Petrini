package com.petcare.petcare.biz.vo;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class BusinessVO {
    // TB_BUSINESS
    private Long bizNo;          // PK (자동증가)
    private String bizId;        // 로그인 ID (세션에서 세팅)
    private String bizType;      // 사업자 유형 (HOSPITAL/STAY/GROOMING 등)
    private String bizRegNo;     // 사업자등록번호
    private String bizName;      // 상호명
    private String ceoName;      // 대표자
    private String phone;        // 연락처
    private String statusCd;     // 상태코드 (PENDING/APPROVED)

    // 2026-07-10 장우철 — 사업자 신청 주소 (승인 시 TB_HOSPITAL.ADDR 로 복사)
    private String zipCode;      // ZIP_CODE
    private String addr;         // ADDR
    private String addrDetail;   // ADDR_DETAIL

    // 2026-07-09 장우철 — TB_BUSINESS_AUTH 최신 건 반려 사유 (반려 화면·재신청 안내)
    private String rejectReason;

    /* [변경 전] 폼 전용 필드명 — apply.jsp 와 불일치(bizAddr1) + DB 미저장
    private String zipcode;
    private String addr1;
    private String addr2;
    */
}
