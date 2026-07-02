<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="reserve" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<%-- 7/2, 곽지윤 사업자(병원) 예약 관리 UI 구성변경 — 캘린더형 → 스토리보드 표 형태로 교체 --%>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 관리</h1>
    <p class="biz-page-desc">진료 예약을 확인하고 상태를 관리하세요.</p>
  </div>

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
          <th style="width:10%">예약번호</th>
          <th style="width:14%">예약자</th>
          <th style="width:20%">반려동물</th>
          <th style="width:18%">예약일시</th>
          <th style="width:14%">상태</th>
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

<script>
  // 목업 예약 데이터 (실 연동 전 화면 확인용)
  var reservations = [
    { id: 1, name: '홍길동', pet: '초코 (강아지)', datetime: '6/25 14:00', status: 'wait' },
    { id: 2, name: '이서연', pet: '나비 (고양이)', datetime: '6/26 10:30', status: 'done' },
    { id: 3, name: '박도현', pet: '두부 (강아지)', datetime: '6/24 09:00', status: 'cancel' },
    { id: 4, name: '최아린', pet: '몽이 (고양이)', datetime: '6/27 11:00', status: 'wait' }
  ];

  var currentTab = 'all';

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

      var actionHtml = '—';
      if (r.status === 'wait') {
        actionHtml =
          '<button class="biz-btn danger" onclick="updateStatus(' + r.id + ',\'cancel\')">예약취소</button> ' +
          '<button class="biz-btn" onclick="updateStatus(' + r.id + ',\'done\')">진료완료</button>';
      }

      tr.innerHTML =
        '<td>' + r.id + '</td>' +
        '<td>' + r.name + '</td>' +
        '<td>' + r.pet + '</td>' +
        '<td>' + r.datetime + '</td>' +
        '<td><span class="bs-badge ' + badge.cls + '">' + badge.label + '</span></td>' +
        '<td>' + actionHtml + '</td>';
      body.appendChild(tr);
    });
  }

  function updateStatus(id, newStatus) {
    var r = reservations.find(function (x) { return x.id === id; });
    if (newStatus === 'cancel' && !confirm('예약을 취소하시겠습니까?')) return;
    r.status = newStatus;
    renderTable();

    var toast = document.getElementById('saveToast');
    document.getElementById('toastMsg').textContent =
      newStatus === 'cancel' ? '예약이 취소되었습니다.' : '진료완료로 처리되었습니다.';
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2000);
  }

  renderTable();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>