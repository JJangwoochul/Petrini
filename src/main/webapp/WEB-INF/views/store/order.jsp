<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .order-wrap{max-width:900px;margin:32px auto 80px;padding:0 20px}
  .order-title{font-size:24px;font-weight:800;color:var(--text-main);margin-bottom:28px}
  .order-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;margin-bottom:20px}
  .order-section h3{font-size:16px;font-weight:800;color:var(--text-main);margin:0 0 18px;padding-bottom:14px;border-bottom:1px solid var(--border)}
  .order-form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
  .order-form-group{display:flex;flex-direction:column;gap:6px}
  .order-form-group.full{grid-column:1/-1}
  .order-form-group label{font-size:13px;font-weight:600;color:var(--text-sub)}
  .order-form-group input,.order-form-group select{border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;color:var(--text-main);outline:none;transition:border-color .2s;font-family:inherit}
  .order-form-group input:focus,.order-form-group select:focus{border-color:var(--primary)}
  .addr-row{display:flex;gap:8px}
  .addr-row input{flex:1}
  .addr-btn{padding:10px 14px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:#fff;color:var(--primary);font-size:13px;font-weight:600;cursor:pointer;white-space:nowrap}
  .order-product-row{display:flex;gap:14px;align-items:center;padding:14px 0;border-bottom:1px solid var(--border)}
  .order-product-row:last-child{border-bottom:none}
  .order-product-thumb{width:60px;height:60px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .order-product-name{flex:1;font-size:14px;font-weight:600;color:var(--text-main)}
  .order-product-price{font-size:14px;font-weight:700;color:var(--text-main)}
  .coupon-input{display:flex;gap:8px}
  .coupon-input input{flex:1;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit}
  .coupon-input input:focus{border-color:var(--primary)}
  .order-total-box{background:var(--bg-page);border-radius:var(--radius-sm);padding:18px;display:flex;flex-direction:column;gap:10px}
  .order-total-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub)}
  .order-total-row.final{font-size:18px;font-weight:800;color:var(--text-main);padding-top:10px;border-top:1px solid var(--border);margin-top:4px}
  .order-total-row.final span:last-child{color:var(--primary-dark)}
  .btn-pay{width:100%;padding:16px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:17px;font-weight:800;cursor:pointer;margin-top:16px;transition:var(--transition)}
  .btn-pay:hover{background:var(--primary-dark)}
</style>
<div class="order-wrap">
  <h1 class="order-title">주문서 작성</h1>

  <div class="order-section">
    <h3>주문 상품</h3>
    <c:set var="productTotal" value="0" />

<c:forEach var="item" items="${orderItems}">
  <c:set var="lineTotal" value="${item.price * item.qty}" />
  <c:set var="productTotal" value="${productTotal + lineTotal}" />

  <div class="order-product-row">
    <img class="order-product-thumb"
         src="${item.thumbnailUrl}"
         alt="${item.productName}"
         onerror="this.src='https://placehold.co/60x60/EAF7F2/2BAB82?text=IMG'">

    <div class="order-product-name">
      ${item.productName} × ${item.qty}
    </div>

    <div class="order-product-price">
      <fmt:formatNumber value="${lineTotal}" pattern="#,###"/>원
    </div>
  </div>
</c:forEach>
  </div>

  <div class="order-section">
    <h3>배송지 입력</h3>
    <div class="order-form-grid">
      <div class="order-form-group"><label>받는 분</label><input type="text" value="${memberInfo.memberName}" placeholder="이름"></div>
      <div class="order-form-group"><label>연락처</label><input type="tel" placeholder="010-0000-0000"></div>
      <div class="order-form-group full">
        <label>주소</label>
        <div class="addr-row"><input type="text" placeholder="우편번호" style="max-width:120px"><button class="addr-btn">주소 검색</button></div>
        <input type="text" placeholder="기본 주소" style="margin-top:8px">
        <input type="text" placeholder="상세 주소" style="margin-top:8px">
      </div>
    </div>
  </div>

  <div class="order-section">
    <h3>주문 시 요청사항</h3>
    <div class="order-form-grid">
      <div class="order-form-group full">
        <label>배송 메모</label>
        <select>
          <option>문 앞에 놓아주세요</option>
          <option>경비실에 맡겨주세요</option>
          <option>부재 시 연락 부탁드려요</option>
          <option>직접 입력</option>
        </select>
      </div>
    </div>
  </div>

  <%-- 지윤 26.07.09 수정: 쿠폰 코드 직접입력 -> 보유쿠폰 드롭다운으로 변경 (등록은 마이페이지에서, 여기선 적용만) --%>
