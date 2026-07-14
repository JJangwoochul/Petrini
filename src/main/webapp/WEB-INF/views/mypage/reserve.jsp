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

<div class="mp-section active">
    <h2 class="mp-title">예약내역</h2>
    <p class="mp-desc">병원·숙소 예약 현황을 확인하고 상세를 볼 수 있습니다.</p>

    <c:if test="${param.error eq 'notfound'}">
      <p style="color:#B91C1C;font-size:14px;margin-bottom:12px">예약을 찾을 수 없습니다.</p>
    </c:if>

    <div class="order-filter" style="margin-bottom:20px">
        <a class="filter-btn ${statusFilter eq 'all' or empty statusFilter ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=all">전체</a>
        <a class="filter-btn ${statusFilter eq 'pending' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=pending">예약신청</a>
        <a class="filter-btn ${statusFilter eq 'confirmed' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=confirmed">확정</a>
        <a class="filter-btn ${statusFilter eq 'done' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=done">완료</a>
        <a class="filter-btn ${statusFilter eq 'cancel' ? 'on' : ''}"
           href="${contextPath}/mypage/reserve?status=cancel">취소</a>
    </div>

    <c:if test="${empty reservationList}">
      <div style="text-align:center;padding:48px 0;color:#999;font-size:14px">예약 내역이 없습니다.</div>
    </c:if>

    <c:forEach var="r" items="${reservationList}">
      <a href="${contextPath}/mypage/reserve/detail?resvId=${r.resvId}"
         class="resv-card" style="text-decoration:none;color:inherit;display:flex;cursor:pointer">

        <%-- 썸네일 --%>
        <c:choose>
          <c:when test="${r.resvType eq 'STAY'}">
            <img class="resv-thumb" src="https://placehold.co/88x88/E0F2FE/0284C7?text=숙소" alt="숙소">
          </c:when>
          <c:otherwise>
            <img class="resv-thumb" src="https://placehold.co/88x88/EAF7F2/2BAB82?text=병원" alt="병원">
          </c:otherwise>
        </c:choose>

        <div class="resv-info">
            <%-- 카테고리 --%>
            <c:choose>
              <c:when test="${r.resvType eq 'STAY'}"><span class="category">펫 숙소</span></c:when>
              <c:otherwise><span class="category">동물병원</span></c:otherwise>
            </c:choose>

            <%-- 장소명 --%>
            <div class="rname">
              <%-- <c:out value="${not empty r.hospitalName ? r.hospitalName : '-'}"/> --%>
              <c:if test="${r.resvType eq 'STAY' and not empty r.roomName}"> <c:out value="${r.stayName}"/> — <c:out value="${r.roomName}"/></c:if>
              <c:if test="${r.resvType eq 'HOSPITAL' and not empty r.hospitalName}"><c:out value="${r.hospitalName}"/></c:if>
            </div>

            <%-- 일정 --%>
            <div class="rmeta">
              <c:choose>
                <c:when test="${r.resvType eq 'STAY'}">
                  <span>
                    <fmt:formatDate value="${r.checkinDate}" pattern="yyyy.MM.dd"/>
                    ~ <fmt:formatDate value="${r.checkoutDate}" pattern="MM.dd"/>
                    · ${r.nightCnt}박
                  </span>
                  <c:if test="${not empty r.totalAmount}">
                    <span><fmt:formatNumber value="${r.totalAmount}" pattern="#,###"/>원</span>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <span>
                    <fmt:formatDate value="${r.resvDate}" pattern="yyyy년 M월 d일"/>
                    <c:if test="${not empty r.resvTime}"> ${r.resvTime}</c:if>
                  </span>
                </c:otherwise>
              </c:choose>
              <c:if test="${not empty r.hospitalAddr}">
                <span><c:out value="${r.hospitalAddr}"/></span>
              </c:if>
              <span>반려동물: <c:out value="${r.petName}"/>
                <c:if test="${not empty r.petSpecies}"> (<c:out value="${r.petSpecies}"/>)</c:if>
              </span>
            </div>
        </div>

        <%-- 상태 배지 --%>
        <div class="resv-right">
          <c:choose>
            <c:when test="${r.statusCd eq 'PENDING'}">
              <span class="badge-status badge-wait">예약신청</span>
            </c:when>
            <c:when test="${r.statusCd eq 'CONFIRMED'}">
              <span class="badge-status badge-ready">예약확정</span>
            </c:when>
            <c:when test="${r.statusCd eq 'DONE'}">
              <span class="badge-status badge-done">이용완료</span>
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

</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
