<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="event" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .cp-wrap{max-width:760px;margin:32px auto 80px;padding:0 20px}
  .cp-head{margin-bottom:24px}
  .cp-head h1{font-size:24px;font-weight:800;color:var(--text-main);margin:0 0 4px}
  .cp-head p{font-size:14px;color:var(--text-muted);margin:0}
  .cp-summary{background:linear-gradient(135deg,#92400E 0%,#F59E0B 100%);border-radius:var(--radius-md);padding:20px 24px;color:#fff;display:flex;justify-content:space-between;align-items:center;margin-bottom:28px}
  .cp-summary-label{font-size:13px;opacity:.85;margin-bottom:4px}
  .cp-summary-val{font-size:26px;font-weight:800}
  .cp-tabs{display:flex;gap:0;border-bottom:2px solid var(--border);margin-bottom:20px}
  .cp-tab{padding:12px 24px;font-size:15px;font-weight:600;color:var(--text-muted);border:none;background:none;cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:var(--transition)}
  .cp-tab.on{color:#D97706;border-bottom-color:#D97706}
  .cp-section{display:none}
  .cp-section.on{display:block}

  /* 쿠폰 티켓 카드 */
  .cp-ticket{display:flex;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden;margin-bottom:14px}
  .cp-ticket-left{width:120px;flex-shrink:0;background:#FFFBEB;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:16px;position:relative;border-right:2px dashed #FDE68A}
  .cp-ticket-left::before,.cp-ticket-left::after{content:"";position:absolute;width:18px;height:18px;background:#F7F9F7;border-radius:50%;right:-10px}
  .cp-ticket-left::before{top:-9px}
  .cp-ticket-left::after{bottom:-9px}
  .cp-ticket-pct{font-size:22px;font-weight:800;color:#B45309;line-height:1.1}
  .cp-ticket-unit{font-size:12px;color:#B45309;font-weight:700}
  .cp-ticket-body{flex:1;padding:16px 20px;display:flex;justify-content:space-between;align-items:center;gap:14px}
  .cp-ticket-name{font-size:14px;font-weight:700;color:var(--text-main);margin-bottom:4px}
  .cp-ticket-cond{font-size:12px;color:var(--text-muted);margin-bottom:2px}
  .cp-ticket-date{font-size:12px;color:var(--text-muted)}
  .cp-ticket-btn{padding:9px 18px;border:none;border-radius:var(--radius-sm);background:#F59E0B;color:#fff;font-size:13px;font-weight:700;cursor:pointer;white-space:nowrap;flex-shrink:0}
  .cp-ticket-btn:hover{background:#D97706}
  .cp-ticket-btn.used{background:#F5F5F5;color:#aaa;cursor:not-allowed}
  .cp-ticket.held .cp-ticket-left{background:var(--primary-light)}
  .cp-ticket.held .cp-ticket-pct,.cp-ticket.held .cp-ticket-unit{color:var(--primary-dark)}
  .cp-ticket.held .cp-ticket-left::before,.cp-ticket.held .cp-ticket-left::after{border:1px solid var(--border)}
  .cp-ticket-btn.use{background:var(--primary)}
  .cp-ticket-btn.use:hover{background:var(--primary-dark)}

  .cp-empty{text-align:center;padding:60px 0;color:var(--text-muted);font-size:14px}
</style>

<div class="cp-wrap">
  <div class="cp-head">
    <h1>쿠폰함</h1>
    <p>받을 수 있는 쿠폰을 확인하고, 보유한 쿠폰을 관리하세요.</p>
  </div>

  <div class="cp-summary">
    <div>
      <div class="cp-summary-label">사용 가능한 쿠폰</div>
      <div class="cp-summary-val">2장</div>
    </div>
    <div style="text-align:right">
      <div class="cp-summary-label">받을 수 있는 쿠폰</div>
      <div class="cp-summary-val">3장</div>
    </div>
  </div>

  <div class="cp-tabs">
    <button class="cp-tab on" onclick="showTab(this,'available')">받을 수 있는 쿠폰</button>
    <button class="cp-tab" onclick="showTab(this,'held')">보유 쿠폰</button>
  </div>

  <%-- 받을 수 있는 쿠폰 --%>
  <div class="cp-section on" id="tab-available">
    <div class="cp-ticket">
      <div class="cp-ticket-left"><span class="cp-ticket-pct">10%</span><span class="cp-ticket-unit">할인</span></div>
      <div class="cp-ticket-body">
        <div>
          <div class="cp-ticket-name">신규 회원 첫 구매 쿠폰</div>
          <div class="cp-ticket-cond">5만원 이상 구매 시 · 전 카테고리</div>
          <div class="cp-ticket-date">2025.07.31까지</div>
        </div>
        <button class="cp-ticket-btn" onclick="claimCoupon(this)">받기</button>
      </div>
    </div>
    <div class="cp-ticket">
      <div class="cp-ticket-left"><span class="cp-ticket-pct">3,000</span><span class="cp-ticket-unit">원 할인</span></div>
      <div class="cp-ticket-body">
        <div>
          <div class="cp-ticket-name">병원 예약 첫 이용 쿠폰</div>
          <div class="cp-ticket-cond">전 진료과 사용 가능</div>
          <div class="cp-ticket-date">2025.08.31까지</div>
        </div>
        <button class="cp-ticket-btn" onclick="claimCoupon(this)">받기</button>
      </div>
    </div>
    <div class="cp-ticket">
      <div class="cp-ticket-left"><span class="cp-ticket-pct">20%</span><span class="cp-ticket-unit">할인</span></div>
      <div class="cp-ticket-body">
        <div>
          <div class="cp-ticket-name">미용·목욕 패키지 쿠폰</div>
          <div class="cp-ticket-cond">그루밍 전 업체 사용 가능 · 최대 1만원</div>
          <div class="cp-ticket-date">2025.08.10까지</div>
        </div>
        <button class="cp-ticket-btn" onclick="claimCoupon(this)">받기</button>
      </div>
    </div>
  </div>

  <%-- 보유 쿠폰 --%>
  <div class="cp-section" id="tab-held">
    <div class="cp-ticket held">
      <div class="cp-ticket-left"><span class="cp-ticket-pct">15%</span><span class="cp-ticket-unit">할인</span></div>
      <div class="cp-ticket-body">
        <div>
          <div class="cp-ticket-name">생일 축하 쿠폰</div>
          <div class="cp-ticket-cond">3만원 이상 구매 시</div>
          <div class="cp-ticket-date">2025.07.15까지 · 사용 가능</div>
        </div>
        <button class="cp-ticket-btn use" onclick="location.href='${contextPath}/store'">사용하러 가기</button>
      </div>
    </div>
    <div class="cp-ticket held">
      <div class="cp-ticket-left"><span class="cp-ticket-pct">5,000</span><span class="cp-ticket-unit">원 할인</span></div>
      <div class="cp-ticket-body">
        <div>
          <div class="cp-ticket-name">사진관 촬영 쿠폰</div>
          <div class="cp-ticket-cond">3만원 이상 촬영 시</div>
          <div class="cp-ticket-date">2025.07.20까지 · 사용 가능</div>
        </div>
        <button class="cp-ticket-btn use" onclick="location.href='${contextPath}/studio'">사용하러 가기</button>
      </div>
    </div>
    <div class="cp-ticket held" style="opacity:.55">
      <div class="cp-ticket-left"><span class="cp-ticket-pct">10%</span><span class="cp-ticket-unit">할인</span></div>
      <div class="cp-ticket-body">
        <div>
          <div class="cp-ticket-name">여름맞이 숙소 예약 쿠폰</div>
          <div class="cp-ticket-cond">2박 이상 예약 시</div>
          <div class="cp-ticket-date">2025.06.15 만료</div>
        </div>
        <button class="cp-ticket-btn used" disabled>기간만료</button>
      </div>
    </div>
  </div>
</div>

<script>
function showTab(el, name){
  document.querySelectorAll('.cp-tab').forEach(t=>t.classList.remove('on'));
  document.querySelectorAll('.cp-section').forEach(s=>s.classList.remove('on'));
  el.classList.add('on');
  document.getElementById('tab-'+name).classList.add('on');
}
function claimCoupon(btn){
  btn.textContent = '받기 완료';
  btn.disabled = true;
  btn.classList.add('used');
  alert('쿠폰함에 추가되었습니다! "보유 쿠폰" 탭에서 확인하세요.');
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
