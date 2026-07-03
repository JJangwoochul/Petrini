<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="calendar" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<%-- 7/3, 사업자(숙박) 예약 캘린더 — FullCalendar 라이브러리 적용 버전 --%>
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>

<style>
  .cal-legend{display:flex;gap:14px;align-items:center;flex-wrap:wrap;padding:18px 20px 0;font-size:12px;color:#666}
  .cal-legend .dot{width:9px;height:9px;border-radius:50%;display:inline-block;margin-right:5px}
  #calendar{padding:20px}

  .cal-detail{padding:18px 20px}
  .cal-detail-empty{text-align:center;color:#aaa;font-size:13px;padding:24px 0}
  .cal-detail-item{display:flex;align-items:center;gap:12px;padding:12px 0;border-bottom:1px solid #F5F6F4}
  .cal-detail-item:last-child{border-bottom:none}
  .cal-detail-item .badge{flex-shrink:0}
  .cal-detail-item .info b{font-size:13px;color:#1A1A2E}
  .cal-detail-item .info small{display:block;font-size:12px;color:#888;margin-top:2px}

  /* FullCalendar 기본 폰트/버튼을 biz 톤에 맞게 살짝 조정 */
  .fc{font-family:inherit}
  .fc .fc-button-primary{background:var(--biz-primary);border-color:var(--biz-primary)}
  .fc .fc-button-primary:hover{background:#238f6c;border-color:#238f6c}
  .fc .fc-daygrid-event{border:none;padding:1px 4px;font-size:11px}
  .fc .fc-toolbar-title{font-size:16px;font-weight:800;color:#1A1A2E}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 캘린더</h1>
    <p class="biz-page-desc">월별 예약 현황을 한눈에 확인하세요.</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="cal-legend">
      <span><span class="dot" style="background:#F5A623"></span>예약대기</span>
      <span><span class="dot" style="background:#4F6BC4"></span>예약확정</span>
      <span><span class="dot" style="background:#2BAB82"></span>숙박중</span>
    </div>
    <div id="calendar"></div>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span id="detailTitle">선택한 날짜의 예약</span></div>
    <div class="cal-detail" id="calDetail"></div>
  </div>
</main>

<script>
  function offset(days) {
    var d = new Date();
    d.setDate(d.getDate() + days);
    return toKey(d);
  }
  function toKey(d) {
    return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0');
  }

  var statusLabel = { wait:'예약대기', confirm:'예약확정', stay:'숙박중' };
  var statusColor  = { wait:'#F5A623', confirm:'#4F6BC4', stay:'#2BAB82' };
  var statusBadgeClass = { wait:'bs-wait', confirm:'bs-ready', stay:'bs-done' };

  var reservations = [
    { name:'이성민', pet:'두부 (포메)',    room:'A-01호 스탠다드', checkIn: offset(-3), checkOut: offset(-1), status:'stay'    },
    { name:'박소현', pet:'몽이 (골든)',    room:'B-02호 디럭스',   checkIn: offset(-1), checkOut: offset(2),  status:'stay'    },
    { name:'정아린', pet:'보리 (말티푸)',  room:'B-01호 디럭스',   checkIn: offset(0),  checkOut: offset(1),  status:'confirm' },
    { name:'한지우', pet:'달이 (사모예드)',room:'C-01호 스위트',   checkIn: offset(2),  checkOut: offset(4),  status:'confirm' },
    { name:'최민준', pet:'하루 (시츄)',    room:'독채 풀빌라',     checkIn: offset(4),  checkOut: offset(6),  status:'wait'    },
    { name:'김하늘', pet:'초코 (푸들)',    room:'A-02호 스탠다드', checkIn: offset(7),  checkOut: offset(9),  status:'confirm' },
    { name:'오세훈', pet:'별이 (비숑)',    room:'B-02호 디럭스',   checkIn: offset(-8), checkOut: offset(-6), status:'stay'    }
  ];

  // FullCalendar는 end가 "그 날짜 미포함(exclusive)"이라, 체크아웃 다음날로 하루 더해서 넘겨줌
  function addOneDay(dateStr) {
    var d = new Date(dateStr);
    d.setDate(d.getDate() + 1);
    return toKey(d);
  }

  var events = reservations.map(function (r) {
    return {
      title: r.name + ' · ' + r.room,
      start: r.checkIn,
      end: addOneDay(r.checkOut),
      color: statusColor[r.status],
      extendedProps: r
    };
  });

  function eventsOnDay(key) {
    return reservations.filter(function (r) { return key >= r.checkIn && key <= r.checkOut; });
  }

  function renderDetail(key) {
    var d = new Date(key);
    document.getElementById('detailTitle').textContent =
      (d.getMonth() + 1) + '월 ' + d.getDate() + '일 예약 (' + eventsOnDay(key).length + '건)';

    var box = document.getElementById('calDetail');
    var list = eventsOnDay(key);

    if (list.length === 0) {
      box.innerHTML = '<div class="cal-detail-empty">해당 날짜에 예약이 없습니다.</div>';
      return;
    }

    box.innerHTML = '';
    list.forEach(function (r) {
      var item = document.createElement('div');
      item.className = 'cal-detail-item';
      item.innerHTML =
        '<span class="bs-badge ' + statusBadgeClass[r.status] + ' badge">' + statusLabel[r.status] + '</span>' +
        '<div class="info"><b>' + r.name + ' · ' + r.pet + '</b><small>' + r.room + ' · ' + r.checkIn + ' ~ ' + r.checkOut + '</small></div>';
      box.appendChild(item);
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      locale: 'ko',
      height: 'auto',
      headerToolbar: { left: 'prev,next today', center: 'title', right: '' },
      buttonText: { today: '오늘' },
      events: events,
      dateClick: function (info) {
        renderDetail(info.dateStr);
      },
      eventClick: function (info) {
        renderDetail(info.event.startStr);
      }
    });
    calendar.render();

    renderDetail(toKey(new Date()));
  });
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>