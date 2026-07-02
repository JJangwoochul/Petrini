/**
 * 역할: 관리자 쇼핑몰(상품·주문) 관리 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - admin/store/product-list.jsp 상품 목록
 * - admin/store/product-form.jsp 상품 등록·수정
 * - admin/store/order-list.jsp 주문 목록
 * - admin/store/order-detail.jsp 주문 상세
 * - admin/store/category.jsp  카테고리 관리
 *
 * 구현할 기능 예시
 * - 상품 목록·등록·수정·삭제
 * - 주문 목록·상세 조회
 * - 주문 상태 변경
 * - 카테고리 관리
 *
 * 연결
 * - 구현: AdminStoreServiceImpl
 * - 호출: AdminStoreController
 * - DB: AdminStoreMapper
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_ORDER
 * - TB_ORDER_ITEM
 * - TB_CATEGORY
 */

package com.petcare.petcare.admin.store.service;

public interface AdminStoreService {}
