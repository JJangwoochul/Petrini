<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 지윤 26.07.07 추가: 가격 콤마 표시용 fmt 태그 --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%-- 지윤 26.07.07 수정: URL param.id 그대로 쓰던 것 -> Controller가 넘겨준 product 객체의 productId로 변경 (실데이터 연동) --%>
<c:set var="productId" value="${product.productId}" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
.detail-wrap { max-width:var(--inner-width); margin:32px auto 80px; padding:0 20px; }
.breadcrumb { font-size:13px; color:var(--text-muted); margin-bottom:24px; }
.breadcrumb a { color:var(--text-muted); text-decoration:none; } .breadcrumb a:hover { color:var(--primary); }
.breadcrumb span { margin:0 6px; }
.detail-top { display:grid; grid-template-columns:1fr 1fr; gap:40px; margin-bottom:48px; }
/* 이미지 */
.detail-gallery {}
.detail-main-img { width:100%; aspect-ratio:1/1; object-fit:cover; border-radius:var(--radius-md); display:block; margin-bottom:12px; }
.detail-thumbs { display:flex; gap:8px; }
.detail-thumb { width:72px; height:72px; border-radius:var(--radius-sm); object-fit:cover; cursor:pointer; border:2px solid transparent; transition:var(--transition); }
.detail-thumb.active,.detail-thumb:hover { border-color:var(--primary); }
/* 정보 */
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
/* 지윤 26.07.08 추가: 바로구매 버튼 스타일 (기존엔 스타일 정의 자체가 없어서 브라우저 기본 버튼으로 보였음) */
.btn-buy-now { flex:1; padding:14px; border:1px solid var(--primary); border-radius:var(--radius-sm); background:#fff; color:var(--primary); font-size:15px; font-weight:700; cursor:pointer; transition:var(--transition); }
.btn-buy-now:hover { background:var(--primary-light); }
.btn-buy-detail { flex:2; padding:14px; border:none; border-radius:var(--radius-sm); background:var(--text-main); color:#fff; font-size:15px; font-weight:700; cursor:pointer; }
/* 탭 */
.detail-tab-bar { display:flex; border-bottom:2px solid var(--border); margin-bottom:28px; }
.detail-tab { padding:12px 24px; font-size:14px; font-weight:600; color:var(--text-muted); border:none; background:none; cursor:pointer; border-bottom:2px solid transparent; margin-bottom:-2px; transition:var(--transition); }
.detail-tab.on { color:var(--primary); border-bottom-color:var(--primary); }
.tab-section { display:none; } .tab-section.on { display:block; }
/* 리뷰 */
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
    <a href="${contextPath}/">홈</a><span>›</span>
    <a href="${contextPath}/store">상품</a><span>›</span>
    <%-- 지윤 26.07.07 수정: 하드코딩된 카테고리명/상품명 -> product 실데이터로 변경 --%>
    <a href="${contextPath}/store">${product.categoryName}</a><span>›</span>
    ${product.productName}
  </div>

  <div class="detail-top">
    <%-- 이미지 갤러리 --%>
    <div class="detail-gallery">

      <%-- 지윤 26.07.07 수정: 메인 상품 고정 이미지 URL -> DB에서 가져온 product.thumbnailUrl로 변경 --%>
     <img class="detail-main-img" id="mainImg"
     src="${product.thumbnailUrl}"
     alt="${product.productName}" onerror="this.src='https://placehold.co/600x600/EAF7F2/2BAB82?text=상품'">

      <%-- 지윤 26.07.07 수정: 썸네일 3개 하드코딩 -> TB_FILE 실데이터로 개수 상관없이 자동 반복
     이미지 없는 상품은 imageList가 빈 리스트라 자동으로 썸네일 줄 자체가 안 보임 --%>
    <div class="detail-thumbs">
    <c:forEach var="img" items="${product.imageList}" varStatus="loop">
    <img class="detail-thumb ${loop.first ? 'active' : ''}" src="${img}" alt="${product.productName} ${loop.index+1}" onclick="switchImg(this,'${img}')">
    </c:forEach>
    </div>
    </div>

    <%-- 상품 정보 --%>
    <div class="detail-info">
      <%-- 지윤 26.07.07 수정: 브랜드/상품명/평점/가격 하드코딩 -> product 실데이터로 변경
     별 아이콘 5개 고정 -> 1개만 남기고 텍스트로 대체 (진짜 별점 렌더링은 리뷰 단계에서 처리 예정) --%>
    <div class="detail-brand">${product.brandName}</div>
    <div class="detail-name">${product.productName}</div>
    <div class="detail-rating">
      <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
      <span>${product.avgRating}점 (${product.reviewCount}개 리뷰)</span>
    </div>
    <div class="detail-price-wrap">
    <div>
     <c:if test="${product.discountRate > 0}"><span class="detail-price-rate">${product.discountRate}%</span></c:if>
     <span class="detail-price-sale"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>원</span>
    </div>
    <c:if test="${product.discountRate > 0}">
    <div class="detail-price-origin">정가 <fmt:formatNumber value="${product.price}" pattern="#,###"/>원</div>
     </c:if>
    </div>

      <div class="detail-tags">
        <span class="detail-tag">무료배송</span>
        <span class="detail-tag">중형견 적합</span>
        <span class="detail-tag">글루텐 프리</span>
        <span class="detail-tag">오메가3 함유</span>
      </div>

      <%-- 지윤 26.07.07 수정: 용량 하드코딩 -> TB_PRODUCT_OPTION 실데이터로 변경
     색상이 없거나 '기본'이면 색상 표시 생략, 사이즈만 표시 --%>
<div class="detail-option">
  <label>옵션 선택</label>
  <select id="optionSelect" onchange="onOptionChange()">
    <c:forEach var="opt" items="${product.optionList}">

      <%-- 지윤 26.07.08 수정: data-option-id 추가 (장바구니 담을 때 어느 옵션인지 알아야 해서) --%>
  <option value="${opt.addPrice}" data-stock="${opt.stockQty}" data-option-id="${opt.optionId}">
  <c:if test="${not empty opt.optionColor && opt.optionColor != '기본'}">${opt.optionColor} / </c:if>${opt.optionSize}
  <c:if test="${opt.addPrice > 0}"> (+<fmt:formatNumber value="${opt.addPrice}" pattern="#,###"/>원)</c:if>
  </option>

    </c:forEach>
    <%-- 지윤 26.07.08 추가: 옵션 없는 상품은 빈 박스로 보이던 것 -> cart.jsp와 동일하게 "단일 옵션" 표시. data-option-id 빈 값 -> 장바구니 담을 때 null 처리됨 --%>
    <c:if test="${empty product.optionList}">
      <option value="0" data-stock="${product.stockQty}" data-option-id="">단일 옵션</option>
    </c:if>
  </select>
</div>

    <div class="detail-option">
  <label>수량</label>
  <div class="detail-qty-wrap">
    <button onclick="changeQty(-1)">−</button>
    <input type="number" id="qty" value="1" min="1" readonly>
    <button onclick="changeQty(1)">+</button>
  </div>
  <%-- 지윤 26.07.07 추가: 재고 초과 경고 --%>
  <div id="stockWarning" style="display:none; color:var(--accent); font-size:12px; margin-top:6px;">재고가 부족합니다.</div>
  </div>

  <%-- 지윤 26.07.07 수정: 하드코딩 48,900원 -> 실제 판매가로 변경 --%>
  <div class="detail-total">
  <span>총 결제금액</span>
  <strong id="totalPrice"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>원</strong>
  </div>

<div class="detail-btn-row">
<button type="button" class="btn-wish-detail wish-btn" data-wish-id="store:${productId}" aria-label="찜하기">찜</button>
<%-- 지윤 26.07.08 수정: alert만 뜨던 가짜 버튼 -> 실제 TB_CART_ITEM에 저장하는 폼으로 변경 --%>
<form id="cartForm" style="display:contents">
  <input type="hidden" name="productId" value="${product.productId}">
  <input type="hidden" name="optionId" id="cartOptionId">
  <input type="hidden" name="qty" id="cartQty">
  <input type="hidden" name="price" id="cartPrice">
  <button type="button" id="btnAddCart" class="btn-cart-detail">장바구니</button>
</form>
<button type="button" id="btnBuyNow" class="btn-buy-now">바로구매</button>
      </div>
    </div>
  </div>

  <%-- 탭 --%>
  <div class="detail-tab-bar">
    <button class="detail-tab on" onclick="showTab('info',this)">상품 정보</button>
    <button class="detail-tab" onclick="showTab('review',this)">리뷰 (${product.reviewCount})</button>
    <button class="detail-tab" onclick="showTab('qna',this)">Q&A (${product.qnaList.size()})</button>
  </div>

  <div class="tab-section on" id="tab-info">
    <img src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=900&q=70&auto=format&fit=crop" style="width:100%;border-radius:var(--radius-md)" alt="상품상세" onerror="this.src='https://placehold.co/900x400/EAF7F2/2BAB82?text=상품상세이미지'">
    <div style="padding:24px;background:var(--bg-page);border-radius:var(--radius-md);margin-top:20px;font-size:14px;color:var(--text-sub);line-height:1.8">
      <strong style="display:block;font-size:16px;color:var(--text-main);margin-bottom:12px">주요 특징</strong>
      · 중형견(11~25kg)의 유지기에 적합한 맞춤 영양 설계<br>
      · 관절 건강을 위한 오메가3 지방산 함유<br>
      · 소화 흡수율을 높인 고품질 단백질 원료<br>
      · 글루코사민·콘드로이틴으로 연골 보호
    </div>
  </div>

  <%-- 지윤 26.07.07 수정: 평점/막대그래프/리뷰카드 하드코딩 -> TB_REVIEW 실데이터로 변경 --%>
<div class="tab-section" id="tab-review">
    <div class="review-summary">
      <div class="review-avg">
        <div class="big">${product.avgRating}</div>
        <div class="review-stars">
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        </div>
        <small>${product.reviewCount}개 리뷰</small>
      </div>
      <div class="review-bars">
        <div class="review-bar-row"><span>5점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating5Percent}%"></div></div><span>${product.rating5Percent}%</span></div>
        <div class="review-bar-row"><span>4점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating4Percent}%"></div></div><span>${product.rating4Percent}%</span></div>
        <div class="review-bar-row"><span>3점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating3Percent}%"></div></div><span>${product.rating3Percent}%</span></div>
        <div class="review-bar-row"><span>2점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating2Percent}%"></div></div><span>${product.rating2Percent}%</span></div>
        <div class="review-bar-row"><span>1점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:${product.rating1Percent}%"></div></div><span>${product.rating1Percent}%</span></div>
      </div>
    </div>
    <c:if test="${empty product.reviewList}">
      <div style="text-align:center;padding:60px 0;color:var(--text-muted)">아직 등록된 리뷰가 없습니다.</div>
    </c:if>
    <c:forEach var="rv" items="${product.reviewList}">
      <div class="review-card">
        <div class="review-card-head">
          <span class="reviewer">${rv.nickname} <c:forEach begin="1" end="${rv.rating}">⭐</c:forEach></span>
          <span class="review-date"><fmt:formatDate value="${rv.regDate}" pattern="yyyy.MM.dd"/></span>
        </div>
        <div class="review-text">${rv.content}</div>
      </div>
    </c:forEach>
  </div>

  <%-- 지윤 26.07.07 수정: "상품상세페이지 Q&A -> TB_PRODUCT_QNA 실데이터로 변경
     관리자 답변 화면은 아직 담당자 미정이라, 유저가 보는 질문/답변 목록만 우선 구현 --%>
