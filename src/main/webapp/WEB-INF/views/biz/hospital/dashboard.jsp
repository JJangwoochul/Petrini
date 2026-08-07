<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<%--7/1, 곽지윤, 사업자(병원)대시보드 ui구성변경(before)--%>
<%--<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">병원 대시보드</h1>
    <p class="biz-page-desc">오늘 진료 현황과 주요 지표를 확인하세요.</p>
  </div>
  <div class="biz-stats">
    <div class="biz-stat-card">
      <div class="bsc-icon appt"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">오늘 예약</span><span class="bsc-val">5<span class="bsc-unit">건</span></span></div>
    </div>
    <div class="biz-stat-card">
      <div class="bsc-icon done"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">진료 완료</span><span class="bsc-val">3<span class="bsc-unit">건</span></span></div>
    </div>
    <div class="biz-stat-card">
      <div class="bsc-icon revenue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">이번 달 매출</span><span class="bsc-val">3.8<span class="bsc-unit">백만원</span></span></div>
    </div>
    <div class="biz-stat-card">
      <div class="bsc-icon review"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">평균 리뷰</span><span class="bsc-val">4.9<span class="bsc-unit">/ 5.0</span></span></div>
    </div>
  </div>
  <div class="biz-card">
    <div class="biz-card-head"><span>오늘 예약 현황</span><small>2025.06.26 기준</small></div>
    <table class="biz-table">
      <thead><tr><th>시간</th><th>보호자</th><th>환자(동물)</th><th>진료 목적</th><th>상태</th><th>처리</th></tr></thead>
      <tbody>
        <tr><td>09:30</td><td>김민준</td><td>초코 (말티즈 / 3세)</td><td>예방접종</td><td><span class="bs-badge bs-done">완료</span></td><td>—</td></tr>
        <tr><td>10:00</td><td>이서연</td><td>나비 (페르시안 / 2세)</td><td>정기검진</td><td><span class="bs-badge bs-done">완료</span></td><td>—</td></tr>
        <tr><td>11:30</td><td>박지호</td><td>몽이 (골든 / 4세)</td><td>피부 트러블</td><td><span class="bs-badge bs-done">완료</span></td><td>—</td></tr>
        <tr><td>14:00</td><td>최유나</td><td>루비 (푸들 / 1세)</td><td>중성화 수술</td><td><span class="bs-badge bs-wait">대기</span></td><td><button class="biz-btn">진료 시작</button></td></tr>
        <tr><td>15:30</td><td>정태양</td><td>별이 (샴 / 5세)</td><td>치석 제거</td><td><span class="bs-badge bs-wait">대기</span></td><td><button class="biz-btn">진료 시작</button></td></tr>
      </tbody>
    </table>
  </div>
</main>--%>

