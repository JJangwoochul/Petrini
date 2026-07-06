<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 지윤 26.07.06 추가: 가격에 콤마(#,###) 찍으려고 fmt 태그 사용 필요해서 taglib 추가 --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
/* 지윤 26.07.06 검색창 스타일 추가 */
.store-search-box { display:flex; gap:8px; margin-bottom:16px; }
.store-search-box input[type=text] { flex:1; padding:9px 14px; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:14px; }
.store-search-box button { padding:9px 20px; border:none; border-radius:var(--radius-sm); background:var(--primary); color:#fff; font-size:13px; font-weight:700; cursor:pointer; }
.species-tabs { display:flex; gap:6px; margin-bottom:14px; }
.species-tab { flex:1; text-align:center; padding:8px 0; border:1px solid var(--border); border-radius:var(--radius-sm); font-size:13px; color:var(--text-sub); text-decoration:none; }
.species-tab.active { background:var(--primary); border-color:var(--primary); color:#fff; font-weight:700; }
.age-filter { display:flex; gap:6px; margin-bottom:14px; }
.age-chip { padding:6px 14px; border:1px solid var(--border); border-radius:20px; font-size:12px; color:var(--text-sub); text-decoration:none; }
.age-chip.active { border-color:var(--primary); background:var(--primary-light); color:var(--primary-dark); font-weight:700; }
</style>

<div class="store-wrap">
  <%-- 사이드바 --%>
  <aside class="store-sidebar">
    <%-- 지윤 26.07.06 카테고리 트리 적용: 강아지/고양이 탭 추가 --%>
    <div class="species-tabs">
      <c:forEach var="sp" items="${categoryTree}">
        <c:if test="${sp.depth == 2}">
          <c:url var="spUrl" value="/store">
            <c:param name="species" value="${sp.categoryId}"/>
          </c:url>
          <a href="${spUrl}" class="species-tab ${selectedSpecies == sp.categoryId ? 'active' : ''}">${sp.categoryName}</a>
        </c:if>
      </c:forEach>
    </div>
    <div class="store-sidebar-card">
      <div class="store-sidebar-title">카테고리</div>
      <ul class="store-cat-list">
        <c:url var="allCatUrl" value="/store">
          <c:param name="species" value="${selectedSpecies}"/>
        </c:url>
        <li><a href="${allCatUrl}" class="${empty selectedCategory ? 'active' : ''}">전체</a></li>
        <c:forEach var="cat" items="${categoryTree}">
          <c:if test="${cat.parentId == selectedSpecies && cat.depth == 3}">
            <c:url var="catUrl" value="/store">
              <c:param name="species" value="${selectedSpecies}"/>
              <c:param name="category" value="${cat.categoryId}"/>
            </c:url>
            <li><a href="${catUrl}" class="${selectedCategory == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a></li>
          </c:if>
        </c:forEach>
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
    <%-- 지윤 26.07.06 상품목록 전용 검색창 추가 --%>
    <form method="get" action="${contextPath}/store" class="store-search-box">
      <c:if test="${not empty selectedCategory}">
        <input type="hidden" name="category" value="${selectedCategory}">
      </c:if>
      <input type="text" name="keyword" value="${selectedKeyword}" placeholder="상품명 또는 브랜드로 검색">
      <button type="submit">검색</button>
    </form>
    <%-- 지윤 26.07.06 나이 필터: 선택된 카테고리에 나이 하위카테고리 있을 때만 표시 --%>
    <c:set var="hasAgeOptions" value="false"/>
    <c:forEach var="cat" items="${categoryTree}">
      <c:if test="${not empty selectedCategory && cat.parentId == selectedCategory}">
        <c:set var="hasAgeOptions" value="true"/>
      </c:if>
    </c:forEach>
    <c:if test="${hasAgeOptions}">
      <div class="age-filter">
        <c:url var="ageAllUrl" value="/store">
          <c:param name="species" value="${selectedSpecies}"/>
          <c:param name="category" value="${selectedCategory}"/>
        </c:url>
        <a href="${ageAllUrl}" class="age-chip ${empty selectedAge ? 'active' : ''}">전체</a>
        <c:forEach var="cat" items="${categoryTree}">
          <c:if test="${cat.parentId == selectedCategory}">
            <c:url var="ageUrl" value="/store">
              <c:param name="species" value="${selectedSpecies}"/>
              <c:param name="category" value="${selectedCategory}"/>
              <c:param name="age" value="${cat.categoryId}"/>
            </c:url>
            <a href="${ageUrl}" class="age-chip ${selectedAge == cat.categoryId ? 'active' : ''}">${cat.categoryName}</a>
          </c:if>
        </c:forEach>
      </div>
    </c:if>
    <div class="store-toolbar">

      <%--<div class="store-result-count">총 <strong>248</strong>개 상품</div>
      26.07.06 지윤. 하드코딩된 숫자 -> productList.size()로 실제 조회된 상품 개수 자동 표시하도록 변경 --%>
      <div class="store-result-count">총 <strong>${productList.size()}</strong>개 상품</div>
      <%-- 지윤 26.07.06 정렬 기능 추가: 버튼 -> 링크로 변경, 카테고리/검색어 유지한 채 정렬만 바뀌게 처리 --%>
<%--<c:url var="sortBaseUrl" value="/store">
  <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
  <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}"/></c:if>
</c:url>--%>
<c:url var="sortBaseUrl" value="/store">
  <c:param name="species" value="${selectedSpecies}"/>
  <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
  <c:if test="${not empty selectedAge}"><c:param name="age" value="${selectedAge}"/></c:if>
  <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}"/></c:if>
</c:url>

<%--<div class="store-sort">
  <a href="${sortBaseUrl}${empty selectedCategory && empty selectedKeyword ? '?' : '&'}sort=popular" class="sort-btn ${selectedSort == 'popular' ? 'on' : ''}">인기순</a>
  <a href="${sortBaseUrl}${empty selectedCategory && empty selectedKeyword ? '?' : '&'}sort=latest" class="sort-btn ${selectedSort == 'latest' ? 'on' : ''}">최신순</a>
  <a href="${sortBaseUrl}${empty selectedCategory && empty selectedKeyword ? '?' : '&'}sort=priceAsc" class="sort-btn ${selectedSort == 'priceAsc' ? 'on' : ''}">낮은가격</a>
  <a href="${sortBaseUrl}${empty selectedCategory && empty selectedKeyword ? '?' : '&'}sort=priceDesc" class="sort-btn ${selectedSort == 'priceDesc' ? 'on' : ''}">높은가격</a>
</div>--%>
<%-- 지윤 26.07.06 수정: sortBaseUrl에 species가 항상 포함되어 이미 완성된 URL(?species=5...)로 나옴
     기존 '?'/'&' 조건 분기를 두면 물음표가 두 번 붙어서 URL이 깨짐 -> 무조건 '&'로 고정 --%>
<div class="store-sort">
  <a href="${sortBaseUrl}&sort=popular" class="sort-btn ${selectedSort == 'popular' ? 'on' : ''}">인기순</a>
  <a href="${sortBaseUrl}&sort=latest" class="sort-btn ${selectedSort == 'latest' ? 'on' : ''}">최신순</a>
  <a href="${sortBaseUrl}&sort=priceAsc" class="sort-btn ${selectedSort == 'priceAsc' ? 'on' : ''}">낮은가격</a>
  <a href="${sortBaseUrl}&sort=priceDesc" class="sort-btn ${selectedSort == 'priceDesc' ? 'on' : ''}">높은가격</a>
</div>

    </div>

    <%--<div class="product-grid">
      <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=1'">
        <div class="product-thumb-wrap">
          <img class="product-thumb" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=400&q=70&auto=format&fit=crop" alt="사료" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
          <span class="product-badge">BEST</span>
          <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
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
          <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
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
          <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
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
          <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
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
          <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
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
          <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
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
    </div>--%>

   <%-- 지윤 26.07.06: 하드코딩 카드 6개 -> productList 실데이터 forEach로 교체 (USER-03) --%>
<div class="product-grid">
  <c:forEach var="p" items="${productList}">
    <div class="product-card" onclick="location.href='${contextPath}/store/detail?id=${p.productId}'">
      <div class="product-thumb-wrap">
        <%-- 지윤 26.07.06: TB_PRODUCT.DESCRIPTION에 임시로 이미지 URL이 들어있어서 그대로 사용 (더미데이터 한정, TB_FILE 연동 전까지) --%>
        <img class="product-thumb" src="${p.thumbnailUrl}" alt="${p.productName}" onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
        <%-- 지윤 26.07.06: 원래 있던 BEST/NEW/SALE 뱃지는 DB에 근거 데이터가 없어서, 할인율 있을 때만 SALE 뱃지 표시하도록 단순화 --%>
        <c:if test="${p.discountRate > 0}"><span class="product-badge">SALE</span></c:if>
        <button type="button" class="product-wish wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
      </div>
      <div class="product-body">
        <div class="product-brand">${p.brandName}</div>
        <div class="product-name">${p.productName}</div>
        <div class="product-rating">
          <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          <%-- 지윤 26.07.06: TB_REVIEW 더미데이터가 아직 없어서 지금은 항상 0.0 (0)으로 뜸. 리뷰 기능 붙이면 자동으로 채워짐 --%>
          <span>${p.avgRating} (${p.reviewCount})</span>
        </div>
        <div class="product-price">
          <%-- 지윤 26.07.06: 할인율 있으면 정가+할인율 같이 표시, 없으면 판매가만 표시 --%>
          <c:if test="${p.discountRate > 0}">
            <span class="price-rate">${p.discountRate}%</span>
            <span class="price-sale"><fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>원</span>
            <span class="price-origin"><fmt:formatNumber value="${p.price}" pattern="#,###"/>원</span>
          </c:if>
          <c:if test="${p.discountRate == 0}">
            <span class="price-sale"><fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>원</span>
          </c:if>
        </div>
      </div>
      <div class="product-footer"><button class="btn-cart" data-product-id="${p.productId}">장바구니 담기</button></div>
    </div>
  </c:forEach>
</div>


   <%-- <div class="pagination">
      <button class="page-btn"><svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg></button>
      <button class="page-btn active">1</button>
      <button class="page-btn">2</button>
      <button class="page-btn">3</button>
      <button class="page-btn">4</button>
      <button class="page-btn">5</button>
      <button class="page-btn"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></button>
    </div>--%>
    <%-- 지윤 26.07.06 페이지네이션 기능 추가: 하드코딩 1~5 -> totalPages만큼 자동 생성 --%>
<%--<c:url var="pageBaseUrl" value="/store">
  <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
  <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}"/></c:if>
  <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
