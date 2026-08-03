/**
 * 역할: 관리자 통계 페이지 데이터 객체
 *
 * - 박유정 / 2026-07-30 — ADMIN-04 Phase 1: admin/stats/index.jsp 요약 카드
 * - 박유정 / 2026-07-31 — ADMIN-04 Phase 2~5: 차트·전월대비·CSV export
 *
 * 참고 테이블
 * - TB_ORDER
 * - TB_MEMBER
 * - TB_RESERVATION
 */

package com.petcare.petcare.admin.main.vo;


import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class AdminStatsVO {
    
    // 2026-07-30 박유정 — Phase 1: 이번 달 요약 카드 4종 (index.jsp adm-stats)
    private long monthSalesAmount;      // 이번 달 총 매출 (원, JSP ÷1000000 → 백만원)
    private int monthNewMemberCount;    // 이번 달 신규 가입 (TB_MEMBER.JOIN_DATE)
    private int monthReservationCount;  // 이번 달 예약 건수 (TB_RESERVATION.REG_DATE)
    private int monthOrderCount;        // 이번 달 주문 수 (TB_ORDER.ORDER_DATE)

    // 2026-07-31 박유정 — Phase 2: 월별 매출 추이 (최근 6개월, index.jsp monthSales)
    private List<AdminMainSalesDayVO> monthlySalesTrendList;

    // 2026-07-31 박유정 — Phase 3: 월별 신규 가입자 (최근 6개월, index.jsp memberGrowth)
    private List<AdminMainSalesDayVO> monthlyMemberTrendList;

    // 2026-07-31 박유정 — Phase 4: 업종별 예약/주문 현황 (병원·숙소·쇼핑, index.jsp reservationChart)
    private List<AdminMainSalesDayVO> categoryResvOrderList;

    // 2026-07-31 박유정 — Phase 5-A: 전월 대비 증감률 (%, JSP c:choose up/down)
    private double monthSalesChangeRate;       // 이번 달 매출
    private double monthNewMemberChangeRate;   // 이번 달 신규 가입
    private double monthReservationChangeRate; // 이번 달 예약
    private double monthOrderChangeRate;       // 이번 달 주문
}
