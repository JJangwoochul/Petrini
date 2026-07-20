package com.petcare.petcare.mypage.order.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.20 마이페이지 주문내역 - 주문 상품 한 줄용 VO
@Getter @Setter
@ToString
@NoArgsConstructor
public class MypageOrderItemVO {
    private Long orderItemId;     //지윤 26.07.20 추가: 리뷰작성 시 어느 주문상품인지 식별용
    private Long productId;
    private String productName;
    private String optionColor;
    private String optionSize;
    private Integer qty;
    private Integer totalPrice;
    private String thumbnailUrl;
    private boolean reviewed;     //지윤 26.07.20 추가: 이미 리뷰 작성했는지 (버튼 상태 분기용)
}