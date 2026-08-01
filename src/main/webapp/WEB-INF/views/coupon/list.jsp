<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  역할: 이벤트/혜택 메인 — 받을 수 있는 쿠폰 목록 + 발급 (event/list)

  [model]
  - availableCoupons : 받을 수 있는 쿠폰 (APPROVED + ACTIVE + 기간 내)
    └ alreadyClaimed : 로그인 사용자가 이미 받았으면 true
--%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="coupon" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .ev-hero{background:linear-gradient(135deg,#92400E 0%,#F59E0B 60%,#FCD34D 100%);padding:48px 0;color:#fff;text-align:center}
  .ev-hero-inner{max-width:var(--inner-width);margin:0 auto;padding:0 20px}
  .ev-hero-badge{display:inline-block;font-size:13px;font-weight:700;background:rgba(255,255,255,.22);padding:5px 16px;border-radius:50px;margin-bottom:14px}
  .ev-hero h1{font-size:30px;font-weight:800;margin:0 0 8px}
  .ev-hero p{font-size:14px;opacity:.9;margin:0}

  .ev-wrap{max-width:860px;margin:32px auto 80px;padding:0 20px}

  .ev-count{font-size:14px;color:var(--text-muted);margin-bottom:18px}
  .ev-count strong{color:#D97706;font-weight:800}

  /* 쿠폰 티켓 */
  .cp-ticket{display:flex;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden;margin-bottom:14px;transition:box-shadow .2s}
  .cp-ticket:hover{box-shadow:var(--shadow-sm)}
  .cp-ticket-left{width:120px;flex-shrink:0;background:#FFFBEB;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:16px;position:relative;border-right:2px dashed #FDE68A}
  .cp-ticket-left::before,.cp-ticket-left::after{content:"";position:absolute;width:18px;height:18px;background:var(--bg-body,#F7F9F7);border-radius:50%;right:-10px}
  .cp-ticket-left::before{top:-9px}
  .cp-ticket-left::after{bottom:-9px}
  .cp-ticket-pct{font-size:22px;font-weight:800;color:#B45309;line-height:1.1}
  .cp-ticket-unit{font-size:12px;color:#B45309;font-weight:700}
  .cp-ticket-body{flex:1;padding:16px 20px;display:flex;justify-content:space-between;align-items:center;gap:14px}
  .cp-ticket-info{flex:1;min-width:0}
  .cp-ticket-name{font-size:14px;font-weight:700;color:var(--text-main);margin-bottom:4px}
  .cp-ticket-cond{font-size:12px;color:var(--text-muted);margin-bottom:2px}
  .cp-ticket-date{font-size:12px;color:var(--text-muted)}
  .cp-ticket-btn{padding:9px 18px;border:none;border-radius:var(--radius-sm);background:#F59E0B;color:#fff;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;flex-shrink:0}
  .cp-ticket-btn:hover{background:#D97706}
  .cp-ticket-btn.claimed{background:#F5F5F5;color:#aaa;cursor:not-allowed}
  .cp-ticket.ended{opacity:.5}
  .cp-ticket-badge{font-size:11px;font-weight:700;padding:2px 8px;border-radius:12px;margin-left:8px}
  .cp-ticket-badge.expired{background:#FEE2E2;color:#DC2626}
  .cp-ticket-badge.exhausted{background:#F1F3F7;color:#999}

  .ev-empty{text-align:center;padding:60px 0;color:var(--text-muted);font-size:14px}

  @media(max-width:640px){
    .cp-ticket{flex-direction:column}
    .cp-ticket-left{width:100%;flex-direction:row;gap:8px;padding:12px 16px;border-right:none;border-bottom:2px dashed #FDE68A}
    .cp-ticket-left::before,.cp-ticket-left::after{display:none}
  }
</style>

<div class="ev-hero">
  <div class="ev-hero-inner">
    <span class="ev-hero-badge">PetCare 혜택</span>
    <h1>지금 받을 수 있는 쿠폰</h1>
    <p>사업자가 제공하는 할인 쿠폰을 받고, 쇼핑·예약 시 사용하세요</p>
  </div>
</div>

<div class="ev-wrap">

  <c:choose>
    <c:when test="${empty availableCoupons}">
      <div class="ev-empty">현재 받을 수 있는 쿠폰이 없습니다.</div>
    </c:when>
    <c:otherwise>
      <%-- 건수 표시 --%>
      <c:set var="claimableCount" value="0" />
      <c:forEach var="cpn" items="${availableCoupons}">
        <c:if test="${!cpn.alreadyClaimed}"><c:set var="claimableCount" value="${claimableCount + 1}" /></c:if>
      </c:forEach>
      <div class="ev-count">총 <strong>${availableCoupons.size()}장</strong>의 쿠폰이 있습니다.</div>

      <c:forEach var="cpn" items="${availableCoupons}">
        <%-- 만료·소진 여부 판단 --%>
        <c:set var="isExpired" value="${cpn.useEndDate < today}" />
        <c:set var="isExhausted" value="${cpn.statusCd eq 'EXHAUSTED' || cpn.issuedQty >= cpn.totalQty}" />
        <c:set var="isEnded" value="${isExpired || isExhausted}" />

        <div class="cp-ticket ${isEnded ? 'ended' : ''}">
          <div class="cp-ticket-left">
            <c:choose>
              <c:when test="${cpn.couponType eq 'FIXED'}">
                <span class="cp-ticket-pct"><fmt:formatNumber value="${cpn.discountValue}" type="number"/></span>
                <span class="cp-ticket-unit">원 할인</span>
              </c:when>
              <c:when test="${cpn.couponType eq 'RATE'}">
                <span class="cp-ticket-pct">${cpn.discountValue}%</span>
                <span class="cp-ticket-unit">할인</span>
              </c:when>
            </c:choose>
          </div>
          <div class="cp-ticket-body">
            <div class="cp-ticket-info">
              <div class="cp-ticket-name">
                ${cpn.couponName}
                <c:if test="${isExhausted}"><span class="cp-ticket-badge exhausted">소진</span></c:if>
                <c:if test="${isExpired && !isExhausted}"><span class="cp-ticket-badge expired">기간만료</span></c:if>
              </div>
              <div class="cp-ticket-cond">
                <c:if test="${cpn.minOrderAmt > 0}"><fmt:formatNumber value="${cpn.minOrderAmt}" type="number"/>원 이상 구매 시</c:if>
                <c:if test="${not empty cpn.bizName}"> · ${cpn.bizName}</c:if>
              </div>
              <div class="cp-ticket-date">
                ${cpn.useEndDate.substring(0,4)}.${cpn.useEndDate.substring(4,6)}.${cpn.useEndDate.substring(6,8)}까지
                <c:if test="${!isExhausted}"> · 잔여 ${cpn.totalQty - cpn.issuedQty}장</c:if>
              </div>
            </div>
            <c:choose>
              <c:when test="${cpn.alreadyClaimed}">
                <button class="cp-ticket-btn claimed" disabled>받기 완료</button>
              </c:when>
              <c:when test="${isEnded}">
                <button class="cp-ticket-btn claimed" disabled>마감</button>
              </c:when>
              <c:otherwise>
                <button class="cp-ticket-btn" onclick="claimCoupon(this, ${cpn.couponId})">받기</button>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>

</div>

<script>
function claimCoupon(btn, couponId) {
    if (btn.disabled) return;

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '${contextPath}/coupon/claim');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (xhr.status === 200) {
            var res = JSON.parse(xhr.responseText);
            if (res.ok) {
                btn.textContent = '받기 완료';
                btn.disabled = true;
                btn.classList.add('claimed');
                alert(res.message);
            } else {
                if (res.message === '로그인이 필요합니다.') {
                    if (confirm('로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?')) {
                        location.href = '${contextPath}/login';
                    }
                } else {
                    alert(res.message);
                }
            }
        }
    };
    xhr.send('couponId=' + couponId);
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
