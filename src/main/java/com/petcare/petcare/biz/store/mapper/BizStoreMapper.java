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

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.biz.store.vo.BizProductVO;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.OptionVO;

@Mapper
public interface BizStoreMapper {

    //지윤 26.07.14 로그인 ID(BIZ_ID)로 BIZ_NO 조회
    //세션(MemberVO)엔 bizNo가 없고 로그인 ID(=BIZ_ID)만 있어서, 매 요청마다 TB_BUSINESS에서 되짚어 조회함
    Long selectBizNoByBizId(@Param("bizId") String bizId);

    //지윤 26.07.14 사업자 상품목록 조회
    //로그인한 사업자(bizNo)가 등록한 상품만, 상품명 검색(keyword)/카테고리(categoryId)/상태(statusCd) 필터 적용
    //offset/size로 페이지네이션 처리 (한 페이지에 몇 개씩 보여줄지)
    List<BizProductVO> selectProductList(@Param("bizNo") Long bizNo, @Param("keyword") String keyword,
                                          @Param("categoryId") Long categoryId, @Param("statusCd") String statusCd,
                                          @Param("offset") int offset, @Param("size") int size);

    //지윤 26.07.14 상품목록 전체 개수 조회 (페이지네이션에서 "총 몇 페이지"를 계산하기 위함, 필터 조건은 목록 조회와 동일)
    int selectProductCount(@Param("bizNo") Long bizNo, @Param("keyword") String keyword,
                            @Param("categoryId") Long categoryId, @Param("statusCd") String statusCd);

    //지윤 26.07.14 상품 등록 시 사용할 다음 PRODUCT_ID를 미리 조회
    //PRODUCT_CD("P-0025" 형식)를 만들려면 새 ID값이 먼저 필요해서, INSERT 전에 이 값부터 뽑음
    Long selectNextProductId();

    //지윤 26.07.14 상품 등록 (실제 TB_PRODUCT에 새 상품 저장)
    void insertProduct(@Param("productId") Long productId, @Param("productCd") String productCd,
                        @Param("productName") String productName, @Param("bizNo") Long bizNo,
                        @Param("categoryId") Long categoryId, @Param("price") Integer price,
                        @Param("salePrice") Integer salePrice, @Param("stockQty") Integer stockQty,
                        @Param("description") String description, @Param("brandName") String brandName,
                        @Param("statusCd") String statusCd);

    //지윤 26.07.14 상품 등록 시 이미지 URL도 같이 저장 (TB_FILE에 REF_TYPE='PRODUCT'로 저장)
    void insertProductImage(@Param("productId") Long productId, @Param("fileUrl") String fileUrl,
                             @Param("originName") String originName);

    //지윤 26.07.14 상품 상세 1건 조회 (수정 모달 열 때, 기존 값 채워서 보여주기 위함)
    //bizNo 조건도 같이 걸어서, 다른 사업자 상품 ID를 넣어도 조회 자체가 안 되게 막음
    BizProductVO selectProductDetail(@Param("productId") Long productId, @Param("bizNo") Long bizNo);

    //지윤 26.07.14 상품 수정
    //WHERE절에 bizNo도 같이 걸어서 본인이 등록한 상품만 수정되게 함 (다른 사업자 상품 ID로 요청 보내도 0건 수정되고 조용히 끝남)
    //statusCd도 같이 받아서 판매중/품절/입고대기/판매중지 상태를 강제로 바꿀 수 있게 함
    int updateProduct(@Param("productId") Long productId, @Param("bizNo") Long bizNo,
                       @Param("productName") String productName, @Param("categoryId") Long categoryId,
                       @Param("price") Integer price, @Param("salePrice") Integer salePrice,
                       @Param("stockQty") Integer stockQty, @Param("description") String description,
                       @Param("brandName") String brandName, @Param("statusCd") String statusCd);

    //지윤 26.07.14 상품 등록/수정 폼의 카테고리 드롭다운용
    //최하위(4단계) 카테고리만 조회 (TB_PRODUCT.CATEGORY_ID가 실제로 참조하는 단계라서 그것만 골라옴)
    List<CategoryVO> selectLeafCategories();

    //지윤 26.07.15 상품 옵션 목록 조회 (목록/상세 화면에서 옵션별(색상, 사이즈) 재고 나눠서 보여줄 때 사용)
    List<OptionVO> selectProductOptions(@Param("productId") Long productId);

    //지윤 26.07.15 옵션 등록 시 다음 OPTION_ID 조회 (SEQ_PRODUCT_OPTION 시퀀스 있으면 이 메서드 SQL만 바꾸면 됨)
    Long selectNextOptionId();

    //지윤 26.07.15 상품 옵션 등록 (등록/수정 공통으로 사용)
    void insertProductOption(@Param("optionId") Long optionId, @Param("productId") Long productId,
                              @Param("optionColor") String optionColor, @Param("optionSize") String optionSize,
                              @Param("addPrice") Integer addPrice, @Param("stockQty") Integer stockQty);

    //지윤 26.07.15 상품 옵션 전체 삭제 (수정 시 기존 옵션 지우고 새로 등록하는 방식이라 필요)
    void deleteProductOptions(@Param("productId") Long productId);
}