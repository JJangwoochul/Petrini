<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="stay" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
  .res-wrap{max-width:740px;margin:32px auto 80px;padding:0 20px}
  .res-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:6px}
  .res-sub{font-size:14px;color:var(--text-muted);margin-bottom:28px}
  .res-place-card{display:flex;gap:14px;align-items:center;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:16px 18px;margin-bottom:22px}
  .res-place-thumb{width:80px;height:80px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .res-place-name{font-size:15px;font-weight:800;color:var(--text-main);margin-bottom:4px}
  .res-place-meta{font-size:13px;color:var(--text-muted)}
  .res-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:22px;margin-bottom:16px}
  .res-section h3{font-size:15px;font-weight:800;color:var(--text-main);margin:0 0 16px;padding-bottom:12px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:8px}
  .res-section h3 svg{width:16px;height:16px;stroke:var(--primary);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .res-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
  .res-group{display:flex;flex-direction:column;gap:5px}
  .res-group.full{grid-column:1/-1}
  .res-group label{font-size:13px;font-weight:600;color:var(--text-sub)}
  .res-group label .req{color:var(--accent);margin-left:2px}
  .res-group input,.res-group select,.res-group textarea{border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 13px;font-size:14px;color:var(--text-main);outline:none;font-family:inherit;width:100%;box-sizing:border-box;transition:border-color .2s}
  .res-group input:focus,.res-group select:focus,.res-group textarea:focus{border-color:var(--primary)}
  .res-group textarea{min-height:80px;resize:vertical;line-height:1.6}
  .pet-pick-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px}
  .pet-pick-card{display:flex;align-items:center;gap:12px;border:2px solid var(--border);border-radius:var(--radius-sm);padding:12px 14px;cursor:pointer;transition:.2s}
  .pet-pick-card:hover{border-color:var(--primary)}
  .pet-pick-card.selected{border-color:var(--primary);background:var(--primary-light)}
  .pet-pick-card input[type="radio"]{display:none}
  .pet-pick-name{font-size:14px;font-weight:700;color:var(--text-main)}
  .pet-pick-meta{font-size:12px;color:var(--text-muted)}
  .price-summary{background:var(--bg-page);border-radius:var(--radius-sm);padding:18px}
  .ps-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub);margin-bottom:10px}
  .ps-row.total{font-size:18px;font-weight:800;color:var(--text-main);padding-top:12px;border-top:1px solid var(--border);margin-top:6px}
  .ps-row.total span:last-child{color:var(--primary-dark)}
  .btn-pay-submit{width:100%;padding:16px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:17px;font-weight:800;cursor:pointer;margin-top:16px;transition:.15s}
  .btn-pay-submit:hover{background:var(--primary-dark)}
</style>

