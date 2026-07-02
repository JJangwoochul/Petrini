/**
 * 역할: 관리자 CMS(배너·공지·FAQ) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - admin/cms/banner.jsp      배너 목록
 * - admin/cms/notice.jsp      공지 목록
 * - admin/cms/faq.jsp         FAQ 목록
 * - admin/cms/banner-form.jsp 배너 등록·수정
 * - admin/cms/notice-form.jsp 공지 등록·수정
 * - admin/cms/faq-form.jsp    FAQ 등록·수정
 *
 * 구현할 기능 예시
 * - 배너 목록·등록·수정·삭제
 * - 공지사항 목록·등록·수정·삭제
 * - FAQ 목록·등록·수정·삭제
 *
 * 연결
 * - 구현: AdminCMSServiceImpl
 * - 호출: AdminCMSController
 * - DB: AdminCMSMapper
 *
 * 참고 테이블
 * - TB_BANNER
 * - TB_NOTICE
 * - TB_FAQ
 */

package com.petcare.petcare.admin.cms.service;

public interface AdminCMSService {}
