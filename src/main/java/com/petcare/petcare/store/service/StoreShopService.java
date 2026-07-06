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

import java.util.List;

import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;

public interface StoreShopService {
//지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터
List<StoreShopVO> getProductList(Long categoryId, String keyword, String sort, int pageNo);

//지윤 26.07.06 페이지네이션용 총 페이지 수 계산
int getTotalPages(Long categoryId, String keyword);

//지윤 26.07.06 카테고리 트리 조회
List<CategoryVO> getCategoryTree();
}