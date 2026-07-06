<%--
  common/kakaomap.jsp — 카카오맵 공통 초기화 (compile-time <%@ include %> 전용)

  ※ <%@ page %> / <%@ taglib %> 선언 없음
     — 포함하는 JSP 페이지가 이미 선언하고 있으므로 중복 선언 불필요
     — 중복 선언 시 JSP 컴파일 오류(Whitelabel Error) 발생

  컨테이너 div :  id="kakao-map"  (고정)

  Model 에서 읽는 값 (KakaoMapService 로 세팅):
    kakaoJsKey   Kakao JS API 키
    mapLat       초기 중심 위도
    mapLng       초기 중심 경도
    bizName      있으면 → 단일 마커 + 인포윈도우 (서비스 상세/목록 페이지)
                 없으면 → 마커 생략   (petmap 등 다중 마커 페이지)

  include 후 JS 전역:
    window.kakaoMap  – kakao.maps.Map
    window.kakaoPs   – kakao.maps.services.Places  (장소 검색 등에 사용)
--%>
<script type="text/javascript"
  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&autoload=false&libraries=services">
</script>
<script>
  kakao.maps.load(function () {
      var el = document.getElementById('kakao-map');
      if (!el) { console.warn('[kakaomap] #kakao-map 컨테이너를 찾을 수 없습니다.'); return; }
  
      var coords = new kakao.maps.LatLng(${mapLat}, ${mapLng});
      var map    = new kakao.maps.Map(el, { center: coords, level: 4 });
  
      map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
      map.addControl(new kakao.maps.ZoomControl(),    kakao.maps.ControlPosition.RIGHT);
  
      /* 전역 노출 */
      window.kakaoMap = map;
      window.kakaoPs  = new kakao.maps.services.Places();
  
      /* bizName 있을 때만 단일 마커 + 인포윈도우 */
      if ('${bizName}'.trim()) {
          var marker = new kakao.maps.Marker({ position: coords, map: map });
          new kakao.maps.InfoWindow({
              content: '<div style="padding:8px 14px;font-size:13px;font-weight:800;'
                     + 'color:#1A1A2E;white-space:nowrap;">${bizName}</div>'
          }).open(map, marker);
      }
  });
</script>
