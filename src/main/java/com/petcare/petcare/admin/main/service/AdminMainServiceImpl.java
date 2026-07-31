/**
 * 역할: AdminMainService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: AdminMainService
 * - 사용: AdminMainMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 *
 * - 박유정 / 2026-07-29 — Phase 1: 승인 대기 사업자 목록
 * - 박유정 / 2026-07-30 — ADMIN-01: 대시보드 통계·차트 / ADMIN-04: 통계 요약
 */

package com.petcare.petcare.admin.main.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petcare.petcare.admin.biz.service.AdminBizService;
import com.petcare.petcare.admin.biz.vo.AdminBizVO;
import com.petcare.petcare.admin.main.vo.AdminMainVO;

import com.petcare.petcare.admin.main.mapper.AdminMainMapper;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.petcare.petcare.admin.main.vo.AdminMainSalesDayVO;
import com.petcare.petcare.admin.main.vo.AdminStatsVO;

@Service
public class AdminMainServiceImpl implements AdminMainService {

    // 2026-07-29 박유정 — 사업자 승인 목록 재사용 (AdminBizMapper 직접 호출 X, /admin/biz/list 와 동일 데이터)
    @Autowired
    private AdminBizService adminBizService;

    // 2026-07-30 박유정 — 대시보드 통계 (Phase 2: AdminMainMapper → TB_MEMBER/ORDER/RESERVATION)
    @Autowired
    private AdminMainMapper adminMainMapper;

    // 2026-07-29 박유정 — 대시보드 요약 조회 
    public AdminMainVO getDashboardSummary() {

        // 2026-07-29 박유정 — STATUS_CD=PENDING 전체 목록 (DB 0건이면 빈 리스트)
        List<AdminBizVO> allPending = adminBizService.getBizApplyList("PENDING");

        // 2026-07-29 박유정 — dashboard.jsp 표는 최대 5건 (subList(0,0) → 빈 리스트, 에러 없음)
        int limit = Math.min(5, allPending.size());
        List<AdminBizVO> topFive = allPending.subList(0, limit);

        // 2026-07-29 박유정 — AdminMainVO.pendingBizList 에 담아 Controller 로 전달
        AdminMainVO summary = new AdminMainVO();
        summary.setPendingBizList(topFive);

        // 2026-07-30 박유정 — Phase 2: 상단 통계 카드 4종 (dashboard.jsp adm-stats)
        summary.setTodayNewMemberCount(adminMainMapper.countTodayNewMembers());
        summary.setTodayOrderCount(adminMainMapper.countTodayOrders());
        summary.setTodaySalesAmount(adminMainMapper.sumTodaySalesAmount());
        summary.setPendingReservationCount(adminMainMapper.countPendingReservations());

        // 2026-07-30 박유정 — Phase 3-A: 최근 주문 5건 (dashboard.jsp)
        summary.setRecentOrderList(adminMainMapper.selectRecentOrders());

        // 2026-07-30 박유정 — Phase 3-B: 회원 현황 도넛 (dashboard.jsp memberChart)
        summary.setMemberGeneralCount(adminMainMapper.countMemberGeneral());
        summary.setMemberBizCount(adminMainMapper.countMemberBiz());
        summary.setMemberWithdrawnCount(adminMainMapper.countMemberWithdrawn());

        // 2026-07-30 박유정 — Phase 3-C: 주간 매출 7일 (주문 없는 날 = 0원)
        List<AdminMainSalesDayVO> salesFromDb = adminMainMapper.selectWeeklySales();

        // 2026-07-30 박유정 — DB 결과를 Map으로 (요일 라벨 → 매출)
        Map<String, Long> salesByDayLabel = new HashMap<>();
        for (AdminMainSalesDayVO row : salesFromDb) {
            salesByDayLabel.put(row.getDayLabel(), row.getSalesAmount());
        }

        // 2026-07-30 박유정 — 최근 7일 고정, 주문 없는 날은 0원
        String[] korDayLabels = {"월", "화", "수", "목", "금", "토", "일"};
        List<AdminMainSalesDayVO> weeklySalesList = new ArrayList<>();
        LocalDate startDate = LocalDate.now().minusDays(6);

        for (int i = 0; i < 7; i++) {
            LocalDate date = startDate.plusDays(i);
            String dayLabel = korDayLabels[date.getDayOfWeek().getValue() - 1];

            AdminMainSalesDayVO day = new AdminMainSalesDayVO();
            day.setDayLabel(dayLabel);
            day.setSalesAmount(salesByDayLabel.getOrDefault(dayLabel, 0L));
            weeklySalesList.add(day);
        }

        summary.setWeeklySalesList(weeklySalesList);

        // 2026-07-30 박유정 — 월간 매출: 이번 달 1일~말일 (주문·미래 날 = 0원)
        List<AdminMainSalesDayVO> monthlyFromDb = adminMainMapper.selectMonthlySales();

        // 2026-07-30 박유정 — DB 결과를 Map으로 (일 숫자 라벨 → 매출)
        Map<String, Long> monthlyByDayLabel = new HashMap<>();
        for (AdminMainSalesDayVO row : monthlyFromDb) {
            monthlyByDayLabel.put(row.getDayLabel(), row.getSalesAmount());
        }

        // 2026-07-30 박유정 — 이번 달 1일~말일 전체 일자 채움 (미래·무주문일 = 0원)
        LocalDate monthStart = LocalDate.now().withDayOfMonth(1);
        int daysInMonth = monthStart.lengthOfMonth();
        List<AdminMainSalesDayVO> monthlySalesList = new ArrayList<>();

        for (int day = 1; day <= daysInMonth; day++) {
            String dayLabel = String.valueOf(day);

            AdminMainSalesDayVO dayVo = new AdminMainSalesDayVO();
            dayVo.setDayLabel(dayLabel);
            dayVo.setSalesAmount(monthlyByDayLabel.getOrDefault(dayLabel, 0L));
            monthlySalesList.add(dayVo);
        }

        summary.setMonthlySalesList(monthlySalesList);
        return summary;
    }

    // 2026-07-30 박유정 — ADMIN-04: 통계 페이지 요약 (admin/stats/index.jsp Phase 1)
    @Override
    public AdminStatsVO getStatsSummary() {
        AdminStatsVO stats = new AdminStatsVO();
        // 2026-07-30 박유정 — 이번 달 총 매출 (원, 취소 제외)
        stats.setMonthSalesAmount(adminMainMapper.sumMonthSalesAmount());
        // 2026-07-30 박유정 — 이번 달 신규 가입 (TB_MEMBER.JOIN_DATE)
        stats.setMonthNewMemberCount(adminMainMapper.countMonthNewMembers());
        // 2026-07-30 박유정 — 이번 달 예약 건수 (TB_RESERVATION.REG_DATE)
        stats.setMonthReservationCount(adminMainMapper.countMonthReservations());
        // 2026-07-30 박유정 — 이번 달 주문 수 (TB_ORDER.ORDER_DATE, 취소 포함)
        stats.setMonthOrderCount(adminMainMapper.countMonthOrders());
        return stats;
    }
}
