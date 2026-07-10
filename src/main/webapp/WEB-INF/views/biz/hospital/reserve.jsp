<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="reserve" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<style>
  .rv-modal-bg{display:none;position:fixed;inset:0;background:rgba(0,0,0,.45);z-index:1000;align-items:center;justify-content:center;padding:20px}
  .rv-modal-bg.open{display:flex}
  .rv-modal{background:#fff;border-radius:14px;width:100%;max-width:480px;max-height:90vh;overflow:auto;box-shadow:0 12px 40px rgba(0,0,0,.15)}
  .rv-modal-head{display:flex;justify-content:space-between;align-items:center;padding:18px 20px;border-bottom:1px solid #E2E8E4}
  .rv-modal-head h3{margin:0;font-size:17px;font-weight:800;color:#1A1A2E}
  .rv-modal-close{background:none;border:none;font-size:24px;cursor:pointer;color:#888;line-height:1}
  .rv-modal-body{padding:20px;display:flex;flex-direction:column;gap:12px}
  .rv-row{display:flex;justify-content:space-between;font-size:14px;gap:12px}
  .rv-row span:first-child{color:#888;flex-shrink:0}
  .rv-row span:last-child{color:#1A1A2E;font-weight:600;text-align:right}
</style>

<%-- 2026-07-10 장우철 — 사업자 예약 관리 DB 연동 (F4~F6) --%>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 관리</h1>
    <p class="biz-page-desc">진료 예약을 확인하고 상태를 관리하세요.</p>
  </div>

  <c:if test="${not empty msg}">
    <div style="margin-bottom:12px;padding:12px 16px;background:#E8F8F1;color:#1F8464;border-radius:8px;font-size:14px">${msg}</div>
  </c:if>

  <div class="biz-card">
    <div style="padding:20px 20px 0">
      <div class="biz-tabs">
        <button type="button" class="biz-tab active" data-tab="all" onclick="switchTab('all')">전체<span class="biz-tab-count" id="cntAll"></span></button>
        <button type="button" class="biz-tab" data-tab="wait" onclick="switchTab('wait')">예약대기<span class="biz-tab-count" id="cntWait"></span></button>
        <button type="button" class="biz-tab" data-tab="done" onclick="switchTab('done')">진료완료<span class="biz-tab-count" id="cntDone"></span></button>
        <button type="button" class="biz-tab" data-tab="cancel" onclick="switchTab('cancel')">취소<span class="biz-tab-count" id="cntCancel"></span></button>
      </div>
    </div>

    <table class="biz-table">
      <thead>
        <tr>
          <th style="width:12%">예약번호</th>
          <th style="width:12%">예약자</th>
          <th style="width:18%">반려동물</th>
          <th style="width:16%">예약일시</th>
          <th style="width:12%">상태</th>
          <th>관리</th>
        </tr>
      </thead>
      <tbody id="reserveBody"></tbody>
    </table>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="toastMsg">처리되었습니다.</span>
</div>

<div class="rv-modal-bg" id="reserveModalBg" onclick="if(event.target===this) closeReserveModal()">
  <div class="rv-modal">
    <div class="rv-modal-head">
      <h3>예약 상세</h3>
      <button type="button" class="rv-modal-close" onclick="closeReserveModal()">×</button>
    </div>
    <div class="rv-modal-body">
      <div class="rv-row"><span>예약자</span><span id="mdMember">-</span></div>
      <div class="rv-row"><span>반려동물</span><span id="mdPet">-</span></div>
      <div class="rv-row"><span>예약일</span><span id="mdDate">-</span></div>
      <div class="rv-row"><span>예약시간</span><span id="mdTime">-</span></div>
      <div class="rv-row"><span>증상</span><span id="mdSymptoms">-</span></div>
      <div class="rv-row"><span>요청사항</span><span id="mdMemo">-</span></div>
    </div>
  </div>
</div>

<script>
  // 2026-07-10 장우철 — 서버 목록 → JS (탭 필터·모달)
  var reservations = [
    <c:forEach var="r" items="${reservationList}" varStatus="st">
    {
      resvId: ${r.resvId},
      resvNo: '<c:out value="${r.resvNo}"/>',
      name: '<c:out value="${r.memberName}"/>',
      pet: '<c:out value="${r.petName}"/> (<c:out value="${r.petSpecies}"/>)',
      dateStr: '<fmt:formatDate value="${r.resvDate}" pattern="yyyy-MM-dd"/>',
      dateLabel: '<fmt:formatDate value="${r.resvDate}" pattern="M/d"/>',
      time: '<c:out value="${r.resvTime}"/>',
      symptoms: '<c:out value="${r.symptoms}"/>',
      requestMemo: '<c:out value="${r.requestMemo}"/>',
      statusCd: '<c:out value="${r.statusCd}"/>',
      status: (function(cd){
        if (cd === 'PENDING' || cd === 'CONFIRMED') return 'wait';
        if (cd === 'DONE') return 'done';
        if (cd === 'CANCEL' || cd === 'REJECTED') return 'cancel';
        return 'wait';
      })('<c:out value="${r.statusCd}"/>')
    }<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  var currentTab = 'all';
  var contextPath = '${contextPath}';

  var badgeMap = {
    wait:   { cls: 'bs-wait',   label: '예약대기' },
    done:   { cls: 'bs-done',   label: '진료완료' },
    cancel: { cls: 'bs-cancel', label: '취소' }
  };

  function switchTab(tab) {
    currentTab = tab;
    document.querySelectorAll('.biz-tab').forEach(function (b) { b.classList.toggle('active', b.dataset.tab === tab); });
    renderTable();
  }

  function renderTable() {
    var list = reservations.filter(function (r) { return currentTab === 'all' || r.status === currentTab; });

    document.getElementById('cntAll').textContent = reservations.length;
    document.getElementById('cntWait').textContent = reservations.filter(function (r) { return r.status === 'wait'; }).length;
    document.getElementById('cntDone').textContent = reservations.filter(function (r) { return r.status === 'done'; }).length;
    document.getElementById('cntCancel').textContent = reservations.filter(function (r) { return r.status === 'cancel'; }).length;

    var body = document.getElementById('reserveBody');
    body.innerHTML = '';

    if (list.length === 0) {
      body.innerHTML = '<tr><td colspan="6" style="text-align:center; color:#aaa; padding:60px 0;">해당 예약이 없습니다.</td></tr>';
      return;
    }

    list.forEach(function (r) {
      var badge = badgeMap[r.status];
      var tr = document.createElement('tr');

      var actionHtml =
        '<button type="button" class="biz-btn ghost" onclick="openReserveModal(' + r.resvId + ')">상세</button> ';
      if (r.status === 'wait') {
        actionHtml +=
          '<button type="button" class="biz-btn danger" onclick="postStatus(' + r.resvId + ',\'CANCEL\')">예약취소</button> ' +
          '<button type="button" class="biz-btn" onclick="postStatus(' + r.resvId + ',\'DONE\')">진료완료</button>';
      }

      tr.innerHTML =
        '<td>' + r.resvNo + '</td>' +
        '<td>' + r.name + '</td>' +
        '<td>' + r.pet + '</td>' +
        '<td>' + r.dateLabel + ' ' + r.time + '</td>' +
        '<td><span class="bs-badge ' + badge.cls + '">' + badge.label + '</span></td>' +
        '<td>' + actionHtml + '</td>';
      body.appendChild(tr);
    });
  }

  function postStatus(resvId, statusCd) {
    if (statusCd === 'CANCEL' && !confirm('예약을 취소하시겠습니까?')) return;
    if (statusCd === 'DONE' && !confirm('진료완료로 처리하시겠습니까?')) return;

    var form = document.createElement('form');
    form.method = 'POST';
    form.action = contextPath + '/biz/hospital/reserve/status';
    form.innerHTML =
      '<input type="hidden" name="resvId" value="' + resvId + '">' +
      '<input type="hidden" name="statusCd" value="' + statusCd + '">';
    document.body.appendChild(form);
    form.submit();
  }

  function openReserveModal(resvId) {
    fetch(contextPath + '/biz/hospital/reserve/detail?resvId=' + resvId)
      .then(function(res) { return res.json(); })
      .then(function(data) {
        if (!data) { alert('예약 정보를 불러올 수 없습니다.'); return; }
        document.getElementById('mdMember').textContent = data.memberName || '-';
        var petLabel = data.petName || '-';
        if (data.petBreed) petLabel += ' (' + data.petBreed + ')';
        document.getElementById('mdPet').textContent = petLabel;
        document.getElementById('mdDate').textContent = data.resvDate ? String(data.resvDate).substring(0, 10) : '-';
        document.getElementById('mdTime').textContent = data.resvTime || '-';
        document.getElementById('mdSymptoms').textContent = data.symptoms || '-';
        document.getElementById('mdMemo').textContent = data.requestMemo || '-';
        document.getElementById('reserveModalBg').classList.add('open');
      })
      .catch(function() { alert('예약 정보를 불러올 수 없습니다.'); });
  }

  function closeReserveModal() {
    document.getElementById('reserveModalBg').classList.remove('open');
  }

  renderTable();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
