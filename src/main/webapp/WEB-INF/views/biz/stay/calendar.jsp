<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="calendar" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<main class="biz-main">
    <div class="biz-page-head">
        <h1 class="biz-page-title">예약 캘린더</h1>
        <p class="biz-page-desc">월별 예약 현황 캘린더 뷰</p>
    </div>
    <div class="biz-placeholder">
        <div class="bp-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                 stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/>
            </svg>
        </div>
        <p>구현 예정입니다.</p>
        <small>월별 예약 현황 캘린더 뷰</small>
    </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