</c:url>--%>
<c:url var="pageBaseUrl" value="/store">
  <c:param name="species" value="${selectedSpecies}"/>
  <c:if test="${not empty selectedCategory}"><c:param name="category" value="${selectedCategory}"/></c:if>
  <c:if test="${not empty selectedAge}"><c:param name="age" value="${selectedAge}"/></c:if>
  <c:if test="${not empty selectedKeyword}"><c:param name="keyword" value="${selectedKeyword}"/></c:if>
  <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
</c:url>

<%--<c:set var="pageSep" value="${empty selectedCategory && empty selectedKeyword && empty selectedSort ? '?' : '&'}"/>--%>
<%-- 지윤 26.07.06 수정: pageBaseUrl도 species가 항상 포함되어 이미 완성된 URL로 나옴 -> 무조건 '&'로 고정 --%>
<c:set var="pageSep" value="&"/>

<div class="pagination">
  <c:if test="${currentPage > 1}">
    <a class="page-btn" href="${pageBaseUrl}${pageSep}page=${currentPage - 1}"><svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg></a>
  </c:if>
  <c:forEach var="p" begin="1" end="${totalPages}">
    <a class="page-btn ${p == currentPage ? 'active' : ''}" href="${pageBaseUrl}${pageSep}page=${p}">${p}</a>
  </c:forEach>
  <c:if test="${currentPage < totalPages}">
    <a class="page-btn" href="${pageBaseUrl}${pageSep}page=${currentPage + 1}"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></a>
  </c:if>
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
