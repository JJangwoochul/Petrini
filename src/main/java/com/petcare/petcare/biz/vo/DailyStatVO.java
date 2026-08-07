package com.petcare.petcare.biz.vo;

import lombok.Getter;
import lombok.Setter;

/**
 * 일별 통계 1행 (차트 데이터용)
 * MyBatis resultType으로 사용
 */
@Getter @Setter
public class DailyStatVO {
    private String dt;       // 'MM-DD' 형태
    private int resvCount;   // 해당 일 예약 건수
    private long revenue;    // 해당 일 매출
}
