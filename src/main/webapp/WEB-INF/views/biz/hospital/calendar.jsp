<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="calendar" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<%-- 7/3, 사업자(병원) 예약 캘린더 UI 구성 — 숙박 calendar.jsp와 동일 구조, 상태는 병원 예약관리(reserve.jsp)와 용어 통일(예약대기/진료완료) --%>
<style>
  .cal-head{display:flex;align-items:center;justify-content:space-between;padding:18px 20px}
  .cal-nav{display:flex;align-items:center;gap:10px}
  .cal-nav button{width:30px;height:30px;border:1px solid var(--biz-border);background:#fff;border-radius:6px;cursor:pointer;font-size:13px;color:#555}
  .cal-nav .cal-today{width:auto;padding:0 12px;font-weight:700;color:var(--biz-primary);border-color:var(--biz-primary)}
  .cal-title{font-size:16px;font-weight:800;color:#1A1A2E;min-width:110px;text-align:center}
  .cal-legend{display:flex;gap:14px;align-items:center;flex-wrap:wrap;padding:0 20px 16px;font-size:12px;color:#666}
  .cal-legend .dot{width:9px;height:9px;border-radius:50%;display:inline-block;margin-right:5px}

  .cal-grid{display:grid;grid-template-columns:repeat(7,1fr);border-top:1px solid var(--biz-border);border-left:1px solid var(--biz-border)}
  .cal-dow{padding:8px 10px;font-size:12px;font-weight:700;color:#888;text-align:left;border-right:1px solid var(--biz-border);border-bottom:1px solid var(--biz-border);background:#FAFBFA}
  .cal-dow.sun{color:#E24B4A}
  .cal-cell{min-height:96px;padding:6px 8px;border-right:1px solid var(--biz-border);border-bottom:1px solid var(--biz-border);vertical-align:top;cursor:pointer;transition:background .12s}
  .cal-cell:hover{background:#FAFBFA}
  .cal-cell.other-month{background:#FCFCFB;color:#ccc}
  .cal-cell.today .cal-daynum{background:var(--biz-primary);color:#fff;border-radius:50%}
  .cal-cell.selected{background:#F1F6FF}
  .cal-daynum{display:inline-flex;align-items:center;justify-content:center;width:22px;height:22px;font-size:12px;font-weight:700;color:#333}
  .cal-cell.sun-col .cal-daynum{color:#E24B4A}
  .cal-events{margin-top:4px;display:flex;flex-direction:column;gap:3px}
  .cal-event{font-size:10.5px;padding:2px 5px;border-radius:4px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:#fff}
  .cal-event.wait{background:#F5A623}
  .cal-event.done{background:#2BAB82}
  .cal-more{font-size:10px;color:#999;padding-left:4px}

  .cal-detail{padding:18px 20px}
  .cal-detail-empty{text-align:center;color:#aaa;font-size:13px;padding:24px 0}
  .cal-detail-item{display:flex;align-items:center;gap:12px;padding:12px 0;border-bottom:1px solid #F5F6F4}
  .cal-detail-item:last-child{border-bottom:none}
  .cal-detail-item .badge{flex-shrink:0}
  .cal-detail-item .info b{font-size:13px;color:#1A1A2E}
  .cal-detail-item .info small{display:block;font-size:12px;color:#888;margin-top:2px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 캘린더</h1>
    <p class="biz-page-desc">월별 진료 예약 현황을 한눈에 확인하세요.</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="cal-head">
      <div class="cal-nav">
        <button onclick="moveMonth(-1)">&lt;</button>
        <span class="cal-title" id="calTitle"></span>
        <button onclick="moveMonth(1)">&gt;</button>
      </div>
      <button class="cal-today" onclick="goToday()">오늘</button>
    </div>
    <div class="cal-legend">
      <span><span class="dot" style="background:#F5A623"></span>예약대기</span>
      <span><span class="dot" style="background:#2BAB82"></span>진료완료</span>
    </div>
    <div class="cal-grid" id="calGrid"></div>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span id="detailTitle">선택한 날짜의 예약</span></div>
    <div class="cal-detail" id="calDetail"></div>
  </div>
</main>

<script>
  var reservations = [
    { name:'홍길동', pet:'초코 (강아지)', time:'09:00', date: offset(-2), status:'done' },
    { name:'이서연', pet:'나비 (고양이)', time:'10:30', date: offset(-1), status:'done' },
    { name:'박도현', pet:'두부 (강아지)', time:'11:00', date: offset(0),  status:'wait' },
    { name:'최아린', pet:'몽이 (고양이)', time:'14:00', date: offset(0),  status:'wait' },
    { name:'정하율', pet:'뽀삐 (강아지)', time:'15:30', date: offset(1),  status:'wait' },
    { name:'김민서', pet:'루비 (고양이)', time:'09:30', date: offset(3),  status:'wait' },
    { name:'오세훈', pet:'별이 (강아지)', time:'13:00', date: offset(3),  status:'wait' },
    { name:'한지우', pet:'달이 (강아지)', time:'16:00', date: offset(5),  status:'wait' }
  ];

  function offset(days) {
    var d = new Date();
    d.setDate(d.getDate() + days);
    return toKey(d);
  }
  function toKey(d) {
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  }

  var statusLabel = { wait:'예약대기', done:'진료완료' };
  var today = new Date();
  var viewYear = today.getFullYear();
  var viewMonth = today.getMonth(); // 0-based
  var selectedKey = toKey(today);

  function moveMonth(diff) {
    viewMonth += diff;
    if (viewMonth < 0) { viewMonth = 11; viewYear--; }
    if (viewMonth > 11) { viewMonth = 0; viewYear++; }
    renderCalendar();
  }

  function goToday() {
    viewYear = today.getFullYear();
    viewMonth = today.getMonth();
    selectedKey = toKey(today);
    renderCalendar();
  }

  function eventsOnDay(key) {
    return reservations.filter(function (r) { return r.date === key; })
                        .sort(function (a, b) { return a.time.localeCompare(b.time); });
  }

  function selectDay(key) {
    selectedKey = key;
    renderCalendar();
  }

  function renderCalendar() {
    document.getElementById('calTitle').textContent = viewYear + '년 ' + (viewMonth + 1) + '월';

    var firstDay = new Date(viewYear, viewMonth, 1);
    var startWeekday = firstDay.getDay();
    var daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
    var daysInPrevMonth = new Date(viewYear, viewMonth, 0).getDate();

    var grid = document.getElementById('calGrid');
    grid.innerHTML = '';

    var dows = ['SUN','MON','TUE','WED','THU','FRI','SAT'];
    dows.forEach(function (d, i) {
      var el = document.createElement('div');
      el.className = 'cal-dow' + (i === 0 ? ' sun' : '');
      el.textContent = d;
      grid.appendChild(el);
    });

    var totalCells = Math.ceil((startWeekday + daysInMonth) / 7) * 7;

    for (var i = 0; i < totalCells; i++) {
      var cell = document.createElement('div');
      var dayNum, cellYear = viewYear, cellMonth = viewMonth, isOther = false;

      if (i < startWeekday) {
        dayNum = daysInPrevMonth - startWeekday + 1 + i;
        cellMonth = viewMonth - 1;
        isOther = true;
      } else if (i >= startWeekday + daysInMonth) {
        dayNum = i - startWeekday - daysInMonth + 1;
        cellMonth = viewMonth + 1;
        isOther = true;
      } else {
        dayNum = i - startWeekday + 1;
      }
      if (cellMonth < 0) { cellMonth = 11; cellYear--; }
      if (cellMonth > 11) { cellMonth = 0; cellYear++; }

      var key = cellYear + '-' + String(cellMonth + 1).padStart(2, '0') + '-' + String(dayNum).padStart(2, '0');
      var isToday = key === toKey(today);
      var isSun = (i % 7) === 0;

      cell.className = 'cal-cell' + (isOther ? ' other-month' : '') + (isToday ? ' today' : '') + (key === selectedKey ? ' selected' : '') + (isSun ? ' sun-col' : '');
      cell.onclick = function (k) { return function () { selectDay(k); }; }(key);

      var html = '<span class="cal-daynum">' + dayNum + '</span><div class="cal-events">';
      var dayEvents = eventsOnDay(key);
      dayEvents.slice(0, 2).forEach(function (ev) {
        html += '<span class="cal-event ' + ev.status + '">' + ev.time + ' ' + ev.name + '</span>';
      });
      if (dayEvents.length > 2) {
        html += '<span class="cal-more">+' + (dayEvents.length - 2) + '건 더보기</span>';
      }
      html += '</div>';
      cell.innerHTML = html;
      grid.appendChild(cell);
    }

    renderDetail();
  }

  function renderDetail() {
    var d = new Date(selectedKey);
    document.getElementById('detailTitle').textContent =
      (d.getMonth() + 1) + '월 ' + d.getDate() + '일 예약 (' + eventsOnDay(selectedKey).length + '건)';

    var box = document.getElementById('calDetail');
    var list = eventsOnDay(selectedKey);

    if (list.length === 0) {
      box.innerHTML = '<div class="cal-detail-empty">해당 날짜에 예약이 없습니다.</div>';
      return;
    }

    box.innerHTML = '';
    list.forEach(function (r) {
      var badgeClass = r.status === 'wait' ? 'bs-wait' : 'bs-done';
      var item = document.createElement('div');
      item.className = 'cal-detail-item';
      item.innerHTML =
        '<span class="bs-badge ' + badgeClass + ' badge">' + statusLabel[r.status] + '</span>' +
        '<div class="info"><b>' + r.time + ' · ' + r.name + '</b><small>' + r.pet + '</small></div>';
      box.appendChild(item);
    });
  }

  renderCalendar();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>