package com.petcare.petcare.store.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.09 회원 보유쿠폰(TB_MEMBER_COUPON + TB_COUPON 조인) 조회용 VO
@Getter @Setter
@ToString
@NoArgsConstructor
public class CouponVO {
    private Long memberCouponId;
    private Long couponId;
    private String couponName;
    private String couponType;
    private Integer discountValue;
    private Integer minOrderAmt;
}