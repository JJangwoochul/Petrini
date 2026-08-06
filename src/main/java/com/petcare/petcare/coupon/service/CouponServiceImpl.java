package com.petcare.petcare.coupon.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.coupon.mapper.CouponMapper;
import com.petcare.petcare.store.vo.CouponVO;
import com.petcare.petcare.store.vo.StoreShopVO;

@Service
public class CouponServiceImpl implements CouponService {

    @Autowired
    private CouponMapper eventCouponMapper;

    @Override
    public List<CouponVO> getAvailableCoupons(Long memberNo) {
        return eventCouponMapper.selectAvailableCoupons(memberNo);
    }

    @Override
    public List<CouponVO> getMyCoupons(Long memberNo) {
        return eventCouponMapper.selectMyCoupons(memberNo);
    }

    @Override
    public int countUsableCoupons(Long memberNo) {
    return eventCouponMapper.countUsableCoupons(memberNo);
    }

    // 지윤 26.08.06: 쿠폰과 발급 사업자 정보 조회
    @Override
    public CouponVO getCouponTarget(Long couponId) {
    return eventCouponMapper.selectCouponTarget(couponId);
    }

    // 지윤 26.08.06: 쿠폰 발급 쇼핑몰의 적용 상품 조회
    // 지윤 26.08.06: 쿠폰 적용 상품 검색 및 정렬
@Override
public List<StoreShopVO> getCouponProducts(
        String bizNo,
        String sort,
        String keyword
) {
    return eventCouponMapper.selectCouponProducts(
            bizNo,
            sort,
            keyword
    );
}
@Override
@Transactional
public void claimCoupon(Long memberNo, Long couponId) {
        // 1) 이미 받았는지 체크 (중복발급 방지)
        int already = eventCouponMapper.countMemberCoupon(memberNo, couponId);
        if (already > 0) {
            throw new IllegalStateException("ALREADY_CLAIMED");
        }

        // 2) 쿠폰 존재 여부만 확인
        CouponVO coupon = eventCouponMapper.selectCouponById(couponId);
        if (coupon == null) {
            throw new IllegalArgumentException("COUPON_NOT_FOUND");
        }

        // 3) TB_MEMBER_COUPON INSERT
        eventCouponMapper.insertMemberCoupon(memberNo, couponId);

        // 4) TB_COUPON 발급수량·예산 갱신
        eventCouponMapper.updateCouponIssued(couponId, coupon.getDiscountValue());
    }
}
