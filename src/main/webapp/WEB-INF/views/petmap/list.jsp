<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="petmap" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .pm-hero{background:linear-gradient(135deg,#0F766E 0%,#14B8A6 60%,#5EEAD4 100%);padding:40px 0;color:#fff;text-align:center}
  .pm-hero-inner{max-width:var(--inner-width);margin:0 auto;padding:0 20px}
  .pm-hero h1{font-size:28px;font-weight:800;margin:0 0 8px}
  .pm-hero p{font-size:14px;opacity:.85;margin:0}
  .pm-wrap{max-width:var(--inner-width);margin:28px auto 80px;padding:0 20px}

  /* ── 필터 영역 ── */
  .pm-filter{margin-bottom:20px}
  .pm-filter-row{display:flex;align-items:center;gap:10px;margin-bottom:10px;flex-wrap:wrap}
  .pm-filter-label{font-size:13px;font-weight:700;color:var(--text-sub);min-width:60px;flex-shrink:0}
  .pm-cats{display:flex;gap:8px;flex-wrap:wrap}
  .pm-cat{display:inline-flex;align-items:center;gap:5px;padding:7px 16px;border:1.5px solid var(--border);border-radius:50px;font-size:13px;font-weight:600;color:var(--text-sub);cursor:pointer;background:var(--bg-card);transition:var(--transition);text-decoration:none}
  .pm-cat:hover{border-color:#14B8A6;color:#0F766E;background:#F0FDFA}
  .pm-cat.on{border-color:#14B8A6;background:#14B8A6;color:#fff}
  .pm-area-select{padding:7px 14px;border:1.5px solid var(--border);border-radius:var(--radius-sm);font-size:13px;font-family:inherit;background:var(--bg-card);color:var(--text-sub);cursor:pointer;outline:none}
  .pm-area-select:focus{border-color:#14B8A6}

  /* ── 본문: 지도 + 목록 ── */
  .pm-body{display:grid;grid-template-columns:1fr 360px;gap:20px;align-items:flex-start}
  .pm-map-wrap{position:sticky;top:20px}
  .pm-map{width:100%;height:520px;border-radius:var(--radius-md);overflow:hidden;border:1px solid var(--border)}
  .pm-map-search{display:flex;gap:8px;margin-bottom:12px}
  .pm-map-search input{flex:1;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit}
  .pm-map-search input:focus{border-color:#14B8A6}
  .pm-map-search button{padding:10px 18px;border:none;border-radius:var(--radius-sm);background:#14B8A6;color:#fff;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap}
  .pm-map-search button:hover{background:#0F766E}
  .pm-list-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;font-size:14px;color:var(--text-sub)}
  .pm-list-head strong{color:var(--text-main)}
  .pm-place-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:14px;margin-bottom:10px;display:flex;gap:12px;cursor:pointer;transition:var(--transition)}
  .pm-place-card:hover{box-shadow:var(--shadow-md);border-color:#14B8A6}
  .pm-place-card.active{border-color:#14B8A6;box-shadow:0 0 0 2px rgba(20,184,166,.2)}
  .pm-thumb{width:72px;height:72px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .pm-info{flex:1;min-width:0}
  .pm-cat-badge{font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px;display:inline-block;margin-bottom:5px;background:#F3F4F6;color:#6B7280}
  .pm-name{font-size:14px;font-weight:800;color:var(--text-main);margin-bottom:3px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .pm-addr{font-size:12px;color:var(--text-muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  /* 페이징 */
  .pm-paging{display:flex;justify-content:center;gap:6px;margin-top:20px}
  .pm-paging a{display:inline-flex;align-items:center;justify-content:center;width:32px;height:32px;border:1px solid var(--border);border-radius:var(--radius-sm);font-size:13px;color:var(--text-sub);text-decoration:none}
  .pm-paging a.on{background:#14B8A6;color:#fff;border-color:#14B8A6}
</style>

<div class="pm-hero">
  <div class="pm-hero-inner">
    <h1>펫맵</h1>
    <p>반려동물과 함께 갈 수 있는 장소를 지도에서 찾아보세요</p>
  </div>
</div>

<div class="pm-wrap">

  <%-- ══════════════════════════════════════════════
       필터 영역 (서버 필터링 — 탭 클릭 시 페이지 새로고침)
       ══════════════════════════════════════════════ --%>
  <div class="pm-filter">

    <%-- ── 1행: 관광타입 (contentTypeId) ── --%>
    <div class="pm-filter-row">
      <span class="pm-filter-label">관광타입</span>
      <div class="pm-cats">
        <a class="pm-cat ${empty contentTypeId ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '')">전체</a>
        <a class="pm-cat ${contentTypeId == '12' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '12')">관광지</a>
        <a class="pm-cat ${contentTypeId == '14' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '14')">문화시설</a>
        <a class="pm-cat ${contentTypeId == '15' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '15')">축제/행사</a>
        <a class="pm-cat ${contentTypeId == '28' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '28')">레포츠</a>
        <a class="pm-cat ${contentTypeId == '32' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '32')">숙박</a>
        <a class="pm-cat ${contentTypeId == '38' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '38')">쇼핑</a>
        <a class="pm-cat ${contentTypeId == '39' ? 'on' : ''}"
           onclick="buildUrl('contentTypeId', '39')">음식점</a>
      </div>
    </div>

    <%-- ── 3행: 대분류 (cat1) — contentTypeId 선택 시에만 표시 ── --%>
    <c:if test="${not empty cat1List}">
      <div class="pm-filter-row">
        <span class="pm-filter-label">대분류</span>
        <div class="pm-cats">
          <a class="pm-cat ${empty cat1 ? 'on' : ''}"
             onclick="buildUrl('cat1', '')">전체</a>
          <c:forEach var="c" items="${cat1List}">
            <a class="pm-cat ${cat1 == c.code ? 'on' : ''}"
               onclick="buildUrl('cat1', '${c.code}')">${c.name}</a>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <%-- ── 4행: 중분류 (cat2) — cat1 선택 시에만 표시 ── --%>
    <c:if test="${not empty cat2List}">
      <div class="pm-filter-row">
        <span class="pm-filter-label">중분류</span>
        <div class="pm-cats">
          <a class="pm-cat ${empty cat2 ? 'on' : ''}"
             onclick="buildUrl('cat2', '')">전체</a>
          <c:forEach var="c" items="${cat2List}">
            <a class="pm-cat ${cat2 == c.code ? 'on' : ''}"
               onclick="buildUrl('cat2', '${c.code}')">${c.name}</a>
          </c:forEach>
        </div>
      </div>
    </c:if>

    <%-- ── 2행: 지역 (areaCode) ── --%>
    <div class="pm-filter-row">
      <span class="pm-filter-label">지역</span>
      <select class="pm-area-select" onchange="buildUrl('areaCode', this.value)">
        <option value="">전체 지역</option>
        <option value="1"  ${areaCode == '1'  ? 'selected' : ''}>서울</option>
        <option value="2"  ${areaCode == '2'  ? 'selected' : ''}>인천</option>
        <option value="3"  ${areaCode == '3'  ? 'selected' : ''}>대전</option>
        <option value="4"  ${areaCode == '4'  ? 'selected' : ''}>대구</option>
        <option value="5"  ${areaCode == '5'  ? 'selected' : ''}>광주</option>
        <option value="6"  ${areaCode == '6'  ? 'selected' : ''}>부산</option>
        <option value="7"  ${areaCode == '7'  ? 'selected' : ''}>울산</option>
        <option value="8"  ${areaCode == '8'  ? 'selected' : ''}>세종</option>
        <option value="31" ${areaCode == '31' ? 'selected' : ''}>경기</option>
        <option value="32" ${areaCode == '32' ? 'selected' : ''}>강원</option>
        <option value="33" ${areaCode == '33' ? 'selected' : ''}>충북</option>
        <option value="34" ${areaCode == '34' ? 'selected' : ''}>충남</option>
        <option value="35" ${areaCode == '35' ? 'selected' : ''}>경북</option>
        <option value="36" ${areaCode == '36' ? 'selected' : ''}>경남</option>
        <option value="37" ${areaCode == '37' ? 'selected' : ''}>전북</option>
        <option value="38" ${areaCode == '38' ? 'selected' : ''}>전남</option>
        <option value="39" ${areaCode == '39' ? 'selected' : ''}>제주</option>
      </select>
    </div>
  </div>

  <%-- ══════════════════════════════════════════════
       본문: 지도 + 장소 목록
       ══════════════════════════════════════════════ --%>
  <div class="pm-body">
    <div class="pm-map-wrap">
      <div class="pm-map-search">
        <input type="text" id="searchInput" placeholder="장소명, 지역명 검색...">
        <button onclick="searchPlace()">검색</button>
      </div>
      <div class="pm-map" id="kakao-map"></div>
      <%@ include file="/WEB-INF/views/common/kakaomap.jsp" %>
    </div>

    <div>
      <div class="pm-list-head">
        <span>총 <strong id="placeCount">${totalCount}</strong>개 장소</span>
      </div>

      <div id="placeList">
        <c:choose>
          <c:when test="${not empty places}">
            <c:forEach var="p" items="${places}" varStatus="st">
              <div class="pm-place-card" id="card-${st.count}"
                   onclick="selectPlace(${st.count})">
                <c:choose>
                  <c:when test="${not empty p.firstimage}">
                    <img class="pm-thumb" src="${p.firstimage}" alt="${p.title}"
                         onerror="this.src='https://placehold.co/72x72/F0FDFA/14B8A6?text=사진없음'">
                  </c:when>
                  <c:otherwise>
                    <img class="pm-thumb" src="https://placehold.co/72x72/F0FDFA/14B8A6?text=사진없음" alt="사진없음">
                  </c:otherwise>
                </c:choose>
                <div class="pm-info">
                  <span class="pm-cat-badge">${p.contenttypeid}</span>
                  <div class="pm-name">${p.title}</div>
                  <div class="pm-addr">${p.addr1}</div>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <p style="text-align:center;color:var(--text-muted);padding:40px 0">
              검색 결과가 없습니다.
            </p>
          </c:otherwise>
        </c:choose>
      </div>

      <%-- ── 페이징 ── --%>
      <c:if test="${totalPages > 1}">
        <div class="pm-paging">
          <c:forEach var="i" begin="1" end="${totalPages}">
            <a class="${pageNo == i ? 'on' : ''}"
               onclick="buildUrl('pageNo', '${i}')">${i}</a>
          </c:forEach>
        </div>
      </c:if>
    </div>
  </div>
</div>

<script>
  /* ══════════════════════════════════════════════════════════════
     필터 URL 빌더
     — 탭/드롭다운 클릭 시 호출. 현재 필터 상태를 유지하면서
       변경된 파라미터만 바꿔서 페이지를 새로고침한다.
     ══════════════════════════════════════════════════════════════ */
  function buildUrl(param, value) {
      // 현재 필터 상태 (JSP EL로 서버값 주입)
      var filters = {
          contentTypeId: '${contentTypeId}',
          areaCode:      '${areaCode}',
          cat1:          '${cat1}',
          cat2:          '${cat2}',
          pageNo:        '${pageNo}'
      };
  
      // 변경할 파라미터 적용
      filters[param] = value;
  
      // ★ 상위 필터가 바뀌면 하위 필터 초기화
      if (param === 'contentTypeId') {
          filters.cat1 = '';
          filters.cat2 = '';
          filters.pageNo = '1';
      }
      if (param === 'cat1') {
          filters.cat2 = '';
          filters.pageNo = '1';
      }
      if (param === 'cat2') {
          filters.pageNo = '1';
      }
      if (param === 'areaCode') {
          filters.pageNo = '1';
      }
  
      // URL 조립
      var url = '${contextPath}/petmap?pageNo=' + filters.pageNo;
      if (filters.contentTypeId) url += '&contentTypeId=' + filters.contentTypeId;
      if (filters.areaCode)      url += '&areaCode=' + filters.areaCode;
      if (filters.cat1)          url += '&cat1=' + filters.cat1;
      if (filters.cat2)          url += '&cat2=' + filters.cat2;
  
      location.href = url;
  }
  
  /* ══════════════════════════════════════════════════════════════
     지도 인터랙션 (마커 + 카드 연동)
     ══════════════════════════════════════════════════════════════ */
  var PLACES = [
    <c:forEach items="${places}" var="p" varStatus="st">
      {
        id: ${st.count},
        title: "${p.title}",
        addr1: "${p.addr1}",
        mapx: ${not empty p.mapx ? p.mapx : '0'},
        mapy: ${not empty p.mapy ? p.mapy : '0'}
      }
      <c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];
  
  var map;
  var markers = [];
  var infowindows = [];
  
  document.addEventListener('DOMContentLoaded', function() {
      initMap();
  });
  
  function initMap() {
      if (!window.kakaoMap) {
          setTimeout(initMap, 100);
          return;
      }
      map = window.kakaoMap;
      renderMarkers(PLACES);
  }
  
  function renderMarkers(list) {
      for (var i = 0; i < markers.length; i++) { markers[i].setMap(null); }
      markers = [];
      infowindows = [];
  
      var bounds = new kakao.maps.LatLngBounds();
      var hasMarker = false;
  
      for (var i = 0; i < list.length; i++) {
          var p = list[i];
          if (p.mapx === 0 || p.mapy === 0) continue;
  
          var pos = new kakao.maps.LatLng(p.mapy, p.mapx);
          var marker = new kakao.maps.Marker({ position: pos, map: map });
          var iw = new kakao.maps.InfoWindow({
              content: '<div style="padding:6px 10px;font-size:12px;font-weight:700;white-space:nowrap">' + p.title + '</div>',
              removable: true
          });
          addMarkerEvent(marker, iw, p.id);
          markers.push(marker);
          infowindows.push(iw);
          bounds.extend(pos);
          hasMarker = true;
      }
      if (hasMarker) map.setBounds(bounds);
  }
  
  function addMarkerEvent(marker, infowindow, placeId) {
      kakao.maps.event.addListener(marker, 'click', function() {
          for (var i = 0; i < infowindows.length; i++) { infowindows[i].close(); }
          infowindow.open(map, marker);
          highlightCard(placeId);
      });
  }
  
  function selectPlace(id) {
      var place = null;
      var idx = -1;
      var markerIdx = 0;
      for (var i = 0; i < PLACES.length; i++) {
          if (PLACES[i].mapx === 0 || PLACES[i].mapy === 0) continue;
          if (PLACES[i].id === id) { place = PLACES[i]; idx = markerIdx; break; }
          markerIdx++;
      }
      if (!place) return;
  
      map.setCenter(new kakao.maps.LatLng(place.mapy, place.mapx));
      map.setLevel(4);
      if (idx >= 0) {
          for (var i = 0; i < infowindows.length; i++) { infowindows[i].close(); }
          infowindows[idx].open(map, markers[idx]);
      }
      highlightCard(id);
  }
  
  function highlightCard(id) {
      var cards = document.querySelectorAll('.pm-place-card');
      for (var i = 0; i < cards.length; i++) { cards[i].classList.remove('active'); }
      var card = document.getElementById('card-' + id);
      if (card) {
          card.classList.add('active');
          card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
  }
  
  function searchPlace() {
      var keyword = document.getElementById('searchInput').value.trim();
      if (!keyword) return;
      window.kakaoPs.keywordSearch(keyword, function(results, status) {
          if (status === kakao.maps.services.Status.OK) {
              map.setCenter(new kakao.maps.LatLng(results[0].y, results[0].x));
              map.setLevel(5);
          } else { alert('검색 결과가 없습니다.'); }
      });
  }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
