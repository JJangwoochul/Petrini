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

/**
 * 역할: 쇼핑몰 DB 접근 (MyBatis interface)
 * ...
 */

package com.petcare.petcare.store.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;

@Mapper
public interface StoreShopMapper {
   //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터(offset, size) 추가
  List<StoreShopVO> selectProductList(@Param("categoryId") Long categoryId, @Param("keyword") String keyword,
  @Param("sort") String sort, @Param("offset") int offset, @Param("size") int size);

  //지윤 26.07.06 페이지네이션용 전체 상품 개수 조회 (카테고리/검색 조건은 목록과 동일하게 적용)
  int selectProductCount(@Param("categoryId") Long categoryId, @Param("keyword") String keyword);

  //지윤 26.07.06 카테고리 트리 전체 조회
  List<CategoryVO> selectCategoryTree();
}
