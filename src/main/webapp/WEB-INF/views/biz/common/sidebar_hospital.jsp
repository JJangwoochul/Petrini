<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 사업자센터 동물병원 사이드바 — bizPage 변수로 active 제어 --%>
<aside class="biz-sidebar">
  <div class="biz-sidebar-profile">
    <div class="biz-sidebar-biz-icon hospital">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
        <rect x="9" y="10" width="6" height="11" rx="1"/>
        <line x1="12" y1="13" x2="12" y2="17"/>
        <line x1="10" y1="15" x2="14" y2="15"/>
      </svg>
    </div>
    <div class="biz-sidebar-bizname">${memberInfo.memberName}</div>
    <div class="biz-sidebar-biztype">동물병원</div>
  </div>
  <nav class="biz-nav">
    <a href="${contextPath}/biz/hospital" class="biz-nav-link ${bizPage eq 'dashboard' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="3" width="7" height="7" rx="1"/>
        <rect x="14" y="3" width="7" height="7" rx="1"/>
        <rect x="3" y="14" width="7" height="7" rx="1"/>
        <rect x="14" y="14" width="7" height="7" rx="1"/>
      </svg>
      홈
    </a>
    <div class="biz-nav-group">진료 관리</div>
    <a href="${contextPath}/biz/hospital/reserve" class="biz-nav-link ${bizPage eq 'reserve' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="4" width="18" height="18" rx="2"/>
        <line x1="3" y1="10" x2="21" y2="10"/>
        <line x1="8" y1="2" x2="8" y2="6"/>
        <line x1="16" y1="2" x2="16" y2="6"/>
      </svg>
      예약 관리<span class="biz-nav-badge">5</span>
    </a>
    <%-- <a href="${contextPath}/biz/hospital/treatments" class="biz-nav-linㄴk ${bizPage eq 'treatments' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
      진료 항목 관리
    </a> --%>
    <%-- <a href="${contextPath}/biz/hospital/patients" class="biz-nav-link ${bizPage eq 'patients' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="4.5" cy="9.5" r="2"/><circle cx="9" cy="5.5" r="2"/><circle cx="15" cy="5.5" r="2"/><circle cx="19.5" cy="9.5" r="2"/><path d="M12 13c-3.87 0-7 1.79-7 4v1h14v-1c0-2.21-3.13-4-7-4z"/></svg>
      내원 환자 이력
    </a> --%>
    <a href="${contextPath}/biz/hospital/records" class="biz-nav-link ${bizPage eq 'records' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/></svg>
      진료기록 관리
    </a>
    <div class="biz-nav-group">운영 관리</div>
    <a href="${contextPath}/biz/hospital/talent" class="biz-nav-link ${bizPage eq 'talent' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
      재능나눔 신청
    </a>
    <a href="${contextPath}/biz/hospital/reviews" class="biz-nav-link ${bizPage eq 'reviews' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
      리뷰 관리
    </a>
    <a href="${contextPath}/biz/hospital/contract" class="biz-nav-link ${bizPage eq 'contract' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
      계약 관리
    </a>
    <a href="${contextPath}/biz/hospital/info" class="biz-nav-link ${bizPage eq 'info' ? 'active' : ''}">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      업체 정보 수정
    </a>
  </nav>
</aside>