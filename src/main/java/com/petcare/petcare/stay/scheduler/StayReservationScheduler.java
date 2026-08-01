/**
 * 역할: 숙소 예약 자동 DONE 스케줄러
 * 2026/07/31 장우철 — CHECKOUT + 체크아웃일 경과 → DONE (하루 1회 의미, 감지 주기 1분)
 */
package com.petcare.petcare.stay.scheduler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.petcare.petcare.stay.mapper.StayMapper;

@Component
public class StayReservationScheduler {

    private static final Logger log = LoggerFactory.getLogger(StayReservationScheduler.class);

    @Autowired
    private StayMapper stayMapper;

    /**
     * 체크아웃일 &lt; 오늘 인 CHECKOUT 예약 → DONE
     * cron 매분 감지로 자정 넘어간 건을 하루 1회 처리 (중복 UPDATE 0건)
     */
    @Scheduled(cron = "0 * * * * *")
    public void autoCompleteStayReservations() {
        try {
            int updatedCount = stayMapper.updateConfirmedToDone();
            if (updatedCount > 0) {
                log.info("[StayScheduler] 숙박 완료 자동 처리 — {}건 CHECKOUT → DONE", updatedCount);
            }
        } catch (Exception e) {
            log.error("[StayScheduler] 숙박 완료 자동 처리 실패", e);
        }
    }

    /**
     * HYJ 26.07.28 — 5분마다 실행
     * 생성 후 15분 경과한 PENDING 예약 → CANCEL 자동 취소
     * 결제 없이 이탈한 "유령 예약"을 정리하여 객실 가용성 복구
     */
    @Scheduled(fixedRate = 300000)
    public void cancelExpiredPendingReservations() {
        try {
            int cancelledCount = stayMapper.cancelExpiredPending();
            if (cancelledCount > 0) {
                log.info("[StayScheduler] 만료 PENDING 예약 자동 취소 — {}건 PENDING → CANCEL", cancelledCount);
            }
        } catch (Exception e) {
            log.error("[StayScheduler] 만료 PENDING 자동 취소 실패", e);
        }
    }
}
