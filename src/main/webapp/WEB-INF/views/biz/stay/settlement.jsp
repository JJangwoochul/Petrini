<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="settlement" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<%-- 7/3, 사업자(숙박) 정산 내역 UI 구성 — 스토어 settlement.jsp와 동일 구조, 정산 방식: 플랫폼 매입 정산(방식1)
     - 체크아웃 완료 전까지는 "정산예정", 체크아웃 완료 후 정산배치 처리되면 "정산완료" --%>
<style>
  .settle-summary{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:16px}
  .settle-summary-card{background:#fff;border:1px solid var(--biz-border);border-radius:12px;padding:16px 18px}
  .settle-summary-card .label{font-size:12px;color:#888;margin-bottom:6px}
  .settle-summary-card .val{font-size:22px;font-weight:800;color:#1A1A2E}
  .settle-summary-card .val span{font-size:13px;font-weight:600;color:#888;margin-left:2px}
  .settle-summary-card.fee .val{color:#E24B4A}

  .settle-filter{display:flex;flex-wrap:wrap;align-items:center;gap:10px;padding:18px 20px}
  .settle-filter select{border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px;color:#333}

  .settle-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">정산 내역</h1>
    <p class="biz-page-desc">일별·월별 매출 및 지급 내역을 확인하세요.</p>
  </div>

  <div class="settle-summary">
    <div class="settle-summary-card">
      <div class="label">정산 예정액 (체크아웃 대기중)</div>
      <div class="val" id="sumPending">0<span>원</span></div>
    </div>
    <div class="settle-summary-card">
      <div class="label">정산 완료액 (이번 달 입금)</div>
      <div class="val" id="sumDone">0<span>원</span></div>
    </div>
    <div class="settle-summary-card fee">
      <div class="label">누적 플랫폼 수수료</div>
      <div class="val" id="sumFee">0<span>원</span></div>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="settle-filter">
      <span style="font-size:13px;color:#666">정산기간</span>
      <select id="fMonth" onchange="applyFilter()">
        <option value="all">전체</option>
        <option value="2026-07">2026년 7월</option>
        <option value="2026-06" selected>2026년 6월</option>
        <option value="2026-05">2026년 5월</option>
      </select>
      <span style="font-size:13px;color:#666;margin-left:10px">정산상태</span>
      <select id="fStatus" onchange="applyFilter()">
        <option value="all">전체</option>
        <option value="pending">정산예정</option>
        <option value="done">정산완료</option>
      </select>
    </div>
  </div>

  <div class="biz-card">
    <div class="settle-table-head">
      <div class="biz-card-head" style="padding:20px 0 12px"><span>정산 내역</span><small>총 <span id="totalCount">0</span>건</small></div>
    </div>
    <table class="biz-table">
      <thead><tr><th>정산기간</th><th>확정 매출</th><th>플랫폼 수수료(12%)</th><th>정산금액</th><th>정산상태</th><th>지급일</th></tr></thead>
      <tbody id="settleBody"></tbody>
    </table>
  </div>
</main>

<script>
  var FEE_RATE = 0.12;

  var settlements = [
    { period:'2026-07-01 ~ 2026-07-15', month:'2026-07', revenue:3200000, status:'pending', payDate:'' },
    { period:'2026-06-16 ~ 2026-06-30', month:'2026-06', revenue:2900000, status:'pending', payDate:'' },
    { period:'2026-06-01 ~ 2026-06-15', month:'2026-06', revenue:2650000, status:'done',    payDate:'2026-06-20' },
    { period:'2026-05-16 ~ 2026-05-31', month:'2026-05', revenue:2400000, status:'done',    payDate:'2026-06-05' },
    { period:'2026-05-01 ~ 2026-05-15', month:'2026-05', revenue:2100000, status:'done',    payDate:'2026-05-20' }
  ];

  settlements.forEach(function (s) {
    s.fee = Math.round(s.revenue * FEE_RATE);
    s.settleAmount = s.revenue - s.fee;
  });

  var filtered = settlements.slice();

  function fmtWon(n){ return n.toLocaleString('ko-KR') + '원'; }

  function applyFilter() {
    var month = document.getElementById('fMonth').value;
    var status = document.getElementById('fStatus').value;

    filtered = settlements.filter(function (s) {
      var matchMonth = month === 'all' || s.month === month;
      var matchStatus = status === 'all' || s.status === status;
      return matchMonth && matchStatus;
    });
    render();
  }

  function render() {
    document.getElementById('totalCount').textContent = filtered.length;

    var pendingSum = settlements.filter(function (s) { return s.status === 'pending'; }).reduce(function (sum, s) { return sum + s.settleAmount; }, 0);
    var doneSum = settlements.filter(function (s) { return s.month === '2026-06' && s.status === 'done'; }).reduce(function (sum, s) { return sum + s.settleAmount; }, 0);
    var feeSum = settlements.reduce(function (sum, s) { return sum + s.fee; }, 0);

    document.getElementById('sumPending').textContent = fmtWon(pendingSum);
    document.getElementById('sumDone').textContent = fmtWon(doneSum);
    document.getElementById('sumFee').textContent = fmtWon(feeSum);

    var body = document.getElementById('settleBody');
    body.innerHTML = '';

    if (filtered.length === 0) {
      body.innerHTML = '<tr><td colspan="6" style="text-align:center;color:#999;padding:24px 0">해당하는 정산 내역이 없습니다.</td></tr>';
      return;
    }

    filtered.forEach(function (s) {
      var badgeClass = s.status === 'done' ? 'bs-done' : 'bs-wait';
      var statusText = s.status === 'done' ? '정산완료' : '정산예정';
      var tr = document.createElement('tr');
      tr.innerHTML =
        '<td>' + s.period + '</td>' +
        '<td>' + fmtWon(s.revenue) + '</td>' +
        '<td>-' + fmtWon(s.fee) + '</td>' +
        '<td><b>' + fmtWon(s.settleAmount) + '</b></td>' +
        '<td><span class="bs-badge ' + badgeClass + '">' + statusText + '</span></td>' +
        '<td>' + (s.payDate || '-') + '</td>';
      body.appendChild(tr);
    });
  }

  render();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>