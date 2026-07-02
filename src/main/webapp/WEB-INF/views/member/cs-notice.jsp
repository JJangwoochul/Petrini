<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="cs" />
<c:set var="noticeId" value="${empty noticeId ? '1' : noticeId}" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
.cs-notice-detail-wrap {
    max-width: 800px;
    margin: 36px auto 80px;
    padding: 0 20px;
}
.cs-notice-back {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    color: var(--text-muted);
    text-decoration: none;
    margin-bottom: 20px;
}
.cs-notice-back:hover { color: var(--primary); }
.cs-notice-back svg {
    width: 16px;
    height: 16px;
    stroke: currentColor;
    fill: none;
    stroke-width: 2;
    stroke-linecap: round;
    stroke-linejoin: round;
}
.cs-notice-detail-card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 32px 28px;
}
.cs-notice-detail-badge {
    display: inline-block;
    font-size: 11px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 4px;
    background: var(--primary-light);
    color: var(--primary-dark);
    margin-bottom: 14px;
}
.cs-notice-detail-badge.info {
    background: #E0F2FE;
    color: #0284C7;
}
.cs-notice-detail-title {
    font-size: 22px;
    font-weight: 800;
    color: var(--text-main);
    margin: 0 0 12px;
    line-height: 1.4;
}
.cs-notice-detail-meta {
    font-size: 13px;
    color: var(--text-muted);
    padding-bottom: 20px;
    margin-bottom: 24px;
    border-bottom: 1px solid var(--border);
}
.cs-notice-detail-body {
    font-size: 15px;
    color: var(--text-sub);
    line-height: 1.85;
}
.cs-notice-detail-body p { margin: 0 0 14px; }
.cs-notice-detail-body ul {
    margin: 0 0 14px;
    padding-left: 20px;
}
.cs-notice-detail-body li { margin-bottom: 6px; }
.cs-notice-empty {
    text-align: center;
    padding: 48px 20px;
    color: var(--text-muted);
}
</style>

<div class="cs-notice-detail-wrap">
    <a href="${contextPath}/member/cs" class="cs-notice-back">
        <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
        공지사항 목록
    </a>

    <article class="cs-notice-detail-card">
        <c:choose>
        <c:when test="${noticeId eq '1'}">
            <span class="cs-notice-detail-badge">공지</span>
            <h1 class="cs-notice-detail-title">7월 여름맞이 최대 30% 할인 이벤트 안내</h1>
            <div class="cs-notice-detail-meta">2025.07.01 · 펫린이 운영팀</div>
            <div class="cs-notice-detail-body">
                <p>안녕하세요, 펫린이입니다.</p>
                <p>여름맞이 대축제가 시작되었습니다. 사료·간식·용품 전 품목 최대 30% 할인과 추가 쿠폰 혜택을 만나보세요.</p>
                <ul>
                    <li>이벤트 기간: 2025.07.01 ~ 2025.07.31</li>
                    <li>할인 범위: 쇼핑몰 전 품목 최대 30%</li>
                    <li>추가 혜택: 결제 금액별 쿠폰 자동 발급</li>
                </ul>
                <p>자세한 내용은 이벤트 페이지에서 확인해 주세요.</p>
            </div>
        </c:when>

        <c:when test="${noticeId eq '2'}">
            <span class="cs-notice-detail-badge">공지</span>
            <h1 class="cs-notice-detail-title">PetCare 서비스 이용약관 개정 안내</h1>
            <div class="cs-notice-detail-meta">2025.06.20 · 펫린이 운영팀</div>
            <div class="cs-notice-detail-body">
                <p>펫린이 서비스 이용약관이 아래와 같이 개정됩니다.</p>
                <ul>
                    <li>시행일: 2025.07.01</li>
                    <li>개정 사유: 회원 보호 및 서비스 정책 명확화</li>
                    <li>주요 변경: 환불·취소 정책, 개인정보 처리 관련 조항 보완</li>
                </ul>
                <p>개정 약관은 고객센터 &gt; 이용약관 메뉴에서 확인하실 수 있습니다. 시행일 이후 서비스 이용 시 개정 약관에 동의한 것으로 간주됩니다.</p>
            </div>
        </c:when>

        <c:when test="${noticeId eq '3'}">
            <span class="cs-notice-detail-badge info">안내</span>
            <h1 class="cs-notice-detail-title">시스템 점검 안내 (6/15 02:00~04:00)</h1>
            <div class="cs-notice-detail-meta">2025.06.10 · 펫린이 운영팀</div>
            <div class="cs-notice-detail-body">
                <p>보다 안정적인 서비스 제공을 위해 아래와 같이 시스템 점검이 진행됩니다.</p>
                <ul>
                    <li>점검 일시: 2025.06.15 (일) 02:00 ~ 04:00</li>
                    <li>점검 내용: 서버 안정화 및 보안 패치</li>
                    <li>영향 범위: 점검 시간 동안 일부 기능 이용 제한</li>
                </ul>
                <p>점검 시간은 작업 상황에 따라 변경될 수 있습니다. 이용에 불편을 드려 죄송합니다.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="cs-notice-empty">
                <p>요청하신 공지를 찾을 수 없습니다.</p>
                <a href="${contextPath}/member/cs" class="cs-notice-back" style="margin-top:16px">목록으로 돌아가기</a>
            </div>
        </c:otherwise>
        </c:choose>
    </article>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
