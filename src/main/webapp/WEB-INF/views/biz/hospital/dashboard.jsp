<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<main class="biz-main">
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
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
