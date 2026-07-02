<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/store.jsp" %>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">쇼핑몰 대시보드</h1>
    <p class="biz-page-desc">주문 현황과 주요 판매 지표를 확인하세요.</p>
  </div>
  <div class="biz-stats">
    <div class="biz-stat-card"><div class="bsc-icon appt"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9 17H5a2 2 0 00-2 2v0a2 2 0 002 2h14"/><path d="M12 3v14"/><path d="M8 7l4-4 4 4"/></svg></div><div class="bsc-body"><span class="bsc-label">신규 주문</span><span class="bsc-val">12<span class="bsc-unit">건</span></span></div></div>
    <div class="biz-stat-card"><div class="bsc-icon done"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg></div><div class="bsc-body"><span class="bsc-label">배송중</span><span class="bsc-val">8<span class="bsc-unit">건</span></span></div></div>
    <div class="biz-stat-card"><div class="bsc-icon revenue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div><div class="bsc-body"><span class="bsc-label">이번 달 매출</span><span class="bsc-val">12.6<span class="bsc-unit">백만원</span></span></div></div>
    <div class="biz-stat-card"><div class="bsc-icon review"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></div><div class="bsc-body"><span class="bsc-label">평균 리뷰</span><span class="bsc-val">4.5<span class="bsc-unit">/ 5.0</span></span></div></div>
  </div>
  <div class="biz-card">
    <div class="biz-card-head"><span>최근 주문 현황</span><small>출고 대기 2건</small></div>
    <table class="biz-table">
      <thead><tr><th>주문번호</th><th>주문자</th><th>상품명</th><th>금액</th><th>상태</th><th>처리</th></tr></thead>
      <tbody>
        <tr><td>#ORD-2025-0892</td><td>김민준</td><td>로얄캐닌 사료 4kg 외 1건</td><td>74,900원</td><td><span class="bs-badge bs-wait">결제완료</span></td><td><button class="biz-btn">출고처리</button></td></tr>
        <tr><td>#ORD-2025-0891</td><td>이서연</td><td>노즈워크 매트 오렌지</td><td>18,500원</td><td><span class="bs-badge bs-wait">결제완료</span></td><td><button class="biz-btn">출고처리</button></td></tr>
        <tr><td>#ORD-2025-0890</td><td>박지호</td><td>H형 하네스 M 블루</td><td>22,000원</td><td><span class="bs-badge bs-ready">배송중</span></td><td>—</td></tr>
        <tr><td>#ORD-2025-0889</td><td>최유나</td><td>수제 져키 200g × 2</td><td>26,000원</td><td><span class="bs-badge bs-done">배송완료</span></td><td>—</td></tr>
      </tbody>
    </table>
  </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
