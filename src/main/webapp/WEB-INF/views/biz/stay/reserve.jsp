<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="reserve" />
<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<%-- 7/2, 사업자(숙박) 예약 관리 UI 구성 — 스토리보드(Biz_Lodge_Reservation) 기준: 검색 + 목록표 + 상세정보 + 상태변경 --%>
<style>
  .rsv-search{display:flex;flex-wrap:wrap;align-items:end;gap:14px;padding:18px 20px}
  .rsv-search .field{display:flex;flex-direction:column;gap:5px}
  .rsv-search label{font-size:12px;font-weight:700;color:#666}
  .rsv-search input,.rsv-search select{border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px;color:#333}
  .rsv-search .date-range{display:flex;align-items:center;gap:6px}
  .rsv-search .date-range input{width:135px}
  .rsv-search .btn-search{background:var(--biz-primary);color:#fff;border:none;border-radius:8px;padding:9px 18px;font-size:13px;font-weight:700;cursor:pointer}
  .rsv-search .btn-reset{background:#fff;border:1px solid var(--biz-border);border-radius:8px;padding:9px 16px;font-size:13px;font-weight:600;color:#555;cursor:pointer}
  .rsv-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}
  .rsv-row{cursor:pointer}
  .rsv-row.selected{background:#F1F6FF}
  .rsv-row td{vertical-align:middle}
  .rsv-pagination{display:flex;align-items:center;justify-content:center;gap:6px;padding:16px 0 8px}
  .rsv-pagination button{width:28px;height:28px;border:1px solid var(--biz-border);background:#fff;border-radius:6px;cursor:pointer;font-size:12px;color:#555}
  .rsv-pagination button.active{background:var(--biz-primary);border-color:var(--biz-primary);color:#fff;font-weight:700}
  .rsv-pagination button:disabled{opacity:.4;cursor:default}
  .rsv-hint{text-align:center;font-size:12px;color:#aaa;margin-top:4px}
  .rsv-detail{display:grid;grid-template-columns:1fr 1fr;gap:0 40px;padding:20px}
  .rsv-detail-row{display:flex;padding:8px 0;border-bottom:1px solid #F5F6F4;font-size:13px}
  .rsv-detail-row span:first-child{width:88px;flex-shrink:0;color:#888}
  .rsv-detail-row span:last-child{color:#1A1A2E;font-weight:600}
  .rsv-detail-empty{padding:40px 20px;text-align:center;color:#aaa;font-size:13px}
  .rsv-status-change{display:flex;align-items:center;gap:16px;padding:0 20px 20px}
  .rsv-status-change .cur{display:flex;align-items:center;gap:8px;font-size:13px;color:#666}
  .rsv-status-change .actions{display:flex;gap:8px;margin-left:auto}
  .rsv-status-change button{padding:9px 22px;border-radius:8px;font-size:13px;font-weight:700;cursor:pointer;border:none}
  .rsv-status-change .btn-approve{background:#4F6BC4;color:#fff}
  .rsv-status-change .btn-cancel{background:#E24B4A;color:#fff}
  .rsv-status-change .btn-approve:disabled,.rsv-status-change .btn-cancel:disabled{opacity:.4;cursor:not-allowed}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 관리</h1>
    <p class="biz-page-desc">숙박 예약을 검색하고 상세정보를 확인해 승인·취소 처리하세요.</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="rsv-search">
      <div class="field">
        <label>숙박기간</label>
        <div class="date-range">
          <input type="date" id="fFrom" value="2026-06-01">
          <span>~</span>
          <input type="date" id="fTo" value="2026-06-30">
        </div>
      </div>
      <div class="field">
        <label>고객명</label>
        <input type="text" id="fName" placeholder="고객명 입력">
      </div>
      <div class="field">
        <label>예약상태</label>
        <select id="fStatus">
          <option value="all">전체</option>
          <option value="ready">예약확정</option>
          <option value="wait">예약대기</option>
          <option value="cancel">예약취소</option>
        </select>
      </div>
      <button class="btn-search" onclick="applyFilter()">검색</button>
      <button class="btn-reset" onclick="resetFilter()">초기화</button>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="rsv-table-head">
      <div class="biz-card-head" style="padding:20px 0 12px"><span>예약 목록</span><small>총 <span id="totalCount">0</span>건</small></div>
    </div>
    <table class="biz-table">
      <thead><tr><th>예약번호</th><th>고객명</th><th>객실명</th><th>숙박기간</th><th>인원</th><th>예약상태</th><th>관리</th></tr></thead>
      <tbody id="rsvBody"></tbody>
    </table>
    <div class="rsv-pagination" id="pagination"></div>
    <p class="rsv-hint">※ 목록의 행을 클릭하면 해당 예약의 상세정보가 아래에 표시됩니다.</p>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span>선택한 예약 상세정보</span></div>
    <div id="detailBox"></div>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var reservations = [
    { no:'R202607100712', name:'홍길동', room:'디럭스룸(101호)', pIn:'2026.07.10', pOut:'2026.07.12', nights:2, guest:'2명', status:'ready', amount:180000, method:'신용카드', bookedAt:'2026.07.01 14:30', phone:'010-1234-5678', email:'hong@example.com', request:'늦은 체크인 예정입니다.', note:'-' },
    { no:'R202606280629', name:'이성민', room:'스탠다드(A-01호)', pIn:'2026.06.28', pOut:'2026.06.29', nights:1, guest:'1명', status:'ready', amount:45000, method:'카카오페이', bookedAt:'2026.06.20 09:12', phone:'010-2222-3333', email:'lee@example.com', request:'-', note:'-' },
    { no:'R202606250628', name:'박소현', room:'디럭스(B-01호)', pIn:'2026.06.25', pOut:'2026.06.28', nights:3, guest:'2명', status:'wait', amount:204000, method:'신용카드', bookedAt:'2026.06.18 21:40', phone:'010-3333-4444', email:'park@example.com', request:'대형견 동반, 마당 이용 문의', note:'-' },
    { no:'R202606200622', name:'최민준', room:'스위트(C-01호)', pIn:'2026.06.20', pOut:'2026.06.22', nights:2, guest:'2명', status:'cancel', amount:196000, method:'신용카드', bookedAt:'2026.06.10 11:05', phone:'010-4444-5555', email:'choi@example.com', request:'-', note:'개인 사정으로 취소 요청' },
    { no:'R202606150617', name:'한지우', room:'디럭스(B-02호)', pIn:'2026.06.15', pOut:'2026.06.17', nights:2, guest:'1명', status:'ready', amount:136000, method:'네이버페이', bookedAt:'2026.06.05 16:22', phone:'010-5555-6666', email:'han@example.com', request:'조용한 객실 요청', note:'-' }
  ];

  var statusLabel = { ready:'예약확정', wait:'예약대기', cancel:'예약취소' };
  var statusBadgeClass = { ready:'bs-ready', wait:'bs-wait', cancel:'bs-cancel' };

  var filtered = reservations.slice();
  var page = 1;
  var pageSize = 3;
  var selectedNo = null;

  function fmtWon(n){ return n.toLocaleString('ko-KR') + '원'; }

  function applyFilter() {
    var from = document.getElementById('fFrom').value;
    var to = document.getElementById('fTo').value;
    var name = document.getElementById('fName').value.trim();
    var status = document.getElementById('fStatus').value;

    filtered = reservations.filter(function (r) {
      var checkIn = r.pIn.replace(/\./g, '-');
      var matchDate = (!from || checkIn >= from) && (!to || checkIn <= to);
      var matchName = !name || r.name.indexOf(name) !== -1;
      var matchStatus = status === 'all' || r.status === status;
      return matchDate && matchName && matchStatus;
    });
    page = 1;
    selectedNo = null;
    render();
  }

  function resetFilter() {
    document.getElementById('fFrom').value = '2026-06-01';
    document.getElementById('fTo').value = '2026-06-30';
    document.getElementById('fName').value = '';
    document.getElementById('fStatus').value = 'all';
    filtered = reservations.slice();
    page = 1;
    selectedNo = null;
    render();
  }

  function selectRow(no) {
    selectedNo = no;
    render();
  }

  function changeStatus(no, newStatus) {
    var r = reservations.find(function (x) { return x.no === no; });
    r.status = newStatus;
    render();
    showToast(newStatus === 'ready' ? '예약이 승인(확정)되었습니다.' : '예약이 취소되었습니다.');
  }

  function showToast(msg) {
    document.getElementById('saveToastMsg').textContent = msg;
    var toast = document.getElementById('saveToast');
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2000);
  }

  function render() {
    document.getElementById('totalCount').textContent = filtered.length;

    var totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
    if (page > totalPages) page = totalPages;
    var pageItems = filtered.slice((page - 1) * pageSize, page * pageSize);

    var body = document.getElementById('rsvBody');
    body.innerHTML = '';
    if (pageItems.length === 0) {
      body.innerHTML = '<tr><td colspan="7" style="text-align:center;color:#999;padding:24px 0">검색 결과가 없습니다.</td></tr>';
    } else {
      pageItems.forEach(function (r) {
        var tr = document.createElement('tr');
        tr.className = 'rsv-row' + (r.no === selectedNo ? ' selected' : '');
        tr.onclick = function () { selectRow(r.no); };
        tr.innerHTML =
          '<td>' + r.no + '</td>' +
          '<td>' + r.name + '</td>' +
          '<td>' + r.room + '</td>' +
          '<td>' + r.pIn + '~' + r.pOut + '<br><small style="color:#999">(' + r.nights + '박' + (r.nights+1) + '일)</small></td>' +
          '<td>' + r.guest + '</td>' +
          '<td><span class="bs-badge ' + statusBadgeClass[r.status] + '">' + statusLabel[r.status] + '</span></td>' +
          '<td><button class="biz-btn" onclick="event.stopPropagation();selectRow(\'' + r.no + '\')">상세보기</button></td>';
        body.appendChild(tr);
      });
    }

    var pg = document.getElementById('pagination');
    pg.innerHTML = '';
    var prev = document.createElement('button');
    prev.textContent = '<';
    prev.disabled = page <= 1;
    prev.onclick = function () { page--; render(); };
    pg.appendChild(prev);
    for (var i = 1; i <= totalPages; i++) {
      var b = document.createElement('button');
      b.textContent = i;
      if (i === page) b.className = 'active';
      (function (n) { b.onclick = function () { page = n; render(); }; })(i);
      pg.appendChild(b);
    }
    var next = document.createElement('button');
    next.textContent = '>';
    next.disabled = page >= totalPages;
    next.onclick = function () { page++; render(); };
    pg.appendChild(next);

    renderDetail();
  }

  function renderDetail() {
    var box = document.getElementById('detailBox');
    var r = reservations.find(function (x) { return x.no === selectedNo; });

    if (!r) {
      box.innerHTML = '<div class="rsv-detail-empty">목록에서 예약을 선택하면 상세정보가 표시됩니다.</div>';
      return;
    }

    box.innerHTML =
      '<div class="rsv-detail">' +
        '<div>' +
          '<div class="rsv-detail-row"><span>예약번호</span><span>' + r.no + '</span></div>' +
          '<div class="rsv-detail-row"><span>예약자명</span><span>' + r.name + '</span></div>' +
          '<div class="rsv-detail-row"><span>연락처</span><span>' + r.phone + '</span></div>' +
          '<div class="rsv-detail-row"><span>이메일</span><span>' + r.email + '</span></div>' +
          '<div class="rsv-detail-row"><span>객실명</span><span>' + r.room + '</span></div>' +
        '</div>' +
        '<div>' +
          '<div class="rsv-detail-row"><span>결제금액</span><span>' + fmtWon(r.amount) + '</span></div>' +
          '<div class="rsv-detail-row"><span>결제수단</span><span>' + r.method + '</span></div>' +
          '<div class="rsv-detail-row"><span>예약일</span><span>' + r.bookedAt + '</span></div>' +
          '<div class="rsv-detail-row"><span>숙박기간</span><span>' + r.pIn + ' ~ ' + r.pOut + ' (' + r.nights + '박' + (r.nights+1) + '일)</span></div>' +
          '<div class="rsv-detail-row"><span>인원</span><span>' + r.guest + '</span></div>' +
        '</div>' +
        '<div style="grid-column:1/-1">' +
          '<div class="rsv-detail-row"><span>요청사항</span><span>' + r.request + '</span></div>' +
          '<div class="rsv-detail-row"><span>특이사항</span><span>' + r.note + '</span></div>' +
        '</div>' +
      '</div>' +
      '<div class="rsv-status-change">' +
        '<div class="cur">현재 상태 <span class="bs-badge ' + statusBadgeClass[r.status] + '">' + statusLabel[r.status] + '</span></div>' +
        '<div class="actions">' +
          '<button class="btn-approve" ' + (r.status === 'ready' ? 'disabled' : '') + ' onclick="changeStatus(\'' + r.no + '\',\'ready\')">승인</button>' +
          '<button class="btn-cancel" ' + (r.status === 'cancel' ? 'disabled' : '') + ' onclick="changeStatus(\'' + r.no + '\',\'cancel\')">취소</button>' +
        '</div>' +
      '</div>' +
      '<p style="padding:0 20px 18px;font-size:12px;color:#aaa">※ 승인 시 예약이 \'예약확정\' 상태로 변경되며, 취소 시 \'예약취소\' 상태로 변경됩니다.</p>';
  }

  render();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>