<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <div class="summary-recap-row"><span>주문 상품</span><span>로얄캐닌 사료 4kg 외 2건</span></div>
    <div class="summary-recap-row"><span>배송지</span>
      <span class="recap-addr" style="display:inline-block;max-width:60%">
        <strong>${memberInfo.memberName}</strong> · 010-0000-0000<br>서울특별시 마포구 합정동 123-4 (2층)
      </span>
    </div>
    <div class="summary-recap-row"><span>배송 메모</span><span>문 앞에 놓아주세요</span></div>
  </div>

  <div class="order-section">
    <h3>결제 수단</h3>
    <div class="pay-methods">
      <input type="radio" name="pay" id="pay-card" class="pay-method" checked onchange="togglePay('card')">
      <label for="pay-card" class="pay-label">
        <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
        신용/체크카드
      </label>
      <input type="radio" name="pay" id="pay-kakao" class="pay-method" onchange="togglePay('kakao')">
      <label for="pay-kakao" class="pay-label">
        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 5.58 2 10c0 2.76 1.63 5.19 4.1 6.67L5 21l4.8-2.6C10.5 18.8 11.24 19 12 19c5.52 0 10-3.58 10-9s-4.48-9-10-9z"/></svg>
        카카오페이
      </label>
      <input type="radio" name="pay" id="pay-naver" class="pay-method" onchange="togglePay('naver')">
      <label for="pay-naver" class="pay-label">
        <svg viewBox="0 0 24 24"><path d="M4 4l7 8-7 8h2l6-7 6 7h2L13 12l7-8h-2l-6 7-6-7z"/></svg>
        네이버페이
      </label>
      <input type="radio" name="pay" id="pay-transfer" class="pay-method" onchange="togglePay('transfer')">
      <label for="pay-transfer" class="pay-label">
        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 9h18"/><path d="M7 13h4M7 16h2"/></svg>
        계좌이체
      </label>
    </div>

    <div id="cardDetail" class="card-detail-row">
      <div class="full"><label>카드 번호</label><input type="text" placeholder="0000 - 0000 - 0000 - 0000"></div>
      <div><label>유효기간</label><input type="text" placeholder="MM / YY"></div>
      <div><label>할부 개월</label>
        <select><option>일시불</option><option>2개월</option><option>3개월</option><option>6개월</option></select>
      </div>
    </div>
    <div id="simpleDetail" class="card-detail-row" style="display:none">
      <div class="full" style="text-align:center;color:var(--text-muted);font-size:13px">결제하기 버튼을 누르면 간편결제 앱으로 이동합니다.</div>
    </div>
  </div>

  <div class="order-section">
    <h3>최종 결제 금액</h3>
    <div class="order-total-box">
      <div class="order-total-row"><span>상품 금액</span><span>98,900원</span></div>
      <div class="order-total-row"><span>배송비</span><span style="color:var(--primary)">무료</span></div>
      <div class="order-total-row"><span>쿠폰/포인트 할인</span><span style="color:var(--accent)">-0원</span></div>
      <div class="order-total-row final"><span>총 결제금액</span><span>98,900원</span></div>
    </div>
    <div class="agree-row" style="margin-top:16px">
      <input type="checkbox" id="agreePay" checked onchange="document.getElementById('btnPayFinal').disabled=!this.checked">
      <label for="agreePay">주문 내용을 확인했으며 결제에 동의합니다.<a href="#" onclick="event.preventDefault()">전자결제 이용약관 보기</a></label>
    </div>
    <button id="btnPayFinal" class="btn-pay" onclick="location.href='${contextPath}/store/order-complete'">98,900원 결제하기</button>
  </div>
</div>
<script>
function togglePay(type){
  var card = document.getElementById('cardDetail');
  var simple = document.getElementById('simpleDetail');
  if(type === 'card'){ card.style.display='grid'; simple.style.display='none'; }
  else { card.style.display='none'; simple.style.display='grid'; }
}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
