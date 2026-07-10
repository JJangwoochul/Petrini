<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
  .stay-search-bar {
      display: flex; gap: 0; background: #fff; border-radius: var(--radius-md);
      overflow: hidden; box-shadow: 0 4px 24px rgba(0,0,0,.18);
      max-width: 700px; margin: 0 auto 0;
  }
  /* 본문 레이아웃 */
  .stay-wrap {
      max-width: var(--inner-width); margin: 28px auto 80px; padding: 0 20px;
      display: grid; grid-template-columns: 240px 1fr; gap: 24px; align-items: flex-start;
  }
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
      background: #E0F2FE; color: #0284C7;
  }
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
  .sc-name   { font-size: 15px; font-weight: 800; color: var(--text-main); margin-bottom: 5px; white-space:nowrap;overflow:hidden;text-overflow:ellipsis }
  .sc-loc    { display: flex; align-items: center; gap: 4px; font-size: 12px; color: var(--text-muted); margin-bottom: 6px; }
  .sc-loc svg { width: 12px; height: 12px; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
  .sc-tags   { display: flex; gap: 5px; flex-wrap: wrap; margin-bottom: 8px; }
  .sc-tag    { font-size: 11px; padding: 2px 8px; border-radius: 20px; background: var(--bg-page); color: var(--text-muted); border: 1px solid var(--border); }
  .sc-foot   { display: flex; justify-content: space-between; align-items: center; }
  .sc-rooms  { font-size: 12px; color: var(--text-muted); }
  .sc-price  { font-size: 13px; color: var(--text-muted); }
  .sc-price strong { font-size: 15px; font-weight: 800; color: var(--text-main); }
  .empty-box{display:flex;flex-direction:column;align-items:center;gap:14px;padding:80px 0;text-align:center;grid-column:1/-1}
  .empty-icon{width:64px;height:64px;border-radius:50%;background:#EFF6FF;display:flex;align-items:center;justify-content:center}
  .empty-icon svg{width:30px;height:30px;stroke:#4F6BC4;fill:none;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round}
</style>

<%-- 히어로 --%>
<div class="stay-hero">
  <div class="stay-hero-inner">
    <h1>반려동물과 함께 묵는 숙소</h1>
    <p>대형견 가능, 안내견 가능, 애견 놀이터 — 우리 아이에게 딱 맞는 숙소를 찾아보세요</p>
    <div class="stay-search-bar"></div>
  </div>
</div>

<%-- 본문 --%>
<div class="stay-wrap">
  <%-- 필터 사이드바 (기존 그대로) --%>
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
      <div class="sfc-title">반려동물 특화 조건</div>
      <div style="display:flex;flex-direction:column;gap:12px">
        <div class="sfc-toggle-row"><span>대형견 가능</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>안내견 가능</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>애견 놀이터</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>야외 수영장</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>펫 어메니티 제공</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
        <div class="sfc-toggle-row"><span>독채 운영</span><label class="toggle"><input type="checkbox"><span class="toggle-slider"></span></label></div>
      </div>
    </div>
    <div class="stay-filter-card">
      <div class="sfc-title">1박 요금</div>
      <input type="range" class="sfc-range" min="0" max="300000" step="10000" value="300000">
      <div class="sfc-range-vals"><span>0원</span><span>30만원 이하</span></div>
    </div>
  </aside>

  <%-- 목록 --%>
  <div>
    <div class="stay-toolbar">
      <span style="font-size:14px;color:var(--text-sub)">총 <strong style="color:var(--text-main)">${lodgeList.size()}</strong>개 숙소</span>
      <div class="stay-sort">
        <span class="sort-chip on" onclick="selSort(this)">추천순</span>
        <span class="sort-chip" onclick="selSort(this)">낮은 가격순</span>
      </div>
    </div>

    <div class="stay-grid">
      <%-- ★ DB 데이터로 카드 반복 생성 --%>
      <c:choose>
        <c:when test="${not empty lodgeList}">
          <c:forEach var="s" items="${lodgeList}">
            <div class="stay-card" onclick="location.href='${contextPath}/stay/detail?id=${s.lodgeId}'">
              <div class="stay-card-thumb">
                <img src="${contextPath}/upload/${s.thumbPath}"
                     alt="${s.lodgeName}">
                <span class="stay-card-badge">반려동물 동반 숙소</span>
                <button class="stay-wish-btn" onclick="event.stopPropagation()">
                  <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
                </button>
              </div>
              <div class="stay-card-body">
                <div class="sc-name">${s.lodgeName}</div>
                <div class="sc-loc">
                  <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                  ${s.addr}
                </div>
                <c:if test="${not empty s.facilities}">
                  <div class="sc-tags">
                    <c:forTokens items="${s.facilities}" delims="," var="tag">
                      <span class="sc-tag">${tag}</span>
                    </c:forTokens>
                  </div>
                </c:if>
                <div class="sc-foot">
                  <span class="sc-rooms">객실 ${s.roomCount}개</span>
                  <c:choose>
                    <c:when test="${s.minPrice > 0}">
                      <div class="sc-price">1박 <strong><fmt:formatNumber value="${s.minPrice}" type="number"/>원</strong>~</div>
                    </c:when>
                    <c:otherwise>
                      <div class="sc-price">가격 문의</div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="empty-box">
            <div class="empty-icon">
              <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
            </div>
            <p style="font-size:15px;font-weight:600;color:var(--text-main);margin:0">등록된 숙소가 없습니다.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<script>
function selChip(el) {
    var parent = el.closest('.sfc-chips');
    var chips = parent.querySelectorAll('.sfc-chip');
    for (var i = 0; i < chips.length; i++) { chips[i].classList.remove('on'); }
    el.classList.add('on');
}
function selSort(el) {
    var chips = document.querySelectorAll('.sort-chip');
    for (var i = 0; i < chips.length; i++) { chips[i].classList.remove('on'); }
    el.classList.add('on');
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