<div class="tab-section" id="tab-qna">
    <c:if test="${empty product.qnaList}">
      <div style="text-align:center;padding:60px 0;color:var(--text-muted)">아직 등록된 문의가 없습니다.</div>
    </c:if>
    <c:forEach var="qna" items="${product.qnaList}">
      <div class="review-card">
        <div class="review-card-head">
          <span class="reviewer">Q. ${qna.nickname}</span>
          <span class="review-date">${qna.regDate}</span>
        </div>
        <div class="review-text">${qna.question}</div>
        <c:if test="${not empty qna.answer}">
          <div style="margin-top:10px; padding:12px; background:var(--bg-page); border-radius:var(--radius-sm); font-size:13px; color:var(--text-sub);">
            <strong style="color:var(--primary-dark);">A.</strong> ${qna.answer}
          </div>
        </c:if>
        <c:if test="${empty qna.answer}">
          <div style="margin-top:10px; font-size:12px; color:var(--text-muted);">답변 대기중입니다.</div>
        </c:if>
      </div>
    </c:forEach>
</div>

</div>

<script>
function switchImg(el, src) {
  document.getElementById('mainImg').src = src;
  document.querySelectorAll('.detail-thumb').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
}
// 지윤 26.07.07 수정: 판매가 하드코딩 -> product.salePrice 실데이터로 변경
// 99개 고정 제한 -> 선택된 옵션의 실제 재고(data-stock) 기준으로 변경 
function getSelectedStock() {
  const sel = document.getElementById('optionSelect');
  if (!sel || sel.options.length === 0) return 99;
  return parseInt(sel.options[sel.selectedIndex].dataset.stock) || 0;
}
function changeQty(d) {
  const inp = document.getElementById('qty');
  const maxStock = getSelectedStock();
  let v = parseInt(inp.value) + d;
  if (v < 1) v = 1;
  if (v > maxStock) {
    v = maxStock;
    document.getElementById('stockWarning').style.display = 'block';
  } else {
    document.getElementById('stockWarning').style.display = 'none';
  }
  inp.value = v;
  updateTotal();
}
function onOptionChange() {
  document.getElementById('qty').value = 1;
  document.getElementById('stockWarning').style.display = 'none';
  updateTotal();
}
function updateTotal() {
  const sel = document.getElementById('optionSelect');
  const addPrice = sel && sel.options.length > 0 ? parseInt(sel.value) || 0 : 0;
  const qty = parseInt(document.getElementById('qty').value);
  const total = (${product.salePrice} + addPrice) * qty;
  document.getElementById('totalPrice').textContent = total.toLocaleString() + '원';
}
//지윤 26.07.07 추가: 페이지 로드 시 총 결제금액 한 번 계산
updateTotal();

