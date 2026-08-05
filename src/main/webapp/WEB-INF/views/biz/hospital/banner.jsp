<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizPage" value="banner" />
<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<main class="biz-main">
    <div class="biz-page-head">
        <div>
            <h1 class="biz-page-title">배너 광고</h1>
            <p class="biz-page-desc">메인페이지 및 서비스 페이지에 노출할 배너를 신청하세요.</p>
        </div>
        <a href="${contextPath}/biz/hospital/banner/form" class="biz-btn primary">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            배너 신청
        </a>
    </div>

    <%-- 알림 메시지 --%>
    <c:if test="${not empty msg}">
        <div class="biz-alert success">${msg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="biz-alert error">${errorMsg}</div>
    </c:if>

    <div class="biz-card">
        <div class="biz-card-head">
            <span class="biz-card-title">내 배너 목록</span>
            <span class="biz-card-sub">총 ${bannerList.size()}건</span>
        </div>

        <c:choose>
            <c:when test="${not empty bannerList}">
                <div class="biz-table-wrap">
                    <table class="biz-table">
                        <thead>
                            <tr>
                                <th>미리보기</th>
                                <th>제목</th>
                                <th>노출 위치</th>
                                <th>노출 기간</th>
                                <th>상태</th>
                                <th>비고</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="banner" items="${bannerList}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty banner.imageUrl}">
                                                <%-- 2026/08/05 장우철 — contextPath 누락 수정 --%>
                                                <img src="${contextPath}/upload/${banner.imageUrl}" alt=""
                                                     style="width:120px;height:50px;object-fit:cover;border-radius:6px"
                                                     onerror="this.src='https://placehold.co/120x50/EAF7F2/2BAB82?text=배너'">
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#999;font-size:13px">이미지 없음</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${banner.title}</strong></td>
                                    <td>
                                        <span class="biz-badge">${banner.positionLabel}</span>
                                    </td>
                                    <td>
                                        <%-- 2026/08/05 장우철 — VO start/endDate=String(TO_CHAR). fmt:formatDate는 Date만 가능 → 500 방지 --%>
                                        ${banner.startDate} ~ ${banner.endDate}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${banner.statusCd eq 'PENDING'}">
                                                <span class="biz-badge warning">심사중</span>
                                            </c:when>
                                            <c:when test="${banner.statusCd eq 'ACTIVE'}">
                                                <span class="biz-badge success">노출중</span>
                                            </c:when>
                                            <c:when test="${banner.statusCd eq 'REJECTED'}">
                                                <span class="biz-badge danger">반려</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="biz-badge">${banner.statusCd}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${banner.statusCd eq 'REJECTED' and not empty banner.rejectReason}">
                                            <span style="color:#e74c3c;font-size:13px">${banner.rejectReason}</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div style="padding:60px 20px;text-align:center;color:#999">
                    <p>신청한 배너가 없습니다.</p>
                    <a href="${contextPath}/biz/hospital/banner/form" style="color:#2BAB82;text-decoration:underline;margin-top:8px;display:inline-block">배너 신청하기</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>
<jsp:include page="/WEB-INF/views/biz/common/footer.jsp" />
