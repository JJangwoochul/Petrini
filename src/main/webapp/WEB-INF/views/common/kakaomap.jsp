<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript"
  src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&autoload=false">
</script>
<script>
kakao.maps.load(function () {
    var coords = new kakao.maps.LatLng(${mapLat}, ${mapLng});
    var map = new kakao.maps.Map(document.getElementById('kakao-map'), {
        center: coords,
        level: 4
    });
    var marker = new kakao.maps.Marker({ position: coords, map: map });
    var infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:8px 14px;font-size:13px;font-weight:800;'
               + 'color:#1A1A2E;white-space:nowrap;">🏥 ${bizName}</div>'
    });
    infowindow.open(map, marker);
    map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
    map.addControl(new kakao.maps.ZoomControl(),    kakao.maps.ControlPosition.RIGHT);
});
</script>