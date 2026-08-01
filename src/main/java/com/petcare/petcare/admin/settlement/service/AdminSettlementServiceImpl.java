/**
 * 역할: 관리자 정산 서비스 구현체
 * 2026/07/30 장우철 — 숙소 정산 구현순서 3-1 ~ 3-5 / 4-3 ~ 4-5 / 5-4 D
 *
 * - 지급은 DB 상태만 변경 (토스 실이체 없음)
 * - 중간정산 승인은 StaySettlementService 에 위임
 * - 더미 지급 완료 시 사업자 사이트 알림 (5-4 D)
 */
package com.petcare.petcare.admin.settlement.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.admin.settlement.mapper.AdminSettlementMapper;
import com.petcare.petcare.admin.settlement.vo.AdminStayRequestVO;
import com.petcare.petcare.admin.settlement.vo.AdminStaySettlementVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.settlement.mapper.StaySettlementMapper;
import com.petcare.petcare.settlement.service.StaySettlementService;
import com.petcare.petcare.settlement.vo.StaySettlementItemVO;
import com.petcare.petcare.settlement.vo.StaySettlementVO;

@Service
public class AdminSettlementServiceImpl implements AdminSettlementService {

    @Autowired
    private AdminSettlementMapper adminSettlementMapper;

    @Autowired
    private StaySettlementService staySettlementService;

    @Autowired
    private StaySettlementMapper staySettlementMapper;

    @Autowired
    private MypageNotifyService mypageNotifyService;

    @Override
    public boolean isReady() {
        return adminSettlementMapper.ping() == 1;
    }

    @Override
    public int countStaySettlements(Long bizNo) {
        return adminSettlementMapper.countStaySettlements(bizNo);
    }

    @Override
    public List<AdminStaySettlementVO> getStaySettlementList(String statusCd) {
        String status = (statusCd == null || statusCd.isBlank() || "all".equalsIgnoreCase(statusCd))
                ? null : statusCd.toLowerCase();
        List<AdminStaySettlementVO> list = adminSettlementMapper.selectStaySettlementList(status);
        return list == null ? new ArrayList<>() : list;
    }

    @Override
    public List<StaySettlementItemVO> getStaySettlementItems(Long settleId) {
        if (settleId == null) {
            return new ArrayList<>();
        }
        List<StaySettlementItemVO> items = adminSettlementMapper.selectStaySettlementItems(settleId);
        return items == null ? new ArrayList<>() : items;
    }

    @Override
    @Transactional
    public int payStaySettlement(Long settleId) {
        if (settleId == null) {
            throw new IllegalArgumentException("settleId 가 없습니다.");
        }
        AdminStaySettlementVO row = adminSettlementMapper.selectStaySettlementById(settleId);
        int updated = adminSettlementMapper.updateStaySettlementPaid(settleId);
        if (updated > 0 && row != null) {
            notifyPaid(row);
        }
        return updated;
    }

    @Override
    @Transactional
    public int payStaySettlements(List<Long> settleIds) {
        if (settleIds == null || settleIds.isEmpty()) {
            throw new IllegalArgumentException("선택된 정산이 없습니다.");
        }
        int updated = 0;
        for (Long id : settleIds) {
            if (id == null) {
                continue;
            }
            updated += payStaySettlement(id);
        }
        if (updated == 0 && settleIds.stream().anyMatch(id -> id != null)) {
            // 전부 이미 완료 등이어도 예외는 아님 — 컨트롤러 메시지용
        }
        return updated;
    }

    private void notifyPaid(AdminStaySettlementVO row) {
        try {
            Long memberNo = staySettlementMapper.selectMemberNoByBizNo(row.getBizNo());
            mypageNotifyService.sendStaySettlementPaidNotification(
                    memberNo,
                    row.getBizName(),
                    formatDate(row.getPeriodStart()),
                    formatDate(row.getPeriodEnd()),
                    row.getRequestType(),
                    row.getSettleAmount());
        } catch (Exception e) {
            // 알림 실패해도 지급 처리는 유지
        }
    }

    private String formatDate(Date d) {
        if (d == null) {
            return "-";
        }
        return new SimpleDateFormat("yyyy-MM-dd").format(d);
    }

    @Override
    public int countStayMidRequestsRequested() {
        return adminSettlementMapper.countStayRequestsRequested();
    }

    @Override
    public List<AdminStayRequestVO> getStayRequestList(String statusCd) {
        String status = (statusCd == null || statusCd.isBlank() || "all".equalsIgnoreCase(statusCd))
                ? null : statusCd.toLowerCase();
        List<AdminStayRequestVO> list = adminSettlementMapper.selectStayRequestList(status);
        return list == null ? new ArrayList<>() : list;
    }

    @Override
    @Transactional
    public StaySettlementVO approveStayMidRequest(Long requestId) {
        if (requestId == null) {
            throw new IllegalArgumentException("requestId 가 없습니다.");
        }
        return staySettlementService.approveMidSettlementRequest(requestId);
    }

    @Override
    @Transactional
    public void rejectStayMidRequest(Long requestId, String rejectReason) {
        if (requestId == null) {
            throw new IllegalArgumentException("requestId 가 없습니다.");
        }
        staySettlementService.rejectMidSettlementRequest(requestId, rejectReason);
    }
}
