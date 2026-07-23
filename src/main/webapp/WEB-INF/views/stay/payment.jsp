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
  <div class="pay-section" id="tossSection">
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

    <%-- 포인트 사용 --%>
      <div style="background:#F0FDF4;border:1px solid #BBF7D0;border-radius:8px;padding:14px 16px;margin:12px 0">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px">
          <span style="font-size:13px;font-weight:700;color:#166534">보유 포인트</span>
          <span style="font-size:14px;font-weight:800;color:#16A34A"><fmt:formatNumber value="${memberInfo.pointBalance}" pattern="#,###"/>P</span>
        </div>
        <div style="display:flex;gap:8px;align-items:center">
          <input type="number" id="pointInput" min="0" max="${memberInfo.pointBalance > reservation.totalAmount ? reservation.totalAmount : memberInfo.pointBalance}"
                 value="0" style="flex:1;border:1px solid #BBF7D0;border-radius:6px;padding:8px 12px;font-size:14px;outline:none"
                 oninput="calcFinalAmount()">
          <button type="button" onclick="useAllPoints()" style="flex-shrink:0;padding:8px 14px;border:1px solid #16A34A;border-radius:6px;background:#fff;color:#16A34A;font-size:13px;font-weight:700;cursor:pointer">전액 사용</button>
        </div>
        <div id="pointMsg" style="font-size:12px;color:#888;margin-top:6px"></div>
      </div>

    <div style="display:none"><span id="pointDiscountRow"></span></div>

    <div class="pay-total-box">
        <div class="pay-row" id="pointDiscountDisplay" style="display:none;margin-bottom:10px">
          <span>포인트 사용</span>
          <span id="pointDiscountLabel" style="color:#16A34A">0P</span>
        </div>
      <div class="pay-total-row">
        <span>총 결제금액</span>
        <span id="finalAmountLabel"><fmt:formatNumber value="${reservation.totalAmount}" pattern="#,###"/>원</span>
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
  var totalAmount = ${reservation.totalAmount};
  var memberPoint = ${memberPoint != null ? memberPoint : 0};
  var clientKey = "${tossApiKey}";
  var customerKey = "petcare_user_${memberInfo.memberId}";
  var resvId = ${reservation.resvId};
  var resvNo = "${reservation.resvNo}";
  var contextPath = "${contextPath}";
  var usedPoint = 0;

  var tossPayments = TossPayments(clientKey);
  var widgets = tossPayments.widgets({ customerKey: customerKey });

  (async function() {
    await widgets.setAmount({ currency: "KRW", value: totalAmount });
    await widgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" });
    await widgets.renderAgreement({ selector: "#agreement" });
  })();

  function useAllPoints() {
    var maxUsable = Math.min(memberPoint, totalAmount);
    document.getElementById('pointInput').value = maxUsable;
    calcFinalAmount();
  }

  function calcFinalAmount() {
    var input = document.getElementById('pointInput');
    var val = parseInt(input.value) || 0;
    var maxUsable = Math.min(memberPoint, totalAmount);

    // 범위 제한
    if (val < 0) val = 0;
    if (val > maxUsable) val = maxUsable;
    input.value = val;

    usedPoint = val;
    var finalAmount = totalAmount - usedPoint;

    // 포인트 할인 행 표시
    var discountDisplay = document.getElementById('pointDiscountDisplay');
    if (discountDisplay) {
      if (usedPoint > 0) {
        discountDisplay.style.display = 'flex';
        document.getElementById('pointDiscountLabel').textContent = '-' + usedPoint.toLocaleString() + 'P';
      } else {
        discountDisplay.style.display = 'none';
      }
    }

    // 최종 금액 + 버튼
    document.getElementById('finalAmountLabel').textContent = finalAmount.toLocaleString() + '원';
    var btn = document.getElementById('btnPayFinal');

    if (finalAmount === 0) {
      btn.textContent = '포인트로 결제하기';
      document.getElementById('tossSection').style.display = 'none';
    } else {
      btn.textContent = finalAmount.toLocaleString() + '원 결제하기';
      document.getElementById('tossSection').style.display = 'block';
      // Toss 금액 업데이트
      widgets.setAmount({ currency: "KRW", value: finalAmount });
    }

    // 메시지
    var msgEl = document.getElementById('pointMsg');
    if (msgEl) {
      if (usedPoint > 0) {
        msgEl.textContent = usedPoint.toLocaleString() + 'P 사용 → 실결제 ' + finalAmount.toLocaleString() + '원';
        msgEl.style.color = '#16A34A';
      } else {
        msgEl.textContent = '';
      }
    }
  }

  async function requestPayment() {
    var finalAmount = totalAmount - usedPoint;

    // 전액 포인트 결제 — Toss 없이 서버로 직접 요청
    if (finalAmount === 0) {
      location.href = contextPath + '/stay/payment/point-only?resvId=' + resvId + '&usedPoint=' + usedPoint;
      return;
    }

    try {
      // 포인트 사용액을 orderId에 포함시켜 서버에서 파싱
      var orderId = 'stay-' + resvId + '-' + usedPoint + '-' + Date.now();
      await widgets.requestPayment({
        orderId: orderId,
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
