/**
 * 역할: 관리자 대시보드·통계용 데이터 객체
 *
 * 필드 예시
 * - totalMembers, totalOrders, totalRevenue, periodLabel
 *
 * 참고 테이블
 * - TB_MEMBER
 * - TB_ORDER
 * - TB_RESERVATION
 *
 * DB 컬럼명은 팀 VO 규칙(camelCase)에 맞게 작성
 *
 * - 박유정 / 2026-07-29 — Phase 1: 승인 대기 사업자 목록
 * - 박유정 / 2026-07-30 — ADMIN-01: 대시보드 통계·차트·최근주문
 */

package com.petcare.petcare.admin.main.vo;

import java.util.List;

import com.petcare.petcare.admin.biz.vo.AdminBizVO;
import com.petcare.petcare.admin.main.vo.AdminMainOrderVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMainVO {

    // 2026-07-29 박유정 — 사업자 승인 대기 (dashboard.jsp 표, 최대 5건은 Service에서 자름)
    private List<AdminBizVO> pendingBizList;

    // 2026-07-30 박유정 — Phase 2: 대시보드 상단 통계 카드 (dashboard.jsp adm-stats)
    private int todayNewMemberCount;      // 오늘 신규 가입자 (TB_MEMBER)
    private int todayOrderCount;          // 오늘 주문 수 (TB_ORDER)
    private long todaySalesAmount;        // 오늘 매출 원 단위 (JSP에서 백만원 변환)
    private int pendingReservationCount;  // 미처리 예약 (PENDING + CONFIRMED)

    // 2026-07-30 박유정 — Phase 3-A: 최근 주문 (dashboard.jsp, 최대 5건은 SQL에서 자름)
    private List<AdminMainOrderVO> recentOrderList;

    // 2026-07-30 박유정 — Phase 3-B: 회원 현황 도넛 (dashboard.jsp memberChart)
    private int memberGeneralCount;    // 일반회원 (탈퇴 제외, 사업자 미승인)
    private int memberBizCount;        // 사업자 (TB_BUSINESS APPROVED)
    private int memberWithdrawnCount;  // 탈퇴 (STATUS_CD = WITHDRAWN)

    // 2026-07-30 박유정 — Phase 3-C: 주간 매출 차트 (dashboard.jsp salesChart, 최근 7일)
    private List<AdminMainSalesDayVO> weeklySalesList;

    // 2026-07-30 박유정 — 월간 매출 차트 (dashboard.jsp salesChart, 이번 달 1일~말일)
    private List<AdminMainSalesDayVO> monthlySalesList;
}
