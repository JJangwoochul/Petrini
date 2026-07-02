<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="products" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<main class="biz-main">
    <div class="biz-page-head">
        <h1 class="biz-page-title">상품 관리</h1>
        <p class="biz-page-desc">상품 등록·수정·삭제, 카테고리 관리</p>
    </div>
    <div class="biz-placeholder">
        <div class="bp-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/>
            </svg>
        </div>
        <p>구현 예정입니다.</p>
        <small>상품 등록·수정·삭제, 카테고리 관리</small>
    </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
