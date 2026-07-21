/**
 * ??븷: StoreShopService 援ы쁽泥?(@Service)
 *
 * 援ы쁽 ?댁슜
 * - Controller?먯꽌 ?섏뼱???붿껌 泥섎━
 * - Mapper ?몄텧?섏뿬 DB 議고쉶쨌?섏젙
 * - 鍮꾩쫰?덉뒪 洹쒖튃 寃利?諛?寃곌낵 諛섑솚
 *
 * ?곌껐
 * - implements: StoreShopService
 * - ?ъ슜: StoreShopMapper
 *
 * 鍮꾩쫰?덉뒪 濡쒖쭅? ?ш린???묒꽦 (Controller, Mapper??吏곸젒 ?묒꽦 X)
 */

package com.petcare.petcare.store.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petcare.petcare.store.mapper.StoreShopMapper;
import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.OptionVO;
import com.petcare.petcare.store.vo.ReviewVO;
import com.petcare.petcare.store.vo.QnaVO;
import com.petcare.petcare.store.vo.CartItemVO;
import com.petcare.petcare.store.vo.CouponVO;
import com.petcare.petcare.store.vo.BrandVO;
import com.petcare.petcare.store.vo.OrderTempVO;
import com.petcare.petcare.store.vo.CartItemVO;
import org.springframework.transaction.annotation.Transactional;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;

@Service
public class StoreShopServiceImpl implements StoreShopService {

    @Autowired
    private StoreShopMapper storeShopMapper;

    @Autowired
    private MypageNotifyService mypageNotifyService;

    //吏??26.07.06 ?섏씠吏???곹뭹 媛쒖닔 (?붽뎄?ы빆 怨좎젙媛?
    private static final int PAGE_SIZE = 12;

