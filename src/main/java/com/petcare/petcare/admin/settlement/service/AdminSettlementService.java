/**
 * 역할: 관리자 정산 비즈니스 로직 (interface)
 * 2026/07/30 장우철 — 숙소 정산 구현순서 3-1 ~ 3-5 / 4-3 ~ 4-5
 *
 * 담당 화면: admin/settlement/list.jsp (STAY 탭)
 * 구현: AdminSettlementServiceImpl
 * DB: AdminSettlementMapper + StaySettlementService(승인 시 부분정산)
 *
 * 3-6 처리자 이력은 로그인 ADMIN_NO 보완 후 진행
 */
package com.petcare.petcare.admin.settlement.service;

import java.util.List;

import com.petcare.petcare.admin.settlement.vo.AdminStayRequestVO;
import com.petcare.petcare.admin.settlement.vo.AdminStaySettlementVO;
import com.petcare.petcare.settlement.vo.StaySettlementItemVO;
import com.petcare.petcare.settlement.vo.StaySettlementVO;

public interface AdminSettlementService {

    boolean isReady();

    int countStaySettlements(Long bizNo);

    List<AdminStaySettlementVO> getStaySettlementList(String statusCd);

    List<StaySettlementItemVO> getStaySettlementItems(Long settleId);

    int payStaySettlement(Long settleId);

    int payStaySettlements(List<Long> settleIds);

    /** 사이드바 배지용 REQUESTED 건수 */
    int countStayMidRequestsRequested();

    /** 중간정산 요청 목록 (requested|approved|rejected|all) */
    List<AdminStayRequestVO> getStayRequestList(String statusCd);

    /** 4-3+4-4 승인 → 부분 정산 생성 */
    StaySettlementVO approveStayMidRequest(Long requestId);

    /** 4-3 거절 */
    void rejectStayMidRequest(Long requestId, String rejectReason);
}
