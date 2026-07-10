<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
<form id="orderForm" action="${contextPath}/store/payment" method="post">
  <c:forEach var="item" items="${orderItems}">
    <c:choose>
      <c:when test="${not empty item.cartItemId}">
        <input type="hidden" name="cartItemIds" value="${item.cartItemId}">
      </c:when>
      <c:otherwise>
        <input type="hidden" name="productId" value="${item.productId}">
        <input type="hidden" name="optionId" value="${item.optionId}">
        <input type="hidden" name="qty" value="${item.qty}">
      </c:otherwise>
    </c:choose>
  </c:forEach>
  <input type="hidden" name="couponId" id="hiddenCouponId">
  <input type="hidden" name="point" id="hiddenPoint">
  <input type="hidden" name="recvName" id="hiddenRecvName">
  <input type="hidden" name="recvPhone" id="hiddenRecvPhone">
  <input type="hidden" name="zipCode" id="hiddenZipCode">
  <input type="hidden" name="addr1" id="hiddenAddr1">
  <input type="hidden" name="addr2" id="hiddenAddr2">
  <input type="hidden" name="deliveryMemo" id="hiddenDeliveryMemo">

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
      ${item.productName}
      <c:choose>
        <c:when test="${not empty item.optionColor && item.optionColor != '기본'}">
          <span style="color:var(--text-muted); font-weight:500; font-size:13px;"> (${item.optionColor} / ${item.optionSize})</span>
        </c:when>
        <c:when test="${not empty item.optionSize}">
          <span style="color:var(--text-muted); font-weight:500; font-size:13px;"> (${item.optionSize})</span>
        </c:when>
      </c:choose>
      <span style="color:var(--text-muted); font-weight:500; font-size:13px;"> / 수량: ${item.qty}개</span>
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
      <div class="order-form-group"><label>받는 분</label><input type="text" id="recvName" value="${memberInfo.memberName}" placeholder="이름"></div>
      <div class="order-form-group">
        <label>연락처</label>
        <div style="display:flex; gap:6px; align-items:center;">
          <c:set var="phonePrefixVal" value="010" />
          <c:set var="phoneMidVal" value="" />
          <c:set var="phoneEndVal" value="" />
          <c:if test="${not empty memberPhone}">
            <c:set var="phoneParts" value="${fn:split(memberPhone, '-')}" />
            <c:if test="${fn:length(phoneParts) == 3}">
              <c:set var="phonePrefixVal" value="${phoneParts[0]}" />
              <c:set var="phoneMidVal" value="${phoneParts[1]}" />
              <c:set var="phoneEndVal" value="${phoneParts[2]}" />
            </c:if>
          </c:if>
          <select id="phonePrefix" style="width:90px">
            <option value="010" ${phonePrefixVal == '010' ? 'selected' : ''}>010</option>
            <option value="011" ${phonePrefixVal == '011' ? 'selected' : ''}>011</option>
            <option value="016" ${phonePrefixVal == '016' ? 'selected' : ''}>016</option>
            <option value="017" ${phonePrefixVal == '017' ? 'selected' : ''}>017</option>
            <option value="018" ${phonePrefixVal == '018' ? 'selected' : ''}>018</option>
            <option value="019" ${phonePrefixVal == '019' ? 'selected' : ''}>019</option>
          </select>
          <span>-</span>
         <input type="text" id="phoneMid" maxlength="4" value="${phoneMidVal}" placeholder="0000" style="text-align:center; width:70px; flex:none;">
          <span>-</span>
          <input type="text" id="phoneEnd" maxlength="4" value="${phoneEndVal}" placeholder="0000" style="text-align:center; width:70px; flex:none;">
        </div>
      </div>
      <div class="order-form-group full">
        <label>주소</label>
        <div class="addr-row">
        <input type="text" id="orderZipcode" name="orderZipcode" value="${memberZipCode}" placeholder="우편번호" style="max-width:120px" readonly>
        <button type="button" class="addr-btn" id="btnSearchAddr">주소 검색</button>
        </div>
        <input type="text" id="orderAddr1" name="orderAddr1" value="${memberAddr1}" placeholder="기본 주소" style="margin-top:8px" readonly>
        <input type="text" id="orderAddr2" name="orderAddr2" value="${memberAddr2}" placeholder="상세 주소" style="margin-top:8px">
      </div>
    </div>
  </div>

 <div class="order-section">
    <h3>주문 시 요청사항</h3>
    <div class="order-form-grid">
      <div class="order-form-group full">
        <label>배송 메모</label>
        <select id="deliveryMemoSelect" onchange="toggleMemoInput()">
          <option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
          <option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
          <option value="부재 시 연락 부탁드려요">부재 시 연락 부탁드려요</option>
          <option value="배송 전에 연락 주세요">배송 전에 연락 주세요</option>
          <option value="직접입력">직접 입력</option>
        </select>
        <input type="text" id="deliveryMemoCustom" maxlength="50" placeholder="배송 메모를 입력해주세요 (최대 50자)" style="margin-top:8px; display:none;">
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
        <label>보유 포인트 <fmt:formatNumber value="${memberPoint}" pattern="#,###"/>P</label>
        <div style="display:flex;gap:8px">
          <input type="number" id="pointInput" placeholder="사용할 포인트 입력" value="0" min="0" style="flex:1" onchange="updateOrderTotal()">
          <button type="button" id="btnUseAllPoint" class="addr-btn">최대사용</button>
        </div>
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
    <button class="btn-pay" onclick="goToPayment()">결제수단 선택하기</button>
  </div>
</form>
</div>

<!-- 카카오 우편번호 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>

