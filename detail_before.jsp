<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 吏??26.07.07 異붽?: 媛寃?肄ㅻ쭏 ?쒖떆??fmt ?쒓렇 --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 吏??26.07.15 異붽?: ?대?吏 URL??http濡??쒖옉?섎뒗吏 寃?ъ슜 (?몃? URL vs 濡쒖뺄 ?낅줈??援щ텇) --%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%-- 吏??26.07.07 ?섏젙: URL param.id 洹몃?濡??곕뜕 寃?-> Controller媛 ?섍꺼以 product 媛앹껜??productId濡?蹂寃?(?ㅻ뜲?댄꽣 ?곕룞) --%>
<c:set var="productId" value="${product.productId}" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
.detail-wrap { max-width:var(--inner-width); margin:32px auto 80px; padding:0 20px; }
.breadcrumb { font-size:13px; color:var(--text-muted); margin-bottom:24px; }
.breadcrumb a { color:var(--text-muted); text-decoration:none; } .breadcrumb a:hover { color:var(--primary); }
.breadcrumb span { margin:0 6px; }
.detail-top { display:grid; grid-template-columns:1fr 1fr; gap:40px; margin-bottom:48px; }
/* ?대?吏 */
.detail-gallery {}
.detail-main-img { width:100%; aspect-ratio:1/1; object-fit:cover; border-radius:var(--radius-md); display:block; margin-bottom:12px; }
.detail-thumbs { display:flex; gap:8px; }
.detail-thumb { width:72px; height:72px; border-radius:var(--radius-sm); object-fit:cover; cursor:pointer; border:2px solid transparent; transition:var(--transition); }
.detail-thumb.active,.detail-thumb:hover { border-color:var(--primary); }
/* ?뺣낫 */
.detail-info {}
.detail-brand { font-size:13px; color:var(--text-muted); margin-bottom:6px; }
.detail-name { font-size:22px; font-weight:800; color:var(--text-main); margin-bottom:12px; line-height:1.3; }
.detail-rating { display:flex; align-items:center; gap:8px; margin-bottom:16px; padding-bottom:16px; border-bottom:1px solid var(--border); }
.detail-rating svg { width:14px; height:14px; fill:var(--yellow); }
.detail-rating span { font-size:13px; color:var(--text-muted); }
.detail-price-wrap { margin-bottom:20px; }
.detail-price-rate { font-size:20px; font-weight:800; color:var(--accent); }
.detail-price-sale { font-size:28px; font-weight:800; color:var(--text-main); margin-left:6px; }
.detail-price-origin { font-size:14px; color:var(--text-muted); text-decoration:line-through; margin-top:2px; }
.detail-tags { display:flex; gap:6px; flex-wrap:wrap; margin-bottom:20px; }
.detail-tag { font-size:12px; background:var(--primary-light); color:var(--primary-dark); padding:4px 10px; border-radius:20px; font-weight:600; }
.detail-option { margin-bottom:16px; }
.detail-option label { font-size:13px; font-weight:600; color:var(--text-sub); display:block; margin-bottom:6px; }
.detail-option select,.detail-qty-wrap input { border:1px solid var(--border); border-radius:var(--radius-sm); padding:10px 14px; font-size:14px; color:var(--text-main); outline:none; width:100%; box-sizing:border-box; }
.detail-option select:focus { border-color:var(--primary); }
.detail-qty-wrap { display:flex; border:1px solid var(--border); border-radius:var(--radius-sm); overflow:hidden; }
.detail-qty-wrap button { width:40px; background:#f5f5f5; border:none; font-size:18px; cursor:pointer; color:var(--text-sub); flex-shrink:0; }
.detail-qty-wrap button:hover { background:var(--primary-light); color:var(--primary); }
.detail-qty-wrap input { border:none; border-left:1px solid var(--border); border-right:1px solid var(--border); text-align:center; width:60px; flex:1; }
.detail-total { background:var(--bg-page); border-radius:var(--radius-sm); padding:14px 16px; margin-bottom:20px; display:flex; justify-content:space-between; align-items:center; }
.detail-total span { font-size:13px; color:var(--text-muted); }
.detail-total strong { font-size:20px; font-weight:800; color:var(--primary-dark); }
.detail-btn-row { display:flex; gap:10px; }
.btn-wish-detail { flex:1; padding:14px; border:2px solid var(--primary); border-radius:var(--radius-sm); background:#fff; color:var(--primary); font-size:15px; font-weight:700; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:6px; }
.btn-wish-detail svg { width:18px; height:18px; stroke:currentColor; fill:none; stroke-width:2; }
.btn-cart-detail { flex:2; padding:14px; border:none; border-radius:var(--radius-sm); background:var(--primary); color:#fff; font-size:15px; font-weight:700; cursor:pointer; }
/* 吏??26.07.08 異붽?: 諛붾줈援щℓ 踰꾪듉 ?ㅽ???(湲곗〈???ㅽ????뺤쓽 ?먯껜媛 ?놁뼱??釉뚮씪?곗? 湲곕낯 踰꾪듉?쇰줈 蹂댁??? */
.btn-buy-now { flex:1; padding:14px; border:1px solid var(--primary); border-radius:var(--radius-sm); background:#fff; color:var(--primary); font-size:15px; font-weight:700; cursor:pointer; transition:var(--transition); }
.btn-buy-now:hover { background:var(--primary-light); }
.btn-buy-detail { flex:2; padding:14px; border:none; border-radius:var(--radius-sm); background:var(--text-main); color:#fff; font-size:15px; font-weight:700; cursor:pointer; }
/* ??*/
.detail-tab-bar { display:flex; border-bottom:2px solid var(--border); margin-bottom:28px; }
.detail-tab { padding:12px 24px; font-size:14px; font-weight:600; color:var(--text-muted); border:none; background:none; cursor:pointer; border-bottom:2px solid transparent; margin-bottom:-2px; transition:var(--transition); }
.detail-tab.on { color:var(--primary); border-bottom-color:var(--primary); }
.tab-section { display:none; } .tab-section.on { display:block; }
/* 由щ럭 */
.review-summary { display:flex; gap:32px; align-items:center; background:var(--bg-page); border-radius:var(--radius-md); padding:24px; margin-bottom:24px; }
.review-avg { text-align:center; }
.review-avg .big { font-size:48px; font-weight:800; color:var(--text-main); line-height:1; }
.review-avg small { font-size:13px; color:var(--text-muted); }
.review-stars { display:flex; gap:3px; justify-content:center; margin:6px 0; }
.review-stars svg { width:18px; height:18px; fill:var(--yellow); }
.review-bars { flex:1; display:flex; flex-direction:column; gap:6px; }
.review-bar-row { display:flex; align-items:center; gap:10px; font-size:12px; color:var(--text-muted); }
.review-bar-bg { flex:1; height:6px; background:var(--border); border-radius:3px; overflow:hidden; }
.review-bar-fill { height:100%; background:var(--yellow); border-radius:3px; }
.review-card { border:1px solid var(--border); border-radius:var(--radius-md); padding:18px; margin-bottom:14px; }
.review-card-head { display:flex; justify-content:space-between; margin-bottom:10px; }
.reviewer { font-size:14px; font-weight:700; color:var(--text-main); }
.review-date { font-size:12px; color:var(--text-muted); }
.review-text { font-size:14px; color:var(--text-sub); line-height:1.6; }
</style>

<div class="detail-wrap">
  <div class="breadcrumb">
    <a href="${contextPath}/">??/a><span>??/span>
    <a href="${contextPath}/store">?곹뭹</a><span>??/span>
    <%-- 吏??26.07.07 ?섏젙: ?섎뱶肄붾뵫??移댄뀒怨좊━紐??곹뭹紐?-> product ?ㅻ뜲?댄꽣濡?蹂寃?--%>
    <a href="${contextPath}/store">${product.categoryName}</a><span>??/span>
    ${product.productName}
  </div>

  <div class="detail-top">
    <%-- ?대?吏 媛ㅻ윭由?--%>
    <div class="detail-gallery">

      <%-- 吏??26.07.07 ?섏젙: 硫붿씤 ?곹뭹 怨좎젙 ?대?吏 URL -> DB?먯꽌 媛?몄삩 product.thumbnailUrl濡?蹂寃?--%>
     <%-- 吏??26.07.15 ?섏젙: 濡쒖뺄 ?낅줈???대?吏??/upload/ ?묐몢???꾩슂, ?몃?(紐⑹뾽) URL? 洹몃?濡?--%>
     <img class="detail-main-img" id="mainImg"
     src="${fn:startsWith(product.thumbnailUrl,'http') ? product.thumbnailUrl : contextPath.concat('/upload/').concat(product.thumbnailUrl)}"
     alt="${product.productName}" onerror="this.src='https://placehold.co/600x600/EAF7F2/2BAB82?text=?곹뭹'">

      <%-- 吏??26.07.07 ?섏젙: ?몃꽕??3媛??섎뱶肄붾뵫 -> TB_FILE ?ㅻ뜲?댄꽣濡?媛쒖닔 ?곴??놁씠 ?먮룞 諛섎났
     ?대?吏 ?녿뒗 ?곹뭹? imageList媛 鍮?由ъ뒪?몃씪 ?먮룞?쇰줈 ?몃꽕??以??먯껜媛 ??蹂댁엫 --%>
   <div class="detail-thumbs">
    <c:forEach var="img" items="${product.imageList}" varStatus="loop">
    <c:set var="thumbSrc" value="${fn:startsWith(img,'http') ? img : contextPath.concat('/upload/').concat(img)}"/>
    <img class="detail-thumb ${loop.first ? 'active' : ''}" src="${thumbSrc}" alt="${product.productName} ${loop.index+1}" onclick="switchImg(this,'${thumbSrc}')">
    </c:forEach>
    </div>
    </div>

    <%-- ?곹뭹 ?뺣낫 --%>
    <div class="detail-info">
      <%-- 吏??26.07.07 ?섏젙: 釉뚮옖???곹뭹紐??됱젏/媛寃??섎뱶肄붾뵫 -> product ?ㅻ뜲?댄꽣濡?蹂寃?     蹂??꾩씠肄?5媛?怨좎젙 -> 1媛쒕쭔 ?④린怨??띿뒪?몃줈 ?泥?(吏꾩쭨 蹂꾩젏 ?뚮뜑留곸? 由щ럭 ?④퀎?먯꽌 泥섎━ ?덉젙) --%>
    <div class="detail-brand">${product.brandName}</div>
    <div class="detail-name">${product.productName}</div>
    <div class="detail-rating">
      <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
      <span>${product.avgRating}??(${product.reviewCount}媛?由щ럭)</span>
    </div>
    <div class="detail-price-wrap">
    <div>
     <c:if test="${product.discountRate > 0}"><span class="detail-price-rate">${product.discountRate}%</span></c:if>
     <span class="detail-price-sale"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>??/span>
    </div>
    <c:if test="${product.discountRate > 0}">
    <div class="detail-price-origin">?뺢? <fmt:formatNumber value="${product.price}" pattern="#,###"/>??/div>
     </c:if>
    </div>

      <div class="detail-tags">
        <span class="detail-tag">臾대즺諛곗넚</span>
        <span class="detail-tag">以묓삎寃??곹빀</span>
        <span class="detail-tag">湲猷⑦뀗 ?꾨━</span>
        <span class="detail-tag">?ㅻ찓媛3 ?⑥쑀</span>
      </div>

      <%-- 吏??26.07.07 ?섏젙: ?⑸웾 ?섎뱶肄붾뵫 -> TB_PRODUCT_OPTION ?ㅻ뜲?댄꽣濡?蹂寃?     ?됱긽???녾굅??'湲곕낯'?대㈃ ?됱긽 ?쒖떆 ?앸왂, ?ъ씠利덈쭔 ?쒖떆 --%>
<div class="detail-option">
  <label>?듭뀡 ?좏깮</label>
  <select id="optionSelect" onchange="onOptionChange()">
    <%-- 吏??26.07.15 ?섏젙: ?듭뀡 ?덈뱺 ?녿뱺(?⑥씪?듭뀡 ?ы븿) 臾댁“嫄??덈궡臾멸뎄遺??癒쇱? 蹂댁뿬二쇨린 --%>
    <option value="" data-stock="0" data-option-id="" disabled selected>?듭뀡???좏깮??二쇱꽭??/option>
    <c:forEach var="opt" items="${product.optionList}">

      <%-- 吏??26.07.08 ?섏젙: data-option-id 異붽? (?λ컮援щ땲 ?댁쓣 ???대뒓 ?듭뀡?몄? ?뚯븘???댁꽌) --%>
<%-- 吏??26.07.15 異붽?: ?ш퀬 0???듭뀡? ?좏깮 ?먯껜瑜?留됱쓬(disabled) + "?덉젅" ?쒖떆 --%>
<option value="${opt.addPrice}" data-stock="${opt.stockQty}" data-option-id="${opt.optionId}" ${opt.stockQty <= 0 ? 'disabled' : ''}>
<c:if test="${not empty opt.optionColor && opt.optionColor != '湲곕낯'}">${opt.optionColor} / </c:if>${opt.optionSize}
<c:if test="${opt.addPrice > 0}"> (+<fmt:formatNumber value="${opt.addPrice}" pattern="#,###"/>??</c:if>
<c:if test="${opt.stockQty <= 0}"> - ?덉젅</c:if>
</option>

    </c:forEach>
    <%-- 吏??26.07.08 異붽?: ?듭뀡 ?녿뒗 ?곹뭹? 鍮?諛뺤뒪濡?蹂댁씠??寃?-> cart.jsp? ?숈씪?섍쾶 "?⑥씪 ?듭뀡" ?쒖떆. data-option-id 鍮?媛?-> ?λ컮援щ땲 ?댁쓣 ??null 泥섎━??--%>
    <c:if test="${empty product.optionList}">
      <option value="0" data-stock="${product.stockQty}" data-option-id="">?⑥씪 ?듭뀡</option>
    </c:if>
  </select>
</div>

    <div class="detail-option">
  <label>?섎웾</label>
  <div class="detail-qty-wrap">
    <button onclick="changeQty(-1)">??/button>
    <input type="number" id="qty" value="1" min="1">
    <button onclick="changeQty(1)">+</button>
  </div>
  <%-- 吏??26.07.07 異붽?: ?ш퀬 珥덇낵 寃쎄퀬 --%>
  <div id="stockWarning" style="display:none; color:var(--accent); font-size:12px; margin-top:6px;">?ш퀬媛 遺議깊빀?덈떎.</div>
<!-- 吏??26.07.14 異붽?: 0媛??댄븯 ?낅젰 ???덈궡臾멸뎄??-->
<div id="qtyLimitMsg" style="display:none; color:var(--accent); font-size:12px; margin-top:6px;"></div>
  </div>

  <%-- 吏??26.07.07 ?섏젙: ?섎뱶肄붾뵫 48,900??-> ?ㅼ젣 ?먮ℓ媛濡?蹂寃?--%>
  <div class="detail-total">
  <span>珥?寃곗젣湲덉븸</span>
  <strong id="totalPrice"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>??/strong>
  </div>

<div class="detail-btn-row">
<button type="button" class="btn-wish-detail wish-btn" data-wish-id="store:${productId}" aria-label="李쒗븯湲?>李?/button>
<%-- 吏??26.07.08 ?섏젙: alert留??⑤뜕 媛吏?踰꾪듉 -> ?ㅼ젣 TB_CART_ITEM????ν븯???쇱쑝濡?蹂寃?--%>
<form id="cartForm" style="display:contents">
  <input type="hidden" name="productId" value="${product.productId}">
  <input type="hidden" name="optionId" id="cartOptionId">
  <input type="hidden" name="qty" id="cartQty">
  <input type="hidden" name="price" id="cartPrice">
  <button type="button" id="btnAddCart" class="btn-cart-detail">?λ컮援щ땲</button>
</form>
<button type="button" id="btnBuyNow" class="btn-buy-now">諛붾줈援щℓ</button>
      </div>
    </div>
  </div>

  <%-- ??--%>
  <div class="detail-tab-bar">
    <button class="detail-tab on" onclick="showTab('info',this)">?곹뭹 ?뺣낫</button>
    <button class="detail-tab" onclick="showTab('review',this)">由щ럭 (${product.reviewCount})</button>
    <button class="detail-tab" onclick="showTab('qna',this)">Q&A (${product.qnaList.size()})</button>
  </div>

  <%-- 吏??26.07.12 ?섏젙: ?섎뱶肄붾뵫 ?대?吏/二쇱슂?뱀쭠 -> product.imageList(?ㅼ젣 ?곹뭹?대?吏)/product.description(?ㅼ젣 ?ㅻ챸) ?ㅻ뜲?댄꽣濡?援먯껜 --%>
  <div class="tab-section on" id="tab-info">
    <c:choose>
      <c:when test="${not empty product.imageList}">
        <img src="${product.imageList[0]}" style="width:100%;border-radius:var(--radius-md)" alt="?곹뭹?곸꽭" onerror="this.src='https://placehold.co/900x400/EAF7F2/2BAB82?text=?곹뭹?곸꽭?대?吏'">
      </c:when>
      <c:otherwise>
        <img src="https://placehold.co/900x400/EAF7F2/2BAB82?text=?곹뭹?곸꽭?대?吏" style="width:100%;border-radius:var(--radius-md)" alt="?곹뭹?곸꽭">
      </c:otherwise>
    </c:choose>
    <div style="padding:24px;background:var(--bg-page);border-radius:var(--radius-md);margin-top:20px;font-size:14px;color:var(--text-sub);line-height:1.8">
      <strong style="display:block;font-size:16px;color:var(--text-main);margin-bottom:12px">?곹뭹 ?ㅻ챸</strong>
      <c:choose>
        <c:when test="${not empty product.description}">${product.description}</c:when>
        <c:otherwise>?깅줉???곹뭹 ?ㅻ챸???놁뒿?덈떎.</c:otherwise>
      </c:choose>
    </div>

    <%-- ?ъ씠??怨듯넻 諛곗넚/援먰솚/諛섑뭹 ?덈궡 (?곹뭹留덈떎 ?ㅻⅤ吏 ?딆? 怨좎젙 ?뺤콉) --%>
    <div style="margin-top:24px;padding:24px;border:1px solid var(--border);border-radius:var(--radius-md);font-size:13px;color:var(--text-sub);line-height:1.8">
      <strong style="display:block;font-size:16px;color:var(--text-main);margin-bottom:14px">諛곗넚 諛?援먰솚/諛섑뭹 ?덈궡</strong>
      <div style="margin-bottom:14px">
        <strong style="color:var(--text-main)">諛곗넚 ?덈궡</strong><br>
        쨌 ?ㅽ썑 1???댁쟾 二쇰Ц 嫄댁뿉 ?쒗빐 ?뱀씪 異쒓퀬?⑸땲??<br>
        쨌 異쒓퀬?쇰줈遺???됯퇏 1~2???뚯슂?⑸땲??<br>
        쨌 5留뚯썝 ?댁긽 援щℓ ??臾대즺諛곗넚, 誘몃쭔 ??諛곗넚鍮?3,000?먯씠 遺怨쇰맗?덈떎.
      </div>
      <div>
        <strong style="color:var(--text-main)">援먰솚/諛섑뭹 ?덈궡</strong><br>
        쨌 ?쒗뭹 ?섏옄媛 ?덉쓣 寃쎌슦 ?섎졊 ??7???대궡 援먰솚/諛섑뭹??媛?ν빀?덈떎.<br>
        쨌 ?쒗뭹 ?ъ옣 ?쇱넀 諛??ъ슜???쒗뭹? 援먰솚/諛섑뭹??遺덇??ν빀?덈떎.<br>
        쨌 ?⑥닚 蹂?ъ쑝濡??명븳 諛섑뭹? ?뺣났 諛곗넚鍮꾧? 諛쒖깮?????덉뒿?덈떎.
      </div>
    </div>
  </div>

  <%-- 吏??26.07.07 ?섏젙: ?됱젏/留됰?洹몃옒??由щ럭移대뱶 ?섎뱶肄붾뵫 -> TB_REVIEW ?ㅻ뜲?댄꽣濡?蹂寃?--%>
<div class="tab-section" id="tab-review">
    <div class="review-summary">
      <div class="review-avg">
        <div class="big">${product.avgRating}</div>
        <div class="review-stars">
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        </div>
        <small>${product.reviewCount}媛?由щ럭</small>
      </div>
      <div class="review-bars">
        <div class="review-bar-row"><span>5??/span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating5Percent}%"></div></div><span>${product.rating5Percent}%</span></div>
        <div class="review-bar-row"><span>4??/span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating4Percent}%"></div></div><span>${product.rating4Percent}%</span></div>
        <div class="review-bar-row"><span>3??/span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating3Percent}%"></div></div><span>${product.rating3Percent}%</span></div>
        <div class="review-bar-row"><span>2??/span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating2Percent}%"></div></div><span>${product.rating2Percent}%</span></div>
        <div class="review-bar-row"><span>1??/span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating1Percent}%"></div></div><span>${product.rating1Percent}%</span></div>
      </div>
    </div>
    <c:if test="${empty product.reviewList}">
      <div style="text-align:center;padding:60px 0;color:var(--text-muted)">?꾩쭅 ?깅줉??由щ럭媛 ?놁뒿?덈떎.</div>
    </c:if>

    <c:forEach var="rv" items="${product.reviewList}">
      <div class="review-card">
        <div class="review-card-head">
          <span class="reviewer">${rv.nickname} <c:forEach begin="1" end="${rv.rating}">狩?/c:forEach></span>
          <span class="review-date"><fmt:formatDate value="${rv.regDate}" pattern="yyyy.MM.dd"/></span>
        </div>
        <c:choose>
          <c:when test="${rv.blinded}">
            <div class="review-text" style="color:var(--text-muted);font-style:italic">??젣 寃??以묒씤 由щ럭?낅땲??</div>
          </c:when>
          <c:otherwise>
            <div class="review-text">${rv.content}</div>
            <c:if test="${not empty rv.bizReply}">
              <div class="review-text" style="margin-top:10px;padding:12px;background:#f7f7f7;border-radius:8px">
                <b>?ъ옣???듦?</b><br>${rv.bizReply}
              </div>
            </c:if>
          </c:otherwise>
        </c:choose>
      </div>
    </c:forEach>
    
  </div>

 <%-- 吏??26.07.10 ?섏젙: 臾몄쓽 ?깅줉(AJAX) 湲곕뒫 異붽? --%>
<div class="tab-section" id="tab-qna">
    <div style="display:flex; gap:8px; margin-bottom:20px;">
      <input type="text" id="qnaInput" maxlength="500" placeholder="?곹뭹?????沅곴툑???먯쓣 臾몄쓽?대낫?몄슂" style="flex:1; border:1px solid var(--border); border-radius:var(--radius-sm); padding:10px 14px; font-size:14px; outline:none;">
      <button type="button" id="btnAddQna" style="padding:10px 20px; border:1px solid var(--primary); border-radius:var(--radius-sm); background:#fff; color:var(--primary); font-size:14px; font-weight:600; cursor:pointer; white-space:nowrap;">臾몄쓽?섍린</button>
    </div>
    <div id="qnaEmptyMsg" style="text-align:center;padding:60px 0;color:var(--text-muted); ${empty product.qnaList ? '' : 'display:none;'}">?꾩쭅 ?깅줉??臾몄쓽媛 ?놁뒿?덈떎.</div>
    <div id="qnaList">
    <c:forEach var="qna" items="${product.qnaList}">

    
      <%-- 吏??26.07.12 ?섏젙: data-qna-id 遺?? 蹂몄씤 湲 + ?듬? 誘몄셿猷?嫄댁뿉留???젣 踰꾪듉 ?몄텧 --%>
      <div class="review-card" data-qna-id="${qna.qnaId}">
        <div class="review-card-head">
          <span class="reviewer">Q. ${qna.nickname}</span>
          <span style="display:flex; align-items:center; gap:10px;">
            <span class="review-date">${qna.regDate}</span>
            <c:if test="${not empty sessionScope.memberInfo && sessionScope.memberInfo.memberNo == qna.memberNo && empty qna.answer}">
              <button type="button" class="btnDeleteQna" data-qna-id="${qna.qnaId}" style="border:none; background:none; color:var(--text-muted); font-size:12px; cursor:pointer; text-decoration:underline;">??젣</button>
            </c:if>
          </span>
        </div>
        <div class="review-text">${qna.question}</div>
        <c:if test="${not empty qna.answer}">
          <div style="margin-top:10px; padding:12px; background:var(--bg-page); border-radius:var(--radius-sm); font-size:13px; color:var(--text-sub);">
            <strong style="color:var(--primary-dark);">A.</strong> ${qna.answer}
          </div>
        </c:if>

      <c:if test="${empty qna.answer}">
          <div style="margin-top:10px; font-size:12px; color:var(--text-muted);">?듬? ?湲곗쨷?낅땲??</div>
        </c:if>
      </div>
    </c:forEach>
    </div>
</div>

</div>

<script>
function switchImg(el, src) {
  document.getElementById('mainImg').src = src;
  document.querySelectorAll('.detail-thumb').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
}
// 吏??26.07.07 ?섏젙: ?먮ℓ媛 ?섎뱶肄붾뵫 -> product.salePrice ?ㅻ뜲?댄꽣濡?蹂寃?// 99媛?怨좎젙 ?쒗븳 -> ?좏깮???듭뀡???ㅼ젣 ?ш퀬(data-stock) 湲곗??쇰줈 蹂寃?
function getSelectedStock() {
  const sel = document.getElementById('optionSelect');
  if (!sel || sel.options.length === 0) return 99;
  return parseInt(sel.options[sel.selectedIndex].dataset.stock) || 0;
}
//吏??26.07.15 異붽?: ?듭뀡 ??怨좊Ⅸ ?곹깭?먯꽌 ?λ컮援щ땲/諛붾줈援щℓ ?꾨Ⅴ硫?留됯린
function isOptionSelected() {
  const sel = document.getElementById('optionSelect');
  if (!sel || sel.options.length === 0) return true;
  return sel.options[sel.selectedIndex].value !== '';
}
//吏??26.07.14 異붽?: 寃쎄퀬臾멸뎄 珥덇린???ы띁
function hideQtyMessages() {
  document.getElementById('stockWarning').style.display = 'none';
  document.getElementById('qtyLimitMsg').style.display = 'none';
}
function changeQty(d) {
  const inp = document.getElementById('qty');
  let v = parseInt(inp.value) + d;
  v = applyQtyLimit(v);
  inp.value = v;
  updateTotal();
}
//吏??26.07.14 異붽?: 吏곸젒 ??댄븨 媛?ν븯寃?諛붾뚮㈃?? ?낅젰媛?寃利앺븯???⑥닔 遺꾨━
function validateQty() {
  const inp = document.getElementById('qty');
  let v = parseInt(inp.value);
  if (isNaN(v)) v = 1;
  v = applyQtyLimit(v);
  inp.value = v;
  updateTotal();

}
//吏??26.07.14 ?섏젙: 999 ?곹븳 濡쒖쭅 ?쒓굅, ?ш퀬 珥덇낵 ??"?ш퀬 OO媛쒓퉴吏留?援щℓ 媛???쇰줈 ?덈궡
function applyQtyLimit(v) {
  hideQtyMessages();
  const stock = getSelectedStock();

  if (v < 1) {
    v = 1;
    document.getElementById('qtyLimitMsg').textContent = '1媛??댁긽遺??援щℓ?????덈뒗 ?곹뭹?낅땲??';
    document.getElementById('qtyLimitMsg').style.display = 'block';
  } else if (v > stock) {
    v = stock;
    document.getElementById('stockWarning').textContent = '?ш퀬 ' + stock + '媛쒓퉴吏留?援щℓ?????덉뒿?덈떎.';
    document.getElementById('stockWarning').style.display = 'block';
  }
  return v;
}
function onOptionChange() {
  document.getElementById('qty').value = 1;
  hideQtyMessages();
  updateTotal();
}
//吏??26.07.14 異붽?: 吏곸젒 ?낅젰 ???ъ빱?ㅻ? 踰쀬뼱?섎뒗 ?쒓컙(blur) 寃利??ㅽ뻾
document.getElementById('qty').addEventListener('blur', validateQty);
//吏??26.07.14 異붽?: ??댄븨?섎뒗 利됱떆 ?レ옄 ??臾몄옄(湲?? ?뚯닔湲고샇, ?뚯닔???? ?쒓굅
document.getElementById('qty').addEventListener('input', function () {
  this.value = this.value.replace(/[^0-9]/g, '');
});
function updateTotal() {
  const sel = document.getElementById('optionSelect');
  const selected = sel && sel.options.length > 0 ? sel.options[sel.selectedIndex] : null;
  //吏??26.07.15 異붽?: ?듭뀡 ??怨좊Ⅸ ?곹깭(?덈궡臾멸뎄媛 ?좏깮???곹깭)硫?0?먯쑝濡??쒖떆
  if (selected && selected.value === '') {
    document.getElementById('totalPrice').textContent = '0??;
    return;
  }
  const addPrice = selected ? (parseInt(selected.value) || 0) : 0;
  const qty = parseInt(document.getElementById('qty').value);
  const total = (${product.salePrice} + addPrice) * qty;
  document.getElementById('totalPrice').textContent = total.toLocaleString() + '??;
}
//吏??26.07.07 異붽?: ?섏씠吏 濡쒕뱶 ??珥?寃곗젣湲덉븸 ??踰?怨꾩궛
updateTotal();

function showTab(id, btn) {
  document.querySelectorAll('.tab-section').forEach(s => s.classList.remove('on'));
  document.querySelectorAll('.detail-tab').forEach(b => b.classList.remove('on'));
  document.getElementById('tab-' + id).classList.add('on');
  btn.classList.add('on');
}
//吏??26.07.09 ?섏젙: 濡쒓렇?????덉쑝硫?AJAX ?붿껌 ?꾩뿉 confirm?쇰줈 濡쒓렇?명럹?댁? ?대룞 ?щ?遺??臾쇱뼱遊?document.getElementById('btnAddCart').addEventListener('click', function () {
  var isLoggedIn = ${not empty sessionScope.memberInfo};
  if (!isLoggedIn) {
    if (confirm('濡쒓렇?몄씠 ?꾩슂???쒕퉬?ㅼ엯?덈떎. 濡쒓렇???섏씠吏濡??대룞?섏떆寃좎뒿?덇퉴?')) {
      location.href = '${contextPath}/login';
    }
    return;
  }
   //吏??26.07.15 異붽?: ?듭뀡 ??怨좊Ⅴ硫??닿린 留됱쓬
  if (!isOptionSelected()) {
    alert('?듭뀡???좏깮?댁＜?몄슂.');
    return;
  }
  
  var sel = document.getElementById('optionSelect');
  var optionId = (sel && sel.options.length > 0) ? sel.options[sel.selectedIndex].dataset.optionId : '';
  var addPrice = (sel && sel.options.length > 0) ? (parseInt(sel.value) || 0) : 0;
  var qty = parseInt(document.getElementById('qty').value);
  var price = ${product.salePrice} + addPrice;

  fetch('${contextPath}/store/cart/add', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'productId=${product.productId}&optionId=' + optionId + '&qty=' + qty + '&price=' + price
  }).then(function(res){
    if (res.ok) {
      refreshCartCount();
      if (confirm('?λ컮援щ땲???댁븯?듬땲?? ?λ컮援щ땲濡??대룞?섏떆寃좎뒿?덇퉴?')) {
        location.href = '${contextPath}/store/cart';
      }
    } else {
      alert('?λ컮援щ땲 ?닿린???ㅽ뙣?덉뒿?덈떎.');
    }
  });
});

