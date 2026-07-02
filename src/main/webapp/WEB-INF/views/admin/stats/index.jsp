<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="stats" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">통계 &amp; 분석</h1>
            <p class="adm-page-desc">기간별 매출·회원·예약 현황을 분석하세요.</p>
        </div>
        <div class="adm-page-actions">
            <select class="adm-filter-select">
                <option>최근 7일</option>
                <option>최근 30일</option>
                <option>최근 3개월</option>
                <option>올해</option>
            </select>
            <button class="adm-filter-btn outline" style="margin-left:8px">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                Excel 내보내기
            </button>
        </div>
    </div>

    <%-- 요약 카드 --%>
    <div class="adm-stats" style="margin-bottom:24px">
        <div class="adm-stat-card">
            <div class="adm-stat-icon blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">이번 달 총 매출</div>
                <div class="adm-stat-val">128.4<span class="adm-stat-unit">백만원</span></div>
                <div class="adm-stat-diff up">▲ 전월 대비 +14.2%</div>
            </div>
        </div>
        <div class="adm-stat-card">
            <div class="adm-stat-icon green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg></div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">이번 달 신규 가입</div>
                <div class="adm-stat-val">842<span class="adm-stat-unit">명</span></div>
                <div class="adm-stat-diff up">▲ 전월 대비 +8.7%</div>
            </div>
        </div>
        <div class="adm-stat-card">
            <div class="adm-stat-icon orange"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">이번 달 예약 건수</div>
                <div class="adm-stat-val">3,241<span class="adm-stat-unit">건</span></div>
                <div class="adm-stat-diff up">▲ 전월 대비 +22.1%</div>
            </div>
        </div>
        <div class="adm-stat-card">
            <div class="adm-stat-icon red"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg></div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">이번 달 주문 수</div>
                <div class="adm-stat-val">4,182<span class="adm-stat-unit">건</span></div>
                <div class="adm-stat-diff up">▲ 전월 대비 +18.3%</div>
            </div>
        </div>
    </div>

    <div class="adm-grid-2">
        <%-- 매출 추이 --%>
        <div class="adm-card">
            <div class="adm-card-head">
                <span class="adm-card-head-title">월별 매출 추이</span>
                <span class="adm-card-head-sub">단위: 백만원</span>
            </div>
            <div class="adm-card-body">
                <canvas id="monthSales" height="220"></canvas>
            </div>
        </div>

        <%-- 회원 증감 --%>
        <div class="adm-card">
            <div class="adm-card-head">
                <span class="adm-card-head-title">월별 신규 가입자</span>
                <span class="adm-card-head-sub">단위: 명</span>
            </div>
            <div class="adm-card-body">
                <canvas id="memberGrowth" height="220"></canvas>
            </div>
        </div>
    </div>

    <%-- 예약 건수 --%>
    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">업종별 예약 현황</span>
            <span class="adm-card-head-sub">이번 달 기준</span>
        </div>
        <div class="adm-card-body">
            <canvas id="reservationChart" height="120"></canvas>
        </div>
    </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script>
var months = ['1월','2월','3월','4월','5월','6월'];

new Chart(document.getElementById('monthSales'), {
    type: 'line',
    data: {
        labels: months,
        datasets: [{
            label: '매출', data: [88.2, 92.4, 104.1, 110.8, 112.3, 128.4],
            borderColor: '#3B5BDB', backgroundColor: 'rgba(59,91,219,.08)',
            borderWidth: 2.5, pointRadius: 4, fill: true, tension: .35
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: false, grid: { color: '#F1F3F7' } }, x: { grid: { display: false } } }
    }
});

new Chart(document.getElementById('memberGrowth'), {
    type: 'bar',
    data: {
        labels: months,
        datasets: [{
            label: '신규 가입자', data: [620, 710, 680, 790, 775, 842],
            backgroundColor: 'rgba(43,171,130,.2)', borderColor: '#2BAB82',
            borderWidth: 2, borderRadius: 6
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, grid: { color: '#F1F3F7' } }, x: { grid: { display: false } } }
    }
});

new Chart(document.getElementById('reservationChart'), {
    type: 'bar',
    data: {
        labels: ['동물병원', '반려동물 숙소', '반려동물 동반 요식업', '애견미용실'],
        datasets: [{
            label: '예약 건수', data: [1284, 842, 671, 444],
            backgroundColor: ['rgba(59,91,219,.7)','rgba(147,51,234,.7)','rgba(234,88,12,.7)','rgba(219,39,119,.7)'],
            borderRadius: 6
        }]
    },
    options: {
        indexAxis: 'y', responsive: true,
        plugins: { legend: { display: false } },
        scales: { x: { beginAtZero: true, grid: { color: '#F1F3F7' } }, y: { grid: { display: false } } }
    }
});
</script>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
