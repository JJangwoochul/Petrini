/**
 * 역할: 대시보드 주간 매출 차트 1일치 데이터
 *
 * - 박유정 / 2026-07-30 — Phase 3-C: salesChart (대시보드)
 * - 박유정 / 2026-07-31 — ADMIN-04: stats 차트 재사용 (dayLabel=월·구분, salesAmount=매출·건수)
 */

package com.petcare.petcare.admin.main.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminMainSalesDayVO {

    // 2026-07-30 박유정 — X축 라벨 (요일·일·월·구분)
    private String dayLabel;
    // 2026-07-30 박유정 — 값 (원/명/건 — 화면별 단위 변환은 JSP·Service)
    private long salesAmount;
    
}
