<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="hospital" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>


<style>
  .hosp-hero{background:linear-gradient(135deg,#0C4A6E 0%,#0284C7 60%,#38BDF8 100%);padding:40px 0;color:#fff;text-align:center}
  .hosp-hero-inner{max-width:var(--inner-width);margin:0 auto;padding:0 20px}
  .hosp-hero h1{font-size:28px;font-weight:800;margin:0 0 8px}
  .hosp-hero p{font-size:14px;opacity:.85;margin:0}
  .hosp-wrap{max-width:var(--inner-width);margin:32px auto 80px;padding:0 20px;display:grid;grid-template-columns:340px 1fr;gap:24px}
  .hosp-filter-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:20px;margin-bottom:14px}
  .hosp-filter-title{font-size:14px;font-weight:800;color:var(--text-main);margin:0 0 14px}
  .hosp-filter-input{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit;box-sizing:border-box}
  .hosp-filter-input:focus{border-color:var(--primary)}
  .hosp-filter-chips{display:flex;flex-wrap:wrap;gap:7px}
  .chip{padding:6px 14px;border:1px solid var(--border);border-radius:50px;font-size:12px;font-weight:600;color:var(--text-sub);cursor:pointer;transition:var(--transition);background:#fff}
  .chip:hover,.chip.on{border-color:var(--primary);background:var(--primary-light);color:var(--primary-dark)}
  .hosp-toggle-row{display:flex;justify-content:space-between;align-items:center;font-size:14px;color:var(--text-sub)}
  .toggle{position:relative;display:inline-block;width:42px;height:24px}
  .toggle input{opacity:0;width:0;height:0}
  .toggle-slider{position:absolute;cursor:pointer;inset:0;background:#ccc;border-radius:24px;transition:.3s}
  .toggle-slider:before{content:"";position:absolute;width:18px;height:18px;left:3px;bottom:3px;background:#fff;border-radius:50%;transition:.3s}
  .toggle input:checked+.toggle-slider{background:var(--primary)}
  .toggle input:checked+.toggle-slider:before{transform:translateX(18px)}
  /* 지도 영역 */
  .hosp-map-area{background:var(--bg-page);border:1px solid var(--border);border-radius:var(--radius-md);height:280px;display:flex;align-items:center;justify-content:center;margin-bottom:14px;overflow:hidden}
  .hosp-map-area img{width:100%;height:100%;object-fit:cover;border-radius:var(--radius-md)}
  /* 병원 목록 */
  .hosp-list-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:14px}
  .hosp-list-head span{font-size:14px;color:var(--text-sub)}
  .hosp-list-head strong{color:var(--text-main);font-weight:700}
  .hosp-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:18px;margin-bottom:12px;display:flex;gap:16px;align-items:flex-start;transition:var(--transition);cursor:pointer}
  .hosp-card:hover{box-shadow:var(--shadow-md);transform:translateY(-2px)}
  .hosp-thumb{width:88px;height:88px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .hosp-body{flex:1;min-width:0}
  .hosp-tags{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:6px}
  .hosp-tag{font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px}
  .hosp-tag.type{background:var(--primary-light);color:var(--primary-dark)}
  .hosp-tag.open{background:#DCFCE7;color:#16A34A}
  .hosp-tag.close{background:#FEE2E2;color:#DC2626}
  .hosp-name{font-size:16px;font-weight:800;color:var(--text-main);margin-bottom:4px}
  .hosp-meta{font-size:13px;color:var(--text-muted);display:flex;flex-direction:column;gap:3px}
  .hosp-meta-row{display:flex;align-items:center;gap:5px}
  .hosp-meta-row svg{width:13px;height:13px;stroke:var(--text-muted);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;flex-shrink:0}
  .hosp-right{display:flex;flex-direction:column;align-items:flex-end;gap:8px;flex-shrink:0}
  .hosp-rating{display:flex;align-items:center;gap:4px;font-size:14px;font-weight:700;color:var(--text-main)}
  .hosp-rating svg{width:14px;height:14px;fill:var(--yellow)}
  .hosp-dist{font-size:12px;color:var(--text-muted)}
  .btn-reserve{padding:8px 16px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap}
</style>

<div class="hosp-hero">
  <div class="hosp-hero-inner">
    <h1>반려동물 관리사 1급 자격 상담사의 24시 상담</h1>
    <p>펫린이는 반려동물 관리자 1급 자격의 상담사들이 24시간 대기중이에요.</p>
  </div>
</div>

<div class="hosp-wrap">
  <aside>
    <div class="hosp-filter-card">
      <div class="hosp-filter-title">지역 검색</div>
      <input type="text" class="hosp-filter-input" placeholder="지역명, 병원명 검색...">
    </div>
    <div class="hosp-filter-card">
      <div class="hosp-filter-title">진료과목</div>
      <div class="hosp-filter-chips">
        <span class="chip on">전체</span>
        <span class="chip">24시간 진료</span>
        <span class="chip">특수동물 진료</span>
        <span class="chip">입원진료 가능</span>
        <span class="chip">호스피텔 가능</span>
      </div>
    </div>
    <div class="hosp-filter-card">
      <div class="hosp-filter-title">진료 대상</div>
      <div class="hosp-filter-chips">
        <span class="chip on">전체</span>
        <span class="chip">강아지</span>
        <span class="chip">고양이</span>
        <span class="chip">특수동물</span>
      </div>
    </div>
    <div class="hosp-filter-card">
      <div class="hosp-toggle-row">
        <span>현재 운영중만 보기</span>
        <label class="toggle"><input type="checkbox" checked><span class="toggle-slider"></span></label>
      </div>
    </div>
  </aside>

  <div>
    <div class="hosp-map-area" id="kakao-map"></div>
    <c:set var="mapLevel"     value="3"/>
    <c:set var="mapAddMarker" value="${true}"/>
    <%@ include file="/WEB-INF/views/common/kakaomap.jsp" %>
    <div class="hosp-list-head">
      <span>검색 결과 <strong>${hospitalList.size()}개</strong> 병원</span>
      <div style="display:flex;gap:8px">
        <span class="chip on" style="font-size:12px">거리순</span>
        <span class="chip" style="font-size:12px">별점순</span>
        <span class="chip" style="font-size:12px">리뷰순</span>
      </div>
    </div>

    <c:choose>
      <c:when test="${not empty hospitalList}">
        <c:forEach var="h" items="${hospitalList}">
          <div class="hosp-card" onclick="location.href='${contextPath}/hospital/detail?id=${h.hospitalId}'">
            <%-- <img class="hosp-thumb" src="https://placehold.co/88x88/E0F2FE/0284C7?text=병원" alt="${h.hospitalName}"> --%>
              <img class="hosp-thumb" src="${contextPath}/upload/${h.thumbPath}" alt="${hospital.hospitalName}">
            <div class="hosp-body">
              <div class="hosp-tags">
                <span class="hosp-tag type">동물병원</span>
              </div>
              <div class="hosp-name">${h.hospitalName}</div>
              <div class="hosp-meta">
                <div class="hosp-meta-row">
                  <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                  ${h.addr}
                </div>
                <div class="hosp-meta-row">
                  <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                  ${h.deptList}
                </div>
              </div>
            </div>
            <div class="hosp-right">
              <div class="hosp-rating">
                <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                <c:choose>
                  <c:when test="${h.avgRating != null}">${h.avgRating} (${h.reviewCnt})</c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
              <button class="btn-reserve"
                      onclick="event.stopPropagation();location.href='${contextPath}/hospital/reserve?id=${h.hospitalId}'">
                예약하기
              </button>
            </div>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <p style="font-size:15px;font-weight:600;color:var(--text-main);margin:0">등록된 병원이 없습니다.</p>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
var chips = document.querySelectorAll('.chip');

for (var i = 0; i < chips.length; i++) {

    chips[i].addEventListener('click', function () {

        // 같은 그룹의 chip들
        var group = this.closest('.hosp-filter-chips, .hosp-list-head div');

        var siblings = group.querySelectorAll('.chip');

        for (var j = 0; j < siblings.length; j++) {
            siblings[j].classList.remove('on');
        }

        // 클릭한 chip 활성화
        this.classList.add('on');

    });

}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
