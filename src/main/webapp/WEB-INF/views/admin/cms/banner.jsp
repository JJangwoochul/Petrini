<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="cms-banner" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>
<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">배너 관리</h1>
            <p class="adm-page-desc">메인 배너를 등록·수정·삭제하세요.</p>
        </div>
        <div class="adm-page-actions">
            <a href="${contextPath}/admin/cms/banner/form" class="adm-filter-btn primary" style="text-decoration:none;display:inline-flex;align-items:center;gap:6px">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="16" height="16"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                배너 등록
            </a>
        </div>
    </div>
    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">배너 목록</span>
            <span class="adm-card-head-sub">총 3건</span>
        </div>
        <div class="adm-table-wrap">
            <table class="adm-table">
                <thead>
                    <tr><th>순서</th><th>미리보기</th><th>제목</th><th>링크</th><th>노출</th><th>기간</th><th>관리</th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td><img src="https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=120&q=70" alt="" style="width:80px;height:40px;object-fit:cover;border-radius:6px"></td>
                        <td><strong>여름맞이 반려동물 케어 특가</strong></td>
                        <td>/store</td>
                        <td><span class="adm-badge active">노출</span></td>
                        <td>2025.06.01 ~ 2025.08.31</td>
                        <td><a href="${contextPath}/admin/cms/banner/form?mode=edit&id=1" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td><img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=120&q=70" alt="" style="width:80px;height:40px;object-fit:cover;border-radius:6px"></td>
                        <td><strong>동물병원 예약 10% 할인</strong></td>
                        <td>/hospital</td>
                        <td><span class="adm-badge active">노출</span></td>
                        <td>2025.07.01 ~ 2025.07.31</td>
                        <td><a href="${contextPath}/admin/cms/banner/form?mode=edit&id=2" class="adm-btn blue">수정</a></td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td><img src="https://images.unsplash.com/photo-1615789591457-74a63395c990?w=120&q=70" alt="" style="width:80px;height:40px;object-fit:cover;border-radius:6px"></td>
                        <td><strong>유기동물 입양 캠페인</strong></td>
                        <td>/give/animal/list</td>
                        <td><span class="adm-badge cancel">숨김</span></td>
                        <td>2025.05.01 ~ 2025.06.30</td>
                        <td><a href="${contextPath}/admin/cms/banner/form?mode=edit&id=3" class="adm-btn blue">수정</a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
