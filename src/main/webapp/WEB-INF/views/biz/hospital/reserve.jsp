<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="reserve" />
<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
<style>
  .fc .fc-button-primary{background:#0284C7;border-color:#0284C7}
  .fc .fc-button-primary:hover,.fc .fc-button-primary:not(:disabled).fc-button-active{background:#0C4A6E;border-color:#0C4A6E}
  .fc .fc-today-button{background:#0C4A6E;border-color:#0C4A6E}
  .fc .fc-daygrid-day.fc-day-today,.fc .fc-timegrid-col.fc-day-today{background:rgba(2,132,199,.05)!important}
  .fc-timegrid-event{border-radius:6px!important;padding:2px 4px!important;font-size:12px!important}
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
  .btn-confirm{border:none;background:#0284C7;color:#fff}
  .btn-cancel-biz{border:2px solid #E2E8E4;background:#fff;color:#555}
  .btn-close-modal{border:none;background:#F5F5F5;color:#555}
</style>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">예약 관리</h1>
    <p class="biz-page-desc">진료 예약을 시간대별로 확인하고 처리하세요.</p>
  </div>
  <div class="biz-card" style="padding:20px">
    <div class="biz-legend">
      <span><span class="legend-dot" style="background:#BAE6FD"></span>대기</span>
      <span><span class="legend-dot" style="background:#0284C7"></span>확정</span>
      <span><span class="legend-dot" style="background:#059669"></span>진료완료</span>
      <span><span class="legend-dot" style="background:#DC2626"></span>응급</span>
    </div>
    <div id="calendar"></div>
  </div>
</main>

<div class="biz-modal-overlay" id="modalOverlay">
  <div class="biz-modal">
    <h3>진료 예약 상세</h3>
    <div class="biz-modal-row"><span>보호자명</span><span id="mName"></span></div>
    <div class="biz-modal-row"><span>환자 (반려동물)</span><span id="mPet"></span></div>
    <div class="biz-modal-row"><span>주증상</span><span id="mSymptom"></span></div>
    <div class="biz-modal-row"><span>담당 수의사</span><span id="mVet"></span></div>
    <div class="biz-modal-row"><span>예약 시간</span><span id="mTime"></span></div>
    <div class="biz-modal-row"><span>상태</span><span id="mStatus"></span></div>
    <div class="biz-modal-actions">
      <button class="btn-confirm" onclick="alert('진료 접수 처리되었습니다.')">접수</button>
      <button class="btn-cancel-biz" onclick="if(confirm('예약을 취소하시겠습니까?'))alert('취소되었습니다.')">취소</button>
      <button class="btn-close-modal" onclick="closeModal()">닫기</button>
    </div>
  </div>
</div>
<script>
  function closeModal() { 
    document.getElementById('modalOverlay').classList.remove('on'); 
  }

  document.getElementById('modalOverlay').addEventListener('click', function(e){ if(e.target===this) closeModal(); });
  var today = new Date();
  function d(dayOff,h,m){ var dt=new Date(today); dt.setDate(today.getDate()+dayOff); dt.setHours(h,m,0); return dt.toISOString(); }
  var events=[
    {title:'코코 — 피부 트러블',   start:d(0,9,0),  end:d(0,9,30), color:'#0284C7', extendedProps:{name:'김예진',pet:'코코 (비숑 · 2세)',symptom:'피부 트러블 / 가려움',vet:'이수진 수의사',status:'확정'}},
    {title:'두부 — 정기검진',      start:d(0,10,0), end:d(0,10,30),color:'#BAE6FD', extendedProps:{name:'이성민',pet:'두부 (포메 · 4세)',symptom:'정기 건강검진',vet:'박준혁 수의사',status:'대기'}},
    {title:'망고 — 예방접종',      start:d(0,11,0), end:d(0,11,20),color:'#0284C7', extendedProps:{name:'최아린',pet:'망고 (말티푸 · 1세)',symptom:'종합백신 예방접종',vet:'이수진 수의사',status:'확정'}},
    {title:'보리 — 응급 (구토)',   start:d(0,14,0), end:d(0,15,0), color:'#DC2626', extendedProps:{name:'한지우',pet:'보리 (골든 · 5세)',symptom:'반복 구토 / 식욕저하',vet:'박준혁 수의사',status:'응급'}},
    {title:'하루 — 구강검진',      start:d(1,9,30), end:d(1,10,0), color:'#BAE6FD', extendedProps:{name:'정우찬',pet:'하루 (시츄 · 3세)',symptom:'치석 / 잇몸 출혈',vet:'이수진 수의사',status:'대기'}},
    {title:'달이 — 슬개골 이상',   start:d(1,11,0), end:d(1,11,40),color:'#0284C7', extendedProps:{name:'오현수',pet:'달이 (포메 · 2세)',symptom:'뒷다리 절뚝임',vet:'박준혁 수의사',status:'확정'}},
    {title:'루비 — 예방접종',      start:d(2,10,0), end:d(2,10,20),color:'#BAE6FD', extendedProps:{name:'신지아',pet:'루비 (푸들 · 1세)',symptom:'광견병 예방접종',vet:'이수진 수의사',status:'대기'}},
    {title:'몽이 — 정기검진',      start:d(-1,14,0),end:d(-1,14,30),color:'#059669',extendedProps:{name:'박소현',pet:'몽이 (골든 · 4세)',symptom:'정기 건강검진',vet:'박준혁 수의사',status:'진료완료'}},
    {title:'콩이 — 피부 트러블',   start:d(-1,10,0),end:d(-1,10,30),color:'#059669',extendedProps:{name:'이나연',pet:'콩이 (비숑 · 1세)',symptom:'피부 발진',vet:'이수진 수의사',status:'진료완료'}},
  ];

  document.addEventListener('DOMContentLoaded', function(){
    var cal = new FullCalendar.Calendar(document.getElementById('calendar'),{
      locale:'ko', initialView:'timeGridWeek',
      headerToolbar:{left:'prev,next today',center:'title',right:'timeGridWeek,timeGridDay,listWeek'},
      buttonText:{today:'오늘',week:'주간',day:'일간',list:'목록'},
      slotMinTime:'09:00:00', slotMaxTime:'19:00:00', slotDuration:'00:30:00',
      allDaySlot:false, nowIndicator:true, height:680, events:events,
      eventClick:function(info){
        var p=info.event.extendedProps, s=info.event.start, e=info.event.end;
        var fmt=function(dt){return dt.getHours()+':'+(dt.getMinutes()<10?'0':'')+dt.getMinutes();};
        document.getElementById('mName').textContent=p.name;
        document.getElementById('mPet').textContent=p.pet;
        document.getElementById('mSymptom').textContent=p.symptom;
        document.getElementById('mVet').textContent=p.vet;
        document.getElementById('mTime').textContent=fmt(s)+' ~ '+fmt(e);
        document.getElementById('mStatus').textContent=p.status;
        document.getElementById('modalOverlay').classList.add('on');
      }
    });
    cal.render();
  });
</script>
<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
