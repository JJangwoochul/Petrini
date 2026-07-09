package com.petcare.petcare.store.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.08 장바구니 항목(TB_CART_ITEM + 상품정보 조인) 조회용 VO
@Getter @Setter
@ToString
@NoArgsConstructor
public class CartItemVO {
    private Long cartItemId;
    private Long cartId;
    private Long productId;
    private Long optionId;
    private String productName;
    private String brandName;
    private String thumbnailUrl;
    private String optionColor;
    private String optionSize;
    private Integer qty;
    private Integer price;
    private Integer stockQty;
}