    //吏??26.07.06 移댄뀒怨좊━/寃?됱뼱/?뺣젹/?섏씠吏?ㅼ씠???뚮씪誘명꽣(pageNo) 異붽?, 26.07.12 媛寃⑸?쨌釉뚮옖???꾪꽣 ?뚮씪誘명꽣 異붽?
    @Override
    public List<StoreShopVO> getProductList(Long categoryId, String keyword, Integer minPrice, Integer maxPrice, String brand, String sort, int pageNo) {
        int offset = (pageNo - 1) * PAGE_SIZE;
        List<StoreShopVO> list = storeShopMapper.selectProductList(categoryId, keyword, minPrice, maxPrice, brand, sort, offset, PAGE_SIZE);
        for (StoreShopVO p : list) {
            if (p.getPrice() != null && p.getSalePrice() != null && p.getPrice() > 0) {
                int rate = (int) Math.round((p.getPrice() - p.getSalePrice()) * 100.0 / p.getPrice());
                p.setDiscountRate(rate);
            } else {
                p.setDiscountRate(0);
            }
        }
        return list;
    }

//吏??26.07.06 珥??섏씠吏 ??怨꾩궛 (?꾩껜媛쒖닔 / 12, ?섎㉧吏 ?덉쑝硫??щ┝)
//吏??26.07.12 媛寃⑸?쨌釉뚮옖???꾪꽣 ?뚮씪誘명꽣 異붽?
  @Override
  public int getTotalPages(Long categoryId, String keyword, Integer minPrice, Integer maxPrice, String brand) {
      int totalCount = storeShopMapper.selectProductCount(categoryId, keyword, minPrice, maxPrice, brand);
      return (int) Math.ceil(totalCount / (double) PAGE_SIZE);
  }

//吏??26.07.12 ?ъ씠?쒕컮 釉뚮옖?쒕퀎 ?곹뭹 ??議고쉶 (釉뚮옖???꾪꽣 ?먯껜???쒖쇅?댁꽌 ?ㅻⅨ 釉뚮옖?쒕룄 怨꾩냽 ?좏깮 媛??
  @Override
  public List<BrandVO> getBrandList(Long categoryId, String keyword, Integer minPrice, Integer maxPrice) {
      return storeShopMapper.selectBrandCounts(categoryId, keyword, minPrice, maxPrice);
  }

//吏??26.07.06 移댄뀒怨좊━ ?몃━??媛怨??놁씠 洹몃?濡??꾨떖
  @Override
  public List<CategoryVO> getCategoryTree() {
      return storeShopMapper.selectCategoryTree();
  }

//吏??26.07.07 ?곹뭹 ?곸꽭 議고쉶 + ?좎씤??怨꾩궛 (紐⑸줉議고쉶? ?숈씪??怨꾩궛 濡쒖쭅)
//吏??26.07.07 ?대?吏 紐⑸줉??媛숈씠 議고쉶?댁꽌 product??梨꾩썙?ｋ룄濡??섏젙
@Override
public StoreShopVO getProductDetail(Long productId) {
    StoreShopVO product = storeShopMapper.selectProductDetail(productId);
    if (product != null) {
        if (product.getPrice() != null && product.getSalePrice() != null && product.getPrice() > 0) {
            int rate = (int) Math.round((product.getPrice() - product.getSalePrice()) * 100.0 / product.getPrice());
            product.setDiscountRate(rate);
        } else {
            product.setDiscountRate(0);
        }
        product.setImageList(storeShopMapper.selectProductImages(productId));
        product.setOptionList(storeShopMapper.selectProductOptions(productId));

//吏??26.07.07 由щ럭 紐⑸줉 議고쉶 + 蹂꾩젏蹂?鍮꾩쑉(%) 怨꾩궛 (蹂꾩젏 留됰?洹몃옒?꾩슜)
List<ReviewVO> reviews = storeShopMapper.selectProductReviews(productId);
product.setReviewList(reviews);
int[] count = new int[6]; // index 1~5 ?ъ슜
for (ReviewVO r : reviews) {
    int star = (int) Math.round(r.getRating());
    if (star >= 1 && star <= 5) count[star]++;
}
int total = reviews.size();
product.setRating5Percent(total == 0 ? 0 : count[5] * 100 / total);
product.setRating4Percent(total == 0 ? 0 : count[4] * 100 / total);
product.setRating3Percent(total == 0 ? 0 : count[3] * 100 / total);
product.setRating2Percent(total == 0 ? 0 : count[2] * 100 / total);
product.setRating1Percent(total == 0 ? 0 : count[1] * 100 / total);

//吏??26.07.07 Q&A 紐⑸줉 議고쉶
product.setQnaList(storeShopMapper.selectProductQna(productId));
    }
    return product;
}

//吏??26.07.08 ?λ컮援щ땲 紐⑸줉? 媛怨??놁씠 洹몃?濡??꾨떖
@Override
public List<CartItemVO> getCartItems(Long memberNo) {
    return storeShopMapper.selectCartItems(memberNo);
}

//吏??26.07.08 ?λ컮援щ땲 ?닿린 1)?뚯썝 ?λ컮援щ땲 ?놁쑝硫??앹꽦 2)媛숈? ?곹뭹+?듭뀡 ?덉쑝硫??섎웾?⑹궛 3)?놁쑝硫???以?異붽?
@Override
public void addToCart(Long memberNo, Long productId, Long optionId, int qty, int price) {
    Long cartId = storeShopMapper.selectCartIdByMember(memberNo);
    if (cartId == null) {
        storeShopMapper.insertCart(memberNo);
        cartId = storeShopMapper.selectCartIdByMember(memberNo);
    }

    Long existingItemId = storeShopMapper.selectExistingCartItemId(cartId, productId, optionId);
    if (existingItemId != null) {
        storeShopMapper.updateCartItemQtyAdd(existingItemId, qty);
    } else {
        storeShopMapper.insertCartItem(cartId, productId, optionId, qty, price);
    }
}

//吏??26.07.08 ?λ컮援щ땲 ?섎웾 蹂寃?(理쒖냼 1媛?
@Override
public void updateCartItemQty(Long cartItemId, int qty) {
    if (qty < 1) qty = 1;
    storeShopMapper.updateCartItemQty(cartItemId, qty);
}

//吏??26.07.08 ?λ컮援щ땲 ??ぉ ??젣
@Override
public void deleteCartItem(Long cartItemId) {
    storeShopMapper.deleteCartItem(cartItemId);
}

//吏??26.07.08 ?λ컮援щ땲 ??ぉ ?щ윭 媛??쒕쾲????젣
@Override
public void deleteCartItems(java.util.List<Long> cartItemIds) {
    if (cartItemIds == null || cartItemIds.isEmpty()) return;
    storeShopMapper.deleteCartItems(cartItemIds);
}

//吏??26.07.08 ?ㅻ뜑 ?λ컮援щ땲 諭껋???@Override
public int getCartItemCount(Long memberNo) {
    return storeShopMapper.selectCartItemCount(memberNo);
}

//吏??26.07.09 ?뚯썝 蹂댁쑀荑좏룿? 媛怨??놁씠 洹몃?濡??꾨떖
@Override
public List<CouponVO> getMemberCoupons(Long memberNo) {
    return storeShopMapper.selectMemberCoupons(memberNo);
 }

//吏??07.09 諛붾줈援щℓ ?대┃ ???대떦?곹뭹 二쇰Ц?섏씠吏濡??대룞
@Override
public List<CartItemVO> getDirectOrderItem(Long productId, Long optionId, int qty) {
    CartItemVO item = storeShopMapper.selectDirectOrderItem(productId, optionId);
    item.setQty(qty);
    return java.util.List.of(item);
}

//吏??26.07.09 ?λ컮援щ땲?먯꽌 泥댄겕????ぉ?ㅻ줈 二쇰Ц?섏씠吏 ?대룞
@Override
public List<CartItemVO> getCartOrderItems(java.util.List<Long> cartItemIds) {
    return storeShopMapper.selectCartItemsByIds(cartItemIds);
}
//吏??26.07.10 ?곹뭹 Q&A 臾몄쓽 ?깅줉
//吏??26.07.12 ?섏젙: ?깅줉 吏곹썑 QNA_ID 議고쉶?댁꽌 諛섑솚?섎룄濡?蹂寃?(?꾨줎?몄뿉????젣踰꾪듉 諛붾줈 遺숈씠湲??꾪븿)
@Override
public Long addProductQna(Long productId, Long memberNo, String question) {
    storeShopMapper.insertProductQna(productId, memberNo, question);
    return storeShopMapper.selectLatestQnaId(productId, memberNo);
}

//吏??26.07.12 ?곹뭹 Q&A ??젣 (蹂몄씤 湲 + ?듬? 誘몄셿猷?嫄대쭔). ??젣??row?섍? 0?대㈃ ?ㅽ뙣(蹂몄씤 ?꾨땲嫄곕굹 ?듬? ?대? ?щ┝)
@Override
public boolean deleteProductQna(Long qnaId, Long memberNo) {
    return storeShopMapper.deleteProductQna(qnaId, memberNo) > 0;
}

//吏??26.07.13 寃곗젣 ?꾨즺 泥섎━ (二쇰Ц/二쇰Ц?곹뭹/寃곗젣?댁뿭 ???+ 荑좏룿/?ъ씤??諛섏쁺 + ?λ컮援щ땲 ?뺣━)
//@Transactional: 以묎컙???섎굹?쇰룄 ?ㅽ뙣?섎㈃ ?꾨? 濡ㅻ갚??@Override
@Transactional
public String completeOrder(OrderTempVO p, String tossPaymentKey, String tossOrderId) {
    String orderNo = "ORD-" + System.currentTimeMillis();

    // ?곹뭹???꾨? 媛숈? ?ъ뾽??BIZ_NO)?쇨퀬 媛??(?꾩옱 ?뚯뒪?몃뜲?댄꽣媛 ?⑥씪 ???援ъ“??泥??곹뭹 湲곗??쇰줈 ?ｌ쓬)
    Long bizNo = p.getOrderItems().get(0).getBizNo();

    storeShopMapper.insertOrder(orderNo, p.getMemberNo(), p.getProductTotal(), p.getDeliveryFee(),
            p.getTotalDiscount(), p.getPointUsed(), p.getFinalTotal(),
            p.getRecvName(), p.getRecvPhone(), p.getZipCode(), p.getAddr1(), p.getAddr2(), bizNo);

    Long orderId = storeShopMapper.selectOrderIdByOrderNo(orderNo);

    for (CartItemVO item : p.getOrderItems()) {
        storeShopMapper.insertOrderItem(orderId, item.getProductId(), item.getOptionId(),
                item.getOptionColor(), item.getOptionSize(), item.getProductName(),
                item.getQty(), item.getPrice(), item.getPrice() * item.getQty());

        //吏??26.07.13 異붽?: 二쇰Ц ?뺤젙??留뚰겮 ?ш퀬 李④컧 (?듭뀡 ?덉쑝硫??듭뀡 ?ш퀬, ?놁쑝硫??곹뭹 ?ш퀬)
        //吏??26.07.15 ?섏젙: ?듭뀡 ?ш퀬 源롮쓣 ?뚮룄 ?곹뭹 ?꾩껜 ?ш퀬瑜?媛숈씠 源롮븘??紐⑸줉/?곹깭 ?쒖떆媛 留욎쓬
        if (item.getOptionId() != null) {
            storeShopMapper.updateOptionStock(item.getOptionId(), item.getQty());
        }

        //吏??26.07.15 ?섏젙: 李④컧 ???곹뭹 ?꾩껜 ?ш퀬媛 0?대㈃ ?먮룞 ?덉젅 泥섎━
        //吏??26.07.16 ?섏젙: 諛⑷툑 ?덉젅濡?"?덈줈 諛붾? 寃쎌슦?먮쭔(諛섑솚媛?0) ?ъ뾽?먯뿉寃??뚮┝ ?꾩넚
        int soldoutJustNow = storeShopMapper.checkAndSetSoldout(item.getProductId());
        if (soldoutJustNow > 0) {
            Long bizMemberNo = storeShopMapper.selectBizMemberNoByBizNo(item.getBizNo());
            mypageNotifyService.sendProductSoldoutNotification(bizMemberNo, item.getProductName(), item.getProductId());
        }
    }

    storeShopMapper.insertPayment(orderId, "TOSS", p.getFinalTotal(), tossPaymentKey, tossOrderId);

    if (p.getCouponMemberCouponId() != null) {
        storeShopMapper.updateCouponUsed(p.getCouponMemberCouponId());
    }

    if (p.getPointUsed() != null && p.getPointUsed() > 0) {
        storeShopMapper.updateMemberPointBalance(p.getMemberNo(), p.getPointUsed());
        storeShopMapper.insertPointHistory(p.getMemberNo(), p.getPointUsed(), orderId);
    }

    if (p.getCartItemIds() != null && !p.getCartItemIds().isEmpty()) {
        storeShopMapper.deleteCartItems(p.getCartItemIds());
    }

    return orderNo;
}
}
