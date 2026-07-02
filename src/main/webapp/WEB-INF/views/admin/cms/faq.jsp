<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="cms-faq" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>
<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">FAQ</h1>
            <p class="adm-page-desc">자주 묻는 질문을 관리하세요.</p>
        </div>
        <div class="adm-page-actions">
            <a href="${contextPath}/admin/cms/faq/form" class="adm-filter-btn primary" style="text-decoration:none;display:inline-flex;align-items:center;gap:6px">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                FAQ 등록
            </a>
        </div>
    </div>
    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">FAQ 목록</span>
            <span class="adm-card-head-sub">총 4건</span>
        </div>
        <div class="adm-table-wrap">
            <table class="adm-table">
                <thead>
                    <tr><th>번호</th><th>카테고리</th><th>질문</th><th>노출</th><th>등록일</th><th>관리</th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td>4</td><td>주문/배송</td>
                        <td><strong>배송은 얼마나 걸리나요?</strong></td>
                        <td><span class="adm-badge active">노출</span></td>
                        <td>2025.06.15</td>
                        <td><a href="${contextPath}/admin/cms/faq/form?mode=edit&id=4" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>3</td><td>회원</td>
                        <td><strong>비밀번호를 잊어버렸어요.</strong></td>
                        <td><span class="adm-badge active">노출</span></td>
                        <td>2025.06.10</td>
                        <td><a href="${contextPath}/admin/cms/faq/form?mode=edit&id=3" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>2</td><td>예약</td>
                        <td><strong>병원 예약을 취소하고 싶어요.</strong></td>
                        <td><span class="adm-badge active">노출</span></td>
                        <td>2025.06.05</td>
                        <td><a href="${contextPath}/admin/cms/faq/form?mode=edit&id=2" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>1</td><td>서비스</td>
                        <td><strong>PetCare는 어떤 서비스인가요?</strong></td>
                        <td><span class="adm-badge active">노출</span></td>
                        <td>2025.05.20</td>
                        <td><a href="${contextPath}/admin/cms/faq/form?mode=edit&id=1" class="adm-btn blue">수정</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
