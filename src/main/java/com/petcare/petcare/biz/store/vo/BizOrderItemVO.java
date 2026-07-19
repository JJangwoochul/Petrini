package com.petcare.petcare.biz.store.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.20 주문 상세 - 상품 목록 한 줄용 VO
@Getter @Setter
@ToString
@NoArgsConstructor
public class BizOrderItemVO {
    private Long orderItemId;
    private Long productId;
    private String productName;
    private String optionColor;
    private String optionSize;
    private Integer qty;
    private Integer unitPrice;
    private Integer totalPrice;
}