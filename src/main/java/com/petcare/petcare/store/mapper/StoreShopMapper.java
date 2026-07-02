/**
 * 역할: 쇼핑몰 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/store/StoreShopMapper.xml
 * namespace: com.petcare.petcare.store.mapper.StoreShopMapper
 *
 * 쿼리 예시
 * - selectProductList
 * - selectProductDetail
 * - selectCartItems
 * - insertOrder
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_CART
 * - TB_ORDER
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.store.mapper;

public interface StoreShopMapper {}
