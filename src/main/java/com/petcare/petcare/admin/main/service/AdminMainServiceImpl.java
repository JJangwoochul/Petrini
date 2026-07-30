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
 */

package com.petcare.petcare.admin.main.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petcare.petcare.admin.biz.service.AdminBizService;
import com.petcare.petcare.admin.biz.vo.AdminBizVO;
import com.petcare.petcare.admin.main.vo.AdminMainVO;

@Service
public class AdminMainServiceImpl implements AdminMainService {

    // 2026-07-29 박유정 — 사업자 승인 목록 재사용 (AdminBizMapper 직접 호출 X, /admin/biz/list 와 동일 데이터)
    @Autowired
    private AdminBizService adminBizService;

    // 2026-07-29 박유정 — 대시보드 요약 조회 (Phase 1: 승인 대기 사업자만, Controller·JSP 연동은 미완)
    @Override
    public AdminMainVO getDashboardSummary() {

        // 2026-07-29 박유정 — STATUS_CD=PENDING 전체 목록 (DB 0건이면 빈 리스트)
        List<AdminBizVO> allPending = adminBizService.getBizApplyList("PENDING");

        // 2026-07-29 박유정 — dashboard.jsp 표는 최대 5건 (subList(0,0) → 빈 리스트, 에러 없음)
        int limit = Math.min(5, allPending.size());
        List<AdminBizVO> topFive = allPending.subList(0, limit);

        // 2026-07-29 박유정 — AdminMainVO.pendingBizList 에 담아 Controller 로 전달
        AdminMainVO summary = new AdminMainVO();
        summary.setPendingBizList(topFive);
        return summary;
    }
}
