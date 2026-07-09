/**
 * 역할: MypageNotifyService 구현체 (@Service)
 *
 * 연결
 * - implements: MypageNotifyService
 * - 사용: MypageNotifyMapper
 */

package com.petcare.petcare.mypage.notify.service;

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
        vo.setLinkUrl("/mypage/biz/apply");
        vo.setIsRead("N");

        mypageNotifyMapper.insertNotification(vo);
    }
}
