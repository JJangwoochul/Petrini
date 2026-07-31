/**
 * 역할: 숙소 체크인 전 취소 시 위약금·환불액 계산 (1-6)
 * 기준: 캔버스 환불/취소 표 (입실일 기준 D-day)
 * 2026/07/31 장우철
 */
package com.petcare.petcare.stay.service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Date;

public final class StayCancelFeeCalculator {

    private static final ZoneId ZONE = ZoneId.of("Asia/Seoul");

    private StayCancelFeeCalculator() {
    }

    /**
     * @param totalAmount 예약 총액
     * @param checkinDate 체크인일
     * @param today       기준일 (보통 오늘)
     */
    public static Result calculate(Long totalAmount, Date checkinDate, LocalDate today) {
        if (checkinDate == null) {
            throw new IllegalArgumentException("체크인일이 없습니다.");
        }
        long amount = totalAmount != null ? totalAmount : 0L;
        if (amount < 0) {
            throw new IllegalArgumentException("예약 금액이 올바르지 않습니다.");
        }

        LocalDate checkin = toLocalDate(checkinDate);
        long daysUntil = ChronoUnit.DAYS.between(today, checkin);

        if (daysUntil < 0) {
            throw new IllegalStateException("체크인일이 지나 취소할 수 없습니다. 환불신청을 이용해 주세요.");
        }

        // 캔버스: 10일전 100%환불 / 7일전 10% / 5일전 30% / 3일전 50% / 1일전 80% / 당일 90%
        int feeRatePercent;
        String tierLabel;
        if (daysUntil >= 10) {
            feeRatePercent = 0;
            tierLabel = "10일 전 이상 (전액 환불)";
        } else if (daysUntil >= 7) {
            feeRatePercent = 10;
            tierLabel = "7일 전";
        } else if (daysUntil >= 5) {
            feeRatePercent = 30;
            tierLabel = "5일 전";
        } else if (daysUntil >= 3) {
            feeRatePercent = 50;
            tierLabel = "3일 전";
        } else if (daysUntil >= 1) {
            feeRatePercent = 80;
            tierLabel = "1일 전";
        } else {
            feeRatePercent = 90;
            tierLabel = "당일 취소";
        }

        long cancelFeeAmt = amount * feeRatePercent / 100L;
        long refundAmt = amount - cancelFeeAmt;

        return new Result(daysUntil, feeRatePercent, cancelFeeAmt, refundAmt, tierLabel);
    }

    public static Result calculate(Long totalAmount, Date checkinDate) {
        return calculate(totalAmount, checkinDate, LocalDate.now(ZONE));
    }

    private static LocalDate toLocalDate(Date date) {
        // MyBatis/Oracle 은 java.sql.Date 로 올 수 있음 (toInstant 불가)
        if (date instanceof java.sql.Date) {
            return ((java.sql.Date) date).toLocalDate();
        }
        return date.toInstant().atZone(ZONE).toLocalDate();
    }

    public static final class Result {
        private final long daysUntilCheckin;
        private final int feeRatePercent;
        private final long cancelFeeAmt;
        private final long refundAmt;
        private final String tierLabel;

        public Result(long daysUntilCheckin, int feeRatePercent, long cancelFeeAmt,
                      long refundAmt, String tierLabel) {
            this.daysUntilCheckin = daysUntilCheckin;
            this.feeRatePercent = feeRatePercent;
            this.cancelFeeAmt = cancelFeeAmt;
            this.refundAmt = refundAmt;
            this.tierLabel = tierLabel;
        }

        public long getDaysUntilCheckin() {
            return daysUntilCheckin;
        }

        public int getFeeRatePercent() {
            return feeRatePercent;
        }

        public long getCancelFeeAmt() {
            return cancelFeeAmt;
        }

        public long getRefundAmt() {
            return refundAmt;
        }

        public String getTierLabel() {
            return tierLabel;
        }
    }
}
