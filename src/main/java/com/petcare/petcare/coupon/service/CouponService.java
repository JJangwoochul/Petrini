package com.petcare.petcare.coupon.service;

import java.util.List;

import com.petcare.petcare.store.vo.CouponVO;

public interface CouponService {

    // 받을 수 있는 쿠폰 목록
    List<CouponVO> getAvailableCoupons(Long memberNo);

    // 보유 쿠폰 목록
    List<CouponVO> getMyCoupons(Long memberNo);

    // 사용 가능 보유 쿠폰 개수
    int countUsableCoupons(Long memberNo);

    // 쿠폰 받기
    void claimCoupon(Long memberNo, Long couponId);
}
