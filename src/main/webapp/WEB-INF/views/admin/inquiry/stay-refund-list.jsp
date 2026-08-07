<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 2026/07/31 장우철 — 관리자 숙소 환불신청 목록 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage" value="stay-refund" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
  <div class="adm-page-head">
    <div class="adm-page-head-left">
      <h1 class="adm-page-title">숙소 환불 신청</h1>
      <p class="adm-page-desc">체크인 이후 1:1 환불 신청을 승인·거절합니다.</p>
    </div>
  </div>

  <c:if test="${not empty successMsg}">
    <div style="background:#ECFDF5;border:1px solid #BBF7D0;color:#166534;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${successMsg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
  </c:if>

  <div style="display:flex;gap:8px;margin-bottom:16px">
    <a href="${contextPath}/admin/inquiry/stay-refund?status=WAIT" style="font-weight:${status eq 'WAIT' ? '700' : '500'};color:${status eq 'WAIT' ? '#3B5BDB' : '#666'}">대기</a>
    <a href="${contextPath}/admin/inquiry/stay-refund?status=DONE" style="font-weight:${status eq 'DONE' ? '700' : '500'};color:${status eq 'DONE' ? '#3B5BDB' : '#666'}">처리완료</a>
    <a href="${contextPath}/admin/inquiry/stay-refund?status=ALL" style="font-weight:${status eq 'ALL' ? '700' : '500'};color:${status eq 'ALL' ? '#3B5BDB' : '#666'}">전체</a>
  </div>

  <div class="adm-card" style="overflow:auto">
    <table style="width:100%;border-collapse:collapse;font-size:13px">
      <thead>
        <tr style="background:#FAFBFC;text-align:left">
          <th style="padding:12px">신청일</th>
          <th style="padding:12px">예약</th>
          <th style="padding:12px">숙소</th>
          <th style="padding:12px">회원</th>
          <th style="padding:12px">예약상태</th>
          <th style="padding:12px">문의상태</th>
          <th style="padding:12px"></th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${empty list}">
          <tr><td colspan="7" style="padding:28px;text-align:center;color:#999">신청이 없습니다.</td></tr>
        </c:if>
        <c:forEach var="i" items="${list}">
          <tr style="border-top:1px solid #EEF0F4">
            <td style="padding:12px"><fmt:formatDate value="${i.regDate}" pattern="yyyy.MM.dd HH:mm"/></td>
            <td style="padding:12px"><c:out value="${i.resvNo}"/></td>
            <td style="padding:12px"><c:out value="${i.stayName}"/></td>
            <td style="padding:12px"><c:out value="${i.memberName}"/></td>
            <td style="padding:12px"><c:out value="${i.resvStatusCd}"/></td>
            <td style="padding:12px">
              <c:choose>
                <c:when test="${i.statusCd eq 'WAIT'}">대기</c:when>
                <c:when test="${i.statusCd eq 'APPROVED'}">승인</c:when>
                <c:when test="${i.statusCd eq 'REJECTED'}">거절</c:when>
                <c:when test="${i.statusCd eq 'DONE'}">완료(레거시)</c:when>
                <c:otherwise><c:out value="${i.statusCd}"/></c:otherwise>
              </c:choose>
            </td>
            <td style="padding:12px">
              <a href="${contextPath}/admin/inquiry/stay-refund/detail?inquiryId=${i.inquiryId}" style="color:#3B5BDB;font-weight:600">상세</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
