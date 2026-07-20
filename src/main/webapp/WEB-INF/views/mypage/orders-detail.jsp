<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="orders" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<%-- 지윤 26.07.20 수정: 밋밋했던 rd-card 스타일 -> 섹션별 라벨/아이콘/여백 보강한 od- 전용 스타일로 리디자인
     결제내역/배송지/배송정보까지 자세히 보여주는 읽기전용 페이지. 리뷰작성은 여기 없음 (목록에서 모달로 처리) --%>
<style>
.od-head { display:flex; align-items:center; justify-content:space-between; margin-bottom:20px; }
.od-head-status { display:flex; align-items:center; gap:12px; }
.od-section { background:#fff; border:1px solid #E2E8E4; border-radius:14px; padding:22px 24px; margin-bottom:16px; }
.od-section-title { font-size:14px; font-weight:800; color:var(--text-main); margin:0 0 14px; display:flex; align-items:center; gap:6px; }
.od-row { display:flex; justify-content:space-between; gap:16px; padding:10px 0; border-bottom:1px solid #F5F6F4; font-size:14px; }
.od-row:last-child { border-bottom:none; }
.od-row .label { color:var(--text-muted); flex-shrink:0; min-width:90px; }
.od-row .value { color:var(--text-main); font-weight:600; text-align:right; }
.od-row.total .value { color:var(--primary); font-size:17px; font-weight:800; }
.od-item { display:flex; align-items:center; gap:14px; padding:14px 0; border-bottom:1px solid #F5F6F4; }
.od-item:last-child { border-bottom:none; }
.od-item img { width:60px; height:60px; border-radius:10px; object-fit:cover; flex-shrink:0; background:#F5F6F4; }
.od-item .name { font-weight:700; font-size:14px; color:var(--text-main); }
.od-item .meta { font-size:13px; color:var(--text-muted); margin-top:4px; }
.od-item .price { margin-left:auto; font-weight:700; color:var(--text-main); }
.od-tracking { display:flex; align-items:center; gap:10px; background:var(--primary-light); border-radius:10px; padding:14px 16px; font-size:14px; }
.od-tracking b { color:var(--primary); }
.od-empty-tracking { color:var(--text-muted); font-size:13px; }
</style>

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<div class="mp-section active">
  <div class="od-head">
    <div>
      <h2 class="mp-title" style="margin-bottom:4px">주문 상세</h2>
      <p class="mp-desc" style="margin:0">주문번호 <strong>#${order.orderNo}</strong> · ${order.orderDate}</p>
    </div>
    <div class="od-head-status">
      <c:choose>
        <c:when test="${order.orderStatus == 'PAID'}"><span class="badge-status badge-ready">결제완료</span></c:when>
        <c:when test="${order.orderStatus == 'READY'}"><span class="badge-status badge-ready">배송준비</span></c:when>
        <c:when test="${order.orderStatus == 'SHIPPING'}"><span class="badge-status badge-ready">배송중</span></c:when>
        <c:when test="${order.orderStatus == 'DONE'}"><span class="badge-status badge-done">배송완료</span></c:when>
        <c:when test="${order.orderStatus == 'CANCEL'}"><span class="badge-status badge-cancel">취소완료</span></c:when>
      </c:choose>
    </div>
  </div>

  <%-- 지윤 26.07.20 추가: 배송정보(택배사/송장번호) - 기존엔 아예 없던 섹션. TB_ORDER_DELIVERY 미등록이면 안내문구만 --%>
  <div class="od-section">
    <p class="od-section-title">🚚 배송정보</p>
    <c:choose>
      <c:when test="${not empty order.courierName}">
        <div class="od-tracking">
          <span><b>${order.courierName}</b></span>
          <span>송장번호 ${order.trackingNo}</span>
        </div>
      </c:when>
      <c:otherwise>
        <p class="od-empty-tracking">아직 등록된 배송정보가 없습니다.</p>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="od-section">
    <p class="od-section-title">💳 결제 내역</p>
    <div class="od-row"><span class="label">총 주문금액</span><span class="value"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>원</span></div>
    <div class="od-row"><span class="label">배송비</span><span class="value"><fmt:formatNumber value="${order.deliveryFee}" pattern="#,###"/>원</span></div>
    <c:if test="${not empty order.discountAmount && order.discountAmount > 0}">
      <div class="od-row"><span class="label">할인금액</span><span class="value">-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###"/>원</span></div>
    </c:if>
    <c:if test="${not empty order.pointUsed && order.pointUsed > 0}">
      <div class="od-row"><span class="label">포인트사용</span><span class="value">-<fmt:formatNumber value="${order.pointUsed}" pattern="#,###"/>원</span></div>
    </c:if>
    <div class="od-row total"><span class="label">총 결제금액</span><span class="value"><fmt:formatNumber value="${order.payAmount}" pattern="#,###"/>원</span></div>
  </div>

  <div class="od-section">
    <p class="od-section-title">📦 주문 상품 (${fn:length(order.itemList)}건)</p>
    <c:forEach var="it" items="${order.itemList}">
      <div class="od-item">
        <c:choose>
          <c:when test="${not empty it.thumbnailUrl}">
            <img src="${fn:startsWith(it.thumbnailUrl, 'http') ? it.thumbnailUrl : contextPath.concat('/upload/').concat(it.thumbnailUrl)}"
                 alt="${it.productName}" onerror="this.src='https://placehold.co/60x60/EAF7F2/2BAB82?text=IMG'">
          </c:when>
          <c:otherwise>
            <img src="https://placehold.co/60x60/EAF7F2/2BAB82?text=IMG" alt="${it.productName}">
          </c:otherwise>
        </c:choose>
        <div>
          <div class="name">${it.productName}</div>
          <div class="meta">
            수량 ${it.qty}개
            <c:if test="${not empty it.optionSize}">
              · 옵션: <c:if test="${not empty it.optionColor && it.optionColor != '기본'}">${it.optionColor} / </c:if>${it.optionSize}
            </c:if>
          </div>
        </div>
        <span class="price"><fmt:formatNumber value="${it.totalPrice}" pattern="#,###"/>원</span>
      </div>
    </c:forEach>
  </div>

  <div class="od-section">
    <p class="od-section-title">🏠 배송지 정보</p>
    <div class="od-row"><span class="label">받는분</span><span class="value">${order.recvName}</span></div>
    <div class="od-row"><span class="label">연락처</span><span class="value">${order.recvPhone}</span></div>
    <div class="od-row"><span class="label">주소</span><span class="value">(${order.zipCode}) ${order.addr1} ${order.addr2}</span></div>
  </div>

  <button type="button" class="btn-sm" onclick="location.href='${contextPath}/mypage/orders'">← 목록으로</button>
</div>

</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>