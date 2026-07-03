<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="orders" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 7/3, 사업자(쇼핑몰) 주문 관리 UI 구성 — 스토리보드(Biz_Order_Manage + Biz_Order_Detail) 기준,
     상품관리(products.jsp)와 동일하게 목록+상세를 한 화면 안에서 토글로 처리 --%>
<style>
  .order-detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:24px;padding:20px}
  .order-detail-grid h4{font-size:13px;font-weight:700;color:#1A1A2E;margin:0 0 10px}
  .order-info-row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #F0F2F0;font-size:13px}
  .order-info-row span:first-child{color:#999}
  .order-info-row span:last-child{color:#1A1A2E;font-weight:600}
  .order-ship-manage{display:flex;flex-direction:column;gap:10px;margin-top:14px}
  .order-ship-manage label{font-size:12px;color:#666;display:block;margin-bottom:4px}
  .order-ship-manage select,.order-ship-manage input{width:100%;border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px}
  .order-items-table{padding:0 20px 20px}
  .order-total-row{display:flex;justify-content:flex-end;gap:16px;padding:14px 4px;font-size:14px;font-weight:700;color:#1A1A2E;border-top:1px solid var(--biz-border)}
  .order-detail-actions{display:flex;justify-content:center;gap:10px;padding:0 20px 20px}
  .order-detail-actions .biz-btn-primary{min-width:120px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">주문 관리</h1>
    <p class="biz-page-desc">주문 확인·출고 처리·취소/반품 처리</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div style="padding:20px 20px 0">
      <div class="biz-tabs">
        <button type="button" class="biz-tab active" data-tab="all" onclick="switchTab('all')">전체<span class="biz-tab-count" id="cntAll"></span></button>
        <button type="button" class="biz-tab" data-tab="paid" onclick="switchTab('paid')">결제완료<span class="biz-tab-count" id="cntPaid"></span></button>
        <button type="button" class="biz-tab" data-tab="ready" onclick="switchTab('ready')">배송준비<span class="biz-tab-count" id="cntReady"></span></button>
        <button type="button" class="biz-tab" data-tab="shipping" onclick="switchTab('shipping')">배송중<span class="biz-tab-count" id="cntShipping"></span></button>
        <button type="button" class="biz-tab" data-tab="done" onclick="switchTab('done')">배송완료<span class="biz-tab-count" id="cntDone"></span></button>
        <button type="button" class="biz-tab" data-tab="cancel" onclick="switchTab('cancel')">취소/반품<span class="biz-tab-count" id="cntCancel"></span></button>
      </div>
    </div>

    <table class="biz-table">
      <thead><tr><th>주문번호</th><th>구매자</th><th>상품명</th><th>결제금액</th><th>상태</th><th>관리</th></tr></thead>
      <tbody id="orderBody"></tbody>
    </table>
  </div>

  <div class="biz-card" id="detailCard" style="display:none">
    <div class="biz-card-head"><span>주문 상세정보</span></div>

    <div class="order-detail-grid">
      <div>
        <h4>주문 정보</h4>
        <div class="order-info-row"><span>주문번호</span><span id="dOrderNo"></span></div>
        <div class="order-info-row"><span>주문일</span><span id="dOrderDate"></span></div>
        <div class="order-info-row"><span>구매자</span><span id="dBuyer"></span></div>
        <div class="order-info-row"><span>연락처</span><span id="dPhone"></span></div>
        <div class="order-info-row"><span>이메일</span><span id="dEmail"></span></div>
        <div class="order-info-row"><span>결제금액</span><span id="dPayAmount"></span></div>
        <div class="order-info-row"><span>결제방법</span><span id="dPayMethod"></span></div>
        <div class="order-info-row"><span>주문상태</span><span id="dStatusLabel"></span></div>
      </div>

      <div>
        <h4>배송 정보</h4>
        <div class="order-info-row"><span>수령인</span><span id="dReceiver"></span></div>
        <div class="order-info-row"><span>연락처</span><span id="dReceiverPhone"></span></div>
        <div class="order-info-row"><span>배송지</span><span id="dAddress"></span></div>
        <div class="order-info-row"><span>배송메모</span><span id="dMemo"></span></div>

        <div class="order-ship-manage">
          <div>
            <label>주문상태</label>
            <select id="dStatusSelect">
              <option value="paid">결제완료</option>
              <option value="ready">배송준비</option>
              <option value="shipping">배송중</option>
              <option value="done">배송완료</option>
              <option value="cancel">취소/반품</option>
            </select>
          </div>
          <div>
            <label>택배사</label>
            <select id="dCarrier">
              <option value="">선택 안 함</option>
              <option value="cj">CJ대한통운</option>
              <option value="hanjin">한진택배</option>
              <option value="lotte">롯데택배</option>
              <option value="post">우체국택배</option>
            </select>
          </div>
          <div>
            <label>송장번호</label>
            <input type="text" id="dTrackingNo" placeholder="송장번호를 입력하세요">
          </div>
        </div>
      </div>
    </div>

    <div class="order-items-table">
      <table class="biz-table">
        <thead><tr><th>상품명</th><th>옵션</th><th>수량</th><th>상품금액</th><th>합계</th></tr></thead>
        <tbody id="orderItemsBody"></tbody>
      </table>
      <div class="order-total-row">
        <span>총 결제금액</span>
        <span id="dTotalAmount"></span>
      </div>
    </div>

    <div class="order-detail-actions">
      <button type="button" class="biz-btn-ghost" onclick="closeDetail()">이전 목록으로</button>
      <button type="button" class="biz-btn-primary" onclick="saveStatus()">상태변경</button>
    </div>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var statusLabel = { paid:'결제완료', ready:'배송준비', shipping:'배송중', done:'배송완료', cancel:'취소/반품' };
  var statusBadgeClass = { paid:'bs-wait', ready:'bs-empty', shipping:'bs-ready', done:'bs-done', cancel:'bs-cancel' };

  var orders = [
    { id:'ORD-2026-0892', buyer:'홍길동', phone:'010-1234-5678', email:'hong@example.com', date:'2026-07-01 14:30', payMethod:'신용카드', status:'paid',
      receiver:'홍길동', receiverPhone:'010-1234-5678', address:'서울시 강남구 역삼로 123, 101동 1004호', memo:'부재 시 경비실에 맡겨주세요.', carrier:'', trackingNo:'',
      items:[ { name:'로얄캐닌 인도어 사료', option:'4kg', qty:1, price:29900 } ], total:29900 },
    { id:'ORD-2026-0891', buyer:'김민지', phone:'010-2222-3333', email:'minji@example.com', date:'2026-07-01 10:12', payMethod:'카카오페이', status:'ready',
      receiver:'김민지', receiverPhone:'010-2222-3333', address:'경기도 성남시 분당구 판교로 45', memo:'', carrier:'', trackingNo:'',
      items:[ { name:'수제 닭가슴살 져키', option:'200g', qty:2, price:8500 } ], total:17000 },
    { id:'ORD-2026-0890', buyer:'박지호', phone:'010-4444-5555', email:'jiho@example.com', date:'2026-06-30 18:44', payMethod:'신용카드', status:'shipping',
      receiver:'박지호', receiverPhone:'010-4444-5555', address:'인천시 연수구 송도과학로 12', memo:'문 앞에 놔주세요.', carrier:'cj', trackingNo:'651234567890',
      items:[ { name:'H형 하네스 블루', option:'M', qty:1, price:22000 } ], total:22000 },
    { id:'ORD-2026-0889', buyer:'최유나', phone:'010-6666-7777', email:'yuna@example.com', date:'2026-06-29 09:20', payMethod:'무통장입금', status:'done',
      receiver:'최유나', receiverPhone:'010-6666-7777', address:'부산시 해운대구 우동 55', memo:'', carrier:'hanjin', trackingNo:'482910384710',
      items:[ { name:'노즈워크 매트 오렌지', option:'L', qty:1, price:18500 } ], total:18500 },
    { id:'ORD-2026-0888', buyer:'정하율', phone:'010-8888-9999', email:'hayul@example.com', date:'2026-06-27 20:05', payMethod:'신용카드', status:'cancel',
      receiver:'정하율', receiverPhone:'010-8888-9999', address:'대전시 서구 둔산로 20', memo:'단순 변심으로 반품 요청', carrier:'', trackingNo:'',
      items:[ { name:'고양이 모래', option:'10L', qty:1, price:15000 } ], total:15000 }
  ];

  var currentTab = 'all';

  function fmtWon(n){ return n.toLocaleString('ko-KR') + '원'; }

  function switchTab(tab) {
    currentTab = tab;
    document.querySelectorAll('.biz-tab').forEach(function (b) { b.classList.toggle('active', b.dataset.tab === tab); });
    closeDetail();
    render();
  }

  function openDetail(id) {
    var o = orders.find(function (x) { return x.id === id; });
    if (!o) return;

    document.getElementById('dOrderNo').textContent    = o.id;
    document.getElementById('dOrderDate').textContent  = o.date;
    document.getElementById('dBuyer').textContent      = o.buyer;
    document.getElementById('dPhone').textContent      = o.phone;
    document.getElementById('dEmail').textContent      = o.email;
    document.getElementById('dPayAmount').textContent  = fmtWon(o.total);
    document.getElementById('dPayMethod').textContent  = o.payMethod;
    document.getElementById('dStatusLabel').textContent = statusLabel[o.status];

    document.getElementById('dReceiver').textContent      = o.receiver;
    document.getElementById('dReceiverPhone').textContent = o.receiverPhone;
    document.getElementById('dAddress').textContent       = o.address;
    document.getElementById('dMemo').textContent          = o.memo || '-';

    document.getElementById('dStatusSelect').value = o.status;
    document.getElementById('dCarrier').value       = o.carrier || '';
    document.getElementById('dTrackingNo').value    = o.trackingNo || '';
    document.getElementById('dTrackingNo').dataset.orderId = o.id;

    var itemsBody = document.getElementById('orderItemsBody');
    itemsBody.innerHTML = '';
    o.items.forEach(function (it) {
      var tr = document.createElement('tr');
      var sum = it.qty * it.price;
      tr.innerHTML =
        '<td>' + it.name + '</td>' +
        '<td>' + it.option + '</td>' +
        '<td>' + it.qty + '개</td>' +
        '<td>' + fmtWon(it.price) + '</td>' +
        '<td>' + fmtWon(sum) + '</td>';
      itemsBody.appendChild(tr);
    });
    document.getElementById('dTotalAmount').textContent = fmtWon(o.total);

    document.getElementById('detailCard').style.display = 'block';
    document.getElementById('detailCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function closeDetail() {
    document.getElementById('detailCard').style.display = 'none';
  }

  function saveStatus() {
    var id = document.getElementById('dTrackingNo').dataset.orderId;
    var o = orders.find(function (x) { return x.id === id; });
    if (!o) return;

    o.status     = document.getElementById('dStatusSelect').value;
    o.carrier    = document.getElementById('dCarrier').value;
    o.trackingNo = document.getElementById('dTrackingNo').value.trim();

    closeDetail();
    render();
    showToast('주문 상태가 변경되었습니다.');
  }

  function showToast(msg) {
    document.getElementById('saveToastMsg').textContent = msg;
    var toast = document.getElementById('saveToast');
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2000);
  }

  function render() {
    var list = orders.filter(function (o) { return currentTab === 'all' || o.status === currentTab; });

    document.getElementById('cntAll').textContent      = orders.length;
    document.getElementById('cntPaid').textContent     = orders.filter(function (o) { return o.status === 'paid'; }).length;
    document.getElementById('cntReady').textContent    = orders.filter(function (o) { return o.status === 'ready'; }).length;
    document.getElementById('cntShipping').textContent = orders.filter(function (o) { return o.status === 'shipping'; }).length;
    document.getElementById('cntDone').textContent     = orders.filter(function (o) { return o.status === 'done'; }).length;
    document.getElementById('cntCancel').textContent   = orders.filter(function (o) { return o.status === 'cancel'; }).length;

    var body = document.getElementById('orderBody');
    body.innerHTML = '';

    if (list.length === 0) {
      body.innerHTML = '<tr><td colspan="6" style="text-align:center;color:#999;padding:24px 0">해당하는 주문이 없습니다.</td></tr>';
      return;
    }

    list.forEach(function (o) {
      var productSummary = o.items.map(function (it) { return it.name; }).join(', ');
      if (o.items.length > 1) productSummary += ' 외 ' + (o.items.length - 1) + '건';

      var tr = document.createElement('tr');
      tr.innerHTML =
        '<td>#' + o.id + '</td>' +
        '<td>' + o.buyer + '</td>' +
        '<td>' + productSummary + '</td>' +
        '<td>' + fmtWon(o.total) + '</td>' +
        '<td><span class="bs-badge ' + statusBadgeClass[o.status] + '">' + statusLabel[o.status] + '</span></td>' +
        '<td><button class="biz-btn" onclick="openDetail(\'' + o.id + '\')">상세</button></td>';
      body.appendChild(tr);
    });
  }

  render();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>