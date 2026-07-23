/**
 * 역할: 관리자 회원 상세 — 포인트 이력 1건
 *
 * - 박유정 / 2026-07-21 STEP 10
 *
 * 참고 테이블: TB_POINT
 */

package com.petcare.petcare.admin.member.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMemberPointVO {

    private Long pointId;        // POINT_ID
    private String pointType;    // POINT_TYPE — EARN / USE
    private Integer pointAmount; // POINT_AMOUNT
    private Integer balanceAfter;// BALANCE_AFTER
    private String reasonCd;     // REASON_CD — ADMIN_GRANT / ADMIN_DEDUCT
    private String reasonDetail; // REF_ID — 관리자 입력 사유
    private String regDate;      // REG_DATE
}