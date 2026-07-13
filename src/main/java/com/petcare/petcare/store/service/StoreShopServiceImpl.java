/**
 * 역할: StoreShopService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: StoreShopService
 * - 사용: StoreShopMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.store.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petcare.petcare.store.mapper.StoreShopMapper;
import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.OptionVO;
import com.petcare.petcare.store.vo.ReviewVO;
import com.petcare.petcare.store.vo.QnaVO;
import com.petcare.petcare.store.vo.CartItemVO;
import com.petcare.petcare.store.vo.CouponVO;
import com.petcare.petcare.store.vo.BrandVO;
import com.petcare.petcare.store.vo.OrderTempVO;
import com.petcare.petcare.store.vo.CartItemVO;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StoreShopServiceImpl implements StoreShopService {

    @Autowired
    private StoreShopMapper storeShopMapper;

    //지윤 26.07.06 페이지당 상품 개수 (요구사항 고정값)
    private static final int PAGE_SIZE = 12;

    //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터(pageNo) 추가, 26.07.12 가격대·브랜드 필터 파라미터 추가
    @Override
    public List<StoreShopVO> getProductList(Long categoryId, String keyword, Integer minPrice, Integer maxPrice, String brand, String sort, int pageNo) {
        int offset = (pageNo - 1) * PAGE_SIZE;
        List<StoreShopVO> list = storeShopMapper.selectProductList(categoryId, keyword, minPrice, maxPrice, brand, sort, offset, PAGE_SIZE);
        for (StoreShopVO p : list) {
            if (p.getPrice() != null && p.getSalePrice() != null && p.getPrice() > 0) {
                int rate = (int) Math.round((p.getPrice() - p.getSalePrice()) * 100.0 / p.getPrice());
                p.setDiscountRate(rate);
            } else {
                p.setDiscountRate(0);
            }
        }
        return list;
    }

//지윤 26.07.06 총 페이지 수 계산 (전체개수 / 12, 나머지 있으면 올림)
//지윤 26.07.12 가격대·브랜드 필터 파라미터 추가
  @Override
  public int getTotalPages(Long categoryId, String keyword, Integer minPrice, Integer maxPrice, String brand) {
      int totalCount = storeShopMapper.selectProductCount(categoryId, keyword, minPrice, maxPrice, brand);
      return (int) Math.ceil(totalCount / (double) PAGE_SIZE);
  }

//지윤 26.07.12 사이드바 브랜드별 상품 수 조회 (브랜드 필터 자체는 제외해서 다른 브랜드도 계속 선택 가능)
  @Override
  public List<BrandVO> getBrandList(Long categoryId, String keyword, Integer minPrice, Integer maxPrice) {
      return storeShopMapper.selectBrandCounts(categoryId, keyword, minPrice, maxPrice);
  }

//지윤 26.07.06 카테고리 트리는 가공 없이 그대로 전달
  @Override
  public List<CategoryVO> getCategoryTree() {
      return storeShopMapper.selectCategoryTree();
  }

//지윤 26.07.07 상품 상세 조회 + 할인율 계산 (목록조회와 동일한 계산 로직)
//지윤 26.07.07 이미지 목록도 같이 조회해서 product에 채워넣도록 수정
@Override
public StoreShopVO getProductDetail(Long productId) {
    StoreShopVO product = storeShopMapper.selectProductDetail(productId);
    if (product != null) {
        if (product.getPrice() != null && product.getSalePrice() != null && product.getPrice() > 0) {
            int rate = (int) Math.round((product.getPrice() - product.getSalePrice()) * 100.0 / product.getPrice());
            product.setDiscountRate(rate);
        } else {
            product.setDiscountRate(0);
        }
        product.setImageList(storeShopMapper.selectProductImages(productId));
        product.setOptionList(storeShopMapper.selectProductOptions(productId));

//지윤 26.07.07 리뷰 목록 조회 + 별점별 비율(%) 계산 (별점 막대그래프용)
List<ReviewVO> reviews = storeShopMapper.selectProductReviews(productId);
product.setReviewList(reviews);
int[] count = new int[6]; // index 1~5 사용
for (ReviewVO r : reviews) {
    int star = (int) Math.round(r.getRating());
    if (star >= 1 && star <= 5) count[star]++;
}
int total = reviews.size();
product.setRating5Percent(total == 0 ? 0 : count[5] * 100 / total);
product.setRating4Percent(total == 0 ? 0 : count[4] * 100 / total);
product.setRating3Percent(total == 0 ? 0 : count[3] * 100 / total);
product.setRating2Percent(total == 0 ? 0 : count[2] * 100 / total);
product.setRating1Percent(total == 0 ? 0 : count[1] * 100 / total);

//지윤 26.07.07 Q&A 목록 조회
product.setQnaList(storeShopMapper.selectProductQna(productId));
    }
    return product;
}

//지윤 26.07.08 장바구니 목록은 가공 없이 그대로 전달
@Override
public List<CartItemVO> getCartItems(Long memberNo) {
    return storeShopMapper.selectCartItems(memberNo);
}

//지윤 26.07.08 장바구니 담기 1)회원 장바구니 없으면 생성 2)같은 상품+옵션 있으면 수량합산 3)없으면 새 줄 추가
@Override
public void addToCart(Long memberNo, Long productId, Long optionId, int qty, int price) {
    Long cartId = storeShopMapper.selectCartIdByMember(memberNo);
    if (cartId == null) {
        storeShopMapper.insertCart(memberNo);
        cartId = storeShopMapper.selectCartIdByMember(memberNo);
    }

    Long existingItemId = storeShopMapper.selectExistingCartItemId(cartId, productId, optionId);
    if (existingItemId != null) {
        storeShopMapper.updateCartItemQtyAdd(existingItemId, qty);
    } else {
        storeShopMapper.insertCartItem(cartId, productId, optionId, qty, price);
    }
}

//지윤 26.07.08 장바구니 수량 변경 (최소 1개)
@Override
public void updateCartItemQty(Long cartItemId, int qty) {
    if (qty < 1) qty = 1;
    storeShopMapper.updateCartItemQty(cartItemId, qty);
}

//지윤 26.07.08 장바구니 항목 삭제
@Override
public void deleteCartItem(Long cartItemId) {
    storeShopMapper.deleteCartItem(cartItemId);
}

//지윤 26.07.08 장바구니 항목 여러 개 한번에 삭제
@Override
public void deleteCartItems(java.util.List<Long> cartItemIds) {
    if (cartItemIds == null || cartItemIds.isEmpty()) return;
    storeShopMapper.deleteCartItems(cartItemIds);
}

//지윤 26.07.08 헤더 장바구니 뱃지용
@Override
public int getCartItemCount(Long memberNo) {
    return storeShopMapper.selectCartItemCount(memberNo);
}

//지윤 26.07.09 회원 보유쿠폰은 가공 없이 그대로 전달
@Override
public List<CouponVO> getMemberCoupons(Long memberNo) {
    return storeShopMapper.selectMemberCoupons(memberNo);
 }

//지윤 07.09 바로구매 클릭 시 해당상품 주문페이지로 이동
@Override
public List<CartItemVO> getDirectOrderItem(Long productId, Long optionId, int qty) {
    CartItemVO item = storeShopMapper.selectDirectOrderItem(productId, optionId);
    item.setQty(qty);
    return java.util.List.of(item);
}

//지윤 26.07.09 장바구니에서 체크한 항목들로 주문페이지 이동
@Override
public List<CartItemVO> getCartOrderItems(java.util.List<Long> cartItemIds) {
    return storeShopMapper.selectCartItemsByIds(cartItemIds);
}
//지윤 26.07.10 상품 Q&A 문의 등록
//지윤 26.07.12 수정: 등록 직후 QNA_ID 조회해서 반환하도록 변경 (프론트에서 삭제버튼 바로 붙이기 위함)
@Override
public Long addProductQna(Long productId, Long memberNo, String question) {
    storeShopMapper.insertProductQna(productId, memberNo, question);
    return storeShopMapper.selectLatestQnaId(productId, memberNo);
}

//지윤 26.07.12 상품 Q&A 삭제 (본인 글 + 답변 미완료 건만). 삭제된 row수가 0이면 실패(본인 아니거나 답변 이미 달림)
@Override
public boolean deleteProductQna(Long qnaId, Long memberNo) {
    return storeShopMapper.deleteProductQna(qnaId, memberNo) > 0;
}

//지윤 26.07.13 결제 완료 처리 (주문/주문상품/결제내역 저장 + 쿠폰/포인트 반영 + 장바구니 정리)
//@Transactional: 중간에 하나라도 실패하면 전부 롤백됨
@Override
@Transactional
public String completeOrder(OrderTempVO p, String tossPaymentKey, String tossOrderId) {
    String orderNo = "ORD-" + System.currentTimeMillis();

    // 상품이 전부 같은 사업자(BIZ_NO)라고 가정 (현재 테스트데이터가 단일 셀러 구조라 첫 상품 기준으로 넣음)
    Long bizNo = p.getOrderItems().get(0).getBizNo();

    storeShopMapper.insertOrder(orderNo, p.getMemberNo(), p.getProductTotal(), p.getDeliveryFee(),
            p.getTotalDiscount(), p.getPointUsed(), p.getFinalTotal(),
            p.getRecvName(), p.getRecvPhone(), p.getZipCode(), p.getAddr1(), p.getAddr2(), bizNo);

    Long orderId = storeShopMapper.selectOrderIdByOrderNo(orderNo);

    for (CartItemVO item : p.getOrderItems()) {
        storeShopMapper.insertOrderItem(orderId, item.getProductId(), item.getOptionId(),
                item.getOptionColor(), item.getOptionSize(), item.getProductName(),
                item.getQty(), item.getPrice(), item.getPrice() * item.getQty());

        //지윤 26.07.13 추가: 주문 확정된 만큼 재고 차감 (옵션 있으면 옵션 재고, 없으면 상품 재고)
        if (item.getOptionId() != null) {
            storeShopMapper.updateOptionStock(item.getOptionId(), item.getQty());
        } else {
            storeShopMapper.updateProductStock(item.getProductId(), item.getQty());
        }
    }

    storeShopMapper.insertPayment(orderId, "TOSS", p.getFinalTotal(), tossPaymentKey, tossOrderId);

    if (p.getCouponMemberCouponId() != null) {
        storeShopMapper.updateCouponUsed(p.getCouponMemberCouponId());
    }

    if (p.getPointUsed() != null && p.getPointUsed() > 0) {
        storeShopMapper.updateMemberPointBalance(p.getMemberNo(), p.getPointUsed());
        storeShopMapper.insertPointHistory(p.getMemberNo(), p.getPointUsed(), orderId);
    }

    if (p.getCartItemIds() != null && !p.getCartItemIds().isEmpty()) {
        storeShopMapper.deleteCartItems(p.getCartItemIds());
    }

    return orderNo;
}
}