//吏??26.07.08 異붽?: 諛붾줈援щℓ -> 二쇰Ц???섏씠吏濡?諛붾줈 ?대룞 (?λ컮援щ땲 嫄곗튂吏 ?딆쓬)
document.getElementById('btnBuyNow').addEventListener('click', function () {
 //吏??26.07.15 異붽?: ?듭뀡 ??怨좊Ⅴ硫??대룞 留됱쓬
  if (!isOptionSelected()) {
    alert('?듭뀡???좏깮?댁＜?몄슂.');
    return;
  }

  var sel = document.getElementById('optionSelect');
  var optionId = (sel && sel.options.length > 0) ? sel.options[sel.selectedIndex].dataset.optionId : '';
  var qty = parseInt(document.getElementById('qty').value);
  location.href = '${contextPath}/store/order'
    + '?productId=${product.productId}'
    + '&optionId=' + optionId
    + '&qty=' + qty;
});

//吏??26.07.10 ?섏젙: ?깅줉 ?깃났 ???덈줈怨좎묠 ?놁씠 ?붾㈃??諛붾줈 吏덈Ц 異붽?
//吏??26.07.12 ?섏젙: ?묐떟??"OK:qnaId" ?뺤떇?쇰줈 諛붾쒖뿉 ?곕씪 ?뚯떛 濡쒖쭅 異붽?, ??移대뱶?먮룄 ??젣踰꾪듉 遺??document.getElementById('btnAddQna').addEventListener('click', function () {
  var isLoggedIn = ${not empty sessionScope.memberInfo};
  if (!isLoggedIn) {
    if (confirm('濡쒓렇?몄씠 ?꾩슂???쒕퉬?ㅼ엯?덈떎. 濡쒓렇???섏씠吏濡??대룞?섏떆寃좎뒿?덇퉴?')) {
      location.href = '${contextPath}/login';
    }
    return;
  }
  var input = document.getElementById('qnaInput');
  var question = input.value.trim();
  if (question === '') {
    alert('臾몄쓽 ?댁슜???낅젰?댁＜?몄슂.');
    return;
  }
  fetch('${contextPath}/store/qna/add', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'productId=${product.productId}&question=' + encodeURIComponent(question)
  }).then(function(res){ return res.text(); })
    .then(function(result){
      if (result.indexOf('OK:') === 0) {
        var newQnaId = result.substring(3);
        var myNickname = '${sessionScope.memberInfo.nickname}';
        var today = new Date();
        var dateStr = today.getFullYear() + '-' + String(today.getMonth()+1).padStart(2,'0') + '-' + String(today.getDate()).padStart(2,'0');

        document.getElementById('qnaEmptyMsg').style.display = 'none';

        var newCard = document.createElement('div');
        newCard.className = 'review-card';
        newCard.dataset.qnaId = newQnaId;
        newCard.innerHTML =
          '<div class="review-card-head">' +
            '<span class="reviewer">Q. ' + myNickname + '</span>' +
            '<span style="display:flex; align-items:center; gap:10px;">' +
              '<span class="review-date">' + dateStr + '</span>' +
              '<button type="button" class="btnDeleteQna" data-qna-id="' + newQnaId + '" style="border:none; background:none; color:var(--text-muted); font-size:12px; cursor:pointer; text-decoration:underline;">??젣</button>' +
            '</span>' +
          '</div>' +
          '<div class="review-text"></div>' +
          '<div style="margin-top:10px; font-size:12px; color:var(--text-muted);">?듬? ?湲곗쨷?낅땲??</div>';
        newCard.querySelector('.review-text').textContent = question;

        document.getElementById('qnaList').prepend(newCard);
        input.value = '';
      } else if (result === 'LOGIN_REQUIRED') {
        alert('濡쒓렇?몄씠 ?꾩슂?⑸땲??');
        location.href = '${contextPath}/login';
      } else {
        alert('臾몄쓽 ?깅줉???ㅽ뙣?덉뒿?덈떎.');
      }
    });
});

