<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="reserve" />
<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
<style>
  .fc .fc-button-primary{background:#4F6BC4;border-color:#4F6BC4}
  .fc .fc-button-primary:hover,.fc .fc-button-primary:not(:disabled).fc-button-active{background:#2D2D5E;border-color:#2D2D5E}
  .fc .fc-today-button{background:#2D2D5E;border-color:#2D2D5E}
  .fc .fc-daygrid-day.fc-day-today{background:rgba(79,107,196,.08)!important}
  .fc-daygrid-event{border-radius:6px!important;font-size:12px!important;padding:2px 5px!important}
  .biz-legend{display:flex;gap:14px;align-items:center;flex-wrap:wrap;margin-bottom:14px}
  .legend-dot{width:10px;height:10px;border-radius:50%;display:inline-block;margin-right:4px}
  .biz-modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);z-index:9999;align-items:center;justify-content:center}
  .biz-modal-overlay.on{display:flex}
  .biz-modal{background:#fff;border-radius:12px;padding:28px;min-width:340px;max-width:460px;width:90%}
  .biz-modal h3{font-size:17px;font-weight:800;color:#1A1A2E;margin:0 0 18px}
  .biz-modal-row{display:flex;justify-content:space-between;font-size:14px;margin-bottom:10px}
  .biz-modal-row span:first-child{color:#888}
  .biz-modal-row span:last-child{font-weight:600;color:#1A1A2E}
  .biz-modal-actions{display:flex;gap:8px;margin-top:20px}
  .biz-modal-actions button{flex:1;padding:10px;border-radius:8px;font-size:14px;font-weight:700;cursor:pointer}
  .btn-confirm{border:none;background:#4F6BC4;color:#fff}
  .btn-cancel-biz{border:2px solid #E2E8E4;background:#fff;color:#555}
  .btn-close-modal{border:none;background:#F5F5F5;color:#555}
</style>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 관리</h1>
    <p class="biz-page-desc">체크인·체크아웃 일정을 월간 캘린더에서 한눈에 확인하세요.</p>
  </div>
  <div class="biz-card" style="padding:20px">
    <div class="biz-legend">
      <span><span class="legend-dot" style="background:#93C5FD"></span>대기</span>
      <span><span class="legend-dot" style="background:#4F6BC4"></span>예약확정</span>
      <span><span class="legend-dot" style="background:#10B981"></span>체크인</span>
      <span><span class="legend-dot" style="background:#6B7280"></span>체크아웃</span>
    </div>
    <div id="calendar"></div>
  </div>
</main>

<div class="biz-modal-overlay" id="modalOverlay">
  <div class="biz-modal">
    <h3>예약 상세</h3>
    <div class="biz-modal-row"><span>고객명</span><span id="mName"></span></div>
    <div class="biz-modal-row"><span>반려동물</span><span id="mPet"></span></div>
    <div class="biz-modal-row"><span>객실</span><span id="mRoom"></span></div>
    <div class="biz-modal-row"><span>체크인</span><span id="mIn"></span></div>
    <div class="biz-modal-row"><span>체크아웃</span><span id="mOut"></span></div>
    <div class="biz-modal-row"><span>상태</span><span id="mStatus"></span></div>
    <div class="biz-modal-actions">
      <button class="btn-confirm" onclick="alert('체크인 처리되었습니다.')">체크인</button>
      <button class="btn-cancel-biz" onclick="if(confirm('예약을 취소하시겠습니까?'))alert('취소되었습니다.')">취소</button>
      <button class="btn-close-modal" onclick="closeModal()">닫기</button>
    </div>
  </div>
</div>
<script>
function closeModal(){ document.getElementById('modalOverlay').classList.remove('on'); }
document.getElementById('modalOverlay').addEventListener('click', function(e){ if(e.target===this) closeModal(); });
var today = new Date();
function ds(dayOff){ var dt=new Date(today); dt.setDate(today.getDate()+dayOff); return dt.toISOString().split('T')[0]; }
var events=[
  {title:'김예진 — 독채 풀빌라',  start:ds(-2), end:ds(0),  color:'#6B7280', extendedProps:{name:'김예진',pet:'코코 (비숑)',room:'독채 풀빌라 A동',checkIn:ds(-2),checkOut:ds(0),status:'체크아웃'}},
  {title:'이성민 — 스탠다드룸',   start:ds(0),  end:ds(2),  color:'#10B981', extendedProps:{name:'이성민',pet:'두부 (포메)',room:'스탠다드룸 201',checkIn:ds(0),checkOut:ds(2),status:'체크인'}},
  {title:'박소현 — 패밀리스위트', start:ds(1),  end:ds(4),  color:'#4F6BC4', extendedProps:{name:'박소현',pet:'몽이 (골든)',room:'패밀리 스위트 B동',checkIn:ds(1),checkOut:ds(4),status:'예약확정'}},
  {title:'최민준 — 독채 풀빌라',  start:ds(3),  end:ds(5),  color:'#93C5FD', extendedProps:{name:'최민준',pet:'하루 (시츄)',room:'독채 풀빌라 B동',checkIn:ds(3),checkOut:ds(5),status:'대기'}},
  {title:'정아린 — 스탠다드룸',   start:ds(5),  end:ds(7),  color:'#4F6BC4', extendedProps:{name:'정아린',pet:'보리 (말티푸)',room:'스탠다드룸 102',checkIn:ds(5),checkOut:ds(7),status:'예약확정'}},
  {title:'한지우 — 패밀리스위트', start:ds(7),  end:ds(10), color:'#93C5FD', extendedProps:{name:'한지우',pet:'달이 (사모예드)',room:'패밀리 스위트 A동',checkIn:ds(7),checkOut:ds(10),status:'대기'}},
];
document.addEventListener('DOMContentLoaded', function(){
  var cal = new FullCalendar.Calendar(document.getElementById('calendar'),{
    locale:'ko', initialView:'dayGridMonth',
    headerToolbar:{left:'prev,next today',center:'title',right:'dayGridMonth,timeGridWeek'},
    buttonText:{today:'오늘',month:'월간',week:'주간'},
    height:700, events:events,
    eventClick:function(info){
      var p=info.event.extendedProps;
      document.getElementById('mName').textContent=p.name;
      document.getElementById('mPet').textContent=p.pet;
      document.getElementById('mRoom').textContent=p.room;
      document.getElementById('mIn').textContent=p.checkIn;
      document.getElementById('mOut').textContent=p.checkOut;
      document.getElementById('mStatus').textContent=p.status;
      document.getElementById('modalOverlay').classList.add('on');
    }
  });
  cal.render();
});
</script>
<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
