<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="cms-notice" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>
<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">공지사항</h1>
            <p class="adm-page-desc">공지사항을 등록하고 관리하세요.</p>
        </div>
        <div class="adm-page-actions">
            <a href="${contextPath}/admin/cms/notice/form" class="adm-filter-btn primary" style="text-decoration:none;display:inline-flex;align-items:center;gap:6px">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                공지 등록
            </a>
        </div>
    </div>
    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">공지 목록</span>
            <span class="adm-card-head-sub">총 3건</span>
        </div>
        <div class="adm-table-wrap">
            <table class="adm-table">
                <thead>
                    <tr><th>번호</th><th>제목</th><th>작성자</th><th>상단고정</th><th>조회</th><th>작성일</th><th>관리</th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td>3</td>
                        <td><strong>7월 여름맞이 최대 30% 할인 이벤트 안내</strong></td>
                        <td>펫린이 운영팀</td>
                        <td><span class="adm-badge active">고정</span></td>
                        <td>1,284</td>
                        <td>2025.07.01</td>
                        <td><a href="${contextPath}/admin/cms/notice/form?mode=edit&id=3" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td><strong>PetCare 서비스 이용약관 개정 안내</strong></td>
                        <td>펫린이 운영팀</td>
                        <td><span class="adm-badge wait">일반</span></td>
                        <td>892</td>
                        <td>2025.06.20</td>
                        <td><a href="${contextPath}/admin/cms/notice/form?mode=edit&id=2" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td><strong>시스템 점검 안내 (6/15 02:00~04:00)</strong></td>
                        <td>펫린이 운영팀</td>
                        <td><span class="adm-badge wait">일반</span></td>
                        <td>456</td>
                        <td>2025.06.10</td>
                        <td><a href="${contextPath}/admin/cms/notice/form?mode=edit&id=1" class="adm-btn blue">수정</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
