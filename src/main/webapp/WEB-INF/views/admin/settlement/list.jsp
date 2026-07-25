<%--
  역할: 관리자 정산 관리 UI
  - 2026/07/24 장우철 — 아코디언 상세, 정산 confirm, 더미 데이터 (API 추후)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage" value="settlement" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
.settle-tabs { display:flex; gap:8px; margin-bottom:16px; }
.settle-tab {
  padding:10px 18px; border-radius:8px; border:1px solid #E4E6ED; background:#fff;
  font-size:14px; font-weight:700; color:#555; text-decoration:none;
}
.settle-tab.active { background:#3B5BDB; color:#fff; border-color:#3B5BDB; }
.settle-toolbar { display:flex; flex-wrap:wrap; gap:10px; align-items:center; margin-bottom:14px; }
.settle-note { font-size:13px; color:#666; margin:0 0 14px; line-height:1.5; }
.settle-table { width:100%; border-collapse:collapse; font-size:14px; }
.settle-table th {
  text-align:left; padding:12px 10px; background:#F8FAFC; border-bottom:1px solid #E4E6ED;
  color:#666; font-weight:700; font-size:12px;
}
.settle-table td { padding:12px 10px; border-bottom:1px solid #F0F0F0; color:#1A1A2E; vertical-align:middle; }
.settle-row-main { cursor:default; }
.settle-badge {
  display:inline-block; padding:3px 8px; border-radius:999px; font-size:12px; font-weight:700;
}
.settle-badge.wait { background:#FFF7ED; color:#C2410C; }
.settle-badge.done { background:#ECFDF5; color:#166534; }
.settle-badge.fail { background:#FEF2F2; color:#B91C1C; }
.settle-btn {
  border:none; border-radius:8px; padding:8px 12px; font-size:13px; font-weight:700; cursor:pointer;
}
.settle-btn.primary { background:#3B5BDB; color:#fff; }
.settle-btn.primary:disabled { background:#C7D2FE; cursor:not-allowed; }
.settle-btn.manual { background:#fff; border:1px solid #DC2626; color:#DC2626; }
.settle-btn.ghost { background:#F3F4F6; color:#374151; }
.settle-toggle {
  width:32px; height:32px; border:1px solid #E4E6ED; border-radius:8px; background:#fff;
  cursor:pointer; font-weight:800; color:#555;
}
.settle-detail {
  display:none; background:#FAFBFC; border-bottom:1px solid #E4E6ED;
}
.settle-detail.open { display:table-row; }
.settle-detail-inner {
  padding:14px 16px 18px; display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:10px 18px;
}
.settle-detail-item label { display:block; font-size:12px; color:#999; margin-bottom:4px; }
.settle-detail-item span { font-size:14px; font-weight:700; color:#1A1A2E; word-break:break-all; }
@media (max-width:900px) {
  .settle-detail-inner { grid-template-columns:1fr; }
}
</style>

<main class="adm-main">
  <div class="adm-page-head">
    <div class="adm-page-head-left">
      <h1 class="adm-page-title">정산 관리</h1>
      <p class="adm-page-desc">매출월 기준 정산 · 쇼핑은 매월 15일 지급 (UI 더미)</p>
    </div>
  </div>

  <div class="settle-tabs">
    <a class="settle-tab ${tab eq 'STORE' ? 'active' : ''}" href="${contextPath}/admin/settlement?tab=STORE">펫샵(쇼핑)</a>
    <a class="settle-tab ${tab eq 'STAY' ? 'active' : ''}" href="${contextPath}/admin/settlement?tab=STAY">숙소</a>
  </div>

  <c:choose>
  <c:when test="${tab eq 'STAY'}">
    <div class="adm-card" style="padding:28px;text-align:center;color:#999">
      숙소 정산 규칙은 추후 확정 · 탭 UI만 준비되어 있습니다.
    </div>
  </c:when>
  <c:otherwise>
    <p class="settle-note">
      · 목록: 체크박스 · 사업장명 · 매출월 · 정산금 · 상태 · 정산<br>
      · 아코디언으로 계좌·총매출·수수료 등 상세 확인<br>
      · 대기: 15일만 정산 가능(더미는 버튼으로 확인) · 실패: 직접지급 · 완료: 비활성
    </p>

    <div class="settle-toolbar">
      <label style="font-size:13px;display:flex;align-items:center;gap:6px">
        <input type="checkbox" id="checkAll"> 전체선택
      </label>
      <button type="button" class="settle-btn primary" id="btnBulkSettle">선택 정산</button>
      <span style="font-size:12px;color:#999">지급일 안내: 매월 15일</span>
    </div>

    <div class="adm-card" style="padding:0;overflow:hidden">
      <table class="settle-table">
        <thead>
          <tr>
            <th style="width:40px"></th>
            <th>사업장명</th>
            <th>매출월</th>
            <th>정산금</th>
            <th>상태</th>
            <th style="width:200px">정산</th>
          </tr>
        </thead>
        <tbody id="settleBody"></tbody>
      </table>
    </div>
  </c:otherwise>
  </c:choose>
</main>

<script>
// 2026/07/24 장우철 — 정산 목록 더미 (API 연동 전)
(function () {
  if ('${tab}' !== 'STORE') return;

  var rows = [
    { id: 1, name: '해피펫 용품', salesMonth: '2026-07', amount: 4520000, status: 'wait',
      owner: '김펫샵', bank: '국민', account: '123456-78-901234', holder: '김펫샵',
      revenue: 5022222, fee: 502222 },
    { id: 2, name: '몽몽스토어', salesMonth: '2026-07', amount: 2180000, status: 'done',
      owner: '이몽몽', bank: '카카오뱅크', account: '3333-01-1234567', holder: '이몽몽',
      revenue: 2422222, fee: 242222 },
    { id: 3, name: '냥냥몰', salesMonth: '2026-07', amount: 980000, status: 'fail',
      owner: '(주)냥냥', bank: '신한', account: '110-123-456789', holder: '(주)냥냥',
      revenue: 1088888, fee: 108888 },
    { id: 4, name: '바크샵', salesMonth: '2026-07', amount: 3310000, status: 'wait',
      owner: '박바크', bank: '토스뱅크', account: '1000-1234-5678', holder: '박바크',
      revenue: 3677777, fee: 367777 }
  ];

  function fmt(n) { return n.toLocaleString('ko-KR') + '원'; }
  function statusHtml(s) {
    if (s === 'done') return '<span class="settle-badge done">완료</span>';
    if (s === 'fail') return '<span class="settle-badge fail">실패</span>';
    return '<span class="settle-badge wait">대기</span>';
  }
  function actionHtml(r) {
    if (r.status === 'done') {
      return '<button type="button" class="settle-btn primary" disabled>정산</button>';
    }
    if (r.status === 'fail') {
      return '<button type="button" class="settle-btn manual" data-action="manual" data-id="' + r.id + '">직접지급</button>';
    }
    return '<button type="button" class="settle-btn primary" data-action="settle" data-id="' + r.id + '">정산</button>';
  }

  function render() {
    var html = '';
    rows.forEach(function (r) {
      html += '<tr class="settle-row-main" data-id="' + r.id + '">'
        + '<td><input type="checkbox" class="row-check" data-id="' + r.id + '" ' + (r.status !== 'wait' ? 'disabled' : '') + '></td>'
        + '<td>' + r.name + '</td>'
        + '<td>' + r.salesMonth + '</td>'
        + '<td>' + fmt(r.amount) + '</td>'
        + '<td>' + statusHtml(r.status) + '</td>'
        + '<td style="display:flex;gap:6px;align-items:center;flex-wrap:wrap">'
        + actionHtml(r)
        + '<button type="button" class="settle-toggle" data-toggle="' + r.id + '" aria-label="상세">▾</button>'
        + '</td></tr>';
      html += '<tr class="settle-detail" id="detail-' + r.id + '"><td colspan="6"><div class="settle-detail-inner">'
        + '<div class="settle-detail-item"><label>사업자명</label><span>' + r.owner + '</span></div>'
        + '<div class="settle-detail-item"><label>입금계좌</label><span>' + r.bank + ' ' + r.account + '</span></div>'
        + '<div class="settle-detail-item"><label>예금주</label><span>' + r.holder + '</span></div>'
        + '<div class="settle-detail-item"><label>총매출</label><span>' + fmt(r.revenue) + '</span></div>'
        + '<div class="settle-detail-item"><label>수수료</label><span>' + fmt(r.fee) + '</span></div>'
        + '<div class="settle-detail-item"><label>정산금</label><span>' + fmt(r.amount) + '</span></div>'
        + '</div></td></tr>';
    });
    document.getElementById('settleBody').innerHTML = html;
  }

  function findRow(id) {
    return rows.find(function (r) { return r.id === id; });
  }

  document.getElementById('settleBody').addEventListener('click', function (e) {
    var toggle = e.target.closest('[data-toggle]');
    if (toggle) {
      var id = toggle.getAttribute('data-toggle');
      var detail = document.getElementById('detail-' + id);
      detail.classList.toggle('open');
      toggle.textContent = detail.classList.contains('open') ? '▴' : '▾';
      return;
    }
    var btn = e.target.closest('[data-action]');
    if (!btn) return;
    var id = Number(btn.getAttribute('data-id'));
    var row = findRow(id);
    if (!row) return;
    if (btn.getAttribute('data-action') === 'settle') {
      if (!confirm('정말 정산하시겠습니까?\n[' + row.name + '] ' + fmt(row.amount))) return;
      alert('UI 더미: 정산 요청이 완료 처리되었습니다. (API 추후)');
      row.status = 'done';
      render();
      return;
    }
    if (btn.getAttribute('data-action') === 'manual') {
      if (!confirm('직접지급 처리 후 완료로 변경할까요?\n[' + row.name + ']')) return;
      alert('UI 더미: 직접지급으로 완료 처리되었습니다. (API 추후)');
      row.status = 'done';
      render();
    }
  });

  document.getElementById('checkAll').addEventListener('change', function () {
    var on = this.checked;
    document.querySelectorAll('.row-check:not(:disabled)').forEach(function (el) {
      el.checked = on;
    });
  });

  document.getElementById('btnBulkSettle').addEventListener('click', function () {
    var ids = [];
    document.querySelectorAll('.row-check:checked').forEach(function (el) {
      ids.push(Number(el.getAttribute('data-id')));
    });
    if (!ids.length) {
      alert('정산할 사업장을 선택하세요. (대기 상태만 선택 가능)');
      return;
    }
    if (!confirm('선택한 ' + ids.length + '개 사업장을 정말 정산하시겠습니까?')) return;
    ids.forEach(function (id) {
      var row = findRow(id);
      if (row && row.status === 'wait') row.status = 'done';
    });
    alert('UI 더미: 선택 정산 완료 처리되었습니다. (API 추후)');
    document.getElementById('checkAll').checked = false;
    render();
  });

  render();
})();
</script>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
