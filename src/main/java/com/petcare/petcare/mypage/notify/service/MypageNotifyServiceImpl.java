/**
 * 역할: MypageNotifyService 구현체 (@Service)
 *
 * 연결
 * - implements: MypageNotifyService
 * - 사용: MypageNotifyMapper
 */

package com.petcare.petcare.mypage.notify.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.mypage.notify.mapper.MypageNotifyMapper;
import com.petcare.petcare.mypage.notify.vo.MypageNotifyVO;

@Service
public class MypageNotifyServiceImpl implements MypageNotifyService {

    @Autowired
    private MypageNotifyMapper mypageNotifyMapper;

    // 2026-07-09 장우철 — 사업자 반려 알림 TB_NOTIFICATION INSERT
    // 이유: CONTENT 컬럼 VARCHAR2(500) 이므로 반려사유 길이 제한, LINK 는 재신청 화면(2번) 경로
    @Override
    @Transactional
    public void sendBizRejectNotification(Long memberNo, String bizName, String rejectReason) {
        if (memberNo == null) {
            return;
        }

        String safeBizName = bizName != null ? bizName : "사업자";
        String safeReason = rejectReason != null ? rejectReason.trim() : "";
        if (safeReason.length() > 450) {
            safeReason = safeReason.substring(0, 450) + "...";
        }

        String content = "[" + safeBizName + "] 신청이 반려되었습니다.\n\n반려 사유:\n" + safeReason;

        MypageNotifyVO vo = new MypageNotifyVO();
        vo.setMemberNo(memberNo);
        vo.setNotiType("SYSTEM");
        vo.setTitle("사업자 등록 신청이 반려되었습니다");
        vo.setContent(content.length() > 500 ? content.substring(0, 497) + "..." : content);
        vo.setLinkUrl("/mypage/biz/rejected");
        vo.setIsRead("N");

        mypageNotifyMapper.insertNotification(vo);
    }

    // 2026-07-10 장우철 — 사업자 승인 알림 TB_NOTIFICATION INSERT
    // 이유: approveBiz 트랜잭션 안에서 해당 MEMBER_NO 에만 등록 (이메일/푸시는 후속)
    @Override
    @Transactional
    public void sendBizApproveNotification(Long memberNo, String bizName, String bizType) {
        if (memberNo == null) {
            return;
        }

        String safeBizName = bizName != null ? bizName : "사업자";
        String typeLabel = resolveBizTypeLabel(bizType);

        String content = "[" + safeBizName + "] 사업자 등록이 승인되었습니다.\n\n"
                + "승인 유형: " + typeLabel + "\n"
                + "사업자센터에서 업체 정보를 등록해 주세요.";

        MypageNotifyVO vo = new MypageNotifyVO();
        vo.setMemberNo(memberNo);
        vo.setNotiType("SYSTEM");
        vo.setTitle("사업자 등록 신청이 승인되었습니다");
        vo.setContent(content.length() > 500 ? content.substring(0, 497) + "..." : content);
        vo.setLinkUrl("/mypage/biz");
        vo.setIsRead("N");

        mypageNotifyMapper.insertNotification(vo);
    }

    // 2026/07/11 장우철 — 병원 예약 확정 알림
    @Override
    @Transactional
    public void sendReserveConfirmNotification(Long memberNo, String hospitalName,
                                               java.util.Date resvDate, String resvTime, Long resvId) {
        if (memberNo == null) {
            return;
        }
        String when = formatResvWhen(resvDate, resvTime);
        String safeName = hospitalName != null ? hospitalName : "병원";
        String content = "[" + safeName + "] 예약이 확정되었습니다.\n\n예약 일시: " + when;

        MypageNotifyVO vo = new MypageNotifyVO();
        vo.setMemberNo(memberNo);
        vo.setNotiType("RESERVE");
        vo.setTitle("병원 예약이 확정되었습니다");
        vo.setContent(content.length() > 500 ? content.substring(0, 497) + "..." : content);
        vo.setLinkUrl(resvId != null ? "/mypage/reserve/detail?resvId=" + resvId : "/mypage/reserve");
        vo.setIsRead("N");
        mypageNotifyMapper.insertNotification(vo);
    }

