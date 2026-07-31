/**
 * 역할: 관리자 통계 페이지 데이터 객체
 *
 * - 박유정 / 2026-07-30 — ADMIN-04: admin/stats/index.jsp
 *
 * 참고 테이블
 * - TB_ORDER
 * - TB_MEMBER
 * - TB_RESERVATION
 */

package com.petcare.petcare.admin.main.vo;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminStatsVO {
    
    // 2026-07-30 박유정 — Phase 1: 이번 달 요약 카드 4종 (index.jsp adm-stats)
    private long monthSalesAmount;      // 이번 달 총 매출 (원, JSP ÷1000000 → 백만원)
    private int monthNewMemberCount;    // 이번 달 신규 가입 (TB_MEMBER.JOIN_DATE)
    private int monthReservationCount;  // 이번 달 예약 건수 (TB_RESERVATION.REG_DATE)
    private int monthOrderCount;        // 이번 달 주문 수 (TB_ORDER.ORDER_DATE)
}
