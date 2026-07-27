<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- adminPage 변수로 active 제어 --%>
<aside class="adm-sidebar">
    <div class="adm-sidebar-profile">
        <img class="adm-avatar"
             src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=76&q=80&auto=format&fit=crop"
             alt="관리자"
             onerror="this.src='https://placehold.co/38x38/EEF2FF/3B5BDB?text=A'">
        <div>
            <div class="adm-profile-name">${memberInfo.memberName}</div>
            <span class="adm-profile-role">ADMIN</span>
        </div>
    </div>

    <nav class="adm-nav">
        <a href="${contextPath}/admin" class="adm-nav-link ${adminPage eq 'dashboard' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            대시보드
        </a>

        <div class="adm-nav-group">회원 · 상품 · 주문</div>
        <a href="${contextPath}/admin/member/list" class="adm-nav-link ${adminPage eq 'member-list' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg>
            회원 관리
        </a>
        <a href="${contextPath}/admin/store/product-list" class="adm-nav-link ${adminPage eq 'product-list' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            상품 관리
        </a>
        <a href="${contextPath}/admin/store/category" class="adm-nav-link ${adminPage eq 'category' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            카테고리 관리
        </a>
        <a href="${contextPath}/admin/store/order-list" class="adm-nav-link ${adminPage eq 'order-list' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
            주문 관리
        </a>
        <%-- 지윤 26.07.21 추가: 사업자 리뷰 삭제요청 승인/반려 화면 --%>
        <a href="${contextPath}/admin/store/review-report" class="adm-nav-link ${adminPage eq 'review-report' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
            리뷰 관리
        </a>

        <div class="adm-nav-group">사업자 · 커뮤니티</div>
        <a href="${contextPath}/admin/biz/list" class="adm-nav-link ${adminPage eq 'biz-list' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"/></svg>
            사업자 승인
            <%-- 2026/07/11 장우철 — PENDING 승인대기 건수 (더미 3 제거) --%>
            <c:if test="${pendingBizApproveCount > 0}">
              <span class="adm-nav-badge">${pendingBizApproveCount}</span>
            </c:if>
        </a>
        <a href="${contextPath}/admin/biz/talent?status=PENDING" class="adm-nav-link ${adminPage eq 'biz-talent' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
            재능나눔 승인
            <%-- 2026-07-14 박유정 — PENDING 승인대기 건수 (AdminSidebarAdvice.pendingTalentApproveCount) --%>
            <c:if test="${pendingTalentApproveCount > 0}">
              <span class="adm-nav-badge">${pendingTalentApproveCount}</span>
            </c:if>
        </a>
        <a href="${contextPath}/admin/community/list" class="adm-nav-link ${adminPage eq 'community-list' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
            커뮤니티 관리
        </a>

        <div class="adm-nav-group">CMS</div>
        <a href="${contextPath}/admin/cms/banner" class="adm-nav-link ${adminPage eq 'cms-banner' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18"/><path d="M9 21V9"/></svg>
            배너 관리
        </a>
        <a href="${contextPath}/admin/cms/notice" class="adm-nav-link ${adminPage eq 'cms-notice' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            공지사항
        </a>
        <a href="${contextPath}/admin/cms/faq" class="adm-nav-link ${adminPage eq 'cms-faq' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 015.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
            FAQ
        </a>

        <div class="adm-nav-group">통계</div>
        <a href="${contextPath}/admin/stats" class="adm-nav-link ${adminPage eq 'stats' ? 'active' : ''}">
            <svg viewBox="0 0 24 24"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
            통계 &amp; 분석
        </a>
    </nav>
</aside>
