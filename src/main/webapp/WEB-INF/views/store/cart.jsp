<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
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
        <input type="checkbox" class="cart-cb" checked>
        <h2>장바구니</h2>
        <span class="cart-count">3</span>
      </div>
      <div class="cart-item" data-price="48900">
        <input type="checkbox" class="cart-cb" checked>
        <img class="cart-thumb" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=160&q=70&auto=format&fit=crop" alt="사료" onerror="this.src='https://placehold.co/80x80/EAF7F2/2BAB82?text=IMG'">
        <div class="cart-info">
          <div class="cart-brand">로얄캐닌</div>
          <div class="cart-name">미디엄 어덜트 사료 4kg</div>
          <div class="cart-opt">옵션: 4kg</div>
        </div>
        <div class="cart-qty-wrap"><button>−</button><input type="number" value="1" readonly><button>+</button></div>
        <div class="cart-price">48,900원</div>
        <button class="cart-del">×</button>
      </div>
      <div class="cart-item" data-price="18500">
        <input type="checkbox" class="cart-cb" checked>
        <img class="cart-thumb" src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=160&q=70&auto=format&fit=crop" alt="장난감" onerror="this.src='https://placehold.co/80x80/EAF7F2/2BAB82?text=IMG'">
        <div class="cart-info">
          <div class="cart-brand">PetPlay</div>
          <div class="cart-name">노즈워크 매트 오렌지</div>
          <div class="cart-opt">단일 옵션</div>
        </div>
        <div class="cart-qty-wrap"><button>−</button><input type="number" value="2" readonly><button>+</button></div>
        <div class="cart-price">37,000원</div>
        <button class="cart-del">×</button>
      </div>
      <div class="cart-item" data-price="13000">
        <input type="checkbox" class="cart-cb" checked>
        <img class="cart-thumb" src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=160&q=70&auto=format&fit=crop" alt="간식" onerror="this.src='https://placehold.co/80x80/EAF7F2/2BAB82?text=IMG'">
        <div class="cart-info">
          <div class="cart-brand">냥냥</div>
          <div class="cart-name">수제 져키 트릿 200g</div>
          <div class="cart-opt">단일 옵션</div>
        </div>
        <div class="cart-qty-wrap"><button>−</button><input type="number" value="1" readonly><button>+</button></div>
        <div class="cart-price">13,000원</div>
        <button class="cart-del">×</button>
      </div>
    </div>
  </div>
  <div class="cart-summary">
    <h3>주문 요약</h3>
    <div class="summary-row"><span>상품 금액</span><span id="sumProduct">98,900원</span></div>
    <div class="summary-row"><span>배송비</span><span style="color:var(--primary);font-weight:700">무료</span></div>
    <div class="summary-row"><span>쿠폰 할인</span><span style="color:var(--accent)">-0원</span></div>
    <div class="coupon-input"><input type="text" placeholder="쿠폰 코드 입력"><button>적용</button></div>
    <div class="summary-row total"><span>총 결제금액</span><span id="sumTotal">98,900원</span></div>
    <button class="btn-order" id="btnOrder" onclick="location.href='${contextPath}/store/order'">주문하기 (3개)</button>
  </div>
</div>
<script>
function won(n){ return n.toLocaleString('ko-KR') + '원'; }

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
  document.getElementById('sumProduct').textContent = won(total);
  document.getElementById('sumTotal').textContent = won(total);
  var btn = document.getElementById('btnOrder');
  btn.textContent = '주문하기 (' + count + '개)';
  btn.disabled = count === 0;
}

document.querySelectorAll('.cart-qty-wrap button').forEach(function(btn){
  btn.addEventListener('click', function(){
    var input = this.parentElement.querySelector('input');
    var val = parseInt(input.value, 10);
    var isPlus = this.textContent.trim() === '+';
    val = isPlus ? val + 1 : Math.max(1, val - 1);
    input.value = val;
    recalc();
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
    this.closest('.cart-item').remove();
    recalc();
  });
});

recalc();
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
