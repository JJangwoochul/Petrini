/**
 * 역할: 쿠폰 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/event/coupon/EventCouponMapper.xml
 * namespace: com.petcare.petcare.event.coupon.mapper.EventCouponMapper
 *
 * 쿼리 예시
 * - selectCouponList
 * - selectMemberCoupons
 * - insertMemberCoupon
 * - updateCouponUsed
 *
 * 참고 테이블
 * - TB_COUPON
 * - TB_MEMBER_COUPON
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.event.coupon.mapper;

public interface EventCouponMapper {}
