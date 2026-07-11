<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="reserve" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<style>
.rd-card{background:#fff;border:1px solid #E2E8E4;border-radius:12px;padding:24px;margin-bottom:16px}
.rd-row{display:flex;justify-content:space-between;gap:16px;padding:12px 0;border-bottom:1px solid #F5F6F4;font-size:14px}
.rd-row:last-child{border-bottom:none}
.rd-row span:first-child{color:#888;flex-shrink:0;min-width:90px}
.rd-row span:last-child{color:#1A1A2E;font-weight:600;text-align:right}
.rd-reason{background:#FEF2F2;border-radius:8px;padding:14px 16px;margin-top:8px;font-size:13px;color:#991B1B;line-height:1.6}
</style>

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- 2026/07/11 장우철 — 마이페이지 예약 상세 (2차) --%>
<div class="mp-section active">
  <h2 class="mp-title">예약 상세</h2>
  <p class="mp-desc">예약번호 <strong><c:out value="${reservation.resvNo}"/></strong></p>

  <div class="rd-card">
    <div class="rd-row">
      <span>상태</span>
      <span>
        <c:choose>
          <c:when test="${reservation.statusCd eq 'PENDING'}"><span class="badge-status badge-wait">예약신청</span></c:when>
          <c:when test="${reservation.statusCd eq 'CONFIRMED'}"><span class="badge-status badge-ready">예약확정</span></c:when>
          <c:when test="${reservation.statusCd eq 'DONE'}"><span class="badge-status badge-done">진료완료</span></c:when>
          <c:otherwise><span class="badge-status badge-cancel">취소</span></c:otherwise>
        </c:choose>
      </span>
    </div>
    <div class="rd-row">
      <span>병원</span>
      <span><c:out value="${not empty reservation.hospitalName ? reservation.hospitalName : '-'}"/></span>
    </div>
    <div class="rd-row">
      <span>주소</span>
      <span><c:out value="${not empty reservation.hospitalAddr ? reservation.hospitalAddr : '-'}"/></span>
    </div>
    <div class="rd-row">
      <span>예약일시</span>
      <span>
        <fmt:formatDate value="${reservation.resvDate}" pattern="yyyy-MM-dd"/>
        <c:if test="${not empty reservation.resvTime}"> ${reservation.resvTime}</c:if>
      </span>
    </div>
    <div class="rd-row">
      <span>반려동물</span>
      <span>
        <c:out value="${reservation.petName}"/>
        <c:if test="${not empty reservation.petSpecies}"> (<c:out value="${reservation.petSpecies}"/>
          <c:if test="${not empty reservation.petBreed}"> / <c:out value="${reservation.petBreed}"/></c:if>)</c:if>
      </span>
    </div>
    <div class="rd-row">
      <span>증상</span>
      <span><c:out value="${not empty reservation.symptoms ? reservation.symptoms : '-'}"/></span>
    </div>
    <div class="rd-row">
      <span>요청사항</span>
      <span><c:out value="${not empty reservation.requestMemo ? reservation.requestMemo : '-'}"/></span>
    </div>
    <c:if test="${reservation.statusCd eq 'CANCEL' or reservation.statusCd eq 'REJECTED'}">
      <div class="rd-row" style="display:block;border-bottom:none;padding-bottom:0">
        <span style="display:block;margin-bottom:6px">취소 사유</span>
        <div class="rd-reason">
          <c:out value="${not empty reservation.rejectReason ? reservation.rejectReason : '사유가 등록되지 않았습니다.'}"/>
        </div>
      </div>
    </c:if>
  </div>

  <button type="button" class="btn-sm" onclick="location.href='${contextPath}/mypage/reserve'">← 목록으로</button>
</div>

</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
