<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
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
    <a href="${contextPath}/store?cat=food">사료/간식</a><span>›</span>
    로얄캐닌 미디엄 어덜트
  </div>

  <div class="detail-top">
    <%-- 이미지 갤러리 --%>
    <div class="detail-gallery">
      <img class="detail-main-img" id="mainImg"
           src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=600&q=80&auto=format&fit=crop"
           alt="메인이미지" onerror="this.src='https://placehold.co/600x600/EAF7F2/2BAB82?text=상품'">
      <div class="detail-thumbs">
        <img class="detail-thumb active" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=144&q=70&auto=format&fit=crop" alt="t1" onclick="switchImg(this,'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=600&q=80&auto=format&fit=crop')" onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=1'">
        <img class="detail-thumb" src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=144&q=70&auto=format&fit=crop" alt="t2" onclick="switchImg(this,'https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=600&q=80&auto=format&fit=crop')" onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=2'">
        <img class="detail-thumb" src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=144&q=70&auto=format&fit=crop" alt="t3" onclick="switchImg(this,'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=600&q=80&auto=format&fit=crop')" onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=3'">
      </div>
    </div>

    <%-- 상품 정보 --%>
    <div class="detail-info">
      <div class="detail-brand">로얄캐닌 (Royal Canin)</div>
      <div class="detail-name">미디엄 어덜트 성견 사료 4kg</div>
      <div class="detail-rating">
        <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        <span>4.8점 (324개 리뷰)</span>
      </div>
      <div class="detail-price-wrap">
        <div><span class="detail-price-rate">11%</span><span class="detail-price-sale">48,900원</span></div>
        <div class="detail-price-origin">정가 55,000원</div>
      </div>
      <div class="detail-tags">
        <span class="detail-tag">무료배송</span>
        <span class="detail-tag">중형견 적합</span>
        <span class="detail-tag">글루텐 프리</span>
        <span class="detail-tag">오메가3 함유</span>
      </div>

      <div class="detail-option">
        <label>용량 선택</label>
        <select><option>4kg (48,900원)</option><option>8kg (89,000원)</option><option>15kg (159,000원)</option></select>
      </div>
      <div class="detail-option">
        <label>수량</label>
        <div class="detail-qty-wrap">
          <button onclick="changeQty(-1)">−</button>
          <input type="number" id="qty" value="1" min="1" max="99" readonly>
          <button onclick="changeQty(1)">+</button>
        </div>
      </div>
      <div class="detail-total">
        <span>총 결제금액</span>
        <strong id="totalPrice">48,900원</strong>
      </div>
      <div class="detail-btn-row">
        <button class="btn-wish-detail"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>찜</button>
        <button class="btn-cart-detail" onclick="alert('장바구니에 담았습니다.')">장바구니</button>
        <button class="btn-buy-detail" onclick="location.href='${contextPath}/store/order'">바로구매</button>
      </div>
    </div>
  </div>

  <%-- 탭 --%>
  <div class="detail-tab-bar">
    <button class="detail-tab on" onclick="showTab('info',this)">상품 정보</button>
    <button class="detail-tab" onclick="showTab('review',this)">리뷰 (324)</button>
    <button class="detail-tab" onclick="showTab('qna',this)">Q&A (12)</button>
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

  <div class="tab-section" id="tab-review">
    <div class="review-summary">
      <div class="review-avg">
        <div class="big">4.8</div>
        <div class="review-stars">
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        </div>
        <small>324개 리뷰</small>
      </div>
      <div class="review-bars">
        <div class="review-bar-row"><span>5점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:72%"></div></div><span>72%</span></div>
        <div class="review-bar-row"><span>4점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:18%"></div></div><span>18%</span></div>
        <div class="review-bar-row"><span>3점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:6%"></div></div><span>6%</span></div>
        <div class="review-bar-row"><span>2점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:2%"></div></div><span>2%</span></div>
        <div class="review-bar-row"><span>1점</span><div class="review-bar-bg"><div class="review-bar-fill" style="width:2%"></div></div><span>2%</span></div>
      </div>
    </div>
    <div class="review-card">
      <div class="review-card-head"><span class="reviewer">김민준 ⭐⭐⭐⭐⭐</span><span class="review-date">2025.06.20</span></div>
      <div class="review-text">우리 강아지가 잘 먹어요! 전에 먹던 사료는 잘 안 먹었는데 이건 정말 맛있게 먹네요. 변도 좋아지고 털도 윤기나는 것 같아요.</div>
    </div>
    <div class="review-card">
      <div class="review-card-head"><span class="reviewer">이서연 ⭐⭐⭐⭐⭐</span><span class="review-date">2025.06.15</span></div>
      <div class="review-text">수의사 선생님 추천으로 구매했어요. 알갱이 크기가 적당하고 냄새도 좋아요. 꾸준히 구매할 것 같습니다.</div>
    </div>
  </div>

  <div class="tab-section" id="tab-qna">
    <div style="text-align:center;padding:60px 0;color:var(--text-muted)">Q&A 구현 예정</div>
  </div>
</div>

<script>
function switchImg(el, src) {
  document.getElementById('mainImg').src = src;
  document.querySelectorAll('.detail-thumb').forEach(t => t.classList.remove('active'));
  el.classList.add('active');
}
function changeQty(d) {
  const inp = document.getElementById('qty');
  let v = parseInt(inp.value) + d;
  if(v < 1) v = 1; if(v > 99) v = 99;
  inp.value = v;
  document.getElementById('totalPrice').textContent = (48900 * v).toLocaleString() + '원';
}
function showTab(id, btn) {
  document.querySelectorAll('.tab-section').forEach(s => s.classList.remove('on'));
  document.querySelectorAll('.detail-tab').forEach(b => b.classList.remove('on'));
  document.getElementById('tab-' + id).classList.add('on');
  btn.classList.add('on');
}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
