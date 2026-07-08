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

@Service
public class StoreShopServiceImpl implements StoreShopService {

    @Autowired
    private StoreShopMapper storeShopMapper;

    //지윤 26.07.06 페이지당 상품 개수 (요구사항 고정값)
    private static final int PAGE_SIZE = 12;

    //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터(pageNo) 추가
    @Override
    public List<StoreShopVO> getProductList(Long categoryId, String keyword, String sort, int pageNo) {
        int offset = (pageNo - 1) * PAGE_SIZE;
        List<StoreShopVO> list = storeShopMapper.selectProductList(categoryId, keyword, sort, offset, PAGE_SIZE);
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
  @Override
  public int getTotalPages(Long categoryId, String keyword) {
      int totalCount = storeShopMapper.selectProductCount(categoryId, keyword);
      return (int) Math.ceil(totalCount / (double) PAGE_SIZE);
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
}