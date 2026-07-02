/**
 * 역할: 사업자 쇼핑몰(상품·주문·배송) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - biz/store/dashboard.jsp   대시보드
 * - biz/store/products.jsp    상품 관리
 * - biz/store/inventory.jsp   재고 관리
 * - biz/store/orders.jsp      주문 관리
 * - biz/store/delivery.jsp    배송 관리
 * - biz/store/reviews.jsp     리뷰 관리
 * - biz/store/settlement.jsp  정산
 * - biz/store/info.jsp        매장 정보
 *
 * 구현할 기능 예시
 * - 사업자 대시보드 요약 조회
 * - 상품·재고 등록·수정
 * - 주문·배송 상태 관리
 * - 리뷰 조회·답변
 * - 정산 내역 조회
 *
 * 연결
 * - 구현: BizStoreServiceImpl
 * - 호출: BizStoreController
 * - DB: BizStoreMapper
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_ORDER
 * - TB_ORDER_ITEM
 * - TB_REVIEW
 */

package com.petcare.petcare.biz.store.service;

public interface BizStoreService {}
