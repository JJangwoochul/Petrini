<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="stay" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
  .sd-wrap { max-width: var(--inner-width); margin: 32px auto 80px; padding: 0 20px; display: grid; grid-template-columns: 1fr 320px; gap: 28px; align-items: flex-start; }
  .sd-back { display:inline-flex; align-items:center; gap:6px; font-size:13px; color:var(--text-muted); text-decoration:none; margin-bottom:18px; transition:var(--transition); }
  .sd-back:hover { color: var(--primary); }
  .sd-back svg { width:14px; height:14px; stroke:currentColor; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
  .sd-gallery { display:grid; grid-template-columns:2fr 1fr 1fr; grid-template-rows:1fr 1fr; gap:6px; border-radius:var(--radius-md); overflow:hidden; height:360px; margin-bottom:22px; }
  .sd-gallery img { width:100%; height:100%; object-fit:cover; display:block; }
  .sd-gallery img:first-child { grid-row: span 2; }
  .sd-badge { display:inline-block; font-size:12px; font-weight:700; padding:4px 12px; border-radius:20px; background:var(--primary-light); color:var(--primary-dark); margin-bottom:10px; }
  .sd-title { font-size:26px; font-weight:800; color:var(--text-main); margin-bottom:10px; line-height:1.3; }
  .sd-loc { display:flex; align-items:center; gap:5px; font-size:14px; color:var(--text-muted); margin-bottom:14px; }
  .sd-loc svg { width:14px; height:14px; stroke:currentColor; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
  .sd-rating { display:flex; align-items:center; gap:8px; font-size:14px; color:var(--text-main); font-weight:700; margin-bottom:14px; }
  .sd-rating svg { width:15px; height:15px; fill:var(--yellow); }
  .sd-tags { display:flex; gap:7px; flex-wrap:wrap; margin-bottom:20px; }
  .sd-tag { font-size:12px; font-weight:600; padding:5px 12px; border-radius:20px; background:var(--bg-page); border:1px solid var(--border); color:var(--text-sub); }
  .sd-section { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-md); padding:20px; margin-bottom:16px; }
  .sd-section h3 { font-size:15px; font-weight:800; color:var(--text-main); margin:0 0 14px; display:flex; align-items:center; gap:8px; }
  .sd-section h3 svg { width:16px; height:16px; stroke:var(--primary); fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
  .sd-info-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
  .sd-info-row { background:var(--bg-page); border-radius:var(--radius-sm); padding:12px 14px; }
  .sd-info-row label { font-size:11px; color:var(--text-muted); font-weight:600; display:block; margin-bottom:3px; }
  .sd-info-row span { font-size:14px; font-weight:600; color:var(--text-main); }
  .sd-desc { font-size:14px; color:var(--text-sub); line-height:1.8; margin:0; }
  .sd-rule-list { display:flex; flex-direction:column; gap:8px; }
  .sd-rule-item { display:flex; align-items:flex-start; gap:10px; font-size:13px; color:var(--text-sub); }
  .sd-rule-item svg { width:15px; height:15px; flex-shrink:0; margin-top:1px; stroke-linecap:round; stroke-linejoin:round; }
  .sd-rule-item.ok svg { stroke:#16A34A; fill:none; stroke-width:2; }
  .sd-rule-item.no svg { stroke:#DC2626; fill:none; stroke-width:2; }
  .room-card { display:flex; justify-content:space-between; align-items:center; padding:16px; background:var(--bg-page); border-radius:var(--radius-sm); margin-bottom:8px; }
  .room-name { font-size:15px; font-weight:700; color:var(--text-main); }
  .room-meta { font-size:12px; color:var(--text-muted); margin-top:4px; }
  .room-price { font-size:17px; font-weight:800; color:var(--primary-dark); }
  .room-price-label { font-size:11px; color:var(--text-muted); }
  .review-summary { display:flex; gap:28px; align-items:center; background:var(--bg-page); border-radius:var(--radius-sm); padding:20px; margin-bottom:18px; }
  .rv-avg .big { font-size:44px; font-weight:800; color:var(--text-main); line-height:1; }
  .rv-avg small { font-size:13px; color:var(--text-muted); }
  .rv-stars { display:flex; gap:3px; margin:6px 0; }
  .rv-stars svg { width:16px; height:16px; fill:var(--yellow); }
  .rv-bars { flex:1; display:flex; flex-direction:column; gap:5px; }
  .rv-bar-row { display:flex; align-items:center; gap:8px; font-size:12px; color:var(--text-muted); }
  .rv-bar-bg { flex:1; height:5px; background:var(--border); border-radius:3px; overflow:hidden; }
  .rv-bar-fill { height:100%; background:var(--yellow); border-radius:3px; }
  .review-card { border:1px solid var(--border); border-radius:var(--radius-sm); padding:16px; margin-bottom:12px; }
  .rv-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:8px; }
  .rv-name { font-size:14px; font-weight:700; color:var(--text-main); }
  .rv-date { font-size:12px; color:var(--text-muted); }
  .rv-text { font-size:14px; color:var(--text-sub); line-height:1.6; }
  .reserve-card { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-md); padding:22px; position:sticky; top:20px; }
  .reserve-card h3 { font-size:16px; font-weight:800; color:var(--text-main); margin:0 0 16px; }
  .rc-price { font-size:22px; font-weight:800; color:var(--text-main); margin-bottom:16px; }
  .rc-price span { font-size:13px; font-weight:400; color:var(--text-muted); }
  .rc-form-group { display:flex; flex-direction:column; gap:5px; margin-bottom:12px; }
  .rc-form-group label { font-size:12px; font-weight:700; color:var(--text-muted); }
  .rc-form-group input, .rc-form-group select { border:1px solid var(--border); border-radius:var(--radius-sm); padding:10px 12px; font-size:14px; color:var(--text-main); outline:none; font-family:inherit; width:100%; box-sizing:border-box; }
  .rc-form-group input:focus, .rc-form-group select:focus { border-color:var(--primary); }
  .rc-date-row { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
  .rc-divider { height:1px; background:var(--border); margin:14px 0; }
  .rc-price-row { display:flex; justify-content:space-between; font-size:14px; color:var(--text-sub); margin-bottom:8px; }
  .rc-price-row.total { font-size:16px; font-weight:800; color:var(--text-main); padding-top:12px; border-top:1px solid var(--border); margin-top:4px; }
  .rc-price-row.total span:last-child { color:var(--primary-dark); }
  .btn-reserve-big { width:100%; padding:14px; border:none; border-radius:var(--radius-sm); background:var(--primary); color:#fff; font-size:16px; font-weight:800; cursor:pointer; margin-top:12px; transition:var(--transition); }
  .btn-reserve-big:hover { background:var(--primary-dark); }
  .rc-notice { font-size:12px; color:var(--text-muted); margin-top:10px; line-height:1.6; }
</style>

<div style="max-width:var(--inner-width);margin:28px auto 0;padding:0 20px">
  <a href="${contextPath}/stay" class="sd-back">
    <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
    숙소 목록으로
  </a>
</div>

<c:if test="${empty stay}">
  <div style="max-width:var(--inner-width);margin:60px auto;text-align:center;color:var(--text-muted)">
    <p style="font-size:18px;font-weight:700;">숙소 정보를 찾을 수 없습니다.</p>
    <a href="${contextPath}/stay" style="color:var(--primary)">목록으로 돌아가기</a>
  </div>
</c:if>

<c:if test="${not empty stay}">
<div class="sd-wrap">
  <div>
    <%-- 갤러리 --%>
    <div class="sd-gallery">
      <%-- <img src="${contextPath}/upload/stay/${stay.stayId}/2.jpg"
           onerror="this.src='https://placehold.co/350x180/EEE/999?text=사진2'">
      <img src="${contextPath}/upload/stay/${stay.stayId}/3.jpg"
           onerror="this.src='https://placehold.co/350x180/EEE/999?text=사진3'">
      <img src="${contextPath}/upload/stay/${stay.stayId}/4.jpg"
           onerror="this.src='https://placehold.co/350x180/EEE/999?text=사진4'">
      <img src="${contextPath}/upload/stay/${stay.stayId}/5.jpg"
           onerror="this.src='https://placehold.co/350x180/EEE/999?text=사진5'"> --%>
      <c:forEach var="img" items="${imgList}">
        <img src="${contextPath}/upload/${img.fileUrl}" alt="${stay.name}" alt="${stay.name}">
      </c:forEach>
    </div>

    <span class="sd-badge">반려동물 동반 숙소</span>
    <div class="sd-title">${stay.name}</div>
    <div class="sd-loc">
      <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
      ${stay.addr}
    </div>
    <div class="sd-rating">
      <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
      4.9 <span style="font-size:13px;color:var(--text-muted);font-weight:400">(84개 리뷰)</span>
    </div>
    <%-- 편의시설 태그 --%>
    <c:if test="${not empty stay.facilities}">
      <div class="sd-tags">
        <c:forEach var="fac" items="${fn:split(stay.facilities, ',')}">
          <span class="sd-tag">${fn:trim(fac)}</span>
        </c:forEach>
      </div>
    </c:if>

    <%-- 기본 정보 — 전부 DB에서 --%>
    <div class="sd-section">
      <h3><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>기본 정보</h3>
      <div class="sd-info-grid">
        <div class="sd-info-row"><label>주소</label><span>${stay.addr}</span></div>
        <div class="sd-info-row"><label>운영 시간</label><span>체크인 ${stay.checkIn} / 체크아웃 ${stay.checkOut}</span></div>
        <c:if test="${not empty stay.rooms}">
          <div class="sd-info-row"><label>수용 인원</label><span>객실별 최대 ${stay.rooms[0].capacity}인</span></div>
        </c:if>
        <c:if test="${not empty stay.petPolicy}">
          <div class="sd-info-row"><label>반려동물 조건</label><span>${stay.petPolicy}</span></div>
        </c:if>
        <c:if test="${not empty stay.petFee}">
          <div class="sd-info-row"><label>추가 요금</label><span>${stay.petFee}</span></div>
        </c:if>
      </div>
    </div>

    <%-- 공간 소개 --%>
    <c:if test="${not empty stay.description}">
      <div class="sd-section">
        <h3><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>공간 소개</h3>
        <p class="sd-desc">${stay.description}</p>
      </div>
    </c:if>

    <%-- 객실 정보 --%>
    <c:if test="${not empty stay.rooms}">
      <div class="sd-section">
        <h3><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>객실 정보 (${fn:length(stay.rooms)}개)</h3>
        <c:forEach var="room" items="${stay.rooms}">
          <div class="room-card">
            <div>
              <div class="room-name">${room.name}</div>
              <div class="room-meta">수용 ${room.capacity}인 · 반려동물 ${room.petLimit}마리</div>
            </div>
            <div style="text-align:right">
              <div class="room-price"><fmt:formatNumber value="${room.pricePerNight}" pattern="#,###"/>원</div>
              <div class="room-price-label">1박 기준</div>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:if>

    <%-- 환불 정책 --%>
    <c:if test="${not empty stay.refundPolicy}">
      <div class="sd-section">
        <h3><svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>환불 / 이용 규칙</h3>
        <p class="sd-desc">${stay.refundPolicy}</p>
      </div>
    </c:if>

    <%-- 위치 --%>
    <c:if test="${not empty stay.lat}">
      <div class="sd-section">
        <h3><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>위치</h3>
        <div id="kakao-map" style="width:100%;height:280px;border-radius:12px;overflow:hidden"></div>
        <%@ include file="/WEB-INF/views/common/kakaomap.jsp" %>
      </div>
    </c:if>

    <%-- 리뷰 (아직 DB 연동 전 — 목업 유지) --%>
    <div class="sd-section">
      <h3><svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>리뷰 (84)</h3>
      <div class="review-summary">
        <div class="rv-avg">
          <div class="big">4.9</div>
          <div class="rv-stars">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
          </div>
          <small>84개 리뷰</small>
        </div>
        <div class="rv-bars">
          <div class="rv-bar-row"><span>5점</span><div class="rv-bar-bg"><div class="rv-bar-fill" style="width:85%"></div></div><span>85%</span></div>
          <div class="rv-bar-row"><span>4점</span><div class="rv-bar-bg"><div class="rv-bar-fill" style="width:11%"></div></div><span>11%</span></div>
          <div class="rv-bar-row"><span>3점</span><div class="rv-bar-bg"><div class="rv-bar-fill" style="width:4%"></div></div><span>4%</span></div>
        </div>
      </div>
      <div class="review-card">
        <div class="rv-head"><span class="rv-name">김민준 · 골든 리트리버 1마리</span><span class="rv-date">2025.06.10</span></div>
        <div class="rv-text">대형견 데리고 갈 곳이 없어서 걱정했는데 정말 천국이었어요. 마당이 넓어서 몽이가 뛰어놀기 너무 좋았고, 풀장도 같이 들어갈 수 있어서 최고였습니다!</div>
      </div>
      <div class="review-card">
        <div class="rv-head"><span class="rv-name">이서연 · 포메라니안, 비숑 2마리</span><span class="rv-date">2025.05.28</span></div>
        <div class="rv-text">반려동물 전용 침대와 식기까지 준비되어 있어서 너무 감동이었어요. 주변 산책로도 좋고 조용해서 힐링이 됐습니다. 꼭 다시 올게요!</div>
      </div>
    </div>
  </div>

  <%-- 예약 카드 --%>
  <div class="reserve-card">
    <h3>예약하기</h3>
    <div class="rc-price">
      <c:choose>
        <c:when test="${not empty stay.rooms}">
          <fmt:formatNumber value="${stay.rooms[0].pricePerNight}" pattern="#,###"/>원
          <span>/ 1박~</span>
        </c:when>
        <c:otherwise>가격 미정</c:otherwise>
      </c:choose>
    </div>
    <div class="rc-form-group">
      <label>날짜 선택</label>
      <div class="rc-date-row">
        <input type="date">
        <input type="date">
      </div>
    </div>
    <div class="rc-form-group">
      <label>인원</label>
      <select><option>1명</option><option>2명</option><option selected>3명</option><option>4명</option><option>5명</option><option>6명</option></select>
    </div>
    <c:if test="${not empty stay.rooms}">
      <div class="rc-form-group">
        <label>객실 선택</label>
        <select>
          <c:forEach var="room" items="${stay.rooms}">
            <option value="${room.roomId}">
              ${room.roomName} — <fmt:formatNumber value="${room.pricePerNight}" pattern="#,###"/>원
            </option>
          </c:forEach>
        </select>
      </div>
    </c:if>
    <div class="rc-divider"></div>
    <button class="btn-reserve-big" onclick="location.href='${contextPath}/stay/reserve?id=${stay.stayId}'">예약 신청하기</button>
    <c:choose>
      <c:when test="${not empty stay.refundPolicy}">
        <div class="rc-notice">${stay.refundPolicy}</div>
      </c:when>
      <c:otherwise>
        <div class="rc-notice">· 예약 확정 후 이메일로 안내드립니다.<br>· 취소는 체크인 3일 전까지 전액 환불됩니다.</div>
      </c:otherwise>
    </c:choose>
  </div>
</div>
</c:if>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
