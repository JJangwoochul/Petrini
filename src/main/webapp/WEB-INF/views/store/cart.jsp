<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- 지윤 26.07.08 가격 콤마 표시용 fmt 태그 --%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="pageId" value="store" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%-- 지윤 26.07.08 추가: 상세페이지에서 장바구니 담기 성공 시 이 페이지로 리다이렉트되면서 뜨는 팝업 --%>
<c:if test="${cartAddSuccess}">
<script>alert('장바구니에 상품을 담았습니다.');</script>
</c:if>



<style>
  .cart-wrap{max-width:var(--inner-width);margin:32px auto 80px;padding:0 20px;display:grid;grid-template-columns:1fr 340px;gap:28px;align-items:flex-start}
  .cart-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
  .cart-section-head{display:flex;align-items:center;gap:12px;padding:16px 20px;border-bottom:1px solid var(--border);background:var(--bg-page)}
  .cart-section-head h2{font-size:16px;font-weight:800;color:var(--text-main);margin:0}
  .cart-count{background:var(--primary);color:#fff;font-size:12px;font-weight:700;padding:2px 8px;border-radius:20px}
  .cart-item{display:flex;gap:16px;padding:18px 20px;border-bottom:1px solid var(--border);align-items:center}
  .cart-item:last-child{border-bottom:none}
  .cart-cb{appearance:none;-webkit-appearance:none;width:18px;height:18px;border:1.5px solid var(--border);border-radius:4px;background:#fff;position:relative;cursor:pointer;flex-shrink:0;transition:border-color .15s}
  .cart-cb:checked{border-color:var(--primary)}
  .cart-cb:checked::after{content:"";position:absolute;left:5px;top:1px;width:5px;height:9px;border:solid var(--primary);border-width:0 2px 2px 0;transform:rotate(45deg)}
  .cart-thumb{width:80px;height:80px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .cart-info{flex:1;min-width:0}
  .cart-brand{font-size:12px;color:var(--text-muted);margin-bottom:3px}
  .cart-name{font-size:14px;font-weight:600;color:var(--text-main);margin-bottom:4px}
  .cart-opt{font-size:12px;color:var(--text-muted)}
  .cart-qty-wrap{display:flex;border:1px solid var(--border);border-radius:var(--radius-sm);overflow:hidden;width:100px;flex-shrink:0}
  .cart-qty-wrap button{width:32px;border:none;background:#f5f5f5;font-size:16px;cursor:pointer;color:var(--text-sub)}
  .cart-qty-wrap button:hover{background:var(--primary-light);color:var(--primary)}
  .cart-qty-wrap input{border:none;border-left:1px solid var(--border);border-right:1px solid var(--border);text-align:center;width:36px;font-size:14px}
  .cart-price{font-size:16px;font-weight:800;color:var(--text-main);text-align:right;flex-shrink:0;min-width:90px}
  .cart-del{background:none;border:none;color:var(--text-muted);cursor:pointer;font-size:18px;line-height:1;padding:4px;flex-shrink:0}
  .cart-del:hover{color:var(--accent)}
  .cart-summary{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;position:sticky;top:20px}
  .cart-summary h3{font-size:16px;font-weight:800;margin:0 0 20px;color:var(--text-main)}
  .summary-row{display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;font-size:14px;color:var(--text-sub)}
  .summary-row.total{font-size:16px;font-weight:800;color:var(--text-main);padding-top:14px;border-top:1px solid var(--border);margin-top:14px}
  .summary-row.total span:last-child{color:var(--primary-dark);font-size:20px}
  .btn-order{width:100%;padding:15px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:16px;font-weight:800;cursor:pointer;margin-top:16px;transition:var(--transition)}
  .btn-order:hover{background:var(--primary-dark)}
  .coupon-input{display:flex;gap:8px;margin-top:12px}
  .coupon-input input{flex:1;border:1px solid var(--border);border-radius:var(--radius-sm);padding:8px 12px;font-size:13px;outline:none}
  .coupon-input input:focus{border-color:var(--primary)}
  .coupon-input button{padding:8px 14px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:#fff;color:var(--primary);font-size:13px;font-weight:600;cursor:pointer}
</style>
<div class="cart-wrap">
  <div>
    <div class="cart-section">

   <div class="cart-section-head">
  <input type="checkbox" class="cart-cb" id="checkAll" checked>
  <h2>전체 선택</h2>
  <span class="cart-count">${cartItems.size()}</span>
  <%-- 지윤 26.07.08 추가: 선택삭제(체크된 것만) / 전체삭제(장바구니 통째로) 버튼 --%>
  <div style="margin-left:auto;display:flex;gap:8px;">
    <button type="button" id="btnDeleteSelected" style="background:none;border:1px solid var(--border);border-radius:var(--radius-sm);padding:6px 12px;font-size:13px;color:var(--text-sub);cursor:pointer;">선택 삭제</button>
    <button type="button" id="btnDeleteAll" style="background:none;border:1px solid var(--border);border-radius:var(--radius-sm);padding:6px 12px;font-size:13px;color:var(--text-sub);cursor:pointer;">전체 삭제</button>
  </div>
</div>

      <c:if test="${empty cartItems}">
        <div style="text-align:center;padding:60px 20px;color:var(--text-muted)">장바구니가 비어있습니다.</div>
      </c:if>
      <c:forEach var="item" items="${cartItems}">
        <div class="cart-item" data-price="${item.price}" data-cart-item-id="${item.cartItemId}">
          <input type="checkbox" class="cart-cb" checked>
          <img class="cart-thumb" src="${item.thumbnailUrl}" alt="${item.productName}" onerror="this.src='https://placehold.co/80x80/EAF7F2/2BAB82?text=IMG'">
          <div class="cart-info">
            <div class="cart-brand">${item.brandName}</div>
            <div class="cart-name">${item.productName}</div>
            <div class="cart-opt">
              <c:choose>
                <c:when test="${not empty item.optionColor && item.optionColor != '기본'}">옵션: ${item.optionColor} / ${item.optionSize}</c:when>
                <c:when test="${not empty item.optionSize}">옵션: ${item.optionSize}</c:when>
                <c:otherwise>단일 옵션</c:otherwise>
              </c:choose>
            </div>
          </div>
          <div class="cart-qty-wrap"><button>−</button><input type="number" value="${item.qty}" readonly><button>+</button></div>
          <div class="cart-price"><fmt:formatNumber value="${item.price * item.qty}" pattern="#,###"/>원</div>
          <button class="cart-del">×</button>
        </div>
      </c:forEach>

    </div>
  </div>
  <div class="cart-summary">
    <h3>주문 요약</h3>
    <div class="summary-row"><span>상품 금액</span><span id="sumProduct">98,900원</span></div>
    <%-- 지윤 26.07.09 배송비 무료 고정 텍스트 -> 5만원 기준 실시간 계산으로 변경 --%>
    <div class="summary-row"><span>배송비</span><span id="sumDelivery" style="color:var(--primary);font-weight:700">무료</span></div>
    <div class="summary-row total"><span>총 결제금액</span><span id="sumTotal">98,900원</span></div>
    <button class="btn-order" id="btnOrder">주문하기 (3개)</button>
  </div>
</div>
<script>
  function won(n){ return n.toLocaleString('ko-KR') + '원'; }
  
  //지윤 26.07.09 배송비 계산 추가 (5만원 이상 무료, 미만은 3,000원)
  function recalc(){
    var total = 0, count = 0;
    document.querySelectorAll('.cart-item').forEach(function(item){
      var checked = item.querySelector('.cart-cb').checked;
      var unitPrice = parseInt(item.dataset.price, 10);
      var qty = parseInt(item.querySelector('.cart-qty-wrap input').value, 10);
      var lineTotal = unitPrice * qty;
      item.querySelector('.cart-price').textContent = won(lineTotal);
      if(checked){ total += lineTotal; count++; }
    });
    var deliveryFee = (total === 0 || total >= 50000) ? 0 : 3000;
    document.getElementById('sumProduct').textContent = won(total);
    document.getElementById('sumDelivery').textContent = deliveryFee === 0 ? '무료' : won(deliveryFee);
    document.getElementById('sumTotal').textContent = won(total + deliveryFee);
    var btn = document.getElementById('btnOrder');
    btn.textContent = '주문하기 (' + count + '개)';
    btn.disabled = count === 0;
  }
  
  document.querySelectorAll('.cart-qty-wrap button').forEach(function(btn){
    btn.addEventListener('click', function(){
      var item = this.closest('.cart-item');
      var input = this.parentElement.querySelector('input');
      var val = parseInt(input.value, 10);
      var isPlus = this.textContent.trim() === '+';
      val = isPlus ? val + 1 : Math.max(1, val - 1);
      input.value = val;
      recalc();
  
      fetch('${contextPath}/store/cart/updateQty', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'cartItemId=' + item.dataset.cartItemId + '&qty=' + val
      });
    });
  });
  
  document.querySelectorAll('.cart-cb').forEach(function(cb){
    cb.addEventListener('change', function(){
      if(this.closest('.cart-section-head')){
        var allChecked = this.checked;
        document.querySelectorAll('.cart-item .cart-cb').forEach(function(c){ c.checked = allChecked; });
      }
      recalc();
    });
  });
  
  document.querySelectorAll('.cart-del').forEach(function(btn){
    btn.addEventListener('click', function(){
      var item = this.closest('.cart-item');
      var cartItemId = item.dataset.cartItemId;
      item.remove();
      recalc();
  
      fetch('${contextPath}/store/cart/delete', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'cartItemId=' + cartItemId
      }).then(function(){ refreshCartCount(); });
    });
  });
  
  //지윤 26.07.08 추가: 선택삭제/전체삭제 (체크된 항목 전부 서버에서 삭제 후 화면에서 제거)
  document.getElementById('btnDeleteSelected').addEventListener('click', function(){
    var checkedItems = Array.from(document.querySelectorAll('.cart-item')).filter(function(item){
      return item.querySelector('.cart-cb').checked;
    });
    if (checkedItems.length === 0) {
      alert('삭제할 상품을 선택해주세요.');
      return;
    }
    if (!confirm(checkedItems.length + '개 상품을 삭제하시겠습니까?')) return;
  
    var params = new URLSearchParams();
    checkedItems.forEach(function(item){
      params.append('cartItemIds', item.dataset.cartItemId);
    });
  
   fetch('${contextPath}/store/cart/deleteAll', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: params.toString()
    }).then(function(res){
      if (res.ok) {
        checkedItems.forEach(function(item){ item.remove(); });
        recalc();
      } else {
        alert('삭제에 실패했습니다.');
      }
    });
  });
  
  //지윤 26.07.08 추가: 전체삭제 (체크 여부 상관없이 장바구니에 있는 항목 전부 삭제)
  document.getElementById('btnDeleteAll').addEventListener('click', function(){
    var allItems = Array.from(document.querySelectorAll('.cart-item'));
    if (allItems.length === 0) {
      alert('장바구니가 비어있습니다.');
      return;
    }
    if (!confirm('장바구니를 전체 삭제하시겠습니까?')) return;
  
    var params = new URLSearchParams();
    allItems.forEach(function(item){
      params.append('cartItemIds', item.dataset.cartItemId);
    });
  
    fetch('${contextPath}/store/cart/deleteAll', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: params.toString()
    }).then(function(res){
      if (res.ok) {
        allItems.forEach(function(item){ item.remove(); });
        recalc();
      } else {
        alert('삭제에 실패했습니다.');
      }
    });
  });
  
  //지윤 26.07.09 추가: 주문하기 클릭 시 체크된 장바구니 항목ID들을 파라미터로 넘김
  document.getElementById('btnOrder').addEventListener('click', function () {
    var checkedIds = Array.from(document.querySelectorAll('.cart-item'))
      .filter(function(item){ return item.querySelector('.cart-cb').checked; })
      .map(function(item){ return item.dataset.cartItemId; });
    if (checkedIds.length === 0) {
      alert('주문할 상품을 선택해주세요.');
      return;
    }
    location.href = '${contextPath}/store/order?cartItemIds=' + checkedIds.join(',');
  });
  
  recalc();
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
