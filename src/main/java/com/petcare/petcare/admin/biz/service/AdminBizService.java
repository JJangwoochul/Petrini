/**
 * 역할: 관리자 사업자 승인·재능나눔 승인 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - admin/biz/list.jsp      사업자 승인 목록
 * - admin/biz/detail.jsp    사업자 신청 상세
 * - admin/biz/talent.jsp    재능나눔 승인
 *
 * 구현할 기능 예시
 * - 사업자 신청 목록 조회 (대기/승인/반려 탭·필터)
 * - 사업자 신청 상세 조회
 * - 사업자 승인 / 반려 처리
 * - 재능나눔 승인 목록 조회
 * - 재능나눔 승인 / 반려 처리
 *
 * 연결
 * - 구현: AdminBizServiceImpl
 * - 호출: AdminBizController
 * - DB: AdminBizMapper
 *
 * 참고 테이블
 * - TB_BUSINESS
 * - (재능나눔) 관련 테이블
 */

package com.petcare.petcare.admin.biz.service;

public interface AdminBizService {}
