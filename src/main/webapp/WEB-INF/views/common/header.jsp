<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>펫린이 - 반려동물 통합 플랫폼</title>
    <link rel="icon" href="${contextPath}/favicon.ico" sizes="any">
    <link rel="icon" href="${contextPath}/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="${contextPath}/favicon.svg">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${contextPath}/resources/css/petcare.css?v=20260705">
</head>
<body>
<header class="pc-header">
    <div class="header-top">
        <div class="header-top-inner">
            <nav class="header-top-nav">
            <%-- 2026/07/07 장우철 — 관리자 헤더 버튼
                 변경 이유: 관리자도 유저 홈(/login)에서 로그인하므로, role=ADMIN 일 때만
                 로그아웃 옆에 관리자 대시보드(/admin) 이동 링크 노출 (유저·사업자에게는 비표시) --%>
            <c:choose>
            <c:when test="${not empty memberInfo}">
                <c:if test="${memberInfo.role eq 'ADMIN'}">
                    <a href="${contextPath}/admin">관리자페이지</a>
                </c:if>
                <a href="${contextPath}/member/logout">로그아웃</a>
            </c:when>
            <c:otherwise>
                <a href="${contextPath}/login">로그인</a>
                <a href="${contextPath}/join">회원가입</a>
            </c:otherwise>
            </c:choose>
            <%-- [변경 전] 로그인 시 로그아웃만 표시 (관리자 전용 링크 없음)
            <c:choose>
            <c:when test="${not empty memberInfo}">
                <a href="${contextPath}/member/logout">로그아웃</a>
            </c:when>
            <c:otherwise>
                <a href="${contextPath}/login">로그인</a>
                <a href="${contextPath}/join">회원가입</a>
            </c:otherwise>
            </c:choose>
            --%>
                <a href="${contextPath}/member/cs">고객센터</a>
            
            </nav>
        </div>
    </div>

    <div class="header-main">
        <div class="header-inner">
            <!-- 로고 -->
            <a href="${contextPath}/" class="logo">
                <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <ellipse cx="16" cy="20" rx="9" ry="8" fill="#2BAB82"/>
                    <ellipse cx="8"  cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="13" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="19" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="24" cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <path d="M14.5 20.5 C14.5 19 16 18 16 18 C16 18 17.5 19 17.5 20.5 C17.5 22 16 23 16 23 C16 23 14.5 22 14.5 20.5Z" fill="white" opacity="0.85"/>
                </svg>
                <span class="logo-text">펫린이</span>
            </a>

            <!-- 검색 -->
            <div class="header-search">
                <input type="text" class="search-input" placeholder="검색어를 입력하세요" value="${param.q}">
                <button type="button" class="search-btn" aria-label="검색">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="11" cy="11" r="8"/>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                </button>
            </div>

            <!-- 유틸 아이콘 -->
            <div class="header-utils">
                <a href="${contextPath}/mypage/wishlist" class="util-btn">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                    </svg>
                    <span>찜</span>
                </a>
                <a href="${contextPath}/store/cart" class="util-btn cart-btn">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="9" cy="21" r="1"/>
                        <circle cx="20" cy="21" r="1"/>
                        <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"/>
                    </svg>
                    <span class="cart-count">0</span>
                    <span>장바구니</span>
                </a>
                <a href="${contextPath}/mypage" class="util-btn">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    <span>마이페이지</span>
                </a>
                <a href="${contextPath}/mypage/notifications" class="util-btn noti-btn" aria-label="알림함">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                        <path d="M13.73 21a2 2 0 01-3.46 0"/>
                    </svg>
                    <span>알림</span>
                </a>
            </div>
        </div>
    </div>

    <!-- GNB -->
    <nav class="gnb">
        <div class="gnb-inner">
            <a href="${contextPath}/stay" class="gnb-item ${pageId eq 'stay' ? 'active' : ''}">숙소</a>
            <a href="${contextPath}/store" class="gnb-item ${pageId eq 'store' ? 'active' : ''}">쇼핑</a>
            <a href="${contextPath}/hospital" class="gnb-item ${pageId eq 'hospital' ? 'active' : ''}">병원</a>
            <a href="${contextPath}/walk" class="gnb-item ${pageId eq 'walk' ? 'active' : ''}">산책</a>
            <a href="${contextPath}/community" class="gnb-item ${pageId eq 'community' ? 'active' : ''}">커뮤니티</a>
            <a href="${contextPath}/give" class="gnb-item ${pageId eq 'give' ? 'active' : ''}">가족찾기</a>
            <a href="${contextPath}/petmap" class="gnb-item ${pageId eq 'petmap' ? 'active' : ''}">펫맵</a>
        </div>
    </nav>
</header>
