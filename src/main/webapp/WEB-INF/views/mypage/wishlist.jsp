<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="wishlist" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<div class="mp-section active">
    <h2 class="mp-title">관심상품</h2>
    <p class="mp-desc">찜한 상품 <strong id="wishCount">0</strong>개</p>
    <div class="wishlist-grid" id="wishlistGrid">
        <div class="search-empty" style="grid-column:1/-1;padding:48px 20px;text-align:center;color:var(--text-muted);">
            찜한 상품이 없습니다.
        </div>
    </div>
</div>

</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
