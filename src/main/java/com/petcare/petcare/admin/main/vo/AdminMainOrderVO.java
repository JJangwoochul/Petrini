/**
 * 역할: 관리자 대시보드 — 최근 주문 1건
 *
 * - 박유정 / 2026-07-30 — Phase 3-A: dashboard.jsp 최근 주문 표
 *
 * 참고 테이블
 * - TB_ORDER
 * - TB_MEMBER
 */


package com.petcare.petcare.admin.main.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMainOrderVO {
    
    // 2026-07-30 박유정 — 상세 링크용 PK
    private Long orderId;
    // 2026-07-30 박유정 — 주문번호 (#${orderNo})
    private String orderNo;
    // 2026-07-30 박유정 — 주문자명 (TB_MEMBER JOIN)
    private String memberName;
    // 2026-07-30 박유정 — 실결제금액 원 (PAY_AMOUNT NUMBER)
    private Long payAmount;
    // 2026-07-30 박유정 — PAID / SHIPPING / CANCEL 등
    private String orderStatus;
}
