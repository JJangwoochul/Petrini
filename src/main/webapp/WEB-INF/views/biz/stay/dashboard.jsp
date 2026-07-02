<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">숙소 대시보드</h1>
    <p class="biz-page-desc">객실 현황과 오늘 체크인·체크아웃을 확인하세요.</p>
  </div>
  <div class="biz-stats">
    <div class="biz-stat-card"><div class="bsc-icon appt"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div><div class="bsc-body"><span class="bsc-label">오늘 체크인</span><span class="bsc-val">2<span class="bsc-unit">건</span></span></div></div>
    <div class="biz-stat-card"><div class="bsc-icon done"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg></div><div class="bsc-body"><span class="bsc-label">객실 가동률</span><span class="bsc-val">75<span class="bsc-unit">%</span></span></div></div>
    <div class="biz-stat-card"><div class="bsc-icon revenue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div><div class="bsc-body"><span class="bsc-label">이번 달 매출</span><span class="bsc-val">5.2<span class="bsc-unit">백만원</span></span></div></div>
    <div class="biz-stat-card"><div class="bsc-icon review"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></div><div class="bsc-body"><span class="bsc-label">평균 리뷰</span><span class="bsc-val">4.7<span class="bsc-unit">/ 5.0</span></span></div></div>
  </div>
  <div class="biz-card">
    <div class="biz-card-head"><span>객실 현황</span><small>입실중 3 / 전체 5</small></div>
    <table class="biz-table">
      <thead><tr><th>객실</th><th>타입</th><th>수용 체중</th><th>입실 동물</th><th>체크아웃</th><th>상태</th></tr></thead>
      <tbody>
        <tr><td>A-01호</td><td>스탠다드 (소형)</td><td>~5kg</td><td>몽이 (말티즈)</td><td>06.27</td><td><span class="bs-badge bs-done">입실중</span></td></tr>
        <tr><td>A-02호</td><td>스탠다드 (소형)</td><td>~5kg</td><td>—</td><td>—</td><td><span class="bs-badge bs-empty">공실</span></td></tr>
        <tr><td>B-01호</td><td>디럭스 (중형)</td><td>~15kg</td><td>바둑이 (비글)</td><td>06.28</td><td><span class="bs-badge bs-done">입실중</span></td></tr>
        <tr><td>B-02호</td><td>디럭스 (중형)</td><td>~15kg</td><td>하루 (포메)</td><td>06.27</td><td><span class="bs-badge bs-done">입실중</span></td></tr>
        <tr><td>C-01호</td><td>스위트 (대형)</td><td>~30kg</td><td>—</td><td>—</td><td><span class="bs-badge bs-empty">공실</span></td></tr>
      </tbody>
    </table>
  </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