function showTab(id, btn) {
  document.querySelectorAll('.tab-section').forEach(s => s.classList.remove('on'));
  document.querySelectorAll('.detail-tab').forEach(b => b.classList.remove('on'));
  document.getElementById('tab-' + id).classList.add('on');
  btn.classList.add('on');
}
//지윤 26.07.09 수정: 로그인 안 했으면 AJAX 요청 전에 confirm으로 로그인페이지 이동 여부부터 물어봄
document.getElementById('btnAddCart').addEventListener('click', function () {
  var isLoggedIn = ${not empty sessionScope.memberInfo};
  if (!isLoggedIn) {
    if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
      location.href = '${contextPath}/login';
    }
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
      if (confirm('장바구니에 담았습니다. 장바구니로 이동하시겠습니까?')) {
        location.href = '${contextPath}/store/cart';
      }
    } else {
      alert('장바구니 담기에 실패했습니다.');
    }
  });
});

//지윤 26.07.08 추가: 바로구매 -> 주문서 페이지로 바로 이동 (장바구니 거치지 않음)
document.getElementById('btnBuyNow').addEventListener('click', function () {
  var sel = document.getElementById('optionSelect');
  var optionId = (sel && sel.options.length > 0) ? sel.options[sel.selectedIndex].dataset.optionId : '';
  var qty = parseInt(document.getElementById('qty').value);

  location.href = '${contextPath}/store/order'
    + '?productId=${product.productId}'
    + '&optionId=' + optionId
    + '&qty=' + qty;
});
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
