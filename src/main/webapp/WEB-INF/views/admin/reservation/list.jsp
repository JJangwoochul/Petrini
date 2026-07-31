<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 2026/07/31 장우철 — 관리자 숙소 예약 목록 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="reservation-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
  <div class="adm-page-head">
    <div class="adm-page-head-left">
      <h1 class="adm-page-title">숙소 예약 관리</h1>
      <p class="adm-page-desc">숙소 예약을 조회하고, 필요 시 전액 환불 취소를 처리하세요.</p>
    </div>
  </div>

  <c:if test="${not empty successMsg}">
    <div style="background:#ECFDF5;border:1px solid #BBF7D0;color:#166534;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${successMsg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
  </c:if>

  <div style="display:flex;gap:0;border-bottom:2px solid #E4E6ED;margin-bottom:16px;flex-wrap:wrap">
    <a href="${contextPath}/admin/reservation/list?status=ALL&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'ALL' ? '700' : '600'};color:${status eq 'ALL' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'ALL' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      전체 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.ALL}</span>
    </a>
    <a href="${contextPath}/admin/reservation/list?status=PENDING&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'PENDING' ? '700' : '600'};color:${status eq 'PENDING' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'PENDING' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      결제대기 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.PENDING}</span>
    </a>
    <a href="${contextPath}/admin/reservation/list?status=CONFIRMED&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'CONFIRMED' ? '700' : '600'};color:${status eq 'CONFIRMED' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'CONFIRMED' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      확정 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.CONFIRMED}</span>
    </a>
    <a href="${contextPath}/admin/reservation/list?status=CHECKIN&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'CHECKIN' ? '700' : '600'};color:${status eq 'CHECKIN' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'CHECKIN' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      체크인 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.CHECKIN}</span>
    </a>
    <a href="${contextPath}/admin/reservation/list?status=CHECKOUT&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'CHECKOUT' ? '700' : '600'};color:${status eq 'CHECKOUT' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'CHECKOUT' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      체크아웃 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.CHECKOUT}</span>
    </a>
    <a href="${contextPath}/admin/reservation/list?status=DONE&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'DONE' ? '700' : '600'};color:${status eq 'DONE' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'DONE' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      완료 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.DONE}</span>
    </a>
    <a href="${contextPath}/admin/reservation/list?status=CANCEL&amp;keyword=${keyword}"
       style="padding:10px 14px;font-size:13px;font-weight:${status eq 'CANCEL' ? '700' : '600'};color:${status eq 'CANCEL' ? '#3B5BDB' : '#999'};text-decoration:none;border-bottom:2px solid ${status eq 'CANCEL' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
      취소 <span style="background:#F3F4F6;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.CANCEL}</span>
    </a>
  </div>

  <form method="get" action="${contextPath}/admin/reservation/list" style="margin-bottom:16px;display:flex;gap:8px">
    <input type="hidden" name="status" value="${status}">
    <input type="text" name="keyword" value="${keyword}" placeholder="예약번호·회원명·숙소명"
           style="flex:1;max-width:320px;padding:10px 12px;border:1px solid #E4E6ED;border-radius:8px;font-size:14px">
    <button type="submit" class="adm-filter-btn" style="cursor:pointer">검색</button>
  </form>

  <div class="adm-card" style="overflow:auto">
    <table class="adm-table" style="width:100%;border-collapse:collapse;font-size:13px">
      <thead>
        <tr style="background:#FAFBFC;text-align:left">
          <th style="padding:12px">예약번호</th>
          <th style="padding:12px">숙소</th>
          <th style="padding:12px">회원</th>
          <th style="padding:12px">체크인~아웃</th>
          <th style="padding:12px">금액</th>
          <th style="padding:12px">상태</th>
          <th style="padding:12px"></th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${empty list}">
          <tr><td colspan="7" style="padding:32px;text-align:center;color:#999">예약이 없습니다.</td></tr>
        </c:if>
        <c:forEach var="r" items="${list}">
          <tr style="border-top:1px solid #EEF0F4">
            <td style="padding:12px"><c:out value="${r.resvNo}"/></td>
            <td style="padding:12px">
              <c:out value="${r.stayName}"/>
              <c:if test="${not empty r.roomName}"><div style="font-size:11px;color:#888"><c:out value="${r.roomName}"/></div></c:if>
            </td>
            <td style="padding:12px"><c:out value="${r.memberName}"/></td>
            <td style="padding:12px">
              <fmt:formatDate value="${r.checkinDate}" pattern="yyyy.MM.dd"/>
              ~
              <fmt:formatDate value="${r.checkoutDate}" pattern="MM.dd"/>
            </td>
            <td style="padding:12px">
              <c:if test="${not empty r.totalAmount}"><fmt:formatNumber value="${r.totalAmount}" pattern="#,###"/>원</c:if>
            </td>
            <td style="padding:12px"><c:out value="${r.statusCd}"/></td>
            <td style="padding:12px">
              <a href="${contextPath}/admin/reservation/detail?resvId=${r.resvId}" style="color:#3B5BDB;font-weight:600">상세</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
