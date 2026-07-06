/**
 * 역할: 쇼핑몰 상품·주문 데이터 객체
 *
 * 필드 예시
 * - productId, productName, price, quantity, orderId
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_CART
 * - TB_ORDER
 *
 * DB 컬럼명은 팀 VO 규칙(camelCase)에 맞게 작성
 */

package com.petcare.petcare.store.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Component;

@Getter @Setter
@ToString
@NoArgsConstructor
@Component("storeShopVO")
public class StoreShopVO {

    // ===== 상품 목록/상세 (TB_PRODUCT) =====
    private Long productId;
    private String productCd;
    private String productName;
    private String brandName;
    private Long categoryId;
    private String categoryName;
    private Integer price;
    private Integer salePrice;
    private Integer discountRate;
    private Integer stockQty;
    private String thumbnailUrl;

    // ===== 리뷰 (TB_REVIEW, 아직 더미데이터 없음 → 0으로 표시됨) =====
    private Double avgRating;
    private Integer reviewCount;
}
