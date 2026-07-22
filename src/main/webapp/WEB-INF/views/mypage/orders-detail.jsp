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
.od-tracking { display:flex; align-items:center; gap:10px; background:var(--primary-light); border-radius:10px; padding:14px 16px; font-size:14px; margin-bottom:18px; }
.od-tracking b { color:var(--primary); }
.od-empty-tracking { color:var(--text-muted); font-size:13px; }
.od-stepper { display:flex; align-items:flex-start; padding-top:6px; }
.od-step { display:flex; flex-direction:column; align-items:center; width:25%; }
.od-step-dot { width:14px; height:14px; border-radius:50%; border:1.5px solid #D8DEDA; background:#fff; }
.od-step-dot.done { background:var(--primary); border-color:var(--primary); }
.od-step-dot.current { box-shadow:0 0 0 3px var(--primary-light); }
.od-step-label { font-size:13px; font-weight:600; margin:8px 0 2px; text-align:center; color:var(--text-muted); }
.od-step-label.done { color:var(--text-main); font-weight:700; }
.od-step-label.current { color:var(--primary); }
.od-step-time { font-size:11px; color:var(--text-muted); margin:0; text-align:center; }
.od-step-line { flex:1; height:1.5px; background:#E2E8E4; margin-top:7px; }
.od-step-line.done { background:var(--primary); }
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

  <%-- 지윤 26.07.21 추가: 주문정보 섹션 - 주문번호/주문일자/주문자/주문처리상태 한눈에 정리 --%>
  <div class="od-section">
    <p class="od-section-title">📋 주문정보</p>
    <div class="od-row"><span class="label">주문번호</span><span class="value">#${order.orderNo}</span></div>
    <div class="od-row"><span class="label">주문일자</span><span class="value">${order.orderDate}</span></div>
    <div class="od-row"><span class="label">주문자</span><span class="value">${order.ordererName}</span></div>
    <div class="od-row">
      <span class="label">주문처리상태</span>
      <span class="value">
        <c:choose>
          <c:when test="${order.orderStatus == 'PAID'}">결제완료</c:when>
          <c:when test="${order.orderStatus == 'READY'}">배송준비</c:when>
          <c:when test="${order.orderStatus == 'SHIPPING'}">배송중</c:when>
          <c:when test="${order.orderStatus == 'DONE'}">배송완료</c:when>
          <c:when test="${order.orderStatus == 'CANCEL'}">취소완료</c:when>
        </c:choose>
      </span>
    </div>
  </div>

  <%-- 지윤 26.07.20 추가: 배송정보(택배사/송장번호) - 기존엔 아예 없던 섹션. TB_ORDER_DELIVERY 미등록이면 안내문구만 --%>
  <div class="od-section">
    <p class="od-section-title">🚚 배송정보</p>
    <c:if test="${not empty order.courierName}">
      <div class="od-tracking">
        <span><b>${order.courierName}</b></span>
        <span>송장번호 ${order.trackingNo}</span>
      </div>
    </c:if>

    <c:choose>
      <c:when test="${not empty order.deliveredAt}"><c:set var="curStep" value="4"/></c:when>
      <c:when test="${not empty order.shippingAt}"><c:set var="curStep" value="3"/></c:when>
      <c:when test="${not empty order.readyAt}"><c:set var="curStep" value="2"/></c:when>
      <c:otherwise><c:set var="curStep" value="1"/></c:otherwise>
    </c:choose>

    <div class="od-stepper">
      <div class="od-step">
        <div class="od-step-dot done"></div>
        <p class="od-step-label done">결제완료</p>
        <p class="od-step-time">${order.orderDate}</p>
      </div>
      <div class="od-step-line ${curStep >= 2 ? 'done' : ''}"></div>

      <div class="od-step">
        <div class="od-step-dot ${curStep >= 2 ? 'done' : ''} ${curStep == 2 ? 'current' : ''}"></div>
        <p class="od-step-label ${curStep >= 2 ? 'done' : ''} ${curStep == 2 ? 'current' : ''}">배송준비</p>
        <p class="od-step-time"><fmt:formatDate value="${order.readyAt}" pattern="yyyy.MM.dd HH:mm"/></p>
      </div>
      <div class="od-step-line ${curStep >= 3 ? 'done' : ''}"></div>

      <div class="od-step">
        <div class="od-step-dot ${curStep >= 3 ? 'done' : ''} ${curStep == 3 ? 'current' : ''}"></div>
        <p class="od-step-label ${curStep >= 3 ? 'done' : ''} ${curStep == 3 ? 'current' : ''}">배송중</p>
        <p class="od-step-time"><fmt:formatDate value="${order.shippingAt}" pattern="yyyy.MM.dd HH:mm"/></p>
      </div>
      <div class="od-step-line ${curStep >= 4 ? 'done' : ''}"></div>

      <div class="od-step">
        <div class="od-step-dot ${curStep >= 4 ? 'done' : ''}"></div>
        <p class="od-step-label ${curStep >= 4 ? 'done' : ''}">배송완료</p>
        <p class="od-step-time">${curStep < 4 ? '예정' : ''}<fmt:formatDate value="${order.deliveredAt}" pattern="yyyy.MM.dd HH:mm"/></p>
      </div>
    </div>
  </div>

  <div class="od-section">
    <p class="od-section-title">💳 결제 내역</p>
    <div class="od-row"><span class="label">총 주문금액</span><span class="value"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>원</span></div>
    <div class="od-row"><span class="label">배송비</span><span class="value"><fmt:formatNumber value="${order.deliveryFee}" pattern="#,###"/>원</span></div>
    <c:set var="couponAmt" value="${empty order.discountAmount ? 0 : order.discountAmount}" />
    <c:set var="pointAmt" value="${empty order.pointUsed ? 0 : order.pointUsed}" />
    <c:set var="totalDiscAmt" value="${couponAmt + pointAmt}" />
    <div class="od-row"><span class="label">쿠폰사용</span><span class="value">${couponAmt > 0 ? '-' : ''}<fmt:formatNumber value="${couponAmt}" pattern="#,###"/>원</span></div>
    <div class="od-row"><span class="label">포인트사용</span><span class="value">${pointAmt > 0 ? '-' : ''}<fmt:formatNumber value="${pointAmt}" pattern="#,###"/>원</span></div>
    <div class="od-row"><span class="label">총 할인금액</span><span class="value">${totalDiscAmt > 0 ? '-' : ''}<fmt:formatNumber value="${totalDiscAmt}" pattern="#,###"/>원</span></div>
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
    <div class="od-row"><span class="label">배송메시지</span><span class="value">${empty order.deliveryMemo ? '-' : order.deliveryMemo}</span></div>
  </div>

  <%-- 지윤 26.07.22 추가: 취소신청 상태 안내 배너 (신청 이력 있을 때만) --%>
  <c:if test="${not empty order.claimStatus}">
    <div class="od-section" style="border-color:#F0AD4E;">
      <p class="od-section-title">🚫 취소 신청 내역</p>
      <div class="od-row">
        <span class="label">처리상태</span>
        <span class="value">
          <c:choose>
            <c:when test="${order.claimStatus == 'PENDING'}">사업자 확인중</c:when>
            <c:when test="${order.claimStatus == 'DONE'}">취소완료 (환불 <fmt:formatNumber value="${order.refundAmount}" pattern="#,###"/>원)</c:when>
            <c:when test="${order.claimStatus == 'REJECTED'}">취소 반려됨</c:when>
          </c:choose>
        </span>
      </div>
      <div class="od-row"><span class="label">신청사유</span><span class="value">${order.cancelReason}</span></div>
      <div class="od-row"><span class="label">신청일시</span><span class="value"><fmt:formatDate value="${order.requestedAt}" pattern="yyyy.MM.dd HH:mm"/></span></div>
    </div>
  </c:if>

  <div style="display:flex; justify-content:space-between; align-items:center;">
    <button type="button" class="btn-sm" onclick="location.href='${contextPath}/mypage/orders'">← 목록으로</button>

    <%-- 지윤 26.07.22 추가: 결제완료 상태 + 아직 취소신청 안 한 주문만 버튼 노출 --%>
    <c:if test="${order.orderStatus == 'PAID' && empty order.claimStatus}">
      <button type="button" class="btn-sm" style="background:#fff;border:1px solid #E2445C;color:#E2445C;" onclick="openCancelModal()">주문취소</button>
    </c:if>
  </div>
</div>

</div>
</div>

<%-- 지윤 26.07.22 추가: 취소사유 입력 모달 --%>
<div id="cancelModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.4); z-index:1000; align-items:center; justify-content:center;">
  <div style="background:#fff; border-radius:14px; padding:24px; width:360px;">
    <p style="font-weight:800; font-size:15px; margin:0 0 12px;">주문취소 신청</p>
    <p style="font-size:13px; color:var(--text-muted); margin:0 0 14px;">배송 시작 전 상품에 한해 취소 가능하며, 신청 후 사업자 확인을 거쳐 환불됩니다.</p>
    <form id="cancelForm" method="post" action="${contextPath}/mypage/orders/cancel">
      <input type="hidden" name="orderId" value="${order.orderId}">
      <textarea name="reason" required placeholder="취소 사유를 입력해주세요" style="width:100%; height:80px; border:1px solid #E2E8E4; border-radius:8px; padding:10px; font-size:13px; resize:none; box-sizing:border-box;"></textarea>
      <div style="display:flex; gap:8px; margin-top:14px;">
        <button type="button" class="btn-sm" style="flex:1;" onclick="closeCancelModal()">닫기</button>
        <button type="submit" class="btn-sm" style="flex:1; background:#E2445C; color:#fff; border:none;">취소 신청</button>
      </div>
    </form>
  </div>
</div>

<script>
function openCancelModal() { document.getElementById('cancelModal').style.display = 'flex'; }
function closeCancelModal() { document.getElementById('cancelModal').style.display = 'none'; }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>