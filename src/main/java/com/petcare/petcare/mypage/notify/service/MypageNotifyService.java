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

import java.util.List;

import com.petcare.petcare.mypage.notify.vo.MypageNotifyVO;

public interface MypageNotifyService {

    void sendBizRejectNotification(Long memberNo, String bizName, String rejectReason);

    // 2026-07-10 장우철 — 사업자 승인 알림 INSERT (문구는 ServiceImpl 에서 수정 가능)
    void sendBizApproveNotification(Long memberNo, String bizName, String bizType);

    // 2026-07-09 장우철 — 알림함 목록·상세 (DB only, 이메일/FCM 은 후속 API)
    List<MypageNotifyVO> getNotificationList(Long memberNo);

    MypageNotifyVO getNotificationDetail(Long notiId, Long memberNo);

    // 2026-07-10 장우철 — 알림함 전체 읽음 / 전체 삭제
    int markAllNotificationsRead(Long memberNo);

    int deleteAllNotifications(Long memberNo);
}