<div class="order-section">
    <h3>쿠폰 / 포인트</h3>
    <div class="order-form-group">
      <label>보유 쿠폰</label>
      <select id="couponSelect" onchange="updateOrderTotal()">
        <option value="0" data-type="" data-value="0" data-min="0">쿠폰 선택 안 함</option>
        <c:forEach var="c" items="${memberCoupons}">
          <option value="${c.memberCouponId}" data-type="${c.couponType}" data-value="${c.discountValue}" data-min="${c.minOrderAmt}">
            ${c.couponName}
            <c:if test="${c.couponType == 'RATE'}"> (${c.discountValue}% 할인)</c:if>
            <c:if test="${c.couponType == 'AMOUNT'}"> (<fmt:formatNumber value="${c.discountValue}" pattern="#,###"/>원 할인)</c:if>
          </option>
        </c:forEach>
      </select>
      <c:if test="${empty memberCoupons}">
        <small style="color:var(--text-muted)">사용 가능한 쿠폰이 없습니다.</small>
      </c:if>
    </div>
    <div class="order-form-grid" style="margin-top:14px">
      <div class="order-form-group">
        <label>보유 포인트 2,400P</label>
        <input type="number" id="pointInput" placeholder="사용할 포인트 입력" value="0" onchange="updateOrderTotal()">
      </div>
    </div>
</div>

  <div class="order-section">
    <h3>결제 예정 금액</h3>
    <div class="order-total-box">
      <div class="order-total-row">
  <span>상품 금액</span>
  <span id="orderProductTotal"><fmt:formatNumber value="${productTotal}" pattern="#,###"/>원</span>
</div>
<div class="order-total-row">
  <span>배송비</span>
  <span id="orderDeliveryFee" style="color:var(--primary)">무료</span>
</div>
<div class="order-total-row">
  <span>쿠폰/포인트 할인</span>
  <span id="orderDiscount" style="color:var(--accent)">-0원</span>
</div>
<div class="order-total-row final">
  <span>결제 예정 금액</span>
  <span id="orderFinalTotal"><fmt:formatNumber value="${productTotal}" pattern="#,###"/>원</span>
</div>
    </div>
    <button class="btn-pay" onclick="location.href='${contextPath}/store/payment'">결제수단 선택하기</button>
  </div>
</div>
<script>

//지윤 26.07.09 추가: 쿠폰/포인트 선택 시 결제 예정 금액 실시간 계산
var PRODUCT_TOTAL = ${productTotal};

function won(n){ return n.toLocaleString('ko-KR') + '원'; }

function updateOrderTotal() {
  var couponSel = document.getElementById('couponSelect');
  var opt = couponSel.options[couponSel.selectedIndex];
  var couponType = opt.dataset.type;
  var couponValue = parseInt(opt.dataset.value) || 0;
  var minOrderAmt = parseInt(opt.dataset.min) || 0;

  var deliveryFee = (PRODUCT_TOTAL === 0 || PRODUCT_TOTAL >= 50000) ? 0 : 3000;

  var couponDiscount = 0;
  if (couponType) {
    if (PRODUCT_TOTAL < minOrderAmt) {
      alert('최소 주문금액 ' + won(minOrderAmt) + ' 이상부터 사용 가능한 쿠폰입니다.');
      couponSel.value = '0';
    } else if (couponType === 'RATE') {
      couponDiscount = Math.floor(PRODUCT_TOTAL * couponValue / 100);
    } else if (couponType === 'AMOUNT') {
      couponDiscount = couponValue;
    }
  }

  var pointInput = document.getElementById('pointInput');
  var pointUsed = parseInt(pointInput.value) || 0;
  if (pointUsed < 0) pointUsed = 0;

  var totalDiscount = couponDiscount + pointUsed;
  var finalTotal = PRODUCT_TOTAL + deliveryFee - totalDiscount;
  if (finalTotal < 0) finalTotal = 0;

  document.getElementById('orderDeliveryFee').textContent = deliveryFee === 0 ? '무료' : won(deliveryFee);
  document.getElementById('orderDiscount').textContent = '-' + won(totalDiscount);
  document.getElementById('orderFinalTotal').textContent = won(finalTotal);
}

//지윤 26.07.09 추가: 페이지 로드 시 배송비/총액 한 번 자동 계산 (쿠폰 안 골라도 정확한 값 보이게)
updateOrderTotal();
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
