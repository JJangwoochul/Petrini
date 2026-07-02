<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="stay" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
  /* ── 히어로 ── */
  .stay-hero {
      background:linear-gradient(135deg,#1A1A2E 0%,#2D2D5E 60%,#4F6BC4 100%);
      padding: 48px 0 0; color: #fff; text-align: center;
  }
  .stay-hero-inner { max-width: var(--inner-width); margin: 0 auto; padding: 0 20px; }
  .stay-hero h1 { font-size: 32px; font-weight: 800; margin: 0 0 10px; }
  .stay-hero p  { font-size: 15px; opacity: .8; margin: 0 0 28px; }
  
  /* 검색 바 */
  .stay-search-bar {
      display: flex; gap: 0; background: #fff; border-radius: var(--radius-md);
      overflow: hidden; box-shadow: 0 4px 24px rgba(0,0,0,.18);
      max-width: 700px; margin: 0 auto 0;
  }
  .ssb-group {
      display: flex; flex-direction: column;
      padding: 12px 18px; flex: 1;
      border-right: 1px solid #eee; cursor: pointer;
  }
  .ssb-group:last-of-type { border-right: none; }
  .ssb-group label { font-size: 11px; font-weight: 700; color: #999; margin-bottom: 3px; cursor: pointer; }
  .ssb-group input, .ssb-group select {
      border: none; outline: none; font-size: 14px;
      font-weight: 600; color: #1A1A2E; background: transparent;
      font-family: inherit; cursor: pointer;
  }
  .stay-search-btn {
      padding: 0 24px; border: none; background: var(--primary);
      color: #fff; font-size: 14px; font-weight: 700;
      cursor: pointer; display: flex; align-items: center; gap: 6px;
      transition: var(--transition);
  }
  .stay-search-btn:hover { background: var(--primary-dark); }
  .stay-search-btn svg {
      width: 16px; height: 16px; stroke: #fff; fill: none;
      stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
  }
  
  /* 탭 */
  .stay-tab-wrap {
      background: #fff; border-bottom: 1px solid var(--border);
      position: sticky; top: 0; z-index: 10;
      box-shadow: 0 2px 8px rgba(0,0,0,.05);
  }
  .stay-tabs {
      max-width: var(--inner-width); margin: 0 auto;
      padding: 0 20px; display: flex; gap: 0;
  }
  .stay-tab {
      display: flex; align-items: center; gap: 8px;
      padding: 15px 24px; font-size: 14px; font-weight: 600;
      color: var(--text-muted); border: none; background: none;
      cursor: pointer; border-bottom: 3px solid transparent;
      margin-bottom: -1px; transition: var(--transition);
  }
  .stay-tab:hover { color: var(--primary); }
  .stay-tab.on { color: var(--primary); border-bottom-color: var(--primary); }
  .stay-tab svg {
      width: 16px; height: 16px; stroke: currentColor; fill: none;
      stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round;
  }
  
  /* 본문 레이아웃 */
  .stay-wrap {
      max-width: var(--inner-width); margin: 28px auto 80px; padding: 0 20px;
      display: grid; grid-template-columns: 240px 1fr; gap: 24px; align-items: flex-start;
  }
  /* 사이드 필터 */
  .stay-filter-card {
      background: var(--bg-card); border: 1px solid var(--border);
      border-radius: var(--radius-md); padding: 18px; margin-bottom: 14px;
  }
  .sfc-title { font-size: 13px; font-weight: 800; color: var(--text-main); margin: 0 0 12px; }
  .sfc-chips { display: flex; flex-wrap: wrap; gap: 6px; }
  .sfc-chip {
      padding: 6px 13px; border: 1px solid var(--border); border-radius: 50px;
      font-size: 12px; color: var(--text-sub); cursor: pointer; transition: var(--transition);
      background: #fff;
  }
  .sfc-chip:hover, .sfc-chip.on {
      border-color: var(--primary); background: var(--primary-light);
      color: var(--primary-dark); font-weight: 600;
  }
  .sfc-range { width: 100%; accent-color: var(--primary); margin-top: 4px; }
  .sfc-range-vals { display: flex; justify-content: space-between; font-size: 12px; color: var(--text-muted); margin-top: 4px; }
  .sfc-toggle-row {
      display: flex; justify-content: space-between;
      align-items: center; font-size: 13px; color: var(--text-sub);
  }
  .toggle { position: relative; display: inline-block; width: 40px; height: 22px; }
  .toggle input { opacity: 0; width: 0; height: 0; }
  .toggle-slider {
      position: absolute; cursor: pointer; inset: 0;
      background: #ccc; border-radius: 22px; transition: .3s;
  }
  .toggle-slider:before {
      content: ''; position: absolute;
      width: 16px; height: 16px; left: 3px; bottom: 3px;
      background: #fff; border-radius: 50%; transition: .3s;
  }
  .toggle input:checked + .toggle-slider { background: var(--primary); }
  .toggle input:checked + .toggle-slider:before { transform: translateX(18px); }
  
  /* 목록 */
  .stay-toolbar {
      display: flex; justify-content: space-between; align-items: center;
      margin-bottom: 16px;
  }
  .stay-sort { display: flex; gap: 6px; }
  .sort-chip {
      padding: 6px 14px; border: 1px solid var(--border); border-radius: 50px;
      font-size: 12px; color: var(--text-sub); cursor: pointer; transition: var(--transition);
      background: #fff;
  }
  .sort-chip.on, .sort-chip:hover {
      border-color: var(--primary); color: var(--primary); background: var(--primary-light);
  }
  .stay-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; margin-bottom: 28px; }
  .stay-card {
      background: var(--bg-card); border: 1px solid var(--border);
      border-radius: var(--radius-md); overflow: hidden;
      transition: var(--transition); cursor: pointer;
  }
  .stay-card:hover { box-shadow: var(--shadow-md); transform: translateY(-2px); }
  .stay-card-thumb { position: relative; }
  .stay-card-thumb img { width: 100%; height: 200px; object-fit: cover; display: block; }
  .stay-card-badge {
      position: absolute; top: 10px; left: 10px;
      font-size: 11px; font-weight: 700; padding: 3px 9px; border-radius: 20px;
  }
  .badge-stay       { background: #E0F2FE; color: #0284C7; }
  .badge-cafe       { background: #FFF7ED; color: #EA580C; }
  .badge-experience { background: #F3E8FF; color: #9333EA; }
  .badge-restaurant { background: #DCFCE7; color: #16A34A; }
  .stay-wish-btn {
      position: absolute; top: 10px; right: 10px;
      width: 32px; height: 32px; border-radius: 50%;
      background: rgba(255,255,255,.9); border: none; cursor: pointer;
      display: flex; align-items: center; justify-content: center;
  }
  .stay-wish-btn svg {
      width: 15px; height: 15px; stroke: var(--accent); fill: none;
      stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round;
  }
  .stay-card-body { padding: 14px; }
  .sc-name   { font-size: 15px; font-weight: 800; color: var(--text-main); margin-bottom: 5px; }
  .sc-loc    { display: flex; align-items: center; gap: 4px; font-size: 12px; color: var(--text-muted); margin-bottom: 6px; }
  .sc-loc svg { width: 12px; height: 12px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
  .sc-tags   { display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 8px; }
  .sc-tag    { font-size: 11px; padding: 2px 8px; border-radius: 20px; background: var(--bg-page); color: var(--text-muted); border: 1px solid var(--border); }
  .sc-foot   { display: flex; justify-content: space-between; align-items: center; }
  .sc-rating { display: flex; align-items: center; gap: 3px; font-size: 13px; font-weight: 700; color: var(--text-main); }
  .sc-rating svg { width: 13px; height: 13px; fill: var(--yellow); }
  .sc-price  { font-size: 13px; color: var(--text-muted); }
  .sc-price strong { font-size: 15px; font-weight: 800; color: var(--text-main); }
</style>

<%-- 히어로 --%>
<div class="stay-hero">
  <div class="stay-hero-inner">
    <h1>반려동물과 함께하는 여가</h1>
    <p>숙소·카페·체험·맛집 — 반려동물 동반 가능한 공간을 찾아보세요</p>
    <div class="stay-search-bar">
      <%-- <div class="ssb-group">
        <label>지역</label>
        <select><option>전체 지역</option><option>서울</option><option>경기</option><option>강원</option><option>제주</option><option>부산</option></select>
      </div>
      <div class="ssb-group">
        <label>날짜</label>
        <input type="date" value="2025-07-05">
      </div>
      <div class="ssb-group">
        <label>반려동물 크기</label>
        <select><option>전체</option><option>소형 (5kg 미만)</option><option>중형 (5~15kg)</option><option>대형 (15kg 이상)</option></select>
      </div>
      <button class="stay-search-btn">
        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
        검색
      </button> --%>
    </div>
  </div>
</div>

<%-- 유형 탭 --%>
<div class="stay-tab-wrap">
  <div class="stay-tabs">
    <button class="stay-tab on" onclick="selTab(this)">
      <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><path d="M9 22V12h6v10"/></svg>
      전체
    </button>
    <button class="stay-tab" onclick="selTab(this)">
      <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><path d="M9 22V12h6v10"/></svg>
      반려동물 동반 숙소
    </button>
    <button class="stay-tab" onclick="selTab(this)">
      <svg viewBox="0 0 24 24"><path d="M18 8h1a4 4 0 010 8h-1"/><path d="M2 8h16v9a4 4 0 01-4 4H6a4 4 0 01-4-4V8z"/><line x1="6" y1="1" x2="6" y2="4"/><line x1="10" y1="1" x2="10" y2="4"/><line x1="14" y1="1" x2="14" y2="4"/></svg>
      반려동물 동반 카페
    </button>
    <button class="stay-tab" onclick="selTab(this)">
      <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      체험 프로그램
    </button>
    <button class="stay-tab" onclick="selTab(this)">
      <svg viewBox="0 0 24 24"><path d="M3 11l19-9-9 19-2-8-8-2z"/></svg>
      반려동물 동반 맛집
    </button>
  </div>
</div>

<%-- 본문 --%>
<div class="stay-wrap">
  <%-- 필터 사이드바 --%>
  <aside>
    <div class="stay-filter-card">
      <div class="sfc-title">지역</div>
      <div class="sfc-chips">
        <span class="sfc-chip on" onclick="selChip(this)">전체</span>
        <span class="sfc-chip" onclick="selChip(this)">서울</span>
        <span class="sfc-chip" onclick="selChip(this)">경기</span>
        <span class="sfc-chip" onclick="selChip(this)">강원</span>
        <span class="sfc-chip" onclick="selChip(this)">제주</span>
        <span class="sfc-chip" onclick="selChip(this)">부산</span>
        <span class="sfc-chip" onclick="selChip(this)">경상</span>
        <span class="sfc-chip" onclick="selChip(this)">전라</span>
      </div>
    </div>
    <div class="stay-filter-card">
      <div class="sfc-title">반려동물 크기</div>
      <div class="sfc-chips">
        <span class="sfc-chip on" onclick="selChip(this)">전체</span>
        <span class="sfc-chip" onclick="selChip(this)">소형</span>
        <span class="sfc-chip" onclick="selChip(this)">중형</span>
        <span class="sfc-chip" onclick="selChip(this)">대형</span>
      </div>
    </div>
    <div class="stay-filter-card">
      <div class="sfc-title">1박 요금</div>
      <input type="range" class="sfc-range" min="0" max="300000" step="10000" value="300000">
      <div class="sfc-range-vals"><span>0원</span><span>30만원 이하</span></div>
    </div>
    <div class="stay-filter-card">
      <div style="display:flex;flex-direction:column;gap:12px">
        <div class="sfc-toggle-row"><span>즉시 예약 가능</span><label class="toggle"><input type="checkbox" checked><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>추가 요금 없음</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>취사 가능</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
      </div>
    </div>
  </aside>

  <%-- 목록 --%>
  <div>
    <div class="stay-toolbar">
      <span style="font-size:14px;color:var(--text-sub)">총 <strong style="color:var(--text-main)">48</strong>개 장소</span>
      <div class="stay-sort">
        <span class="sort-chip on" onclick="selSort(this)">추천순</span>
        <span class="sort-chip" onclick="selSort(this)">리뷰 많은순</span>
        <span class="sort-chip" onclick="selSort(this)">낮은 가격순</span>
        <span class="sort-chip" onclick="selSort(this)">최신순</span>
      </div>
    </div>

    <div class="stay-grid">
      <%-- 카드 1 — 펫 호텔 --%>
      <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=1'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=500&q=70&auto=format&fit=crop" alt="펫호텔" onerror="this.src='https://placehold.co/500x200/E0F2FE/0284C7?text=숙소'">
          <span class="stay-card-badge badge-stay">반려동물 동반 숙소</span>
          <button class="stay-wish-btn" onclick="event.stopPropagation()"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">강아지숲 펫 빌라 — 독채 풀빌라</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>경기 가평군 · 서울에서 1시간</div>
          <div class="sc-tags">
            <span class="sc-tag">대형견 가능</span>
            <span class="sc-tag">풀빌라</span>
            <span class="sc-tag">독채</span>
            <span class="sc-tag">취사 가능</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.9 (84)</div>
            <div class="sc-price">1박 <strong>158,000원</strong>~</div>
          </div>
        </div>
      </div>

      <%-- 카드 2 — 반려동물 카페 --%>
      <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=2'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1559925393-8be0ec4767c8?w=500&q=70&auto=format&fit=crop" alt="카페" onerror="this.src='https://placehold.co/500x200/FFF7ED/EA580C?text=카페'">
          <span class="stay-card-badge badge-cafe">반려동물 카페</span>
          <button class="stay-wish-btn" onclick="event.stopPropagation()"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">멍냥 카페 합정 — 반려동물 동반 브런치</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 마포구 합정동</div>
          <div class="sc-tags">
            <span class="sc-tag">소형견 가능</span>
            <span class="sc-tag">야외 테라스</span>
            <span class="sc-tag">브런치</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.7 (142)</div>
            <div class="sc-price">입장료 없음</div>
          </div>
        </div>
      </div>

      <%-- 카드 3 — 체험 --%>
      <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=3'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=500&q=70&auto=format&fit=crop" alt="체험" onerror="this.src='https://placehold.co/500x200/F3E8FF/9333EA?text=체험'">
          <span class="stay-card-badge badge-experience">체험 프로그램</span>
          <button class="stay-wish-btn" onclick="event.stopPropagation()"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">반려견 수영장 체험 — 여름 특별 프로그램</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>경기 고양시 일산동구</div>
          <div class="sc-tags">
            <span class="sc-tag">전 견종 가능</span>
            <span class="sc-tag">수영장</span>
            <span class="sc-tag">샤워실 완비</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.8 (67)</div>
            <div class="sc-price">1회 <strong>35,000원</strong></div>
          </div>
        </div>
      </div>

      <%-- 카드 4 — 맛집 --%>
      <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=4'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500&q=70&auto=format&fit=crop" alt="맛집" onerror="this.src='https://placehold.co/500x200/DCFCE7/16A34A?text=맛집'">
          <span class="stay-card-badge badge-restaurant">반려동물 맛집</span>
          <button class="stay-wish-btn" onclick="event.stopPropagation()"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">멍멍 파스타 — 반려동물 동반 이탈리안</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 강남구 청담동</div>
          <div class="sc-tags">
            <span class="sc-tag">소형견 가능</span>
            <span class="sc-tag">반려견 메뉴</span>
            <span class="sc-tag">야외석</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.6 (228)</div>
            <div class="sc-price">1인 <strong>25,000원~</strong></div>
          </div>
        </div>
      </div>

      <%-- 카드 5 --%>
      <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=5'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=70&auto=format&fit=crop" alt="글램핑" onerror="this.src='https://placehold.co/500x200/E0F2FE/0284C7?text=숙소'">
          <span class="stay-card-badge badge-stay">반려동물 동반 숙소</span>
          <button class="stay-wish-btn" onclick="event.stopPropagation()"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">펫 글램핑 제주 — 자연 속 반려동물 캠핑</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>제주 서귀포시 표선면</div>
          <div class="sc-tags">
            <span class="sc-tag">대형견 가능</span>
            <span class="sc-tag">글램핑</span>
            <span class="sc-tag">바베큐 가능</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.8 (55)</div>
            <div class="sc-price">1박 <strong>120,000원~</strong></div>
          </div>
        </div>
      </div>

      <%-- 카드 6 --%>
      <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=6'">
        <div class="stay-card-thumb">
          <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=500&q=70&auto=format&fit=crop" alt="체험" onerror="this.src='https://placehold.co/500x200/F3E8FF/9333EA?text=체험'">
          <span class="stay-card-badge badge-experience">체험 프로그램</span>
          <button class="stay-wish-btn" onclick="event.stopPropagation()"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
        </div>
        <div class="stay-card-body">
          <div class="sc-name">반려견 어질리티 체험 — 기초 훈련 클래스</div>
          <div class="sc-loc"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 송파구 방이동</div>
          <div class="sc-tags">
            <span class="sc-tag">소·중형견</span>
            <span class="sc-tag">훈련사 지도</span>
            <span class="sc-tag">1시간</span>
          </div>
          <div class="sc-foot">
            <div class="sc-rating"><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>4.9 (38)</div>
            <div class="sc-price">1회 <strong>45,000원</strong></div>
          </div>
        </div>
      </div>
    </div>

    <div style="display:flex;justify-content:center;gap:5px">
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">‹</button>
      <button style="width:36px;height:36px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-weight:700;cursor:pointer">1</button>
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">2</button>
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">3</button>
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">›</button>
    </div>
  </div>
</div>

<script>
function selTab(btn) {
    document.querySelectorAll('.stay-tab').forEach(t => t.classList.remove('on'));
    btn.classList.add('on');
}
function selChip(el) {
    const parent = el.closest('.sfc-chips');
    parent.querySelectorAll('.sfc-chip').forEach(c => c.classList.remove('on'));
    el.classList.add('on');
}
function selSort(el) {
    document.querySelectorAll('.sort-chip').forEach(c => c.classList.remove('on'));
    el.classList.add('on');
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
