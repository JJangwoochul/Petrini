<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="hospital" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
.reserve-wrap{max-width:700px;margin:32px auto 80px;padding:0 20px}
.reserve-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:6px}
.reserve-hospital{font-size:14px;color:var(--text-muted);margin-bottom:28px}
.step-bar{display:flex;align-items:center;margin-bottom:36px}
.step-item{display:flex;flex-direction:column;align-items:center;gap:6px;flex:1;position:relative}
.step-item:not(:last-child)::after{content:"";position:absolute;top:18px;left:50%;right:-50%;height:2px;background:var(--border);z-index:0}
.step-item.done:not(:last-child)::after,.step-item.active:not(:last-child)::after{background:var(--primary)}
.step-num{width:36px;height:36px;border-radius:50%;border:2px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:var(--text-muted);background:#fff;position:relative;z-index:1}
.step-item.done .step-num{background:var(--primary);border-color:var(--primary);color:#fff}
.step-item.active .step-num{background:var(--primary-light);border-color:var(--primary);color:var(--primary-dark)}
.step-label{font-size:12px;color:var(--text-muted);font-weight:500}
.step-item.active .step-label{color:var(--primary-dark);font-weight:700}
.step-section{display:none}.step-section.on{display:block}
.step-section-title{font-size:18px;font-weight:800;color:var(--text-main);margin-bottom:18px}
.pet-select-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.pet-select-card{border:2px solid var(--border);border-radius:var(--radius-md);padding:16px;display:flex;align-items:center;gap:14px;cursor:pointer;transition:var(--transition)}
.pet-select-card:hover{border-color:var(--primary)}
.pet-select-card.selected{border-color:var(--primary);background:var(--primary-light)}
.pet-select-thumb{width:56px;height:56px;border-radius:50%;object-fit:cover;flex-shrink:0;background:var(--primary-light);display:flex;align-items:center;justify-content:center;font-size:20px;font-weight:800;color:var(--primary-dark)}
.pet-select-name{font-size:15px;font-weight:700;color:var(--text-main);margin-bottom:3px}
.pet-select-meta{font-size:12px;color:var(--text-muted)}
.reserve-date-input{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:12px 14px;font-size:15px;box-sizing:border-box}
.time-slots{display:grid;grid-template-columns:repeat(4,1fr);gap:10px}
.time-slot{padding:10px;border:1px solid var(--border);border-radius:var(--radius-sm);text-align:center;font-size:14px;cursor:pointer;transition:var(--transition);color:var(--text-sub)}
.time-slot:hover{border-color:var(--primary);color:var(--primary)}
.time-slot.selected{border-color:var(--primary);background:var(--primary);color:#fff;font-weight:700}
.symptom-chips{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:14px}
.reserve-textarea{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:12px 14px;font-size:14px;min-height:100px;resize:vertical;outline:none;font-family:inherit;box-sizing:border-box}
.reserve-textarea:focus{border-color:var(--primary)}
.reserve-summary{background:var(--bg-page);border-radius:var(--radius-md);padding:20px;display:flex;flex-direction:column;gap:12px}
.rs-row{display:flex;justify-content:space-between;font-size:14px}
.rs-row span:first-child{color:var(--text-muted)}
.rs-row span:last-child{color:var(--text-main);font-weight:600;text-align:right}
.reserve-nav{display:flex;justify-content:space-between;margin-top:24px}
.btn-prev{padding:12px 28px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;color:var(--text-sub);font-size:15px;font-weight:700;cursor:pointer}
.btn-next{padding:12px 32px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:15px;font-weight:700;cursor:pointer;transition:var(--transition)}
.btn-next:hover{background:var(--primary-dark)}
.reserve-empty{text-align:center;padding:40px 0;color:var(--text-muted);font-size:14px}
</style>

<%-- 2026-07-10 장우철 — 병원 예약 DB 연동 (F1~F2), UI 흐름 유지 --%>
<form id="reserveForm" method="post" action="${contextPath}/hospital/reserve">
  <input type="hidden" name="hospitalId" value="${hospitalId}">
  <input type="hidden" name="petId" id="petIdInput" value="">
  <input type="hidden" name="resvTime" id="resvTimeInput" value="">

<div class="reserve-wrap">
  <h1 class="reserve-title">병원 예약</h1>
  <div class="reserve-hospital">${hospital.name} · ${hospital.addr}</div>

  <div class="step-bar">
    <div class="step-item active" id="si1"><div class="step-num">1</div><span class="step-label">반려동물 선택</span></div>
    <div class="step-item" id="si2"><div class="step-num">2</div><span class="step-label">날짜 선택</span></div>
    <div class="step-item" id="si3"><div class="step-num">3</div><span class="step-label">시간 선택</span></div>
    <div class="step-item" id="si4"><div class="step-num">4</div><span class="step-label">내용 입력</span></div>
  </div>

  <div class="step-section on" id="step1">
    <div class="step-section-title">예약할 반려동물을 선택하세요</div>
    <c:choose>
      <c:when test="${empty petList}">
        <div class="reserve-empty">등록된 반려동물이 없습니다.<br>마이페이지에서 반려동물을 등록해 주세요.</div>
      </c:when>
      <c:otherwise>
        <div class="pet-select-grid">
          <c:forEach var="pet" items="${petList}" varStatus="st">
            <div class="pet-select-card ${st.first ? 'selected' : ''}" data-pet-id="${pet.petId}"
                 data-pet-name="${pet.petName}"
                 data-pet-meta="${pet.breed} · ${pet.age}세"
                 onclick="selectPet(this)">
              <div class="pet-select-thumb">${fn:substring(pet.petName, 0, 1)}</div>
              <div>
                <div class="pet-select-name">${pet.petName}</div>
                <div class="pet-select-meta">
                  <c:choose>
                    <c:when test="${pet.species eq 'DOG'}">강아지</c:when>
                    <c:when test="${pet.species eq 'CAT'}">고양이</c:when>
                    <c:otherwise>기타</c:otherwise>
                  </c:choose>
                  · ${pet.breed} · ${pet.age}세
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
    <div class="reserve-nav"><span></span><button type="button" class="btn-next" onclick="goStep(2)">다음 →</button></div>
  </div>

  <div class="step-section" id="step2">
    <div class="step-section-title">예약 날짜를 선택하세요</div>
    <input type="date" class="reserve-date-input" name="resvDate" id="resvDate" required>
    <div class="reserve-nav">
      <button type="button" class="btn-prev" onclick="goStep(1)">이전</button>
      <button type="button" class="btn-next" onclick="goStep(3)">다음</button>
    </div>
  </div>

  <div class="step-section" id="step3">
    <div class="step-section-title">예약 시간을 선택하세요</div>
    <p style="font-size:13px;color:var(--text-muted);margin-bottom:16px" id="timeDateLabel">날짜를 먼저 선택해 주세요</p>
    <div class="time-slots" id="timeSlots">
      <div class="time-slot" data-time="09:00" onclick="selTime(this)">09:00</div>
      <div class="time-slot" data-time="10:00" onclick="selTime(this)">10:00</div>
      <div class="time-slot" data-time="10:30" onclick="selTime(this)">10:30</div>
      <div class="time-slot" data-time="11:00" onclick="selTime(this)">11:00</div>
      <div class="time-slot" data-time="14:00" onclick="selTime(this)">14:00</div>
      <div class="time-slot" data-time="14:30" onclick="selTime(this)">14:30</div>
      <div class="time-slot" data-time="15:00" onclick="selTime(this)">15:00</div>
      <div class="time-slot" data-time="15:30" onclick="selTime(this)">15:30</div>
      <div class="time-slot" data-time="16:00" onclick="selTime(this)">16:00</div>
      <div class="time-slot" data-time="17:00" onclick="selTime(this)">17:00</div>
    </div>
    <div class="reserve-nav">
      <button type="button" class="btn-prev" onclick="goStep(2)">이전</button>
      <button type="button" class="btn-next" onclick="goStep(4)">다음</button>
    </div>
  </div>

  <div class="step-section" id="step4">
    <div class="step-section-title">증상 및 요청사항을 입력하세요</div>
    <div class="symptom-chips">
      <span class="chip" onclick="toggleChip(this)">정기검진</span>
      <span class="chip" onclick="toggleChip(this)">피부 트러블</span>
      <span class="chip" onclick="toggleChip(this)">구토/설사</span>
      <span class="chip" onclick="toggleChip(this)">식욕 저하</span>
      <span class="chip" onclick="toggleChip(this)">예방접종</span>
    </div>
    <input type="text" name="symptoms" id="symptomsInput" class="reserve-date-input" style="margin-bottom:12px" placeholder="주요 증상">
    <textarea class="reserve-textarea" name="requestMemo" id="requestMemoInput" placeholder="요청사항 (선택)"></textarea>
    <div style="margin-top:20px;margin-bottom:14px"><strong style="font-size:15px;color:var(--text-main)">예약 최종 확인</strong></div>
    <div class="reserve-summary">
      <div class="rs-row"><span>병원</span><span id="sumHospital">${hospital.name}</span></div>
      <div class="rs-row"><span>반려동물</span><span id="sumPet">-</span></div>
      <div class="rs-row"><span>예약 일시</span><span id="sumDateTime">-</span></div>
      <div class="rs-row"><span>주증상</span><span id="sumSymptom">-</span></div>
    </div>
    <div class="reserve-nav">
      <button type="button" class="btn-prev" onclick="goStep(3)">이전</button>
      <button type="button" class="btn-next" onclick="submitReserve()">예약 완료</button>
    </div>
  </div>
</div>
</form>

<script>
var currentStep = 1;
var selectedPetCard = document.querySelector('.pet-select-card.selected');

function goStep(n) {
  if (n === 2 && !document.getElementById('petIdInput').value) {
    var first = document.querySelector('.pet-select-card');
    if (first) selectPet(first);
    if (!document.getElementById('petIdInput').value) { alert('반려동물을 선택해 주세요.'); return; }
  }
  if (n === 3) {
    var d = document.getElementById('resvDate').value;
    if (!d) { alert('예약 날짜를 선택해 주세요.'); return; }
    document.getElementById('timeDateLabel').textContent = d + ' 예약 시간을 선택하세요';
  }
  if (n === 4) {
    if (!document.getElementById('resvTimeInput').value) { alert('예약 시간을 선택해 주세요.'); return; }
    updateSummary();
  }
  document.getElementById('step'+currentStep).classList.remove('on');
  for (var i=1;i<=4;i++){
    var si = document.getElementById('si'+i);
    si.className = 'step-item';
    if (i < n) si.classList.add('done');
    else if (i === n) si.classList.add('active');
  }
  currentStep = n;
  document.getElementById('step'+n).classList.add('on');
  window.scrollTo(0,0);
}

function selectPet(el) {
  document.querySelectorAll('.pet-select-card').forEach(function(c){ c.classList.remove('selected'); });
  el.classList.add('selected');
  selectedPetCard = el;
  document.getElementById('petIdInput').value = el.getAttribute('data-pet-id');
}

function selTime(el) {
  document.querySelectorAll('.time-slot').forEach(function(t){ t.classList.remove('selected'); });
  el.classList.add('selected');
  document.getElementById('resvTimeInput').value = el.getAttribute('data-time');
}

function toggleChip(el) {
  el.classList.toggle('on');
  var chips = [];
  document.querySelectorAll('.symptom-chips .chip.on').forEach(function(c){ chips.push(c.textContent); });
  if (chips.length) document.getElementById('symptomsInput').value = chips.join(', ');
}

function updateSummary() {
  if (selectedPetCard) {
    document.getElementById('sumPet').textContent =
      selectedPetCard.getAttribute('data-pet-name') + ' (' + selectedPetCard.getAttribute('data-pet-meta') + ')';
  }
  var d = document.getElementById('resvDate').value;
  var t = document.getElementById('resvTimeInput').value;
  document.getElementById('sumDateTime').textContent = d + ' ' + t;
  document.getElementById('sumSymptom').textContent = document.getElementById('symptomsInput').value || '-';
}

function submitReserve() {
  if (!document.getElementById('petIdInput').value) { alert('반려동물을 선택해 주세요.'); goStep(1); return; }
  if (!document.getElementById('resvDate').value) { alert('예약 날짜를 선택해 주세요.'); goStep(2); return; }
  if (!document.getElementById('resvTimeInput').value) { alert('예약 시간을 선택해 주세요.'); goStep(3); return; }
  if (confirm('예약을 확정하시겠습니까?')) {
    document.getElementById('reserveForm').submit();
  }
}

(function init() {
  var today = new Date().toISOString().slice(0, 10);
  document.getElementById('resvDate').setAttribute('min', today);
  var first = document.querySelector('.pet-select-card.selected') || document.querySelector('.pet-select-card');
  if (first) selectPet(first);
})();
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
