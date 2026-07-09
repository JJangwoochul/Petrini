/**
 * 역할: 마이페이지 알림 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - mypage/notifications.jsp  알림 목록
 * - mypage/notification-detail.jsp 알림 상세
 *
 * 구현할 기능 예시
 * - 알림 목록·상세 조회
 * - 읽음 처리
 *
 * 연결
 * - 구현: MypageNotifyServiceImpl
 * - 호출: MypageNotifyController
 * - DB: MypageNotifyMapper
 *
 * 참고 테이블
 * - TB_NOTIFICATION
 */

package com.petcare.petcare.mypage.notify.service;

public interface MypageNotifyService {

    // 2026-07-09 장우철 — 사업자 신청 반려 알림 발송
    // 이유: AdminBizServiceImpl.rejectBiz 에서 호출, 해당 회원 알림함에만 저장
    void sendBizRejectNotification(Long memberNo, String bizName, String rejectReason);
}