//吏??26.07.12 ?곹뭹 Q&A ??젣: 湲곗〈 湲/?덈줈 異붽???湲 紐⑤몢 泥섎━?섎룄濡?qnaList???대깽???꾩엫
document.getElementById('qnaList').addEventListener('click', function (e) {
  var btn = e.target.closest('.btnDeleteQna');
  if (!btn) return;
  if (!confirm('臾몄쓽瑜???젣?섏떆寃좎뒿?덇퉴?')) return;
  var qnaId = btn.dataset.qnaId;
  fetch('${contextPath}/store/qna/delete', {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: 'qnaId=' + qnaId
  }).then(function(res){ return res.text(); })
    .then(function(result){
      if (result === 'OK') {
        var card = document.querySelector('#qnaList [data-qna-id="' + qnaId + '"]');
        if (card) card.remove();
        if (document.getElementById('qnaList').children.length === 0) {
          document.getElementById('qnaEmptyMsg').style.display = '';
        }
      } else if (result === 'LOGIN_REQUIRED') {
        alert('濡쒓렇?몄씠 ?꾩슂?⑸땲??');
        location.href = '${contextPath}/login';
      } else if (result === 'FAILED') {
        alert('?듬????대? ?깅줉??臾몄쓽????젣?????놁뒿?덈떎.');
      } else {
        alert('??젣???ㅽ뙣?덉뒿?덈떎.');
      }
    });
});
</script>


<%@ include file="/WEB-INF/views/common/footer.jsp" %>
