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

    // 2026/07/11 장우철 — 병원 예약 확정/취소 알림 (NOTI_TYPE=RESERVE)
    // resvId: 3차에서 상세 이동용 linkUrl 에 사용 (2차 상세 URL 미리 연결)
    void sendReserveConfirmNotification(Long memberNo, String hospitalName, java.util.Date resvDate,
                                        String resvTime, Long resvId);

    void sendReserveCancelNotification(Long memberNo, String hospitalName, java.util.Date resvDate,
                                       String resvTime, String cancelReason, Long resvId);

    // 2026/07/13 장우철 — 진료완료 알림 → 예약 상세(리뷰 작성)
    void sendReserveDoneNotification(Long memberNo, String hospitalName, java.util.Date resvDate,
                                     String resvTime, Long resvId);

    // 2026/07/13 장우철 — 유저 리뷰 등록 → 사업자(병원 회원) 알림
    void sendHospitalReviewToBizNotification(Long bizMemberNo, String hospitalName,
                                             String reviewerNickname, Double rating, Long resvId);

    // 2026/07/14 장우철 — 병원 답글 → 리뷰 작성 회원 알림
    void sendHospitalReviewReplyNotification(Long memberNo, String hospitalName,
                                             Long resvId, Long hospitalId);

    // 2026-07-16 지윤 — 상품 품절 알림 → 사업자 회원 알림함 "재고" 탭
    void sendProductSoldoutNotification(Long bizMemberNo, String productName, Long productId);                                         

    // 2026-07-09 장우철 — 알림함 목록·상세 (DB only, 이메일/FCM 은 후속 API)
    List<MypageNotifyVO> getNotificationList(Long memberNo);

    MypageNotifyVO getNotificationDetail(Long notiId, Long memberNo);

    // 2026-07-10 장우철 — 알림함 전체 읽음 / 전체 삭제
    int markAllNotificationsRead(Long memberNo);

    int deleteAllNotifications(Long memberNo);

    // 2026/07/11 장우철 — 헤더 미읽음 알림 배지
    int countUnreadNotifications(Long memberNo);
}
