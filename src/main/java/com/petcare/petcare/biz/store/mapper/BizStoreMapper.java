/**
 * 역할: 사업자 쇼핑몰 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/biz/store/BizStoreMapper.xml
 * namespace: com.petcare.petcare.biz.store.mapper.BizStoreMapper
 *
 * 쿼리 예시
 * - selectBizDashboard
 * - selectProductList
 * - updateProduct
 * - selectOrderList
 * - updateOrderStatus
 * - selectReviewList
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_ORDER
 * - TB_ORDER_ITEM
 * - TB_REVIEW
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.biz.store.mapper;

public interface BizStoreMapper {}
