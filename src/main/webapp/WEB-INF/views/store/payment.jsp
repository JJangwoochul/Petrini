<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
.order-wrap{max-width:900px;margin:32px auto 80px;padding:0 20px}
.order-title{font-size:24px;font-weight:800;color:var(--text-main);margin-bottom:6px}
.order-subtitle{font-size:14px;color:var(--text-muted);margin-bottom:28px}
.order-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;margin-bottom:20px}
.order-section h3{font-size:16px;font-weight:800;color:var(--text-main);margin:0 0 18px;padding-bottom:14px;border-bottom:1px solid var(--border)}
/* 요약 카드 */
.summary-recap-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub);margin-bottom:10px}
.summary-recap-row:last-child{margin-bottom:0}
.summary-recap-row span:last-child{color:var(--text-main);font-weight:600;text-align:right}
.recap-addr{background:var(--bg-page);border-radius:var(--radius-sm);padding:14px 16px;font-size:13px;color:var(--text-sub);line-height:1.7}
.recap-addr strong{color:var(--text-main)}
/* 결제수단 */
.pay-methods{display:grid;grid-template-columns:repeat(4,1fr);gap:10px}
.pay-method{display:none}
.pay-label{display:flex;flex-direction:column;align-items:center;gap:6px;padding:14px;border:2px solid var(--border);border-radius:var(--radius-sm);cursor:pointer;transition:var(--transition);font-size:13px;color:var(--text-sub);font-weight:600}
.pay-label svg{width:24px;height:24px;stroke:var(--text-muted);fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.pay-method:checked+.pay-label{border-color:var(--primary);background:var(--primary-light);color:var(--primary-dark)}
.pay-method:checked+.pay-label svg{stroke:var(--primary)}
.card-detail-row{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:16px;padding-top:16px;border-top:1px dashed var(--border)}
.card-detail-row .full{grid-column:1/-1}
.card-detail-row label{display:block;font-size:12px;font-weight:600;color:var(--text-sub);margin-bottom:6px}
.card-detail-row input,.card-detail-row select{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit;box-sizing:border-box}
.card-detail-row input:focus,.card-detail-row select:focus{border-color:var(--primary)}
/* 약관 */
.agree-row{display:flex;align-items:center;gap:8px;font-size:13px;color:var(--text-sub)}
.agree-row input{accent-color:var(--primary);width:16px;height:16px}
.agree-row a{color:var(--primary);text-decoration:underline;margin-left:4px}
/* 최종 금액 */
.order-total-box{background:var(--bg-page);border-radius:var(--radius-sm);padding:18px;display:flex;flex-direction:column;gap:10px}
.order-total-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub)}
.order-total-row.final{font-size:18px;font-weight:800;color:var(--text-main);padding-top:10px;border-top:1px solid var(--border);margin-top:4px}
.order-total-row.final span:last-child{color:var(--primary-dark)}
.btn-pay{width:100%;padding:16px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:17px;font-weight:800;cursor:pointer;margin-top:16px;transition:var(--transition)}
.btn-pay:hover{background:var(--primary-dark)}
.btn-pay:disabled{background:var(--border);cursor:not-allowed}
.order-nav{display:flex;justify-content:flex-start;margin-bottom:20px}
.btn-back{padding:9px 16px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;color:var(--text-sub);font-size:13px;font-weight:600;cursor:pointer;display:flex;align-items:center;gap:5px}
.btn-back svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
</style>
<div class="order-wrap">
  <div class="order-nav">
    <button class="btn-back" onclick="location.href='${contextPath}/store/order'"><svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>주문서로 돌아가기</button>
  </div>
  <h1 class="order-title">결제</h1>
  <p class="order-subtitle">주문 내용을 확인하고 결제수단을 선택해주세요.</p>

  <div class="order-section">
    <h3>주문 요약</h3>
    <div class="summary-recap-row"><span>주문 상품</span>
  <span>
    <c:out value="${orderItems[0].productName}"/>
    <c:if test="${fn:length(orderItems) > 1}"> 외 ${fn:length(orderItems) - 1}건</c:if>
  </span>
