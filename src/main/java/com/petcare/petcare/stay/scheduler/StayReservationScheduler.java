/**
 * 역할: 숙소 예약 자동 완료 스케줄러 (@Component)
 *
 * 동작
 * - 매일 새벽 01:00에 실행
 * - 체크아웃 날짜가 오늘 이전(어제까지)인 CONFIRMED 예약을 DONE으로 일괄 변경
 * - DONE 처리된 예약에 대해 리뷰 작성 권한이 자동으로 부여됨
 *
 * 연결
 * - StayMapper.updateConfirmedToDone (XML)
 *
 * 주의
 * - PetcareApplication에 @EnableScheduling 추가 필요
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
     * 매일 새벽 01:00 실행
     * 체크아웃 날짜가 오늘 이전인 CONFIRMED 예약 → DONE 일괄 변경
     *  초  분  시  일  월  요일
        0   0   1   *   *   *   → 매일 아침 1시
        0   0   9   *   *   *   → 매일 아침 9시
        0   30  12  *   *   *   → 매일 오후 12시 30분
        0   0   0   1   *   *   → 매월 1일 자정
        0   *   *   *   *   *   → 매분 실행 (테스트용)
     */
    
    @Scheduled(cron = "0 * * * * *")
    public void autoCompleteStayReservations() {
        try {
            int updatedCount = stayMapper.updateConfirmedToDone();
            if (updatedCount > 0) {
                log.info("[StayScheduler] 숙박 완료 자동 처리 — {}건 CONFIRMED → DONE", updatedCount);
            }
        } catch (Exception e) {
            log.error("[StayScheduler] 숙박 완료 자동 처리 실패", e);
        }
    }
}
