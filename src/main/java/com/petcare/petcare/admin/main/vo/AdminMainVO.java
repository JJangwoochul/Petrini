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
 */

package com.petcare.petcare.admin.main.vo;

import java.util.List;

import com.petcare.petcare.admin.biz.vo.AdminBizVO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMainVO {

    // 2026-07-29 박유정 — 사업자 승인 대기 (dashboard.jsp 표, 최대 5건은 Service에서 자름)
    private List<AdminBizVO> pendingBizList;
}
