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
import com.petcare.petcare.store.vo.CartItemVO;
import com.petcare.petcare.store.vo.CouponVO;

public interface StoreShopService {
//지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터
List<StoreShopVO> getProductList(Long categoryId, String keyword, String sort, int pageNo);

//지윤 26.07.06 페이지네이션용 총 페이지 수 계산
int getTotalPages(Long categoryId, String keyword);

//지윤 26.07.06 카테고리 트리 조회
List<CategoryVO> getCategoryTree();

//지윤 26.07.07 상품 상세 조회
StoreShopVO getProductDetail(Long productId);

//지윤 26.07.08 장바구니 목록 조회
List<CartItemVO> getCartItems(Long memberNo);

//지윤 26.07.08 장바구니 담기 (같은 상품+옵션 있으면 수량 합침, 없으면 새로 추가)
void addToCart(Long memberNo, Long productId, Long optionId, int qty, int price);

//지윤 26.07.08 장바구니 수량 변경
void updateCartItemQty(Long cartItemId, int qty);

//지윤 26.07.08 장바구니 항목 삭제
void deleteCartItem(Long cartItemId);

//지윤 26.07.08 장바구니 항목 여러 개 한번에 삭제 (선택삭제/전체삭제용)
void deleteCartItems(java.util.List<Long> cartItemIds);

//장바구니 숫자뱃지
int getCartItemCount(Long memberNo);

//지윤 26.07.09 회원 보유쿠폰 목록 조회
List<CouponVO> getMemberCoupons(Long memberNo);

//지윤 26.07.09 바로구매 클릭 시 해당 상품 주문페이지 이동
List<CartItemVO> getDirectOrderItem(Long productId, Long optionId, int qty);

//지윤 26.07.09 장바구니에서 체크한 항목들로 주문페이지 이동
List<CartItemVO> getCartOrderItems(java.util.List<Long> cartItemIds);
}