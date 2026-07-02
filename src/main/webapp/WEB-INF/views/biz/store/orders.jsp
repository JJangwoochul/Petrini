<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="orders" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<main class="biz-main">
    <div class="biz-page-head">
        <h1 class="biz-page-title">주문 관리</h1>
        <p class="biz-page-desc">주문 확인·출고 처리·취소/반품 처리</p>
    </div>
    <div class="biz-placeholder">
        <div class="bp-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M9 17H5a2 2 0 00-2 2v0a2 2 0 002 2h14"/><path d="M12 3v14"/><path d="M8 7l4-4 4 4"/>
            </svg>
        </div>
        <p>구현 예정입니다.</p>
        <small>주문 확인·출고 처리·취소/반품 처리</small>
    </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
