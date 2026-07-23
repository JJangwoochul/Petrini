/**
 * 역할: 관리자 회원 상세 — 최근 주문 1건
 *
 * - 박유정 / 2026-07-21 STEP 11
 *
 * 참고 테이블: TB_ORDER, TB_ORDER_ITEM
 */

package com.petcare.petcare.admin.member.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMemberOrderVO {

    private Long orderId;          // ORDER_ID
    private String orderNo;        // ORDER_NO
    private String orderStatus;    // ORDER_STATUS — PAID / SHIPPING / DELIVERED / CANCEL 등
    private Long payAmount;        // PAY_AMOUNT
    private String orderDate;      // ORDER_DATE
    private String firstProductName; // 첫 상품명 (TB_ORDER_ITEM)
    private Integer itemCount;     // 주문 상품 건수
}