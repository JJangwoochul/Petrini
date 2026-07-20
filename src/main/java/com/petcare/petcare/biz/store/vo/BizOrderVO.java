package com.petcare.petcare.biz.store.vo;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.20 사업자 주문목록/상세 조회용 VO
@Getter @Setter
@ToString
@NoArgsConstructor
public class BizOrderVO {
    private Long orderId;
    private String orderNo;
    private String orderStatus;
    private Integer payAmount;
    private String orderDate;
    private String buyerName;
    private String firstProductName;
    private Integer itemCount;

    //지윤 26.07.20 추가: 상세보기 전용 필드
    private String buyerPhone;
    private String buyerEmail;
    private String recvName;
    private String recvPhone;
    private String zipCode;
    private String addr1;
    private String addr2;
    private String payMethod;
    private String courierName;
    private String trackingNo;
    private String deliveryStatus;
    private List<BizOrderItemVO> itemList;
}