<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/ad-banner.jsp" %>
<style>
.store-wrap { max-width:var(--inner-width); margin:32px auto 80px; padding:0 20px; display:flex; gap:28px; align-items:flex-start; }
/* 사이드바 */
.store-sidebar { width:220px; flex-shrink:0; }
.store-sidebar-card { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-md); padding:20px; margin-bottom:16px; }
.store-sidebar-title { font-size:14px; font-weight:800; color:var(--text-main); margin:0 0 14px; }
.store-cat-list { list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:2px; }
.store-cat-list li a { display:flex; justify-content:space-between; padding:8px 10px; border-radius:var(--radius-sm); font-size:13px; color:var(--text-sub); text-decoration:none; transition:var(--transition); }
.store-cat-list li a:hover { background:var(--primary-light); color:var(--primary-dark); }
.store-cat-list li a.active { background:var(--primary-light); color:var(--primary-dark); font-weight:700; }
.store-cat-list .cat-count { font-size:12px; color:var(--text-muted); }
.price-range { display:flex; flex-direction:column; gap:8px; }
.price-range input[type=range] { width:100%; accent-color:var(--primary); }
.price-range-vals { display:flex; justify-content:space-between; font-size:12px; color:var(--text-muted); }
/* 상품 영역 */
.store-content { flex:1; min-width:0; }
.store-toolbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:18px; }
.store-result-count { font-size:14px; color:var(--text-sub); }
.store-result-count strong { color:var(--text-main); font-weight:700; }
.store-sort { display:flex; gap:8px; }
.sort-btn { padding:6px 14px; border:1px solid var(--border); border-radius:50px; font-size:13px; color:var(--text-sub); background:#fff; cursor:pointer; transition:var(--transition); }
.sort-btn:hover,.sort-btn.on { border-color:var(--primary); color:var(--primary); background:var(--primary-light); font-weight:600; }
/* 상품 그리드 */
.product-grid { display:grid; grid-template-columns:repeat(3,1fr); gap:20px; margin-bottom:32px; }
.product-card { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-md); overflow:hidden; transition:var(--transition); cursor:pointer; }
.product-card:hover { box-shadow:var(--shadow-md); transform:translateY(-3px); }
.product-thumb-wrap { position:relative; }
.product-thumb { width:100%; aspect-ratio:1/1; object-fit:cover; display:block; }
.product-badge { position:absolute; top:10px; left:10px; background:var(--accent); color:#fff; font-size:11px; font-weight:700; padding:3px 8px; border-radius:20px; }
.product-wish { position:absolute; top:10px; right:10px; width:32px; height:32px; border-radius:50%; background:rgba(255,255,255,.9); border:none; cursor:pointer; display:flex; align-items:center; justify-content:center; }
.product-wish svg { width:16px; height:16px; stroke:var(--accent); fill:none; stroke-width:1.8; }
.product-body { padding:14px; }
.product-brand { font-size:11px; color:var(--text-muted); margin-bottom:4px; }
.product-name { font-size:14px; font-weight:600; color:var(--text-main); margin-bottom:8px; line-height:1.4; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
.product-rating { display:flex; align-items:center; gap:4px; margin-bottom:8px; }
.product-rating svg { width:13px; height:13px; fill:var(--yellow); stroke:none; }
.product-rating span { font-size:12px; color:var(--text-muted); }
.product-price { display:flex; align-items:baseline; gap:6px; }
.price-sale { font-size:16px; font-weight:800; color:var(--text-main); }
.price-rate { font-size:14px; font-weight:700; color:var(--accent); }
.price-origin { font-size:12px; color:var(--text-muted); text-decoration:line-through; }
.product-footer { padding:0 14px 14px; }
.btn-cart { width:100%; padding:9px; border:none; border-radius:var(--radius-sm); background:var(--primary); color:#fff; font-size:13px; font-weight:700; cursor:pointer; transition:var(--transition); }
.btn-cart:hover { background:var(--primary-dark); }
/* 페이지네이션 */
.pagination { display:flex; justify-content:center; gap:5px; }
.page-btn { width:36px; height:36px; border-radius:var(--radius-sm); border:1px solid var(--border); background:#fff; font-size:13px; color:var(--text-sub); cursor:pointer; display:flex; align-items:center; justify-content:center; transition:var(--transition); }
.page-btn:hover { border-color:var(--primary); color:var(--primary); }
.page-btn.active { background:var(--primary); border-color:var(--primary); color:#fff; font-weight:700; }
.page-btn svg { width:14px; height:14px; stroke:currentColor; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
</style>

<div class="store-wrap">
  <%-- 사이드바 --%>
  <aside class="store-sidebar">
    <div class="store-sidebar-card">
      <div class="store-sidebar-title">카테고리</div>
      <ul class="store-cat-list">
        <li><a href="#" class="active">전체<span class="cat-count">248</span></a></li>
        <li><a href="#">사료<span class="cat-count">82</span></a></li>
        <li><a href="#">간식<span class="cat-count">64</span></a></li>
        <li><a href="#">용품<span class="cat-count">38</span></a></li>
      </ul>
    </div>
    <div class="store-sidebar-card">
      <div class="store-sidebar-title">가격대</div>
      <div class="price-range">
        <input type="range" min="0" max="100000" step="1000" value="100000">
        <div class="price-range-vals"><span>0원</span><span>100,000원 이하</span></div>
      </div>
    </div>
    <div class="store-sidebar-card">
      <div class="store-sidebar-title">브랜드</div>
      <ul class="store-cat-list">
        <li><a href="#">로얄캐닌<span class="cat-count">18</span></a></li>
        <li><a href="#">Hill's<span class="cat-count">14</span></a></li>
        <li><a href="#">냥냥<span class="cat-count">22</span></a></li>
        <li><a href="#">PetPlay<span class="cat-count">16</span></a></li>
        <li><a href="#">WalkMe<span class="cat-count">12</span></a></li>
      </ul>
    </div>
  </aside>

  <%-- 상품 목록 --%>
  <div class="store-content">
    <div class="store-toolbar">
      <div class="store-result-count">총 <strong>248</strong>개 상품</div>
      <div class="store-sort">
        <button class="sort-btn on">인기순</button>
        <button class="sort-btn">최신순</button>
        <button class="sort-btn">낮은가격</button>
        <button class="sort-btn">높은가격</button>
      </div>
    </div>

    <div class="product-grid">
      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=1'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=400&q=70&auto=format&fit=crop" alt="사료" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <span class="product-badge">BEST</span>
          <button class="product-wish"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="product-body">
          <div class="product-brand">로얄캐닌</div>
          <div class="product-name">미디엄 어덜트 사료 4kg</div>
          <div class="product-rating">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <span>4.8 (324)</span>
          </div>
          <div class="product-price">
            <span class="price-rate">11%</span>
            <span class="price-sale">48,900원</span>
            <span class="price-origin">55,000원</span>
          </div>
        </div>
        <div class="product-footer"><button class="btn-cart">장바구니 담기</button></div>
      </div>

      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=2'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&q=70&auto=format&fit=crop" alt="장난감" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <button class="product-wish"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="product-body">
          <div class="product-brand">PetPlay</div>
          <div class="product-name">노즈워크 매트 오렌지 — 인지력 향상 장난감</div>
          <div class="product-rating">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <span>4.6 (189)</span>
          </div>
          <div class="product-price"><span class="price-sale">18,500원</span></div>
        </div>
        <div class="product-footer"><button class="btn-cart">장바구니 담기</button></div>
      </div>

      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=3'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=400&q=70&auto=format&fit=crop" alt="간식" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <span class="product-badge">NEW</span>
          <button class="product-wish"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="product-body">
          <div class="product-brand">냥냥</div>
          <div class="product-name">수제 져키 트릿 200g</div>
          <div class="product-rating">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <span>4.7 (241)</span>
          </div>
          <div class="product-price"><span class="price-rate">15%</span><span class="price-sale">13,000원</span><span class="price-origin">15,300원</span></div>
        </div>
        <div class="product-footer"><button class="btn-cart">장바구니 담기</button></div>
      </div>

      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=4'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1596854407944-bf87f6fdd049?w=400&q=70&auto=format&fit=crop" alt="하네스" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <button class="product-wish"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="product-body">
          <div class="product-brand">WalkMe</div>
          <div class="product-name">H형 하네스 M사이즈 블루</div>
          <div class="product-rating">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <span>4.5 (98)</span>
          </div>
          <div class="product-price"><span class="price-rate">21%</span><span class="price-sale">22,000원</span><span class="price-origin">28,000원</span></div>
        </div>
        <div class="product-footer"><button class="btn-cart">장바구니 담기</button></div>
      </div>

      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=5'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=400&q=70&auto=format&fit=crop" alt="침대" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <button class="product-wish"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="product-body">
          <div class="product-brand">PetNest</div>
          <div class="product-name">메모리폼 반려견 침대 L사이즈</div>
          <div class="product-rating">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <span>4.9 (412)</span>
          </div>
          <div class="product-price"><span class="price-sale">59,000원</span></div>
        </div>
        <div class="product-footer"><button class="btn-cart">장바구니 담기</button></div>
      </div>

      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=6'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1516750105099-4b8a83e217ee?w=400&q=70&auto=format&fit=crop" alt="샴푸" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <span class="product-badge">SALE</span>
          <button class="product-wish"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="product-body">
          <div class="product-brand">PetClean</div>
          <div class="product-name">순한 강아지 샴푸 500ml — 민감성 피부용</div>
          <div class="product-rating">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <span>4.4 (167)</span>
          </div>
          <div class="product-price"><span class="price-rate">30%</span><span class="price-sale">12,600원</span><span class="price-origin">18,000원</span></div>
        </div>
        <div class="product-footer"><button class="btn-cart">장바구니 담기</button></div>
      </div>
    </div>

    <div class="pagination">
      <button class="page-btn"><svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg></button>
      <button class="page-btn active">1</button>
      <button class="page-btn">2</button>
      <button class="page-btn">3</button>
      <button class="page-btn">4</button>
      <button class="page-btn">5</button>
      <button class="page-btn"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></button>
    </div>
  </div>
</div>

<script>
document.querySelectorAll('.sort-btn').forEach(b => b.addEventListener('click', function(){
  document.querySelectorAll('.sort-btn').forEach(x => x.classList.remove('on'));
  this.classList.add('on');
}));
document.querySelectorAll('.btn-cart').forEach(b => b.addEventListener('click', e => {
  e.stopPropagation();
  alert('장바구니에 담았습니다!');
}));
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
