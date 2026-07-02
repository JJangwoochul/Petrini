<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="rooms" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<main class="biz-main">
    <div class="biz-page-head">
        <h1 class="biz-page-title">객실 관리</h1>
        <p class="biz-page-desc">객실 타입·가격·사진 등록</p>
    </div>
    <div class="biz-placeholder">
        <div class="bp-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                 stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="3" width="20" height="14" rx="2"/><path d="M8 21h8M12 17v4"/>
            </svg>
        </div>
        <p>구현 예정입니다.</p>
        <small>객실 타입·가격·사진 등록</small>
    </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