</div>
<div class="summary-recap-row"><span>배송지</span>
  <span class="recap-addr" style="display:inline-block;max-width:60%">
    <strong>${recvName}</strong> · ${recvPhone}<br>${addr1} ${addr2}
  </span>
</div>
<div class="summary-recap-row"><span>배송 메모</span><span>${deliveryMemo}</span></div>
  </div>

  <div class="order-section">
    <h3>결제 수단</h3>
    <div id="payment-method"></div>
    <div id="agreement"></div>
  </div>

  <div class="order-section">
    <h3>최종 결제 금액</h3>
    <div class="order-total-box">
      <div class="order-total-row"><span>상품 금액</span><span><fmt:formatNumber value="${productTotal}" pattern="#,###"/>원</span></div>
            
<%-- 지윤 26.07.13 수정: deliveryFee(숫자)에 문자열 전용 메서드 concat() 호출하던 버그로 500 에러 발생 -> fmt:formatNumber로 수정 --%>
<%--<div class="order-total-row"><span>배송비</span><span style="color:var(--primary)">
        <c:choose>
          <c:when test="${deliveryFee == 0}">무료</c:when>
          <c:otherwise><fmt:formatNumber value="${deliveryFee}" pattern="#,###"/>원</c:otherwise>
        </c:choose>
      </span></div>--%>
<div class="order-total-row"><span>배송비</span><span style="color:var(--primary)">
  <c:choose>
    <c:when test="${deliveryFee == 0}">무료</c:when>
    <c:otherwise><fmt:formatNumber value="${deliveryFee}" pattern="#,###"/>원</c:otherwise>
  </c:choose>
</span></div>


<div class="order-total-row"><span>쿠폰/포인트 할인</span><span style="color:var(--accent)">-<fmt:formatNumber value="${totalDiscount}" pattern="#,###"/>원</span></div>
<div class="order-total-row final"><span>총 결제금액</span><span><fmt:formatNumber value="${finalTotal}" pattern="#,###"/>원</span></div>
    </div>
    <div class="agree-row" style="margin-top:16px">
      <input type="checkbox" id="agreePay" checked onchange="document.getElementById('btnPayFinal').disabled=!this.checked">
      <label for="agreePay">주문 내용을 확인했으며 결제에 동의합니다.<a href="#" onclick="event.preventDefault()">전자결제 이용약관 보기</a></label>
    </div>
   <button id="btnPayFinal" class="btn-pay" onclick="requestPayment()"><fmt:formatNumber value="${finalTotal}" pattern="#,###"/>원 결제하기</button>
  </div>
</div>
<script src="https://js.tosspayments.com/v2/standard"></script>

<script>
  const amount = ${finalTotal};
  const clientKey = "${tossApiKey}"; // 토스 공개 테스트 키
  const customerKey = "petcare_user_${memberInfo.memberId}";
  const tossPayments = TossPayments(clientKey);
  const widgets = tossPayments.widgets({ customerKey });

  //지윤 26.07.13 추가: 필수약관 동의 상태 저장용 변수 (기본 false, 위젯 이벤트로 갱신됨)
  let agreedRequiredTerms = false;
  (async () => {
    await widgets.setAmount({ currency: "KRW", value: amount });
    await widgets.renderPaymentMethods({ selector: "#payment-method", variantKey: "DEFAULT" });
    const agreementWidget = await widgets.renderAgreement({ selector: "#agreement" });

    //지윤 26.07.13 추가: 약관 체크 상태가 바뀔 때마다 agreedRequiredTerms 값 갱신
    agreementWidget.on('agreementStatusChange', function (agreementStatus) {
      agreedRequiredTerms = agreementStatus.agreedRequiredTerms;
    });
  })();
  async function requestPayment() {
    //지윤 26.07.13 추가: 필수약관 미동의 상태면 안내 팝업 띄우고 결제 요청 자체를 안 보냄
    if (!agreedRequiredTerms) {
      alert('결제 서비스 이용약관, 개인정보 처리 동의는 필수입니다.');
      return;
    }
    await widgets.requestPayment({
      orderId: "order-" + Date.now(),
      orderName: "로얄캐닌 사료 4kg 외 2건",
      successUrl: window.location.origin + "${contextPath}/store/order-complete",
      failUrl: window.location.origin + "${contextPath}/store/payment"
    });
  }
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