//지윤 26.07.09 추가: 쿠폰/포인트 선택 시 결제 예정 금액 실시간 계산
var PRODUCT_TOTAL = ${productTotal};
var MEMBER_POINT = ${memberPoint};
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
  //지윤 26.07.10 추가: 보유포인트와 결제금액(상품+배송비) 중 작은 값 넘지 못하게 제한
  var maxUsablePoint = Math.min(MEMBER_POINT, PRODUCT_TOTAL + deliveryFee);
  if (pointUsed > maxUsablePoint) {
    pointUsed = maxUsablePoint;
    pointInput.value = pointUsed;
  }

  var totalDiscount = couponDiscount + pointUsed;
  var finalTotal = PRODUCT_TOTAL + deliveryFee - totalDiscount;
  if (finalTotal < 0) finalTotal = 0;

  document.getElementById('orderDeliveryFee').textContent = deliveryFee === 0 ? '무료' : won(deliveryFee);
  document.getElementById('orderDiscount').textContent = '-' + won(totalDiscount);
  document.getElementById('orderFinalTotal').textContent = won(finalTotal);
}

//지윤 26.07.10 추가: 보유포인트 "최대사용" <-> "사용취소" 토글 버튼
document.getElementById('btnUseAllPoint').addEventListener('click', function () {
  var btn = this;
  var pointInput = document.getElementById('pointInput');

  if (btn.textContent === '최대사용') {
    var deliveryFee = (PRODUCT_TOTAL === 0 || PRODUCT_TOTAL >= 50000) ? 0 : 3000;
    var paymentAmount = PRODUCT_TOTAL + deliveryFee;
    var maxUsable = Math.min(MEMBER_POINT, paymentAmount);
    pointInput.value = maxUsable;
    btn.textContent = '사용취소';
  } else {
    pointInput.value = 0;
    btn.textContent = '최대사용';
  }
  updateOrderTotal();
});

//지윤 26.07.10 추가: 주문결제화면 연락처는 숫자만 입력, 4자리 채우면 다음 칸으로 자동 이동
document.getElementById('phoneMid').addEventListener('input', function () {
  this.value = this.value.replace(/[^0-9]/g, '');
  if (this.value.length >= 4) document.getElementById('phoneEnd').focus();
});
document.getElementById('phoneEnd').addEventListener('input', function () {
  this.value = this.value.replace(/[^0-9]/g, '');
});

//지윤 26.07.10 추가: 결제 진행 전 배송지 필수 항목 검증
function goToPayment() {
  var recvName = document.getElementById('recvName').value.trim();
  if (recvName === '') {
    alert('받는 분 이름을 입력해주세요.');
    return;
  }
  var prefix = document.getElementById('phonePrefix').value;
  var mid = document.getElementById('phoneMid').value;
  var end = document.getElementById('phoneEnd').value;
  if (mid.length !== 4 || end.length !== 4) {
    alert('휴대전화번호를 정확히 입력해주세요.');
    return;
  }
  var zipCode = document.getElementById('orderZipcode').value.trim();
  if (zipCode === '') {
    alert('우편번호를 입력해주세요. (주소 검색 버튼을 눌러주세요)');
    return;
  }
  var addr1 = document.getElementById('orderAddr1').value.trim();
  if (addr1 === '') {
    alert('기본 주소를 입력해주세요.');
    return;
  }
  var memoSelect = document.getElementById('deliveryMemoSelect');
  var memo = memoSelect.value === '직접입력'
      ? document.getElementById('deliveryMemoCustom').value.trim()
      : memoSelect.value;
  var couponSel = document.getElementById('couponSelect');

  document.getElementById('hiddenCouponId').value = couponSel.value;
  document.getElementById('hiddenPoint').value = document.getElementById('pointInput').value || 0;
  document.getElementById('hiddenRecvName').value = recvName;
  document.getElementById('hiddenRecvPhone').value = prefix + '-' + mid + '-' + end;
  document.getElementById('hiddenZipCode').value = zipCode;
  document.getElementById('hiddenAddr1').value = addr1;
  document.getElementById('hiddenAddr2').value = document.getElementById('orderAddr2').value.trim();
  document.getElementById('hiddenDeliveryMemo').value = memo;
  document.getElementById('orderForm').submit();
}

//지윤 26.07.10 추가: 배송메모 "직접입력" 선택 시 텍스트박스 보이기/숨기기
function toggleMemoInput() {
  var select = document.getElementById('deliveryMemoSelect');
  var customInput = document.getElementById('deliveryMemoCustom');
  if (select.value === '직접입력') {
    customInput.style.display = 'block';
    customInput.focus();
  } else {
    customInput.style.display = 'none';
    customInput.value = '';
  }
}

//지윤 26.07.09 추가: 페이지 로드 시 배송비/총액 한 번 자동 계산 (쿠폰 안 골라도 정확한 값 보이게)
updateOrderTotal();

// 주소 검색 (카카오/다음 우편번호 API)
document.getElementById('btnSearchAddr').addEventListener('click', function () {
  if (typeof daum === 'undefined' || !daum.Postcode) {
    alert('주소 검색 API를 불러오지 못했습니다.');
    return;
  }
  new daum.Postcode({
    oncomplete: function (data) {
      var addr = '';
      var extraAddr = '';
      if (data.userSelectedType === 'R') {
        addr = data.roadAddress;
        if (data.bname !== '') {
          extraAddr += data.bname;
        }
        if (data.buildingName !== '') {
          extraAddr += (extraAddr ? ', ' : '') + data.buildingName;
        }
        if (extraAddr !== '') {
          extraAddr = ' (' + extraAddr + ')';
        }
      } else {
        addr = data.jibunAddress;
      }
      document.getElementById('orderZipcode').value = data.zonecode;
      document.getElementById('orderAddr1').value = addr + extraAddr;
      document.getElementById('orderAddr2').focus();
    }
  }).open();
});
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
