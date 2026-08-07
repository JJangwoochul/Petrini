<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 2026/08/04 장우철 — 사업자 환불신청 상세 (승인/거절/회수완료) --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage" value="refunds" />
<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">환불 신청 상세</h1>
    <p class="biz-page-desc">
      <a href="${contextPath}/biz/store/refunds?statusCd=${refund.returnStatusCd == 'RETURNING' ? 'RETURNING' : 'REQUESTED'}"
         style="color:#64748B;">← 목록</a>
    </p>
  </div>

  <c:if test="${not empty msg}">
    <div style="background:#ECFDF5;border:1px solid #A7F3D0;color:#065F46;padding:12px;border-radius:8px;margin-bottom:12px;">${msg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div style="background:#FFF1F2;border:1px solid #FECDD3;color:#BE123C;padding:12px;border-radius:8px;margin-bottom:12px;">${errorMsg}</div>
  </c:if>

  <div class="biz-card" style="margin-bottom:16px;">
    <div class="biz-card-head"><span>주문 정보</span></div>
    <div style="padding:16px 20px;">
      <div class="order-info-row"><span>주문번호</span><span>#${refund.orderNo}</span></div>
      <div class="order-info-row"><span>주문상태</span><span>${refund.orderStatus}</span></div>
      <div class="order-info-row"><span>주문일</span><span><fmt:formatDate value="${refund.orderDate}" pattern="yyyy-MM-dd HH:mm"/></span></div>
      <div class="order-info-row"><span>구매자</span><span>${refund.buyerName}</span></div>
      <div class="order-info-row"><span>연락처</span><span>${refund.buyerPhone}</span></div>
      <div class="order-info-row"><span>출고송장</span><span>${empty refund.trackingNo ? '-' : refund.courierName} ${refund.trackingNo}</span></div>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px;">
    <div class="biz-card-head"><span>상품</span></div>
    <div style="padding:16px 20px;">
      <div class="order-info-row"><span>상품명</span><span>${refund.productName}</span></div>
      <div class="order-info-row"><span>옵션</span>
        <span>
          <c:if test="${not empty refund.optionColor}">${refund.optionColor}</c:if>
          <c:if test="${not empty refund.optionSize}"> / ${refund.optionSize}</c:if>
          · 수량 ${refund.qty}
        </span>
      </div>
      <div class="order-info-row"><span>상품금액</span><span><fmt:formatNumber value="${refund.totalPrice}" pattern="#,###"/>원</span></div>
      <div class="order-info-row"><span>반품택배비(유저)</span><span><fmt:formatNumber value="${refund.returnFeeAmount}" pattern="#,###"/>원</span></div>
      <c:set var="expectRefund" value="${refund.totalPrice - refund.returnFeeAmount}" />
      <c:if test="${expectRefund < 0}"><c:set var="expectRefund" value="0" /></c:if>
      <div class="order-info-row"><span>예상 환불액</span>
        <span style="font-weight:800;color:#E2445C;">
          <c:choose>
            <c:when test="${not empty refund.refundAmount}"><fmt:formatNumber value="${refund.refundAmount}" pattern="#,###"/>원</c:when>
            <c:otherwise><fmt:formatNumber value="${expectRefund}" pattern="#,###"/>원</c:otherwise>
          </c:choose>
        </span>
      </div>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px;">
    <div class="biz-card-head"><span>환불 신청 내용</span></div>
    <div style="padding:16px 20px;">
      <div class="order-info-row"><span>유형</span>
        <span>
          <c:choose>
            <c:when test="${refund.returnReasonCd == 'DEFECT'}">환불 (상품이상)</c:when>
            <c:otherwise>환불 (단순변심)</c:otherwise>
          </c:choose>
        </span>
      </div>
      <div class="order-info-row"><span>신청일</span><span><fmt:formatDate value="${refund.returnRequestedAt}" pattern="yyyy-MM-dd HH:mm"/></span></div>
      <div style="margin-top:12px;">
        <div style="font-size:12px;color:#94A3B8;margin-bottom:6px;">내용</div>
        <div style="white-space:pre-wrap;background:#F8FAFC;border-radius:8px;padding:12px;font-size:14px;">${refund.claimReason}</div>
      </div>
      <c:if test="${not empty refund.photoUrls}">
        <div style="margin-top:14px;display:flex;gap:8px;flex-wrap:wrap;">
          <c:forEach var="url" items="${refund.photoUrls}">
            <a href="${url}" target="_blank"><img src="${url}" alt="증빙" style="width:96px;height:96px;object-fit:cover;border-radius:8px;border:1px solid #E2E8E4;"></a>
          </c:forEach>
        </div>
      </c:if>
      <c:if test="${not empty refund.returnRejectReason}">
        <div style="margin-top:12px;color:#BE123C;">거절 사유: ${refund.returnRejectReason}</div>
      </c:if>
    </div>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span>처리</span></div>
    <div style="padding:16px 20px;">
      <div style="background:#F8FAFC;border-radius:8px;padding:12px;font-size:13px;color:#475569;line-height:1.6;margin-bottom:16px;">
        배송중인 건이어도 상품은 유저 수령 후 반송하는 방식입니다.<br>
        승인 → 환불진행 → 반송 상품 수령 확인 후 <strong>회수완료</strong>를 누르면 환불됩니다.<br>
        환불액 = 상품금액 − 반품택배비(유저 부담).
      </div>

      <c:if test="${refund.returnStatusCd == 'REQUESTED'}">
        <div style="display:flex;gap:8px;flex-wrap:wrap;align-items:flex-start;">
          <form method="post" action="${contextPath}/biz/store/refunds/approve"
                onsubmit="return confirm('승인하여 환불진행으로 바꿀까요?');">
            <%-- 2026/08/07 장우철 CSRF --%>
            <input type="hidden" name="_csrf" value="${_csrf}">
            <input type="hidden" name="orderItemId" value="${refund.orderItemId}">
            <button type="submit" class="biz-btn primary">승인 (환불진행)</button>
          </form>
          <form method="post" action="${contextPath}/biz/store/refunds/reject"
                onsubmit="return confirm('거절할까요?');" style="display:flex;gap:8px;align-items:center;flex-wrap:wrap;">
            <%-- 2026/08/07 장우철 CSRF --%>
            <input type="hidden" name="_csrf" value="${_csrf}">
            <input type="hidden" name="orderItemId" value="${refund.orderItemId}">
            <input type="text" name="rejectReason" required placeholder="거절 사유" maxlength="500"
                   style="min-width:220px;padding:8px 10px;border:1px solid #E2E8E4;border-radius:6px;">
            <button type="submit" class="biz-btn" style="background:#E2445C;color:#fff;border-color:#E2445C;">거절</button>
          </form>
        </div>
      </c:if>

      <c:if test="${refund.returnStatusCd == 'RETURNING'}">
        <form method="post" action="${contextPath}/biz/store/refunds/complete"
              onsubmit="return confirm('회수완료 처리하고 토스 환불을 진행할까요?\n예상 환불액: ${expectRefund}원');">
          <%-- 2026/08/07 장우철 CSRF --%>
          <input type="hidden" name="_csrf" value="${_csrf}">
          <input type="hidden" name="orderItemId" value="${refund.orderItemId}">
          <button type="submit" class="biz-btn primary">회수완료 (환불 실행)</button>
        </form>
      </c:if>

      <c:if test="${refund.returnStatusCd == 'DONE'}">
        <span class="bs-badge bs-done">환불 완료</span>
        <span style="margin-left:8px;"><fmt:formatDate value="${refund.returnDoneAt}" pattern="yyyy-MM-dd HH:mm"/></span>
      </c:if>
      <c:if test="${refund.returnStatusCd == 'REJECTED'}">
        <span class="bs-badge bs-cancel">거절됨</span>
      </c:if>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
