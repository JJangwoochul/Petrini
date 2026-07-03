<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="delivery" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 7/3, 사업자(쇼핑몰) 배송 관리 UI 구성 — 스토리보드 없어서 신규 설계.
     주문관리(orders.jsp)와 역할 분리: 주문관리=개별 주문 처리, 배송관리=택배사/송장번호 중심 일괄 처리 --%>
<style>
  .dlv-summary{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:16px}
  .dlv-summary-card{background:#fff;border:1px solid var(--biz-border);border-radius:12px;padding:16px 18px}
  .dlv-summary-card .label{font-size:12px;color:#888;margin-bottom:6px}
  .dlv-summary-card .val{font-size:22px;font-weight:800;color:#1A1A2E}
  .dlv-summary-card .val span{font-size:13px;font-weight:600;color:#888;margin-left:2px}
  .dlv-summary-card.warn .val{color:#E24B4A}

  .dlv-filter{display:flex;flex-wrap:wrap;align-items:center;gap:10px;padding:18px 20px}
  .dlv-filter select,.dlv-filter input{border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px;color:#333}
  .dlv-filter .btn-search{background:var(--biz-primary);color:#fff;border:none;border-radius:8px;padding:9px 18px;font-size:13px;font-weight:700;cursor:pointer}
  .dlv-filter .btn-reset{background:#fff;border:1px solid var(--biz-border);border-radius:8px;padding:9px 16px;font-size:13px;font-weight:600;color:#555;cursor:pointer}
  .dlv-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}

  .dlv-bulk-box{padding:20px}
  .dlv-bulk-box textarea{width:100%;min-height:120px;border:1px solid var(--biz-border);border-radius:8px;padding:10px;font-size:13px;font-family:monospace}
  .dlv-bulk-hint{font-size:12px;color:#888;margin:6px 0 14px}
  .dlv-bulk-actions{display:flex;justify-content:flex-end;gap:8px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">배송 관리(임시)</h1>
    <p class="biz-page-desc">택배사·송장번호를 등록하고 배송 현황을 추적하세요.</p>
  </div>

  <div class="dlv-summary">
    <div class="dlv-summary-card"><div class="label">배송준비</div><div class="val" id="sumReady">0<span>건</span></div></div>
    <div class="dlv-summary-card"><div class="label">배송중</div><div class="val" id="sumShipping">0<span>건</span></div></div>
    <div class="dlv-summary-card"><div class="label">배송완료</div><div class="val" id="sumDone">0<span>건</span></div></div>
    <div class="dlv-summary-card warn"><div class="label">배송지연 (3일 이상 배송중)</div><div class="val" id="sumDelay">0<span>건</span></div></div>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="dlv-filter">
      <select id="fCarrier">
        <option value="all">택배사 전체</option>
        <option value="cj">CJ대한통운</option>
        <option value="hanjin">한진택배</option>
        <option value="lotte">롯데택배</option>
        <option value="post">우체국택배</option>
      </select>
      <select id="fStatus">
        <option value="all">배송상태 전체</option>
        <option value="ready">배송준비</option>
        <option value="shipping">배송중</option>
        <option value="done">배송완료</option>
      </select>
      <input type="text" id="fKeyword" placeholder="주문번호 또는 구매자명">
      <button class="btn-search" onclick="applyFilter()">검색</button>
      <button class="btn-reset" onclick="resetFilter()">초기화</button>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="dlv-table-head">
      <div class="biz-card-head" style="padding:20px 0 12px"><span>배송 목록</span><small>총 <span id="totalCount">0</span>건</small></div>
      <button type="button" class="biz-btn-primary" onclick="openBulk()">+ 송장 일괄등록</button>
    </div>
    <table class="biz-table">
      <thead><tr><th>주문번호</th><th>구매자</th><th>택배사</th><th>송장번호</th><th>상태</th><th>발송일</th><th>관리</th></tr></thead>
      <tbody id="dlvBody"></tbody>
    </table>
  </div>

  <div class="biz-card" id="bulkCard" style="display:none">
    <div class="biz-card-head"><span>송장 일괄등록</span></div>
    <div class="dlv-bulk-box">
      <p class="dlv-bulk-hint">한 줄에 하나씩, <b>주문번호,택배사코드,송장번호</b> 형식으로 입력하세요. 택배사코드: cj / hanjin / lotte / post<br>예) ORD-2026-0892,cj,651234567890</p>
      <textarea id="bulkText" placeholder="ORD-2026-0892,cj,651234567890&#10;ORD-2026-0891,hanjin,482910384710"></textarea>
      <div class="dlv-bulk-actions">
        <button type="button" class="biz-btn-ghost" onclick="closeBulk()">취소</button>
        <button type="button" class="biz-btn-primary" onclick="submitBulk()">일괄 등록</button>
      </div>
    </div>
  </div>

  <div class="biz-card" id="editCard" style="display:none">
    <div class="biz-card-head"><span>송장 수정</span></div>
    <form style="padding:20px;max-width:480px">
      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>주문번호</label>
          <input type="text" id="eOrderNo" readonly style="background:#FAFBFA">
        </div>
        <div class="biz-form-row">
          <label>배송상태<span class="req">*</span></label>
          <select id="eStatus">
            <option value="ready">배송준비</option>
            <option value="shipping">배송중</option>
            <option value="done">배송완료</option>
          </select>
        </div>
        <div class="biz-form-row">
          <label>택배사<span class="req">*</span></label>
          <select id="eCarrier">
            <option value="cj">CJ대한통운</option>
            <option value="hanjin">한진택배</option>
            <option value="lotte">롯데택배</option>
            <option value="post">우체국택배</option>
          </select>
        </div>
        <div class="biz-form-row">
          <label>송장번호<span class="req">*</span></label>
          <input type="text" id="eTrackingNo" placeholder="송장번호를 입력하세요">
        </div>
      </div>
      <div class="dlv-bulk-actions" style="margin-top:16px">
        <button type="button" class="biz-btn-ghost" onclick="closeEdit()">취소</button>
        <button type="button" class="biz-btn-primary" onclick="submitEdit()">저장</button>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var carrierLabel = { cj:'CJ대한통운', hanjin:'한진택배', lotte:'롯데택배', post:'우체국택배' };
  var statusLabel  = { ready:'배송준비', shipping:'배송중', done:'배송완료' };

  var deliveries = [
    { orderNo:'ORD-2026-0892', buyer:'홍길동', carrier:'',       trackingNo:'',             status:'ready',    shipDate:'' },
    { orderNo:'ORD-2026-0891', buyer:'김민지', carrier:'',       trackingNo:'',             status:'ready',    shipDate:'' },
    { orderNo:'ORD-2026-0890', buyer:'박지호', carrier:'cj',     trackingNo:'651234567890', status:'shipping', shipDate:'2026-06-28' },
    { orderNo:'ORD-2026-0889', buyer:'최유나', carrier:'hanjin', trackingNo:'482910384710', status:'done',     shipDate:'2026-06-27' },
    { orderNo:'ORD-2026-0887', buyer:'오세훈', carrier:'lotte',  trackingNo:'392910485710', status:'shipping', shipDate:'2026-06-25' }
  ];

  var filtered = deliveries.slice();

  function applyFilter() {
    var carrier = document.getElementById('fCarrier').value;
    var status = document.getElementById('fStatus').value;
    var keyword = document.getElementById('fKeyword').value.trim();

    filtered = deliveries.filter(function (d) {
      var matchCarrier = carrier === 'all' || d.carrier === carrier;
      var matchStatus = status === 'all' || d.status === status;
      var matchKeyword = !keyword || d.orderNo.indexOf(keyword) !== -1 || d.buyer.indexOf(keyword) !== -1;
      return matchCarrier && matchStatus && matchKeyword;
    });
    render();
  }

  function resetFilter() {
    document.getElementById('fCarrier').value = 'all';
    document.getElementById('fStatus').value = 'all';
    document.getElementById('fKeyword').value = '';
    filtered = deliveries.slice();
    render();
  }

  function isDelayed(d) {
    if (d.status !== 'shipping' || !d.shipDate) return false;
    var shipped = new Date(d.shipDate);
    var diffDays = Math.floor((new Date() - shipped) / (1000 * 60 * 60 * 24));
    return diffDays >= 3;
  }

  function openBulk() {
    document.getElementById('bulkCard').style.display = 'block';
    document.getElementById('editCard').style.display = 'none';
    document.getElementById('bulkCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  function closeBulk() {
    document.getElementById('bulkCard').style.display = 'none';
    document.getElementById('bulkText').value = '';
  }

  function submitBulk() {
    var lines = document.getElementById('bulkText').value.trim().split('\n');
    var okCount = 0, failLines = [];

    lines.forEach(function (line) {
      line = line.trim();
      if (!line) return;
      var parts = line.split(',').map(function (s) { return s.trim(); });
      if (parts.length !== 3) { failLines.push(line); return; }

      var d = deliveries.find(function (x) { return x.orderNo === parts[0]; });
      if (!d || !carrierLabel[parts[1]]) { failLines.push(line); return; }

      d.carrier = parts[1];
      d.trackingNo = parts[2];
      d.status = 'shipping';
      d.shipDate = todayStr();
      okCount++;
    });

    closeBulk();
    filtered = deliveries.slice();
    render();

    if (failLines.length > 0) {
      alert(okCount + '건 등록 완료, ' + failLines.length + '건은 형식이 맞지 않아 실패했습니다:\n' + failLines.join('\n'));
    } else {
      showToast(okCount + '건의 송장이 등록되었습니다.');
    }
  }

  function openEdit(orderNo) {
    var d = deliveries.find(function (x) { return x.orderNo === orderNo; });
    if (!d) return;

    document.getElementById('eOrderNo').value = d.orderNo;
    document.getElementById('eStatus').value = d.status;
    document.getElementById('eCarrier').value = d.carrier || 'cj';
    document.getElementById('eTrackingNo').value = d.trackingNo;

    document.getElementById('bulkCard').style.display = 'none';
    document.getElementById('editCard').style.display = 'block';
    document.getElementById('editCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  function closeEdit() {
    document.getElementById('editCard').style.display = 'none';
  }

  function submitEdit() {
    var orderNo = document.getElementById('eOrderNo').value;
    var trackingNo = document.getElementById('eTrackingNo').value.trim();
    if (!trackingNo) { alert('송장번호를 입력해주세요.'); return; }

    var d = deliveries.find(function (x) { return x.orderNo === orderNo; });
    d.status = document.getElementById('eStatus').value;
    d.carrier = document.getElementById('eCarrier').value;
    d.trackingNo = trackingNo;
    if (!d.shipDate) d.shipDate = todayStr();

    closeEdit();
    filtered = deliveries.slice();
    render();
    showToast('송장 정보가 수정되었습니다.');
  }

  function todayStr() {
    var d = new Date();
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  }

  function showToast(msg) {
    document.getElementById('saveToastMsg').textContent = msg;
    var toast = document.getElementById('saveToast');
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2000);
  }

  function render() {
    document.getElementById('totalCount').textContent = filtered.length;
    document.getElementById('sumReady').textContent    = deliveries.filter(function (d) { return d.status === 'ready'; }).length;
    document.getElementById('sumShipping').textContent = deliveries.filter(function (d) { return d.status === 'shipping'; }).length;
    document.getElementById('sumDone').textContent      = deliveries.filter(function (d) { return d.status === 'done'; }).length;
    document.getElementById('sumDelay').textContent     = deliveries.filter(isDelayed).length;

    var body = document.getElementById('dlvBody');
    body.innerHTML = '';

    if (filtered.length === 0) {
      body.innerHTML = '<tr><td colspan="7" style="text-align:center;color:#999;padding:24px 0">해당하는 배송 건이 없습니다.</td></tr>';
      return;
    }

    filtered.forEach(function (d) {
      var delayTag = isDelayed(d) ? ' <span class="bs-badge bs-cancel" style="margin-left:4px">지연</span>' : '';
      var tr = document.createElement('tr');
      tr.innerHTML =
        '<td>#' + d.orderNo + '</td>' +
        '<td>' + d.buyer + '</td>' +
        '<td>' + (d.carrier ? carrierLabel[d.carrier] : '-') + '</td>' +
        '<td>' + (d.trackingNo || '-') + '</td>' +
        '<td><span class="bs-badge bs-empty">' + statusLabel[d.status] + '</span>' + delayTag + '</td>' +
        '<td>' + (d.shipDate || '-') + '</td>' +
        '<td><button class="biz-btn" onclick="openEdit(\'' + d.orderNo + '\')">' + (d.trackingNo ? '수정' : '송장등록') + '</button></td>';
      body.appendChild(tr);
    });
  }

  render();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>