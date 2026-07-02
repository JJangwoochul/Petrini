<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="stay" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
  .res-wrap { max-width: 740px; margin: 32px auto 80px; padding: 0 20px; }
  .res-title { font-size: 22px; font-weight: 800; color: var(--text-main); margin-bottom: 6px; }
  .res-sub   { font-size: 14px; color: var(--text-muted); margin-bottom: 28px; }
  
  /* 예약 숙소 요약 카드 */
  .res-place-card {
      display: flex; gap: 14px; align-items: center;
      background: var(--bg-card); border: 1px solid var(--border);
      border-radius: var(--radius-md); padding: 16px 18px; margin-bottom: 22px;
  }
  .res-place-thumb { width: 80px; height: 80px; border-radius: var(--radius-sm); object-fit: cover; flex-shrink: 0; }
  .res-place-name  { font-size: 15px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; }
  .res-place-meta  { font-size: 13px; color: var(--text-muted); }
  .res-place-price { margin-left: auto; font-size: 15px; font-weight: 800; color: var(--text-main); white-space: nowrap; }
  
  .res-section { background: var(--bg-card); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 22px; margin-bottom: 16px; }
  .res-section h3 { font-size: 15px; font-weight: 800; color: var(--text-main); margin: 0 0 16px; padding-bottom: 12px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 8px; }
  .res-section h3 svg { width: 16px; height: 16px; stroke: var(--primary); fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
  .res-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
  .res-group { display: flex; flex-direction: column; gap: 5px; }
  .res-group.full { grid-column: 1 / -1; }
  .res-group label { font-size: 13px; font-weight: 600; color: var(--text-sub); }
  .res-group label .req { color: var(--accent); margin-left: 2px; }
  .res-group input, .res-group select, .res-group textarea {
      border: 1px solid var(--border); border-radius: var(--radius-sm);
      padding: 10px 13px; font-size: 14px; color: var(--text-main);
      outline: none; font-family: inherit; width: 100%; box-sizing: border-box;
      transition: border-color .2s;
  }
  .res-group input:focus, .res-group select:focus, .res-group textarea:focus { border-color: var(--primary); }
  .res-group textarea { min-height: 80px; resize: vertical; line-height: 1.6; }
  
  /* 반려동물 선택 카드 */
  .pet-pick-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
  .pet-pick-card {
      display: flex; align-items: center; gap: 12px;
      border: 2px solid var(--border); border-radius: var(--radius-sm);
      padding: 12px 14px; cursor: pointer; transition: var(--transition);
  }
  .pet-pick-card:hover { border-color: var(--primary); }
  .pet-pick-card.selected { border-color: var(--primary); background: var(--primary-light); }
  .pet-pick-thumb { width: 44px; height: 44px; border-radius: 50%; object-fit: cover; flex-shrink: 0; }
  .pet-pick-name { font-size: 14px; font-weight: 700; color: var(--text-main); }
  .pet-pick-meta { font-size: 12px; color: var(--text-muted); }
  
  /* 결제 수단 */
  .pay-methods { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; }
  .pay-method  { display: none; }
  .pay-label {
      display: flex; flex-direction: column; align-items: center; gap: 5px;
      padding: 12px; border: 2px solid var(--border); border-radius: var(--radius-sm);
      cursor: pointer; transition: var(--transition); font-size: 12px; color: var(--text-sub); font-weight: 600;
  }
  .pay-label svg { width: 22px; height: 22px; stroke: var(--text-muted); fill: none; stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round; }
  .pay-method:checked + .pay-label { border-color: var(--primary); background: var(--primary-light); color: var(--primary-dark); }
  .pay-method:checked + .pay-label svg { stroke: var(--primary); }
  
  /* 금액 요약 */
  .price-summary { background: var(--bg-page); border-radius: var(--radius-sm); padding: 18px; }
  .ps-row { display: flex; justify-content: space-between; font-size: 14px; color: var(--text-sub); margin-bottom: 10px; }
  .ps-row.total { font-size: 18px; font-weight: 800; color: var(--text-main); padding-top: 12px; border-top: 1px solid var(--border); margin-top: 6px; }
  .ps-row.total span:last-child { color: var(--primary-dark); }
  
  .btn-pay-submit { width: 100%; padding: 16px; border: none; border-radius: var(--radius-sm); background: var(--primary); color: #fff; font-size: 17px; font-weight: 800; cursor: pointer; margin-top: 16px; transition: var(--transition); }
  .btn-pay-submit:hover { background: var(--primary-dark); }
</style>

<div class="res-wrap">
  <h1 class="res-title">예약 / 결제</h1>
  <p class="res-sub">예약 정보를 확인하고 결제를 진행하세요.</p>

  <%-- 예약 장소 요약 --%>
  <div class="res-place-card">
    <img class="res-place-thumb"
         src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=160&q=80&auto=format&fit=crop"
         alt="숙소" onerror="this.src='https://placehold.co/80x80/E0F2FE/0284C7?text=숙소'">
    <div>
      <div class="res-place-name">강아지숲 펫 빌라 — 독채 풀빌라</div>
      <div class="res-place-meta">경기 가평군 · 2025.07.05(토) ~ 07.06(일) · 1박 · 3명</div>
    </div>
    <div class="res-place-price">188,000원</div>
  </div>

  <%-- 반려동물 선택 --%>
  <div class="res-section">
    <h3>
      <svg viewBox="0 0 24 24"><circle cx="4.5" cy="9.5" r="2"/><circle cx="9" cy="5.5" r="2"/><circle cx="15" cy="5.5" r="2"/><circle cx="19.5" cy="9.5" r="2"/><path d="M12 13c-3.87 0-7 1.79-7 4v1h14v-1c0-2.21-3.13-4-7-4z"/></svg>
      함께 가는 반려동물
    </h3>
    <div class="pet-pick-grid">
      <div class="pet-pick-card selected" onclick="selPet(this)">
        <img class="pet-pick-thumb"
             src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=88&q=70&auto=format&fit=crop"
             alt="몽이" onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=DOG'">
        <div>
          <div class="pet-pick-name">몽이</div>
          <div class="pet-pick-meta">골든 리트리버 · 4세</div>
        </div>
      </div>
      <div class="pet-pick-card" onclick="selPet(this)">
        <img class="pet-pick-thumb"
             src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=88&q=70&auto=format&fit=crop"
             alt="나비" onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=CAT'">
        <div>
          <div class="pet-pick-name">나비</div>
          <div class="pet-pick-meta">페르시안 · 2세</div>
        </div>
      </div>
    </div>
  </div>

  <%-- 예약자 정보 --%>
  <div class="res-section">
    <h3>
      <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
      예약자 정보
    </h3>
    <div class="res-grid">
      <div class="res-group"><label>이름 <span class="req">*</span></label><input type="text" value="${memberInfo.memberName}"></div>
      <div class="res-group"><label>연락처 <span class="req">*</span></label><input type="tel" placeholder="010-0000-0000"></div>
      <div class="res-group full"><label>요청사항</label><textarea placeholder="숙소에 요청하실 사항을 입력하세요. (늦은 체크인, 알레르기 등)"></textarea></div>
    </div>
  </div>

  <%-- 결제 수단 --%>
  <div class="res-section">
    <h3>
      <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
      결제 수단
    </h3>
    <div class="pay-methods">
      <input type="radio" name="pay" id="pay-card" class="pay-method" checked>
      <label for="pay-card" class="pay-label">
        <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
        신용/체크카드
      </label>
      <input type="radio" name="pay" id="pay-kakao" class="pay-method">
      <label for="pay-kakao" class="pay-label">
        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 5.58 2 10c0 2.76 1.63 5.19 4.1 6.67L5 21l4.8-2.6C10.5 18.8 11.24 19 12 19c5.52 0 10-3.58 10-9s-4.48-9-10-9z"/></svg>
        카카오페이
      </label>
      <input type="radio" name="pay" id="pay-naver" class="pay-method">
      <label for="pay-naver" class="pay-label">
        <svg viewBox="0 0 24 24"><path d="M4 4l7 8-7 8h2l6-7 6 7h2L13 12l7-8h-2l-6 7-6-7z"/></svg>
        네이버페이
      </label>
      <input type="radio" name="pay" id="pay-bank" class="pay-method">
      <label for="pay-bank" class="pay-label">
        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M3 9h18"/></svg>
        계좌이체
      </label>
    </div>
  </div>

  <%-- 최종 금액 --%>
  <div class="res-section">
    <h3>
      <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
      최종 금액
    </h3>
    <div class="price-summary">
      <div class="ps-row"><span>숙박 요금 (1박)</span><span>158,000원</span></div>
      <div class="ps-row"><span>반려동물 추가 요금</span><span style="color:var(--primary)">무료</span></div>
      <div class="ps-row"><span>청소비</span><span>30,000원</span></div>
      <div class="ps-row"><span>쿠폰 할인</span><span style="color:var(--accent)">-0원</span></div>
      <div class="ps-row total"><span>총 결제금액</span><span>188,000원</span></div>
    </div>
    <button class="btn-pay-submit" onclick="if(confirm('188,000원을 결제하시겠습니까?'))location.href='${contextPath}/stay/complete'">188,000원 결제하기</button>
  </div>
</div>

<script>
function selPet(el) {
    el.classList.toggle('selected');
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
