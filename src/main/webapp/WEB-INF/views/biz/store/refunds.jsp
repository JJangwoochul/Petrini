<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 2026/08/04 장우철 — 사업자 환불신청 처리 목록 --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage" value="refunds" />
<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">환불 신청</h1>
    <p class="biz-page-desc">대기·진행 중인 환불을 승인·거절·회수완료 처리합니다.</p>
  </div>

  <c:if test="${not empty msg}">
    <div style="background:#ECFDF5;border:1px solid #A7F3D0;color:#065F46;padding:12px;border-radius:8px;margin-bottom:12px;">${msg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div style="background:#FFF1F2;border:1px solid #FECDD3;color:#BE123C;padding:12px;border-radius:8px;margin-bottom:12px;">${errorMsg}</div>
  </c:if>

  <div class="biz-card">
    <div style="padding:20px 20px 0">
      <div class="biz-tabs">
        <a href="${contextPath}/biz/store/refunds?statusCd=REQUESTED"
           class="biz-tab ${selectedStatusCd == 'REQUESTED' ? 'active' : ''}">
          신청대기<span class="biz-tab-count">${requestedCount}</span>
        </a>
        <a href="${contextPath}/biz/store/refunds?statusCd=RETURNING"
           class="biz-tab ${selectedStatusCd == 'RETURNING' ? 'active' : ''}">
          환불진행<span class="biz-tab-count">${returningCount}</span>
        </a>
      </div>
    </div>

    <table class="biz-table">
      <thead>
        <tr>
          <th>신청일</th>
          <th>주문번호</th>
          <th>구매자</th>
          <th>상품</th>
          <th>유형</th>
          <th>상품금액</th>
          <th>상태</th>
          <th>관리</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty returnList}">
            <tr><td colspan="8" style="text-align:center;color:#999;padding:24px 0">해당하는 환불 신청이 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="r" items="${returnList}">
              <tr>
                <td><fmt:formatDate value="${r.returnRequestedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>#${r.orderNo}</td>
                <td>${r.buyerName}</td>
                <td>${r.productName}</td>
                <td>
                  <c:choose>
                    <c:when test="${r.returnReasonCd == 'DEFECT'}">상품이상</c:when>
                    <c:otherwise>단순변심</c:otherwise>
                  </c:choose>
                </td>
                <td><fmt:formatNumber value="${r.totalPrice}" pattern="#,###"/>원</td>
                <td>
                  <c:choose>
                    <c:when test="${r.returnStatusCd == 'REQUESTED'}"><span class="bs-badge bs-wait">신청대기</span></c:when>
                    <c:when test="${r.returnStatusCd == 'RETURNING'}"><span class="bs-badge bs-prep">환불진행</span></c:when>
                    <c:otherwise>${r.returnStatusCd}</c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <a class="biz-btn" style="text-decoration:none"
                     href="${contextPath}/biz/store/refunds/detail?orderItemId=${r.orderItemId}">상세</a>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
