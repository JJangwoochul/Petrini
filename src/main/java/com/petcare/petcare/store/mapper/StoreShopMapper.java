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

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.OptionVO;
import com.petcare.petcare.store.vo.ReviewVO;
import com.petcare.petcare.store.vo.QnaVO;

@Mapper
public interface StoreShopMapper {

    //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터(offset, size) 추가
    List<StoreShopVO> selectProductList(@Param("categoryId") Long categoryId, @Param("keyword") String keyword,
                                         @Param("sort") String sort, @Param("offset") int offset, @Param("size") int size);

    //지윤 26.07.06 페이지네이션용 전체 상품 개수 조회 (카테고리/검색 조건은 목록과 동일하게 적용)
    int selectProductCount(@Param("categoryId") Long categoryId, @Param("keyword") String keyword);

    //지윤 26.07.06 카테고리 트리 전체 조회
    List<CategoryVO> selectCategoryTree();

    //지윤 26.07.07 상품 상세 조회
   StoreShopVO selectProductDetail(@Param("productId") Long productId);

   //지윤 26.07.07 상품 이미지 목록 조회
   List<String> selectProductImages(@Param("productId") Long productId);

   //지윤 26.07.07 상품 옵션 목록 조회
   List<OptionVO> selectProductOptions(@Param("productId") Long productId);

   //지윤 26.07.07 상품 리뷰 목록 조회
   List<ReviewVO> selectProductReviews(@Param("productId") Long productId);

   //지윤 26.07.07 상품 Q&A 목록 조회
   List<QnaVO> selectProductQna(@Param("productId") Long productId);
}