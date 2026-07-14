<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="reserve" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- 2026/07/11 장우철 — 마이페이지 예약 내역 DB 연동 (2차) --%>
<div class="mp-section active">
    <h2 class="mp-title">예약내역</h2>
    <p class="mp-desc">병원 예약 현황을 확인하고 상세를 볼 수 있습니다.</p>

    <c:if test="${param.error eq 'notfound'}">
      <p style="color:#B91C1C;font-size:14px;margin-bottom:12px">예약을 찾을 수 없습니다.</p>
    </c:if>
    <c:if test="${not empty msg}">
      <p style="color:#166534;font-size:14px;margin-bottom:12px"><c:out value="${msg}"/></p>
    </c:if>

    <div class="order-filter" style="margin-bottom:20px">
        <a class="filter-btn ${statusFilter eq 'all' or empty statusFilter ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=all">전체</a>
        <a class="filter-btn ${statusFilter eq 'pending' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=pending">예약신청</a>
        <a class="filter-btn ${statusFilter eq 'confirmed' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=confirmed">예약확정</a>
        <a class="filter-btn ${statusFilter eq 'done' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=done">진료완료</a>
        <a class="filter-btn ${statusFilter eq 'cancel' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=cancel">취소</a>
    </div>

    <c:if test="${empty reservationList}">
      <div style="text-align:center;padding:48px 0;color:#999;font-size:14px">예약 내역이 없습니다.</div>
    </c:if>

    <c:forEach var="r" items="${reservationList}">
      <a href="${contextPath}/mypage/reserve/detail?resvId=${r.resvId}"
         class="resv-card" style="text-decoration:none;color:inherit;display:flex;cursor:pointer">
        <img class="resv-thumb"
             src="https://placehold.co/88x88/EAF7F2/2BAB82?text=병원"
             alt="동물병원">
        <div class="resv-info">
            <span class="category">동물병원</span>
            <div class="rname">
              <c:out value="${not empty r.hospitalName ? r.hospitalName : '병원'}"/>
              <c:if test="${not empty r.symptoms}"> — <c:out value="${r.symptoms}"/></c:if>
            </div>
            <div class="rmeta">
                <span>
                  <fmt:formatDate value="${r.resvDate}" pattern="yyyy년 M월 d일"/>
                  <c:if test="${not empty r.resvTime}"> ${r.resvTime}</c:if>
                </span>
                <c:if test="${not empty r.hospitalAddr}">
                  <span><c:out value="${r.hospitalAddr}"/></span>
                </c:if>
                <span>반려동물: <c:out value="${r.petName}"/>
                  <c:if test="${not empty r.petSpecies}"> (<c:out value="${r.petSpecies}"/>)</c:if>
                </span>
            </div>
        </div>
        <div class="resv-right">
          <c:choose>
            <c:when test="${r.statusCd eq 'PENDING'}">
              <span class="badge-status badge-wait">예약신청</span>
            </c:when>
            <c:when test="${r.statusCd eq 'CONFIRMED'}">
              <span class="badge-status badge-ready">예약확정</span>
            </c:when>
            <c:when test="${r.statusCd eq 'DONE'}">
              <span class="badge-status badge-done">진료완료</span>
              <%-- 2026/07/13 장우철 — DONE + 미작성 시 리뷰 안내 --%>
              <c:if test="${r.reviewedYn ne 'Y'}">
                <span class="btn-sm" style="pointer-events:none;margin-top:6px;background:#2BAB82;color:#fff">리뷰 작성</span>
              </c:if>
              <c:if test="${r.reviewedYn eq 'Y'}">
                <span style="font-size:12px;color:#888;margin-top:6px">리뷰 완료</span>
              </c:if>
            </c:when>
            <c:otherwise>
              <span class="badge-status badge-cancel">취소</span>
            </c:otherwise>
          </c:choose>
          <span class="btn-sm" style="pointer-events:none">상세보기</span>
        </div>
      </a>
    </c:forEach>
</div>

</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
