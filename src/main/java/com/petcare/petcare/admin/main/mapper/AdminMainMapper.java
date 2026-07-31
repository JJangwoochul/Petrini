/**
 * 역할: 관리자 대시보드 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/admin/main/AdminMainMapper.xml
 * namespace: com.petcare.petcare.admin.main.mapper.AdminMainMapper
 *
 * - 박유정 / 2026-07-30 — Phase 2: 상단 통계 카드 COUNT/SUM
 * - 박유정 / 2026-07-30 — Phase 3: 최근주문·회원·매출차트
 * - 박유정 / 2026-07-30 — ADMIN-04: 이번 달 통계 요약
 *
 * 참고 테이블
 * - TB_MEMBER
 * - TB_ORDER
 * - TB_RESERVATION
 */

package com.petcare.petcare.admin.main.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

import com.petcare.petcare.admin.main.vo.AdminMainOrderVO;

import com.petcare.petcare.admin.main.vo.AdminMainSalesDayVO;

@Mapper
public interface AdminMainMapper {

        // 2026-07-30 박유정 — 오늘 신규 가입자 (TB_MEMBER.JOIN_DATE = 오늘)
        int countTodayNewMembers();
        // 2026-07-30 박유정 — 오늘 주문 건수 (TB_ORDER.ORDER_DATE = 오늘)
        int countTodayOrders();
        // 2026-07-30 박유정 — 오늘 매출 합계 원 (TB_ORDER.PAY_AMOUNT, 취소 제외)
        long sumTodaySalesAmount();
        // 2026-07-30 박유정 — 미처리 예약 (TB_RESERVATION STATUS PENDING + CONFIRMED)
        int countPendingReservations();

        // 2026-07-30 박유정 — Phase 3-A: 최근 주문 5건 (TB_ORDER + TB_MEMBER)
        List<AdminMainOrderVO> selectRecentOrders();

        // 2026-07-30 박유정 — Phase 3-B: 일반회원 (탈퇴 제외, 사업자 미승인)
        int countMemberGeneral();

        // 2026-07-30 박유정 — Phase 3-B: 사업자 회원 (TB_BUSINESS APPROVED)
        int countMemberBiz();
    
        // 2026-07-30 박유정 — Phase 3-B: 탈퇴 회원
        int countMemberWithdrawn();

        // 2026-07-30 박유정 — Phase 3-C: 최근 7일 일별 매출 (TB_ORDER)
        List<AdminMainSalesDayVO> selectWeeklySales();

        // 2026-07-30 박유정 — 월간 매출: 이번 달 1일~말일 (TB_ORDER)
        List<AdminMainSalesDayVO> selectMonthlySales();

        // 2026-07-30 박유정 — ADMIN-04: 이번 달 총 매출 (TB_ORDER, 취소 제외)
        long sumMonthSalesAmount();
        
        // 2026-07-30 박유정 — ADMIN-04: 이번 달 신규 가입 (TB_MEMBER.JOIN_DATE)
        int countMonthNewMembers();

        // 2026-07-30 박유정 — ADMIN-04: 이번 달 예약 건수 (TB_RESERVATION.REG_DATE)
        int countMonthReservations();

        // 2026-07-30 박유정 — ADMIN-04: 이번 달 주문 수 (TB_ORDER.ORDER_DATE)
        int countMonthOrders();
       
}