    // 2026/07/11 장우철 — 병원 예약 취소 알림 (취소 사유 포함)
    @Override
    @Transactional
    public void sendReserveCancelNotification(Long memberNo, String hospitalName,
                                              java.util.Date resvDate, String resvTime,
                                              String cancelReason, Long resvId) {
        if (memberNo == null) {
            return;
        }
        String when = formatResvWhen(resvDate, resvTime);
        String safeName = hospitalName != null ? hospitalName : "병원";
        String reason = (cancelReason != null && !cancelReason.isBlank()) ? cancelReason.trim() : "-";
        String content = "[" + safeName + "] 예약이 취소되었습니다.\n\n예약 일시: " + when
                + "\n취소 사유: " + reason;
        if (content.length() > 500) {
            content = content.substring(0, 497) + "...";
        }

        MypageNotifyVO vo = new MypageNotifyVO();
        vo.setMemberNo(memberNo);
        vo.setNotiType("RESERVE");
        vo.setTitle("병원 예약이 취소되었습니다");
        vo.setContent(content);
        vo.setLinkUrl(resvId != null ? "/mypage/reserve/detail?resvId=" + resvId : "/mypage/reserve");
        vo.setIsRead("N");
        mypageNotifyMapper.insertNotification(vo);
    }

    private String formatResvWhen(java.util.Date resvDate, String resvTime) {
        String datePart = "-";
        if (resvDate != null) {
            datePart = new java.text.SimpleDateFormat("yyyy-MM-dd").format(resvDate);
        }
        String timePart = (resvTime != null && !resvTime.isBlank()) ? resvTime : "";
        return (datePart + " " + timePart).trim();
    }

    private String resolveBizTypeLabel(String bizType) {
        if (bizType == null) {
            return "사업자";
        }
        return switch (bizType) {
            case "HOSPITAL" -> "병원";
            case "STAY" -> "숙소";
            case "STORE" -> "펫샵";
            case "GROOMING" -> "미용";
            case "STUDIO" -> "스튜디오";
            case "RESTAURANT" -> "식당";
            default -> bizType;
        };
    }

    // 2026-07-09 장우철 — 알림함 목록 (TB_NOTIFICATION)
    @Override
    @Transactional(readOnly = true)
    public List<MypageNotifyVO> getNotificationList(Long memberNo) {
        if (memberNo == null) {
            return Collections.emptyList();
        }
        return mypageNotifyMapper.selectNotificationList(memberNo);
    }

    // 2026-07-09 장우철 — 알림 상세 + 읽음 처리
    @Override
    @Transactional
    public MypageNotifyVO getNotificationDetail(Long notiId, Long memberNo) {
        if (notiId == null || memberNo == null) {
            return null;
        }
        MypageNotifyVO noti = mypageNotifyMapper.selectNotificationDetail(notiId, memberNo);
        if (noti != null && !"Y".equalsIgnoreCase(noti.getIsRead())) {
            mypageNotifyMapper.updateNotificationRead(notiId, memberNo);
            noti.setIsRead("Y");
        }
        return noti;
    }

    // 2026-07-10 장우철 — 알림함 전체 읽음
    @Override
    @Transactional
    public int markAllNotificationsRead(Long memberNo) {
        if (memberNo == null) {
            return 0;
        }
        return mypageNotifyMapper.updateAllNotificationRead(memberNo);
    }

    // 2026-07-10 장우철 — 알림함 전체 삭제
    @Override
    @Transactional
    public int deleteAllNotifications(Long memberNo) {
        if (memberNo == null) {
            return 0;
        }
        return mypageNotifyMapper.deleteAllNotificationsByMemberNo(memberNo);
    }

    // 2026/07/11 장우철 — 헤더 미읽음 알림 배지
    @Override
    @Transactional(readOnly = true)
    public int countUnreadNotifications(Long memberNo) {
        if (memberNo == null) {
            return 0;
        }
        return mypageNotifyMapper.countUnreadNotifications(memberNo);
    }
}
