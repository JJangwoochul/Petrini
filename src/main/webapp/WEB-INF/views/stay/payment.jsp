<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="stay" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .pay-wrap{max-width:720px;margin:32px auto 80px;padding:0 20px}
  .pay-back{display:inline-flex;align-items:center;gap:6px;font-size:13px;color:var(--text-muted);text-decoration:none;margin-bottom:18px;transition:var(--transition)}
  .pay-back:hover{color:var(--primary)}
  .pay-back svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .pay-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:6px}
  .pay-sub{font-size:14px;color:var(--text-muted);margin-bottom:28px}
  .pay-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:22px;margin-bottom:16px}
  .pay-section h3{font-size:15px;font-weight:800;color:var(--text-main);margin:0 0 16px;padding-bottom:12px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:8px}
  .pay-section h3 svg{width:16px;height:16px;stroke:var(--primary);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .pay-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub);margin-bottom:10px}
  .pay-row:last-child{margin-bottom:0}
  .pay-row span:last-child{color:var(--text-main);font-weight:600;text-align:right}
  .pay-total-box{background:var(--bg-page);border-radius:var(--radius-sm);padding:18px;margin-top:14px}
  .pay-total-row{display:flex;justify-content:space-between;font-size:18px;font-weight:800;color:var(--text-main)}
  .pay-total-row span:last-child{color:var(--primary-dark)}
  .btn-pay{width:100%;padding:16px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:17px;font-weight:800;cursor:pointer;margin-top:16px;transition:var(--transition)}
  .btn-pay:hover{background:var(--primary-dark)}
  .btn-pay:disabled{background:var(--border);cursor:not-allowed}
  .agree-row{display:flex;align-items:center;gap:8px;font-size:13px;color:var(--text-sub);margin-top:14px}
  .agree-row input{accent-color:var(--primary);width:16px;height:16px}
</style>

<div class="pay-wrap">
  <a href="${contextPath}/stay/reserve?id=${reservation.targetId}&roomId=${reservation.roomId}" class="pay-back">
    <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
    예약 정보로 돌아가기
  </a>

  <h1 class="pay-title">결제</h1>
  <p class="pay-sub">예약 내용을 확인하고 결제를 진행하세요.</p>

  <%-- 예약 요약 --%>
  <div class="pay-section">
    <h3>
      <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
      예약 정보
    </h3>
    <div class="pay-row"><span>예약번호</span><span>${reservation.resvNo}</span></div>
    <div class="pay-row"><span>숙소</span><span>${reservation.stayName}</span></div>
    <div class="pay-row"><span>객실</span><span>${reservation.serviceName}</span></div>
    <div class="pay-row"><span>이용 기간</span>
      <span>
        <fmt:formatDate value="${reservation.checkinDate}" pattern="yyyy.MM.dd"/> ~
        <fmt:formatDate value="${reservation.checkoutDate}" pattern="MM.dd"/>
        · ${reservation.nightCnt}박
      </span>
    </div>
    <div class="pay-row"><span>반려동물</span><span>${reservation.petName}</span></div>
  </div>

  <%-- 결제 수단 (Toss Widget) --%>
  <div class="pay-section">
    <h3>
      <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
      결제 수단
    </h3>
    <div id="payment-method"></div>
    <div id="agreement"></div>
  </div>

  <%-- 결제 금액 --%>
  <div class="pay-section">
    <h3>
      <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
      결제 금액
    </h3>
    <div class="pay-row">
      <span>숙박 요금</span>
      <span><fmt:formatNumber value="${reservation.totalAmount}" pattern="#,###"/>원</span>
    </div>
    <div class="pay-total-box">
      <div class="pay-total-row">
        <span>총 결제금액</span>
        <span><fmt:formatNumber value="${reservation.totalAmount}" pattern="#,###"/>원</span>
      </div>
    </div>
    <div class="agree-row">
      <input type="checkbox" id="agreePay" checked onchange="document.getElementById('btnPayFinal').disabled=!this.checked">
      <label for="agreePay">예약 내용을 확인했으며 결제에 동의합니다.</label>
    </div>
    <button id="btnPayFinal" class="btn-pay" onclick="requestPayment()">
      <fmt:formatNumber value="${reservation.totalAmount}" pattern="#,###"/>원 결제하기
    </button>
  </div>
</div>

<script src="https://js.tosspayments.com/v2/standard"></script>
<script>
  var amount = ${reservation.totalAmount};
  var clientKey = "${tossApiKey}";
  var customerKey = "petcare_user_${memberInfo.memberId}";
  var resvId = ${reservation.resvId};
  var resvNo = "${reservation.resvNo}";
  var contextPath = "${contextPath}";

  var tossPayments = TossPayments(clientKey);
  var widgets = tossPayments.widgets({ customerKey: customerKey });

  (async function() {
    await widgets.setAmount({ currency: "KRW", value: amount });
    await widgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" });
    await widgets.renderAgreement({ selector: "#agreement" });
  })();

  async function requestPayment() {
    try {
      await widgets.requestPayment({
        orderId: "stay-" + resvId + "-" + Date.now(),
        orderName: "${reservation.stayName} - ${reservation.serviceName} ${reservation.nightCnt}박",
        successUrl: window.location.origin + contextPath + "/stay/payment/success",
        failUrl: window.location.origin + contextPath + "/stay/payment/fail"
      });
    } catch (error) {
      if (error.code === "USER_CANCEL") {
        // 사용자가 결제창을 닫음
      } else {
        alert("결제 요청 중 오류가 발생했습니다: " + error.message);
      }
    }
  }
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
