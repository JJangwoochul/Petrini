/**
 * 역할: 대시보드 주간 매출 차트 1일치 데이터
 *
 * - 박유정 / 2026-07-30 — Phase 3-C: salesChart
 */

package com.petcare.petcare.admin.main.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMainSalesDayVO {

    // 2026-07-30 박유정 — X축 라벨 (월, 화, 수 ...)
    private String dayLabel;
    // 2026-07-30 박유정 — 그날 매출 합계 (원 단위, JSP에서 ÷10000 → 만원)
    private long salesAmount;
    
}
