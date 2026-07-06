/**
 * 역할: 관리자 쇼핑몰 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/admin/store/AdminStoreMapper.xml
 * namespace: com.petcare.petcare.admin.store.mapper.AdminStoreMapper
 *
 * 쿼리 예시
 * - selectProductList
 * - selectProductDetail
 * - insertProduct
 * - updateProduct
 * - selectOrderList
 * - selectOrderDetail
 * - updateOrderStatus
 * - selectCategoryList
 * - insertCategory
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_ORDER
 * - TB_ORDER_ITEM
 * - TB_CATEGORY
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.admin.store.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface AdminStoreMapper {}
