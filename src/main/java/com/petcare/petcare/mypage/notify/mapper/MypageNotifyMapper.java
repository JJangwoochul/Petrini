/**
 * 역할: 마이페이지 알림 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/mypage/notify/MypageNotifyMapper.xml
 * namespace: com.petcare.petcare.mypage.notify.mapper.MypageNotifyMapper
 *
 * 쿼리 예시
 * - selectNotificationList
 * - selectNotificationDetail
 * - updateReadStatus
 *
 * 참고 테이블
 * - TB_NOTIFICATION
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.mypage.notify.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.mypage.notify.vo.MypageNotifyVO;

@Mapper
public interface MypageNotifyMapper {

    // 2026-07-09 장우철 — 사업자 반려 알림 INSERT
    // 이유: 관리자 rejectBiz 처리 시 해당 MEMBER_NO 에만 TB_NOTIFICATION 1건 등록
    int insertNotification(MypageNotifyVO vo);
}
