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

    //지윤 26.07.22 추가: 취소신청 정보 (취소신청 탭/상세용)
    private String claimStatus;    // PENDING/DONE/REJECTED
    private String cancelReason;   // 유저가 입력한 취소사유
    private String requestedAt;    // 취소 신청일시
    private Integer refundAmount;  // 실제 환불금액 (승인완료 시에만 값 있음)

    //지윤 26.07.22 추가: 취소승인 처리(토스취소/재고/포인트/쿠폰 복구)에 필요한 값
    private Long memberNo;
    private Integer pointUsed;
    private Long memberCouponId;
    private String tossPaymentKey;
}