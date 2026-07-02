<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 관리자 전용 헤더 — adminPage 변수로 사이드바 active 제어 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PetCare 관리자</title>
    <link rel="icon" href="${contextPath}/favicon.ico" sizes="any">
    <link rel="icon" href="${contextPath}/favicon.svg" type="image/svg+xml">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${contextPath}/resources/css/admin.css">
</head>
<body>
<div class="adm-page">

<header class="adm-header">
    <a href="${contextPath}/admin" class="adm-logo">
        <svg width="24" height="24" viewBox="0 0 32 32" fill="none">
            <ellipse cx="16" cy="20" rx="9" ry="8" fill="#2BAB82"/>
            <ellipse cx="8"  cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
            <ellipse cx="13" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
            <ellipse cx="19" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
            <ellipse cx="24" cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
        </svg>
        <span>PetCare</span>
        <span class="adm-tag">ADMIN</span>
    </a>
    <div class="adm-header-divider"></div>
    <span class="adm-header-title">관리자 센터</span>
    <div class="adm-header-right">
        <a href="${contextPath}/admin/biz/list">
            <svg viewBox="0 0 24 24"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 01-3.46 0"/></svg>
            사업자 승인 대기
            <span class="adm-noti-badge">3</span>
        </a>
        <div class="adm-header-divider"></div>
        <a href="${contextPath}/">
            <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
            사이트로 이동
        </a>
        <a href="${contextPath}/member/logout">
            <svg viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            로그아웃
        </a>
    </div>
</header>

<div class="adm-body">
