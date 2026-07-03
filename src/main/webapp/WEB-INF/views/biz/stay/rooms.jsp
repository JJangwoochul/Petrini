<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="rooms" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<%-- 7/3, 사업자(숙박) 객실 관리 UI 구성 : 검색/필터 + 목록표 + 페이지네이션 + 등록/수정 폼(같은 화면 내 토글) --%>
<style>
  .room-filter{display:flex;flex-wrap:wrap;align-items:center;gap:10px;padding:18px 20px}
  .room-filter select,.room-filter input{border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px;color:#333}
  .room-filter input[type="text"]{width:220px}
  .room-filter .btn-search{background:var(--biz-primary);color:#fff;border:none;border-radius:8px;padding:9px 18px;font-size:13px;font-weight:700;cursor:pointer}
  .room-filter .btn-reset{background:#fff;border:1px solid var(--biz-border);border-radius:8px;padding:9px 16px;font-size:13px;font-weight:600;color:#555;cursor:pointer}
  .room-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}
  .room-thumb{width:64px;height:48px;border-radius:6px;object-fit:cover;display:block}
  .room-pagination{display:flex;align-items:center;justify-content:center;gap:6px;padding:16px 0 20px}
  .room-pagination button{width:28px;height:28px;border:1px solid var(--biz-border);background:#fff;border-radius:6px;cursor:pointer;font-size:12px;color:#555}
  .room-pagination button.active{background:var(--biz-primary);border-color:var(--biz-primary);color:#fff;font-weight:700}
  .room-pagination button:disabled{opacity:.4;cursor:default}
  .room-form-actions{display:flex;justify-content:center;gap:10px;margin-top:22px}
  .room-form-actions .biz-btn-primary{min-width:180px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">객실 관리</h1>
    <p class="biz-page-desc">객실 타입·가격·사진을 등록하고 관리하세요.</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="room-filter">
      <select id="fField">
        <option value="name">객실명</option>
      </select>
      <input type="text" id="fKeyword" placeholder="객실명을 입력하세요.">
      <span style="font-size:13px;color:#666;margin-left:6px">상태</span>
      <select id="fStatus">
        <option value="all">전체</option>
        <option value="sale">판매중</option>
        <option value="stop">판매중지</option>
      </select>
      <button class="btn-search" onclick="applyFilter()">검색</button>
      <button class="btn-reset" onclick="resetFilter()">초기화</button>
    </div>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="room-table-head">
      <div class="biz-card-head" style="padding:20px 0 12px"><span>객실목록</span><small>총 <span id="totalCount">0</span>실</small></div>
      <button type="button" class="biz-btn-primary" onclick="openForm('add')">+ 객실 등록</button>
    </div>
    <table class="biz-table">
      <thead><tr><th>이미지</th><th>객실명</th><th>기준인원</th><th>최대인원</th><th>평일요금</th><th>주말요금</th><th>상태</th><th>관리</th></tr></thead>
      <tbody id="roomBody"></tbody>
    </table>
    <div class="room-pagination" id="pagination"></div>
  </div>

  <div class="biz-card" id="formCard" style="display:none">
    <div class="biz-card-head"><span id="formTitle">객실 등록</span></div>
    <form id="roomForm" style="padding:20px;max-width:640px">
      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>객실이름<span class="req">*</span></label>
          <input type="text" id="rName" placeholder="객실 이름을 입력하세요">
        </div>

        <div class="biz-form-row">
          <label>판매상태<span class="req">*</span></label>
          <select id="rStatus">
            <option value="sale">판매중</option>
            <option value="stop">판매중지</option>
          </select>
        </div>

        <div class="biz-form-row">
          <label>1박 요금(평일)<span class="req">*</span></label>
          <input type="number" id="rWeekday" placeholder="숫자만 입력하세요 (예: 80000)">
        </div>
        <div class="biz-form-row">
          <label>1박 요금(주말)<span class="req">*</span></label>
          <input type="number" id="rWeekend" placeholder="숫자만 입력하세요 (예: 120000)">
        </div>
        <div class="biz-form-row">
          <label>기준인원<span class="req">*</span></label>
          <input type="number" id="rBase" placeholder="기본 숙박 인원을 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>최대인원<span class="req">*</span></label>
          <input type="number" id="rMax" placeholder="숙박 가능한 최대 인원을 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>객실크기</label>
          <input type="text" id="rSize" placeholder="예) 20㎡, 싱글, 더블, 트윈, 스위트 등">
        </div>
        <div class="biz-form-row">
          <label>객실설명</label>
          <textarea id="rDesc" placeholder="객실에 대한 설명을 입력하세요"></textarea>
        </div>

        <div class="biz-form-row">
          <label>객실이미지</label>
          <div style="display:flex;gap:10px;align-items:center">
            <input type="text" id="rImgName" placeholder="선택된 파일이 없습니다" readonly style="flex:1;background:#FAFBFA">
            <button type="button" class="biz-btn-ghost" style="white-space:nowrap" onclick="document.getElementById('rImgFile').click()">이미지 찾기</button>
            <input type="file" id="rImgFile" accept="image/*" style="display:none">
          </div>
          <div class="biz-form-image-box" id="imgPreviewBox" style="width:200px;height:140px;margin-top:10px;display:none">
            <img id="imgPreview" src="" alt="객실 이미지 미리보기">
          </div>
        </div>
      </div>

      <div class="room-form-actions">
        <button type="button" class="biz-btn-ghost" onclick="closeForm()">취소</button>
        <button type="button" class="biz-btn-primary" id="submitBtn" onclick="submitRoom()">객실등록신청</button>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var rooms = [
    { id:1, name:'디럭스룸', base:2, max:4, weekday:80000,  weekend:120000, status:'sale', img:'https://images.unsplash.com/photo-1611892440504-42a792e24d32?w=300&q=80', size:'20㎡', desc:'창가 전망의 아늑한 2인실입니다.' },
    { id:2, name:'스위트룸', base:4, max:6, weekday:150000, weekend:200000, status:'stop', img:'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=300&q=80', size:'32㎡', desc:'넓은 거실이 딸린 패밀리 스위트입니다.' },
    { id:3, name:'스탠다드룸(A-01호)', base:1, max:2, weekday:45000, weekend:65000, status:'sale', img:'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=300&q=80', size:'14㎡', desc:'소형견 동반 고객에게 알맞은 기본형 객실입니다.' },
    { id:4, name:'독채 풀빌라', base:2, max:6, weekday:180000, weekend:260000, status:'sale', img:'https://images.unsplash.com/photo-1568495248636-6432b97bd949?w=300&q=80', size:'55㎡', desc:'마당이 있는 독채형 숙소로 대형견도 자유롭게 뛰놀 수 있습니다.' }
  ];

  var statusLabel = { sale:'판매중', stop:'판매중지' };
  var statusBadgeClass = { sale:'bs-done', stop:'bs-cancel' };

  var filtered = rooms.slice();
  var page = 1;
  var pageSize = 3;
  var editingId = null;
  var previewSrc = '';

  function fmtWon(n){ return n.toLocaleString('ko-KR') + '원'; }

  function applyFilter() {
    var keyword = document.getElementById('fKeyword').value.trim();
    var status = document.getElementById('fStatus').value;

    filtered = rooms.filter(function (r) {
      var matchName = !keyword || r.name.indexOf(keyword) !== -1;
      var matchStatus = status === 'all' || r.status === status;
      return matchName && matchStatus;
    });
    page = 1;
    render();
  }

  function resetFilter() {
    document.getElementById('fKeyword').value = '';
    document.getElementById('fStatus').value = 'all';
    filtered = rooms.slice();
    page = 1;
    render();
  }

  function deleteRoom(id) {
    if (!confirm('선택한 객실을 삭제하시겠습니까?')) return;
    rooms = rooms.filter(function (r) { return r.id !== id; });
    filtered = filtered.filter(function (r) { return r.id !== id; });
    render();
    showToast('객실이 삭제되었습니다.');
  }

  function openForm(mode, id) {
    editingId = null;
    previewSrc = '';
    document.getElementById('roomForm').reset();
    document.getElementById('imgPreviewBox').style.display = 'none';

    if (mode === 'edit') {
      var r = rooms.find(function (x) { return x.id === id; });
      if (!r) return;
      editingId = id;
      document.getElementById('rStatus').value = r.status;
      document.getElementById('formTitle').textContent = '객실 수정';
      document.getElementById('submitBtn').textContent = '수정완료';
      document.getElementById('rName').value    = r.name;
      document.getElementById('rWeekday').value = r.weekday;
      document.getElementById('rWeekend').value = r.weekend;
      document.getElementById('rBase').value    = r.base;
      document.getElementById('rMax').value     = r.max;
      document.getElementById('rSize').value    = r.size;
      document.getElementById('rDesc').value    = r.desc;
      previewSrc = r.img;
      document.getElementById('rImgName').value = '기존 이미지 사용중';
      document.getElementById('imgPreview').src = previewSrc;
      document.getElementById('imgPreviewBox').style.display = 'block';
    } else {
      document.getElementById('formTitle').textContent = '객실 등록';
      document.getElementById('submitBtn').textContent = '객실등록신청';
      document.getElementById('rStatus').value = 'sale';
    }

    document.getElementById('formCard').style.display = 'block';
    document.getElementById('formCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function closeForm() {
    document.getElementById('formCard').style.display = 'none';
  }

  document.getElementById('rImgFile').addEventListener('change', function (e) {
    var file = e.target.files[0];
    if (!file) return;
    document.getElementById('rImgName').value = file.name;
    previewSrc = URL.createObjectURL(file);
    document.getElementById('imgPreview').src = previewSrc;
    document.getElementById('imgPreviewBox').style.display = 'block';
  });

  function submitRoom() {
    var required = [
      { id: 'rName',    label: '객실이름' },
      { id: 'rWeekday', label: '1박 요금(평일)' },
      { id: 'rWeekend', label: '1박 요금(주말)' },
      { id: 'rBase',    label: '기준인원' },
      { id: 'rMax',     label: '최대인원' }
    ];
    for (var i = 0; i < required.length; i++) {
      var el = document.getElementById(required[i].id);
      if (!el.value.trim()) {
        alert(required[i].label + '을(를) 입력해주세요.');
        el.focus();
        return;
      }
    }

    var data = {
      name: document.getElementById('rName').value.trim(),
      status: document.getElementById('rStatus').value,
      weekday: Number(document.getElementById('rWeekday').value),
      weekend: Number(document.getElementById('rWeekend').value),
      base: Number(document.getElementById('rBase').value),
      max: Number(document.getElementById('rMax').value),
      size: document.getElementById('rSize').value.trim(),
      desc: document.getElementById('rDesc').value.trim(),
      img: previewSrc || 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=300&q=80'
    };

    if (editingId) {
      var r = rooms.find(function (x) { return x.id === editingId; });
      Object.assign(r, data);
      showToast('객실 정보가 수정되었습니다.');
    } else {
      data.id = rooms.length ? Math.max.apply(null, rooms.map(function (x) { return x.id; })) + 1 : 1;
      rooms.push(data);
      showToast('객실 등록 신청이 완료되었습니다.');
    }

    filtered = rooms.slice();
    closeForm();
    render();
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

    var body = document.getElementById('roomBody');
    body.innerHTML = '';
    if (pageItems.length === 0) {
      body.innerHTML = '<tr><td colspan="8" style="text-align:center;color:#999;padding:24px 0">등록된 객실이 없습니다.</td></tr>';
    } else {
      pageItems.forEach(function (r) {
        var tr = document.createElement('tr');
        tr.innerHTML =
          '<td><img class="room-thumb" src="' + r.img + '" alt="' + r.name + '"></td>' +
          '<td>' + r.name + '</td>' +
          '<td>' + r.base + '명</td>' +
          '<td>' + r.max + '명</td>' +
          '<td>' + fmtWon(r.weekday) + '</td>' +
          '<td>' + fmtWon(r.weekend) + '</td>' +
          '<td><span class="bs-badge ' + statusBadgeClass[r.status] + '">' + statusLabel[r.status] + '</span></td>' +
          '<td>' +
            '<button class="biz-btn" onclick="openForm(\'edit\',' + r.id + ')">수정</button> ' +
            '<button class="biz-btn danger" onclick="deleteRoom(' + r.id + ')">삭제</button>' +
          '</td>';
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
  }

  render();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>