<%--HYJ 26.08.06 DB 연동--%>
<%--7/1, 곽지윤, 사업자(병원)대시보드 ui구성변경(after)--%>
<main class="biz-main hospital-dashboard">
  <div class="dashboard-top">
    <div>
      <h1>안녕하세요, ${hospital.name} 원장님!</h1>
      <p>오늘의 병원 현황을 한눈에 확인하세요.</p>
    </div>
    <div class="date-select">
      <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd (E)" />
    </div>
  </div>

  <%-- ── 요약 카드 ── --%>
  <section class="summary-grid">
    <div class="summary-card">
      <div class="summary-icon green">📅</div>
      <div>
        <p>오늘 예약</p>
        <strong>${dash.todayResvCount} <span>건</span></strong>
        <small>어제 대비
          <c:choose>
            <c:when test="${dash.resvDiff > 0}">▲ ${dash.resvDiff}건</c:when>
            <c:when test="${dash.resvDiff < 0}">▼ ${-dash.resvDiff}건</c:when>
            <c:otherwise>동일</c:otherwise>
          </c:choose>
        </small>
      </div>
    </div>
    <div class="summary-card">
      <div class="summary-icon purple">🩺</div>
      <div>
        <p>진료 대기</p>
        <strong>${dash.pendingCount} <span>건</span></strong>
        <small>승인 대기 중</small>
      </div>
    </div>
    <div class="summary-card">
      <div class="summary-icon blue">📋</div>
      <div>
        <p>진료 완료</p>
        <strong>${dash.doneCount} <span>건</span></strong>
        <small>어제 대비
          <c:choose>
            <c:when test="${dash.doneDiff > 0}">▲ ${dash.doneDiff}건</c:when>
            <c:when test="${dash.doneDiff < 0}">▼ ${-dash.doneDiff}건</c:when>
            <c:otherwise>동일</c:otherwise>
          </c:choose>
        </small>
      </div>
    </div>
    <div class="summary-card">
      <div class="summary-icon orange">₩</div>
      <div>
        <p>이번 달 매출</p>
        <strong><fmt:formatNumber value="${dash.monthRevenue}" type="number"/> <span>원</span></strong>
        <small>어제 대비
          <c:choose>
            <c:when test="${dash.revenueDiff > 0}">▲ <fmt:formatNumber value="${dash.revenueDiff}" type="number"/>원</c:when>
            <c:when test="${dash.revenueDiff < 0}">▼ <fmt:formatNumber value="${-dash.revenueDiff}" type="number"/>원</c:when>
            <c:otherwise>동일</c:otherwise>
          </c:choose>
        </small>
      </div>
    </div>
  </section>

  <%-- ── 차트 + 도넛 ── --%>
  <section class="dashboard-grid">
    <div class="dash-card chart-card">
      <div class="card-head">
        <h3>예약 / 매출 통계</h3>
        <div class="tab-btns">
          <button class="active" data-days="7">일간</button>
          <button data-days="30">월간</button>
        </div>
      </div>
      <div class="line-chart">
        <div class="chart-legend">
          <span class="green-dot"></span> 예약 건수(건)
          <span class="blue-dot"></span> 매출(원)
        </div>
        <canvas id="dashChart" height="220"></canvas>
      </div>
    </div>

    <div class="dash-card status-card">
      <div class="card-head"><h3>예약 상태 현황</h3></div>
      <div class="donut-wrap">
        <div class="donut-chart"><div><span>총 예약</span><strong>${dash.totalStatusCount}건</strong></div></div>
        <ul class="status-list">
          <li><span class="box green-box"></span>예약 확정 <b>${dash.statusConfirmed}건</b></li>
          <li><span class="box blue-box"></span>예약 대기 <b>${dash.statusPending}건</b></li>
          <li><span class="box orange-box"></span>진료 완료 <b>${dash.statusDone}건</b></li>
          <li><span class="box gray-box"></span>취소 <b>${dash.statusCancel}건</b></li>
        </ul>
      </div>
    </div>
  </section>

  <%-- ── 오늘 예약 + 최근 리뷰 ── --%>
  <section class="bottom-grid">
    <div class="dash-card">
      <div class="card-head">
        <h3>오늘의 예약 목록</h3>
        <a href="${contextPath}/biz/hospital/reserve" class="outline-btn">전체 예약 보기</a>
      </div>
      <table class="biz-table">
        <thead><tr><th>예약 시간</th><th>예약자</th><th>반려동물</th><th>담당 수의사</th><th>진료 항목</th><th>상태</th><th>관리</th></tr></thead>
        <tbody>
          <c:forEach var="r" items="${todayList}">
          <tr>
            <td>${r.resvTime}</td>
            <td>${r.memberName}</td>
            <td>${r.petName} (${r.petSpecies})</td>
            <td>${r.doctorName}</td>
            <td>${r.treatTypeName}</td>
            <td>
              <c:choose>
                <c:when test="${r.statusCd eq 'CONFIRMED'}"><span class="badge confirm">예약 확정</span></c:when>
                <c:when test="${r.statusCd eq 'PENDING'}"><span class="badge wait">예약 대기</span></c:when>
                <c:when test="${r.statusCd eq 'DONE'}"><span class="badge confirm">진료 완료</span></c:when>
                <c:otherwise><span class="badge">${r.statusCd}</span></c:otherwise>
              </c:choose>
            </td>
            <td><a href="${contextPath}/biz/hospital/reserve" class="detail-btn">상세보기</a></td>
          </tr>
          </c:forEach>
          <c:if test="${empty todayList}">
          <tr><td colspan="7" style="text-align:center; color:#999; padding:24px;">오늘 예약이 없습니다.</td></tr>
          </c:if>
        </tbody>
      </table>
    </div>

    <div class="dash-card review-card">
      <div class="card-head">
        <h3>최근 리뷰</h3>
        <a href="${contextPath}/biz/hospital/reviews" class="outline-btn">전체 리뷰 보기</a>
      </div>
      <c:forEach var="rv" items="${recentReviews}">
      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>${rv.nickname} 님</b>
            <span class="stars"><c:forEach begin="1" end="5" var="i"><c:choose><c:when test="${i <= rv.rating}">★</c:when><c:otherwise>☆</c:otherwise></c:choose></c:forEach></span>
          </p>
          <small>${rv.content}</small>
        </div>
        <em><fmt:formatDate value="${rv.regDate}" pattern="yyyy-MM-dd"/></em>
      </div>
      </c:forEach>
      <c:if test="${empty recentReviews}">
      <p style="text-align:center; color:#999; padding:24px;">아직 리뷰가 없습니다.</p>
      </c:if>
    </div>
  </section>
</main>

<%-- 차트 JS --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script>
(function(){
  var labels = [<c:forEach var="l" items="${dash.chartLabels}" varStatus="s">'${l}'<c:if test="${!s.last}">,</c:if></c:forEach>];
  var resvData = [<c:forEach var="c" items="${dash.chartResvCounts}" varStatus="s">${c}<c:if test="${!s.last}">,</c:if></c:forEach>];
  var revData = [<c:forEach var="r" items="${dash.chartRevenues}" varStatus="s">${r}<c:if test="${!s.last}">,</c:if></c:forEach>];

  var ctx = document.getElementById('dashChart').getContext('2d');
  new Chart(ctx, {
    type: 'line',
    data: {
      labels: labels,
      datasets: [
        { label: '예약 건수', data: resvData, borderColor: '#2BAB82', backgroundColor: 'rgba(43,171,130,0.1)', tension: 0.3, yAxisID: 'y' },
        { label: '매출(원)', data: revData, borderColor: '#0284C7', backgroundColor: 'rgba(2,132,199,0.1)', tension: 0.3, yAxisID: 'y1' }
      ]
    },
    options: {
      responsive: true,
      interaction: { mode: 'index', intersect: false },
      plugins: { legend: { display: false } },
      scales: {
        y:  { type: 'linear', position: 'left',  beginAtZero: true, ticks: { precision: 0 } },
        y1: { type: 'linear', position: 'right', beginAtZero: true, grid: { drawOnChartArea: false },
              ticks: { callback: function(v){ return (v/10000).toFixed(0) + '만'; } } }
      }
    }
  });
})();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
