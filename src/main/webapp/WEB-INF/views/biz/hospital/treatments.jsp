<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="treatments" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<main class="biz-main">
    <div class="biz-page-head">
        <h1 class="biz-page-title">진료 항목 관리</h1>
        <p class="biz-page-desc">진료 항목·가격 등록 및 수정</p>
    </div>
    <div class="biz-placeholder">
        <div class="bp-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
            </svg>
        </div>
        <p>구현 예정입니다.</p>
        <small>진료 항목·가격 등록 및 수정</small>
    </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
