<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="petmap" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
  .petmap-hero {
    background: linear-gradient(135deg, #0F766E 0%, #14B8A6 55%, #5EEAD4 100%);
    padding: 40px 0;
    color: #fff;
    text-align: center;
  }
  .petmap-hero-inner { max-width: var(--inner-width); margin: 0 auto; padding: 0 20px; }
  .petmap-hero h1 { font-size: 28px; font-weight: 800; margin: 0 0 8px; }
  .petmap-hero p { font-size: 14px; opacity: .9; margin: 0; }

  .petmap-wrap {
    max-width: var(--inner-width);
    margin: 28px auto 80px;
    padding: 0 20px;
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 24px;
  }
  .petmap-filter-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 20px;
    margin-bottom: 14px;
  }
  .petmap-filter-title {
    font-size: 14px;
    font-weight: 800;
    color: var(--text-main);
    margin: 0 0 14px;
  }
  .petmap-filter-input {
    width: 100%;
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 10px 14px;
    font-size: 14px;
    outline: none;
    box-sizing: border-box;
    font-family: inherit;
  }
  .petmap-filter-input:focus { border-color: #14B8A6; }
  .petmap-chips { display: flex; flex-wrap: wrap; gap: 7px; }
  .petmap-chip {
    padding: 6px 14px;
    border: 1px solid var(--border);
    border-radius: 50px;
    font-size: 12px;
    font-weight: 600;
    color: var(--text-sub);
    cursor: pointer;
    transition: var(--transition);
    background: #fff;
  }
  .petmap-chip:hover, .petmap-chip.on {
    border-color: #14B8A6;
    background: #CCFBF1;
    color: #0F766E;
  }

  .petmap-map-area {
    background: var(--bg-page);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    height: 360px;
    margin-bottom: 16px;
    overflow: hidden;
  }
  .petmap-list-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 14px;
  }
  .petmap-list-head span { font-size: 14px; color: var(--text-sub); }
  .petmap-list-head strong { color: var(--text-main); font-weight: 700; }

  .petmap-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 16px;
    margin-bottom: 10px;
    display: flex;
    gap: 14px;
    align-items: flex-start;
    transition: var(--transition);
    cursor: pointer;
    text-decoration: none;
    color: inherit;
  }
  .petmap-card:hover {
    box-shadow: var(--shadow-md);
    transform: translateY(-2px);
  }
  .petmap-icon {
    width: 44px;
    height: 44px;
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    flex-shrink: 0;
  }
  .petmap-icon.hotel { background: #EAF7F2; }
  .petmap-icon.hospital { background: #E0F2FE; }
  .petmap-icon.store { background: #FEF3C7; }
  .petmap-icon.walk { background: #DCFCE7; }
  .petmap-icon.cafe { background: #FCE7F3; }
  .petmap-body { flex: 1; min-width: 0; }
  .petmap-name { font-size: 15px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; }
  .petmap-meta { font-size: 13px; color: var(--text-muted); }
  .petmap-dist { font-size: 12px; color: var(--text-muted); flex-shrink: 0; }

  @media (max-width: 900px) {
    .petmap-wrap { grid-template-columns: 1fr; }
  }
</style>

<div class="petmap-hero">
  <div class="petmap-hero-inner">
    <h1>펫맵</h1>
    <p>숙소·병원·쇼핑·산책로·카페 등 반려동물 동반 장소를 지도에서 찾아보세요</p>
  </div>
</div>

<div class="petmap-wrap">
  <aside>
    <div class="petmap-filter-card">
      <div class="petmap-filter-title">장소 검색</div>
      <input type="text" class="petmap-filter-input" placeholder="지역명, 장소명 검색...">
    </div>
    <div class="petmap-filter-card">
      <div class="petmap-filter-title">카테고리</div>
      <div class="petmap-chips" id="petmapCategoryChips">
        <span class="petmap-chip on" data-cat="all">전체</span>
        <span class="petmap-chip" data-cat="hotel">숙소</span>
        <span class="petmap-chip" data-cat="hospital">병원</span>
        <span class="petmap-chip" data-cat="store">쇼핑</span>
        <span class="petmap-chip" data-cat="walk">산책로</span>
        <span class="petmap-chip" data-cat="cafe">카페</span>
      </div>
    </div>
  </aside>

  <div>
    <div class="petmap-map-area" id="petmap"></div>
    <div class="petmap-list-head">
      <span>주변 장소 <strong id="petmapCount">5</strong>곳</span>
    </div>

    <a href="${contextPath}/stay/detail?id=1" class="petmap-card" data-cat="hotel">
      <div class="petmap-icon hotel">🏨</div>
      <div class="petmap-body">
        <div class="petmap-name">강아지숲 펫 빌라</div>
        <div class="petmap-meta">서울 강남구 · 반려동물 동반 숙소</div>
      </div>
      <span class="petmap-dist">0.9km</span>
    </a>
    <a href="${contextPath}/hospital/detail?id=1" class="petmap-card" data-cat="hospital">
      <div class="petmap-icon hospital">🏥</div>
      <div class="petmap-body">
        <div class="petmap-name">행복 동물병원</div>
        <div class="petmap-meta">서울 마포구 · 24시 응급 진료</div>
      </div>
      <span class="petmap-dist">1.2km</span>
    </a>
    <a href="${contextPath}/store/detail?id=1" class="petmap-card" data-cat="store">
      <div class="petmap-icon store">🛒</div>
      <div class="petmap-body">
        <div class="petmap-name">펫린이 스토어 강남점</div>
        <div class="petmap-meta">서울 강남구 · 사료·용품 매장</div>
      </div>
      <span class="petmap-dist">1.5km</span>
    </a>
    <a href="${contextPath}/walk" class="petmap-card" data-cat="walk">
      <div class="petmap-icon walk">🌳</div>
      <div class="petmap-body">
        <div class="petmap-name">한강공원 반려견 산책로</div>
        <div class="petmap-meta">서울 영등포구 · 강변 산책 코스</div>
      </div>
      <span class="petmap-dist">2.1km</span>
    </a>
    <a href="#" class="petmap-card" data-cat="cafe" onclick="return false;">
      <div class="petmap-icon cafe">☕</div>
      <div class="petmap-body">
        <div class="petmap-name">멍멍 카페 합정점</div>
        <div class="petmap-meta">서울 마포구 · 대형견 입장 가능</div>
      </div>
      <span class="petmap-dist">2.4km</span>
    </a>
  </div>
</div>

<script>
  var places = [
    { name: '강아지숲 펫 빌라', lat: 37.5640, lng: 126.9820 },
    { name: '행복 동물병원', lat: 37.5680, lng: 126.9760 },
    { name: '펫린이 스토어', lat: 37.5620, lng: 126.9850 },
    { name: '한강 산책로', lat: 37.5580, lng: 126.9720 },
    { name: '멍멍 카페', lat: 37.5700, lng: 126.9680 }
  ];

  var container = document.getElementById('petmap');
  var map = new kakao.maps.Map(container, {
    center: new kakao.maps.LatLng(${lat}, ${lng}),
    level: 4
  });

  places.forEach(function(place) {
    var marker = new kakao.maps.Marker({
      position: new kakao.maps.LatLng(place.lat, place.lng),
      map: map
    });
    var infowindow = new kakao.maps.InfoWindow({ content: '<div style="padding:6px 10px;font-size:12px;">' + place.name + '</div>' });
    kakao.maps.event.addListener(marker, 'mouseover', function() { infowindow.open(map, marker); });
    kakao.maps.event.addListener(marker, 'mouseout', function() { infowindow.close(); });
  });

  document.querySelectorAll('#petmapCategoryChips .petmap-chip').forEach(function(chip) {
    chip.addEventListener('click', function() {
      document.querySelectorAll('#petmapCategoryChips .petmap-chip').forEach(function(c) { c.classList.remove('on'); });
      chip.classList.add('on');
      var cat = chip.getAttribute('data-cat');
      var visible = 0;
      document.querySelectorAll('.petmap-card').forEach(function(card) {
        var show = cat === 'all' || card.getAttribute('data-cat') === cat;
        card.style.display = show ? '' : 'none';
        if (show) visible++;
      });
      document.getElementById('petmapCount').textContent = visible;
    });
  });
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
