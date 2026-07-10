<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="stay" />
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
  /* 객실 카드 */
  .room-card{border:1px solid var(--border);border-radius:var(--radius-md);padding:18px;margin-bottom:12px;display:flex;justify-content:space-between;align-items:center;transition:var(--transition)}
  .room-card:hover{border-color:var(--primary);background:#FAFFFE}
  .room-info h4{font-size:15px;font-weight:700;color:var(--text-main);margin:0 0 6px}
  .room-meta{font-size:13px;color:var(--text-muted);display:flex;gap:12px}
  .room-meta span{display:flex;align-items:center;gap:4px}
  .room-meta svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2}
  .room-right{text-align:right}
  .room-price{font-size:18px;font-weight:800;color:var(--primary-dark);margin-bottom:6px}
  .room-price small{font-size:12px;font-weight:400;color:var(--text-muted)}
  .btn-room-reserve{padding:8px 20px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:13px;font-weight:700;cursor:pointer}
  /* 예약 카드 */
  .reserve-card { background:var(--bg-card); border:1px solid var(--border); border-radius:var(--radius-md); padding:22px; position:sticky; top:20px; }
  .reserve-card h3 { font-size:16px; font-weight:800; color:var(--text-main); margin:0 0 16px; }
  .rc-price { font-size:22px; font-weight:800; color:var(--text-main); margin-bottom:16px; }
  .rc-price span { font-size:13px; font-weight:400; color:var(--text-muted); }
  .rc-form-group { display:flex; flex-direction:column; gap:5px; margin-bottom:12px; }
  .rc-form-group label { font-size:12px; font-weight:700; color:var(--text-muted); }
  .rc-form-group input, .rc-form-group select {
      border:1px solid var(--border); border-radius:var(--radius-sm);
      padding:10px 12px; font-size:14px; color:var(--text-main);
      outline:none; font-family:inherit; width:100%; box-sizing:border-box;
  }
  .rc-form-group input:focus, .rc-form-group select:focus { border-color:var(--primary); }
  .rc-date-row { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
  .btn-reserve-big { width:100%; padding:14px; border:none; border-radius:var(--radius-sm); background:var(--primary); color:#fff; font-size:16px; font-weight:800; cursor:pointer; margin-top:12px; transition:var(--transition); }
  .btn-reserve-big:hover { background:var(--primary-dark); }
  .rc-notice { font-size:12px; color:var(--text-muted); margin-top:10px; line-height:1.6; }
  .sd-policy{font-size:13px;color:var(--text-sub);line-height:1.7}
  .sd-policy strong{display:block;font-size:14px;color:var(--text-main);margin-bottom:6px}
</style>

<div style="max-width:var(--inner-width);margin:28px auto 0;padding:0 20px">
  <a href="${contextPath}/stay" class="sd-back">
    <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
    숙소 목록으로
  </a>
</div>

<c:choose>
<c:when test="${lodge != null}">
<div class="sd-wrap">
  <div>
    <%-- 갤러리 (이미지 데이터 없으면 플레이스홀더) --%>
    <div class="sd-gallery">
      <img src="https://placehold.co/700x360/E0F2FE/0284C7?text=${lodge.lodgeName}" alt="${lodge.lodgeName}">
      <img src="https://placehold.co/350x180/EAF7F2/2BAB82?text=사진2" alt="2">
      <img src="https://placehold.co/350x180/F0F9FF/0284C7?text=사진3" alt="3">
      <img src="https://placehold.co/350x180/EAF7F2/2BAB82?text=사진4" alt="4">
      <img src="https://placehold.co/350x180/F0F9FF/0284C7?text=사진5" alt="5">
    </div>

    <span class="sd-badge">반려동물 동반 숙소</span>
    <%-- ★ DB 데이터 반영 --%>
    <div class="sd-title">${lodge.lodgeName}</div>

    <%-- 편의시설 태그 --%>
    <c:if test="${not empty lodge.facilities}">
      <div class="sd-tags">
        <c:forTokens items="${lodge.facilities}" delims="," var="tag">
          <span class="sd-tag">${tag}</span>
        </c:forTokens>
      </div>
    </c:if>

    <%-- 기본 정보 --%>
    <div class="sd-section">
      <h3><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>기본 정보</h3>
      <div class="sd-info-grid">
        <div class="sd-info-row"><label>주소</label><span>${lodge.addr}</span></div>
        <div class="sd-info-row"><label>객실 수</label><span>${lodge.rooms.size()}개</span></div>
      </div>
    </div>

    <%-- ★ 객실 목록 (DB 데이터) --%>
    <div class="sd-section">
      <h3>
        <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
        객실 안내
      </h3>
      <c:choose>
        <c:when test="${not empty lodge.rooms}">
          <c:forEach var="r" items="${lodge.rooms}">
            <div class="room-card">
              <div class="room-info">
                <h4>${r.roomName}</h4>
                <div class="room-meta">
                  <span>
                    <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    최대 ${r.capacity}명
                  </span>
                  <span>
                    <svg viewBox="0 0 24 24"><circle cx="4.5" cy="9.5" r="2"/><circle cx="9" cy="5.5" r="2"/><circle cx="15" cy="5.5" r="2"/><circle cx="19.5" cy="9.5" r="2"/></svg>
                    반려동물 ${r.petLimit}마리
                  </span>
                </div>
              </div>
              <div class="room-right">
                <div class="room-price">
                  <fmt:formatNumber value="${r.pricePerNight}" type="number"/>원
                  <small>/ 1박</small>
                </div>
                <button class="btn-room-reserve"
                        onclick="location.href='${contextPath}/stay/reserve?id=${lodge.lodgeId}'">
                  예약하기
                </button>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <p style="text-align:center;color:var(--text-muted);padding:20px 0">등록된 객실이 없습니다.</p>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- 위치 (카카오맵) --%>
    <div class="sd-section">
      <h3><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>위치</h3>
      <div id="kakao-map" style="width:100%;height:280px;border-radius:12px;overflow:hidden"></div>
      <%@ include file="/WEB-INF/views/common/kakaomap.jsp" %>
    </div>
  </div>

  <%-- 예약 카드 (오른쪽 사이드) --%>
  <div class="reserve-card">
    <h3>예약하기</h3>
    <%-- 최저가 표시 --%>
    <c:if test="${not empty lodge.rooms}">
      <div class="rc-price">
        <fmt:formatNumber value="${lodge.rooms[0].pricePerNight}" type="number"/>원
        <span>/ 1박~</span>
      </div>
    </c:if>
    <div class="rc-form-group">
      <label>날짜 선택</label>
      <div class="rc-date-row">
        <input type="date">
        <input type="date">
      </div>
    </div>
    <div class="rc-form-group">
      <label>인원</label>
      <select>
        <option>1명</option><option>2명</option><option selected>3명</option>
        <option>4명</option><option>5명</option><option>6명</option>
      </select>
    </div>
    <c:if test="${not empty lodge.rooms}">
      <div class="rc-form-group">
        <label>객실 선택</label>
        <select>
          <c:forEach var="r" items="${lodge.rooms}">
            <option value="${r.roomId}">
              ${r.roomName} — <fmt:formatNumber value="${r.pricePerNight}" type="number"/>원
            </option>
          </c:forEach>
        </select>
      </div>
    </c:if>
    <button class="btn-reserve-big"
            onclick="location.href='${contextPath}/stay/reserve?id=${lodge.lodgeId}'">
      예약 신청하기
    </button>
    <%-- 환불 정책 --%>
    <c:if test="${not empty lodge.refundPolicy}">
      <div class="rc-notice">${lodge.refundPolicy}</div>
    </c:if>
  </div>
</div>
</c:when>
<c:otherwise>
  <div style="max-width:var(--inner-width);margin:60px auto;text-align:center;padding:0 20px">
    <p style="font-size:15px;color:var(--text-muted)">해당 숙소를 찾을 수 없습니다.</p>
    <a href="${contextPath}/stay" style="color:var(--primary);font-weight:700">목록으로 돌아가기</a>
  </div>
</c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
