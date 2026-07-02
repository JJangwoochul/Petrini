<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="hotel" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
  .hotel-page {
    max-width: var(--inner-width);
    margin: 0 auto;
    padding: 28px 20px 80px;
  }

  /* 검색 + 지역 필터 (동일 너비) */
  .hotel-toolbar {
    max-width: 720px;
    margin: 0 auto 24px;
  }
  .hotel-search-row {
    display: flex;
    gap: 0;
    width: 100%;
    margin-bottom: 12px;
  }
  .hotel-search-input {
    flex: 1;
    min-width: 0;
    height: 44px;
    padding: 0 16px;
    border: 1px solid #ccc;
    border-right: none;
    border-radius: 4px 0 0 4px;
    font-size: 14px;
    color: var(--text-main);
    outline: none;
  }
  .hotel-search-input::placeholder { color: #aaa; }
  .hotel-search-input:focus { border-color: var(--primary); }
  .hotel-search-btn {
    min-width: 88px;
    height: 44px;
    border: none;
    border-radius: 0 4px 4px 0;
    background: var(--primary);
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: background .2s;
  }
  .hotel-search-btn:hover { background: var(--primary-dark); }

  /* 상단 드롭다운 */
  .hotel-filter-row {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
  }
  .hotel-filter-select {
    height: 40px;
    padding: 0 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 14px;
    color: var(--text-main);
    background: #fff;
    cursor: pointer;
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23666' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 12px center;
  }
  .hotel-filter-select:disabled {
    background-color: #f5f5f5;
    color: #aaa;
    cursor: not-allowed;
  }

  /* 숙소 카드 */
  .stay-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
  }
  .stay-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    overflow: hidden;
    cursor: pointer;
    transition: var(--transition);
  }
  .stay-card:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-3px);
  }
  .stay-card-thumb {
    position: relative;
    width: 100%;
    aspect-ratio: 4 / 3;
    background: #e8e8e8;
    overflow: hidden;
  }
  .stay-card-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }
  .stay-card-badge {
    position: absolute;
    top: 12px;
    left: 12px;
    font-size: 11px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 20px;
  }
  .badge-stay {
    background: var(--primary-light);
    color: var(--primary-dark);
  }
  .stay-wish-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 34px;
    height: 34px;
    border-radius: 50%;
    border: none;
    background: rgba(255,255,255,.92);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .stay-wish-btn svg {
    width: 16px;
    height: 16px;
    stroke: var(--accent);
    fill: none;
    stroke-width: 1.8;
  }
  .stay-card-body {
    padding: 18px 16px 22px;
    min-height: 148px;
    display: flex;
    flex-direction: column;
  }
  .sc-name {
    font-size: 15px;
    font-weight: 700;
    color: var(--text-main);
    margin-bottom: 10px;
    line-height: 1.45;
    min-height: 44px;
  }
  .sc-loc {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 13px;
    color: var(--text-muted);
    margin-bottom: 10px;
  }
  .sc-loc svg {
    width: 14px;
    height: 14px;
    stroke: var(--text-muted);
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
    flex-shrink: 0;
  }
  .sc-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
    margin-bottom: 14px;
    min-height: 28px;
  }
  .sc-tag {
    font-size: 11px;
    font-weight: 600;
    padding: 4px 10px;
    border-radius: 20px;
    background: var(--bg-page);
    border: 1px solid var(--border);
    color: var(--text-sub);
  }
  .sc-foot {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-top: auto;
  }
  .sc-rating {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 13px;
    font-weight: 700;
    color: var(--text-main);
  }
  .sc-rating svg {
    width: 14px;
    height: 14px;
    fill: var(--yellow);
    stroke: none;
  }
  .sc-price {
    font-size: 13px;
    color: var(--text-sub);
    text-align: right;
  }
  .sc-price strong {
    font-size: 15px;
    font-weight: 800;
    color: var(--text-main);
  }

  @media (max-width: 768px) {
    .stay-grid { grid-template-columns: 1fr 1fr; }
    .hotel-filter-row { grid-template-columns: 1fr; }
  }
</style>

<main class="hotel-page">

  <div id="hotelPageData" data-context-path="${contextPath}" hidden></div>

  <%-- 검색 + 지역 필터 --%>
  <div class="hotel-toolbar">
    <div class="hotel-search-row">
      <input type="text" class="hotel-search-input" placeholder="숙소명 검색">
      <button type="button" class="hotel-search-btn">검색</button>
    </div>
    <div class="hotel-filter-row">
      <select id="hotelRegion" class="hotel-filter-select" aria-label="전체" onchange="onHotelRegionChange()">
        <option value="">전체</option>
      </select>
      <select id="hotelGu" class="hotel-filter-select" aria-label="시/군/구" disabled onchange="onHotelGuChange()">
        <option value="">시/군/구</option>
      </select>
      <select id="hotelDong" class="hotel-filter-select" aria-label="동/읍/면" disabled>
        <option value="">동/읍/면</option>
      </select>
    </div>
  </div>

  <div class="hotel-list">
    <div class="stay-grid">
      <div class="stay-card" onclick="location.href='${contextPath}/hotel/detail?id=1'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=500&q=70&auto=format&fit=crop" alt="강아지숲 펫 빌라"
               onerror="this.src='https://placehold.co/500x200/EAF7F2/2BAB82?text=숙소'">
          <span class="stay-card-badge badge-stay">반려동물 동반 숙소</span>
          <button type="button" class="stay-wish-btn wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">강아지숲 펫 빌라 — 독채 풀빌라</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>경기 가평군 청평면</div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.9 (186)</div>
            <div class="sc-price">1박 <strong>120,000원~</strong></div>
          </div>
        </div>
      </div>

      <div class="stay-card" onclick="location.href='${contextPath}/hotel/detail?id=2'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=70&auto=format&fit=crop" alt="멍멍 펜션"
               onerror="this.src='https://placehold.co/500x200/EAF7F2/2BAB82?text=숙소'">
          <span class="stay-card-badge badge-stay">반려동물 동반 숙소</span>
          <button type="button" class="stay-wish-btn wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">멍멍 펜션 — 반려동물 동반 오션뷰</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>강원 강릉시 경포동</div>
          <div class="sc-tags">
            <span class="sc-tag">오션뷰</span>
            <span class="sc-tag">마당 완비</span>
            <span class="sc-tag">소·중형견</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.8 (94)</div>
            <div class="sc-price">1박 <strong>98,000원~</strong></div>
          </div>
        </div>
      </div>

      <div class="stay-card" onclick="location.href='${contextPath}/hotel/detail?id=3'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1560448204-e02f11c2d0e2?w=500&q=70&auto=format&fit=crop" alt="댕댕이 호텔"
               onerror="this.src='https://placehold.co/500x200/EAF7F2/2BAB82?text=숙소'">
          <span class="stay-card-badge badge-stay">반려동물 동반 숙소</span>
          <button type="button" class="stay-wish-btn wish-btn" aria-label="찜하기"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">댕댕이 호텔 — 제주 오션뷰 스위트</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>제주 제주시 연동</div>
          <div class="sc-tags">
            <span class="sc-tag">제주</span>
            <span class="sc-tag">펫 어메니티</span>
            <span class="sc-tag">조식 포함</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.7 (152)</div>
            <div class="sc-price">1박 <strong>120,000원~</strong></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>

<script src="${contextPath}/resources/js/hotel-locations.js"></script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
