/**
 * ??븷: ?쇳븨紐??ъ슜?? 鍮꾩쫰?덉뒪 濡쒖쭅 (interface)
 *
 * ?대떦 ?붾㈃
 * - store/list.jsp            ?곹뭹 紐⑸줉
 * - store/detail.jsp          ?곹뭹 ?곸꽭
 * - store/cart.jsp            ?λ컮援щ땲
 * - store/order.jsp           二쇰Ц
 * - store/payment.jsp         寃곗젣
 * - store/order-complete.jsp  二쇰Ц ?꾨즺
 *
 * 援ы쁽??湲곕뒫 ?덉떆
 * - ?곹뭹 紐⑸줉쨌?곸꽭 議고쉶
 * - ?λ컮援щ땲쨌二쇰Ц쨌寃곗젣 泥섎━
 *
 * ?곌껐
 * - 援ы쁽: StoreShopServiceImpl
 * - ?몄텧: StoreShopController
 * - DB: StoreShopMapper
 *
 * 李멸퀬 ?뚯씠釉? * - TB_PRODUCT
 * - TB_CART
 * - TB_ORDER
 */

package com.petcare.petcare.store.service;

import java.util.List;

import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.CartItemVO;
import com.petcare.petcare.store.vo.CouponVO;
import com.petcare.petcare.store.vo.BrandVO;
import com.petcare.petcare.store.vo.OrderTempVO;

public interface StoreShopService {
//吏??26.07.06 移댄뀒怨좊━/寃?됱뼱/?뺣젹/?섏씠吏?ㅼ씠???뚮씪誘명꽣
//吏??26.07.12 媛寃⑸?(minPrice/maxPrice)쨌釉뚮옖??brand) ?꾪꽣 ?뚮씪誘명꽣 異붽?
List<StoreShopVO> getProductList(Long categoryId, String keyword, Integer minPrice, Integer maxPrice, String brand, String sort, int pageNo);

//吏??26.07.06 ?섏씠吏?ㅼ씠?섏슜 珥??섏씠吏 ??怨꾩궛
//吏??26.07.12 媛寃⑸?쨌釉뚮옖???꾪꽣 ?뚮씪誘명꽣 異붽?
int getTotalPages(Long categoryId, String keyword, Integer minPrice, Integer maxPrice, String brand);

//吏??26.07.12 ?ъ씠?쒕컮 釉뚮옖?쒕퀎 ?곹뭹 ??議고쉶
List<BrandVO> getBrandList(Long categoryId, String keyword, Integer minPrice, Integer maxPrice);

//吏??26.07.06 移댄뀒怨좊━ ?몃━ 議고쉶
List<CategoryVO> getCategoryTree();

//吏??26.07.07 ?곹뭹 ?곸꽭 議고쉶
StoreShopVO getProductDetail(Long productId);

//吏??26.07.08 ?λ컮援щ땲 紐⑸줉 議고쉶
List<CartItemVO> getCartItems(Long memberNo);

//吏??26.07.08 ?λ컮援щ땲 ?닿린 (媛숈? ?곹뭹+?듭뀡 ?덉쑝硫??섎웾 ?⑹묠, ?놁쑝硫??덈줈 異붽?)
void addToCart(Long memberNo, Long productId, Long optionId, int qty, int price);

//吏??26.07.08 ?λ컮援щ땲 ?섎웾 蹂寃?void updateCartItemQty(Long cartItemId, int qty);

//吏??26.07.08 ?λ컮援щ땲 ??ぉ ??젣
void deleteCartItem(Long cartItemId);

//吏??26.07.08 ?λ컮援щ땲 ??ぉ ?щ윭 媛??쒕쾲????젣 (?좏깮??젣/?꾩껜??젣??
void deleteCartItems(java.util.List<Long> cartItemIds);

//?λ컮援щ땲 ?レ옄諭껋?
int getCartItemCount(Long memberNo);

//吏??26.07.09 ?뚯썝 蹂댁쑀荑좏룿 紐⑸줉 議고쉶
List<CouponVO> getMemberCoupons(Long memberNo);

//吏??26.07.09 諛붾줈援щℓ ?대┃ ???대떦 ?곹뭹 二쇰Ц?섏씠吏 ?대룞
List<CartItemVO> getDirectOrderItem(Long productId, Long optionId, int qty);

//吏??26.07.09 ?λ컮援щ땲?먯꽌 泥댄겕????ぉ?ㅻ줈 二쇰Ц?섏씠吏 ?대룞
List<CartItemVO> getCartOrderItems(java.util.List<Long> cartItemIds);

//吏??26.07.12 ?섏젙: ?깅줉 吏곹썑 ??젣踰꾪듉 遺숈씠?ㅻ㈃ ?덈줈 ?앷릿 QNA_ID媛 ?꾩슂?댁꽌 void -> Long?쇰줈 蹂寃?Long addProductQna(Long productId, Long memberNo, String question);

//吏??26.07.12 ?곹뭹 Q&A ??젣 (蹂몄씤 湲 + ?듬? 誘몄셿猷?嫄대쭔). ?깃났 ?щ? 諛섑솚
boolean deleteProductQna(Long qnaId, Long memberNo);

//吏??26.07.13 寃곗젣 ?꾨즺 ??二쇰Ц/二쇰Ц?곹뭹/寃곗젣?댁뿭 ???+ 荑좏룿?ъ슜泥섎━ + ?ъ씤?몄감媛?+ 二쇰Ц???λ컮援щ땲??ぉ ??젣瑜????몃옖??뀡?쇰줈 泥섎━. ?앹꽦??ORDER_NO 諛섑솚
String completeOrder(OrderTempVO orderTemp, String tossPaymentKey, String tossOrderId);
}