<div class="res-wrap">
  <h1 class="res-title">예약 / 결제</h1>
  <p class="res-sub">예약 정보를 확인하고 결제를 진행하세요.</p>

  <%-- 숙소 요약 --%>
  <div class="res-place-card">
    <c:choose>
      <c:when test="${not empty imgList}">
        <img class="res-place-thumb" src="${contextPath}/upload/${imgList[0].fileUrl}" alt="${stay.name}">
      </c:when>
      <c:otherwise>
        <img class="res-place-thumb" src="https://placehold.co/80x80/E0F2FE/0284C7?text=숙소" alt="숙소">
      </c:otherwise>
    </c:choose>
    <div>
      <div class="res-place-name">${stay.name}</div>
      <div class="res-place-meta">${stay.addr}</div>
    </div>
  </div>

  <form id="reserveForm" action="${contextPath}/stay/reserve" method="post">
    <input type="hidden" name="stayId" value="${stay.stayId}">

    <%-- 객실 + 날짜 --%>
    <div class="res-section">
      <h3>
        <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
        객실 및 일정
      </h3>
      <div class="res-grid">
        <div class="res-group full">
          <label>객실 선택 <span class="req">*</span></label>
          <select name="roomId" id="roomSelect" required onchange="calcPrice()">
            <option value="">객실을 선택하세요</option>
            <c:forEach var="room" items="${stay.rooms}">
              <option value="${room.roomId}"
                      data-price="${room.pricePerNight}"
                      ${room.roomId == selectedRoomId ? 'selected' : ''}>
                ${room.name} — <fmt:formatNumber value="${room.pricePerNight}" pattern="#,###"/>원/박
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="res-group">
          <label>체크인 <span class="req">*</span></label>
          <input type="date" name="checkinDate" id="checkinDate" required onchange="calcPrice()">
        </div>
        <div class="res-group">
          <label>체크아웃 <span class="req">*</span></label>
          <input type="date" name="checkoutDate" id="checkoutDate" required onchange="calcPrice()">
        </div>
      </div>
    </div>

    <%-- 반려동물 선택 --%>
    <div class="res-section">
      <h3>
        <svg viewBox="0 0 24 24"><circle cx="11" cy="4" r="2"/><circle cx="18" cy="8" r="2"/><circle cx="20" cy="16" r="2"/><circle cx="4" cy="8" r="2"/><path d="M12 10c-1.5 2-3 3.5-3 5a3 3 0 006 0c0-1.5-1.5-3-3-5z"/></svg>
        함께 가는 반려동물
      </h3>
      <c:choose>
        <c:when test="${not empty petList}">
          <div class="pet-pick-grid">
            <c:forEach var="pet" items="${petList}" varStatus="st">
              <label class="pet-pick-card ${st.index == 0 ? 'selected' : ''}" onclick="selPet(this)">
                <input type="radio" name="petId" value="${pet.petId}" ${st.index == 0 ? 'checked' : ''}>
                <div>
                  <div class="pet-pick-name">${pet.petName}</div>
                  <div class="pet-pick-meta">${pet.breed} · ${pet.age}세</div>
                </div>
              </label>
            </c:forEach>
          </div>
        </c:when>
        <c:otherwise>
          <p style="color:var(--text-muted);font-size:14px">
            등록된 반려동물이 없습니다. <a href="${contextPath}/mypage/pet" style="color:var(--primary)">반려동물 등록</a> 후 이용해주세요.
          </p>
        </c:otherwise>
      </c:choose>
    </div>

    <%-- 예약자 정보 --%>
    <div class="res-section">
      <h3>
        <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        예약자 정보
      </h3>
      <div class="res-grid">
        <div class="res-group"><label>이름</label><input type="text" value="${memberInfo.memberName}" readonly></div>
        <div class="res-group"><label>연락처</label><input type="tel" value="${memberInfo.phone}" readonly></div>
        <div class="res-group full"><label>요청사항</label><textarea name="requestMemo" placeholder="숙소에 요청하실 사항을 입력하세요."></textarea></div>
      </div>
    </div>

    <%-- 결제 금액 --%>
    <input type="hidden" name="nightCnt" id="nightCntInput" value="0">
    <input type="hidden" name="totalAmount" id="totalAmountInput" value="0">

    <div class="res-section">
      <h3>
        <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
        결제 금액
      </h3>
      <div class="price-summary">
        <div class="ps-row"><span>숙박 요금</span><span id="priceLabel">객실과 날짜를 선택하세요</span></div>
        <c:if test="${not empty stay.petFee}">
          <div class="ps-row"><span>반려동물 추가 비용</span><span>${stay.petFee}</span></div>
        </c:if>
        <div class="ps-row total"><span>총 결제금액</span><span id="totalLabel">-</span></div>
      </div>
      <button type="submit" class="btn-pay-submit" id="submitBtn" disabled>예약 신청하기</button>
    </div>
  </form>
</div>

<script>
  // 오늘 날짜를 min으로 설정
  var today = new Date().toISOString().split('T')[0];
  document.getElementById('checkinDate').min = today;
  document.getElementById('checkoutDate').min = today;

  function selPet(el) {
    document.querySelectorAll('.pet-pick-card').forEach(function(c){ c.classList.remove('selected'); });
    el.classList.add('selected');
    el.querySelector('input[type="radio"]').checked = true;
  }

  function calcPrice() {
    var roomSel = document.getElementById('roomSelect');
    var ci = document.getElementById('checkinDate').value;
    var co = document.getElementById('checkoutDate').value;

    if (!roomSel.value || !ci || !co) {
      document.getElementById('priceLabel').textContent = '객실과 날짜를 선택하세요';
      document.getElementById('totalLabel').textContent = '-';
      document.getElementById('submitBtn').disabled = true;
      return;
    }

    var ciDate = new Date(ci);
    var coDate = new Date(co);
    var nights = Math.round((coDate - ciDate) / (1000 * 60 * 60 * 24));

    if (nights <= 0) {
      document.getElementById('priceLabel').textContent = '체크아웃은 체크인 이후여야 합니다';
      document.getElementById('totalLabel').textContent = '-';
      document.getElementById('submitBtn').disabled = true;
      return;
    }

    var price = Number(roomSel.options[roomSel.selectedIndex].dataset.price);
    var total = price * nights;

    document.getElementById('nightCntInput').value = nights;
    document.getElementById('totalAmountInput').value = total;
    document.getElementById('priceLabel').textContent =
        price.toLocaleString() + '원 × ' + nights + '박';
    document.getElementById('totalLabel').textContent =
        total.toLocaleString() + '원';
    document.getElementById('submitBtn').disabled = false;
    document.getElementById('submitBtn').textContent =
        total.toLocaleString() + '원 예약 신청하기';
  }

  // 초기 선택값이 있으면 계산
  if (document.getElementById('roomSelect').value) calcPrice();
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
