/**
 * 역할: 쇼핑몰(사용자) 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - store/list.jsp            상품 목록
 * - store/detail.jsp          상품 상세
 * - store/cart.jsp            장바구니
 * - store/order.jsp           주문
 * - store/payment.jsp         결제
 * - store/order-complete.jsp  주문 완료
 *
 * 구현할 기능 예시
 * - 상품 목록·상세 조회
 * - 장바구니·주문·결제 처리
 *
 * 연결
 * - 구현: StoreShopServiceImpl
 * - 호출: StoreShopController
 * - DB: StoreShopMapper
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_CART
 * - TB_ORDER
 */

package com.petcare.petcare.store.service;

public interface StoreShopService {}
