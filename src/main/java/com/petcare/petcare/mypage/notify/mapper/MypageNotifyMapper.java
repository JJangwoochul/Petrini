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

public interface MypageNotifyMapper {}
