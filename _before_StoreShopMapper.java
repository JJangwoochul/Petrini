/**
 * ??븷: ?쇳븨紐?DB ?묎렐 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/store/StoreShopMapper.xml
 * namespace: com.petcare.petcare.store.mapper.StoreShopMapper
 *
 * 荑쇰━ ?덉떆
 * - selectProductList
 * - selectProductDetail
 * - selectCartItems
 * - insertOrder
 *
 * 李멸퀬 ?뚯씠釉? * - TB_PRODUCT
 * - TB_CART
 * - TB_ORDER
 *
 * SQL? XML?먮쭔 ?묒꽦 (@Select ???대끂?뚯씠???ъ슜 X)
 * 硫붿꽌?쒕챸? Service?먯꽌 ?몄텧?섎뒗 ?대쫫怨??숈씪?섍쾶
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
import com.petcare.petcare.store.vo.CartItemVO;
import com.petcare.petcare.store.vo.CouponVO;
import com.petcare.petcare.store.vo.BrandVO;

@Mapper
public interface StoreShopMapper {

    //吏??26.07.06 移댄뀒怨좊━/寃?됱뼱/?뺣젹/?섏씠吏?ㅼ씠???뚮씪誘명꽣(offset, size) 異붽?
    //吏??26.07.12 媛寃⑸?(minPrice/maxPrice)쨌釉뚮옖??brand) ?꾪꽣 ?뚮씪誘명꽣 異붽?
    List<StoreShopVO> selectProductList(@Param("categoryId") Long categoryId, @Param("keyword") String keyword,
                                         @Param("minPrice") Integer minPrice, @Param("maxPrice") Integer maxPrice,
                                         @Param("brand") String brand,
                                         @Param("sort") String sort, @Param("offset") int offset, @Param("size") int size);

    //吏??26.07.06 ?섏씠吏?ㅼ씠?섏슜 ?꾩껜 ?곹뭹 媛쒖닔 議고쉶 (移댄뀒怨좊━/寃??議곌굔? 紐⑸줉怨??숈씪?섍쾶 ?곸슜)
    //吏??26.07.12 媛寃⑸?쨌釉뚮옖???꾪꽣 ?뚮씪誘명꽣 異붽?
    int selectProductCount(@Param("categoryId") Long categoryId, @Param("keyword") String keyword,
                            @Param("minPrice") Integer minPrice, @Param("maxPrice") Integer maxPrice,
                            @Param("brand") String brand);

    //吏??26.07.12 釉뚮옖?쒕퀎 ?곹뭹 ??吏묎퀎 (移댄뀒怨좊━/寃??媛寃?議곌굔? 紐⑸줉怨??숈씪?섍쾶 ?곸슜, 釉뚮옖???꾪꽣 ?먯껜???쒖쇅?댁꽌 ?ㅻⅨ 釉뚮옖?쒕룄 怨꾩냽 ?좏깮 媛?ν븯寃???
    List<BrandVO> selectBrandCounts(@Param("categoryId") Long categoryId, @Param("keyword") String keyword,
                                     @Param("minPrice") Integer minPrice, @Param("maxPrice") Integer maxPrice);

    //吏??26.07.06 移댄뀒怨좊━ ?몃━ ?꾩껜 議고쉶
    List<CategoryVO> selectCategoryTree();

    //吏??26.07.07 ?곹뭹 ?곸꽭 議고쉶
   StoreShopVO selectProductDetail(@Param("productId") Long productId);

   //吏??26.07.07 ?곹뭹 ?대?吏 紐⑸줉 議고쉶
   List<String> selectProductImages(@Param("productId") Long productId);

   //吏??26.07.07 ?곹뭹 ?듭뀡 紐⑸줉 議고쉶
   List<OptionVO> selectProductOptions(@Param("productId") Long productId);

   //吏??26.07.07 ?곹뭹 由щ럭 紐⑸줉 議고쉶
   List<ReviewVO> selectProductReviews(@Param("productId") Long productId);

   //吏??26.07.07 ?곹뭹 Q&A 紐⑸줉 議고쉶
   List<QnaVO> selectProductQna(@Param("productId") Long productId);

   //吏??26.07.08 ?λ컮援щ땲 紐⑸줉 議고쉶 (?곹뭹/?듭뀡 ?뺣낫 議곗씤)
   List<CartItemVO> selectCartItems(@Param("memberNo") Long memberNo);

   //吏??26.07.08 ???뚯썝???λ컮援щ땲(CART_ID) 議고쉶, ?놁쑝硫?null
   Long selectCartIdByMember(@Param("memberNo") Long memberNo);

   //吏??26.07.08 ?좉퇋 ?λ컮援щ땲 ?앹꽦
   void insertCart(@Param("memberNo") Long memberNo);

   //吏??26.07.08 ?대? ?닿릿 ?곹뭹+?듭뀡?몄? ?뺤씤 (?덉쑝硫?洹?CART_ITEM_ID, ?놁쑝硫?null)
   Long selectExistingCartItemId(@Param("cartId") Long cartId, @Param("productId") Long productId, @Param("optionId") Long optionId);

   //吏??26.07.08 湲곗〈 ??ぉ ?섎웾 異붽?
   void updateCartItemQtyAdd(@Param("cartItemId") Long cartItemId, @Param("addQty") int addQty);

   //吏??26.07.08 ????ぉ 異붽?
   void insertCartItem(@Param("cartId") Long cartId, @Param("productId") Long productId, @Param("optionId") Long optionId, @Param("qty") int qty, @Param("price") int price);

   //吏??26.07.08 ?λ컮援щ땲 ?섎웾 蹂寃?   void updateCartItemQty(@Param("cartItemId") Long cartItemId, @Param("qty") int qty);

   //吏??26.07.08 ?λ컮援щ땲 ??ぉ ??젣
   void deleteCartItem(@Param("cartItemId") Long cartItemId);

   //吏??26.07.08 ?λ컮援щ땲 ??ぉ ?щ윭 媛??쒕쾲????젣 (?좏깮??젣/?꾩껜??젣??
   void deleteCartItems(@Param("cartItemIds") java.util.List<Long> cartItemIds);

   //吏??26.07.08 ?ㅻ뜑 ?λ컮援щ땲 諭껋???- ?뚯썝???λ컮援щ땲 ??ぉ 媛쒖닔
   int selectCartItemCount(@Param("memberNo") Long memberNo);

   //吏??26.07.09 ?뚯썝 蹂댁쑀荑좏룿 紐⑸줉 議고쉶 (誘몄궗??荑좏룿留?
   List<CouponVO> selectMemberCoupons(@Param("memberNo") Long memberNo);

   //吏??07.09 ?곹뭹 諛붾줈援щℓ -> 二쇰Ц?섏씠吏
   CartItemVO selectDirectOrderItem(@Param("productId") Long productId,
                                 @Param("optionId") Long optionId);

   //吏??26.07.09 ?λ컮援щ땲?먯꽌 泥댄겕????ぉ?ㅻ줈 二쇰Ц?섏씠吏 ?대룞
   List<CartItemVO> selectCartItemsByIds(@Param("cartItemIds") java.util.List<Long> cartItemIds);

   //吏??26.07.10 ?곹뭹 Q&A 臾몄쓽 ?깅줉
   void insertProductQna(@Param("productId") Long productId, @Param("memberNo") Long memberNo, @Param("question") String question);

   //吏??26.07.12 ?곹뭹 Q&A ??젣 (蹂몄씤 湲 + ?듬? 誘몄셿猷?嫄대쭔). ??젣??row??諛섑솚 (0?대㈃ ?ㅽ뙣 ?먯씤 援щ텇??
   int deleteProductQna(@Param("qnaId") Long qnaId, @Param("memberNo") Long memberNo);

   //吏??26.07.13 二쇰Ц ???(寃곗젣 ?꾨즺 ??
   void insertOrder(@Param("orderNo") String orderNo, @Param("memberNo") Long memberNo,
                      @Param("totalAmount") Integer totalAmount, @Param("deliveryFee") Integer deliveryFee,
                      @Param("discountAmount") Integer discountAmount, @Param("pointUsed") Integer pointUsed,
                      @Param("payAmount") Integer payAmount, @Param("recvName") String recvName,
                      @Param("recvPhone") String recvPhone, @Param("zipCode") String zipCode,
                      @Param("addr1") String addr1, @Param("addr2") String addr2, @Param("bizNo") Long bizNo);

    //吏??26.07.13 諛⑷툑 ??ν븳 二쇰Ц??ORDER_ID 議고쉶 (ORDER_NO??UNIQUE???닿구濡??섏쭦??議고쉶)
    Long selectOrderIdByOrderNo(@Param("orderNo") String orderNo);

    //吏??26.07.13 二쇰Ц?곹뭹 ???(二쇰Ц 1嫄대떦 ?щ윭 踰??몄텧)
    void insertOrderItem(@Param("orderId") Long orderId, @Param("productId") Long productId,
                          @Param("optionId") Long optionId, @Param("optionColor") String optionColor,
                          @Param("optionSize") String optionSize, @Param("productName") String productName,
                          @Param("qty") Integer qty, @Param("unitPrice") Integer unitPrice, @Param("totalPrice") Integer totalPrice);

    //吏??26.07.13 寃곗젣?댁뿭 ???    void insertPayment(@Param("orderId") Long orderId, @Param("payMethod") String payMethod,
                        @Param("payAmount") Integer payAmount, @Param("tossPaymentKey") String tossPaymentKey,
                        @Param("tossOrderId") String tossOrderId);

    //吏??26.07.13 荑좏룿 ?ъ슜 泥섎━
    void updateCouponUsed(@Param("memberCouponId") Long memberCouponId);

    //吏??26.07.13 ?ъ씤??李④컧
    void updateMemberPointBalance(@Param("memberNo") Long memberNo, @Param("pointUsed") Integer pointUsed);

    //吏??26.07.13 ?ъ씤???ъ슜 ?대젰 ???    void insertPointHistory(@Param("memberNo") Long memberNo, @Param("pointUsed") Integer pointUsed, @Param("orderId") Long orderId);
    
    //吏??26.07.12 諛⑷툑 ?깅줉??臾몄쓽??QNA_ID 議고쉶 (?깅줉 吏곹썑 ?붾㈃????젣踰꾪듉 諛붾줈 遺숈씠湲??꾪븿)
    Long selectLatestQnaId(@Param("productId") Long productId, @Param("memberNo") Long memberNo);

    //吏??26.07.13 二쇰Ц ?꾨즺 ???ш퀬 李④컧 - ?듭뀡 ?덈뒗 ?곹뭹??(TB_PRODUCT_OPTION.STOCK_QTY)
    void updateOptionStock(@Param("optionId") Long optionId, @Param("qty") Integer qty);

    //吏??26.07.15 異붽?: ?ш퀬 0 ?섎㈃ ?먮룞 ?덉젅 泥섎━
    int checkAndSetSoldout(@Param("productId") Long productId);

    //吏??26.07.16 異붽?: ?덉젅 ?뚮┝ 蹂대궪 ?ъ뾽???뚯썝踰덊샇 議고쉶
    Long selectBizMemberNoByBizNo(@Param("bizNo") Long bizNo);
}
