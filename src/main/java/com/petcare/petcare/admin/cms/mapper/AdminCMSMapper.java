/**
 * 역할: 관리자 CMS DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/admin/cms/AdminCMSMapper.xml
 * namespace: com.petcare.petcare.admin.cms.mapper.AdminCMSMapper
 *
 * 쿼리 예시
 * - selectBannerList
 * - insertBanner
 * - updateBanner
 * - deleteBanner
 * - selectNoticeList
 * - insertNotice
 * - updateNotice
 * - deleteNotice
 * - selectFaqList
 * - insertFaq
 * - updateFaq
 * - deleteFaq
 *
 * 참고 테이블
 * - TB_BANNER
 * - TB_NOTICE
 * - TB_FAQ
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.admin.cms.mapper;

public interface AdminCMSMapper {}
