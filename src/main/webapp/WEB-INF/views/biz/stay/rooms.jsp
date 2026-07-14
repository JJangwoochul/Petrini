<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="rooms" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<style>
  .room-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}
  .room-form-actions{display:flex;justify-content:center;gap:10px;margin-top:22px}
  .room-form-actions .biz-btn-primary{min-width:180px}
  .price-cell{text-align:right;font-variant-numeric:tabular-nums}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">객실 관리</h1>
    <p class="biz-page-desc">객실 타입·가격을 등록하고 관리하세요.</p>
  </div>

  <%-- ═══ 객실 목록 ═══ --%>
  <div class="biz-card" style="margin-bottom:16px">
    <div class="room-table-head">
      <div class="biz-card-head" style="padding:20px 0 12px">
        <span>객실목록</span><small>총 ${fn:length(roomList)}실</small>
      </div>
      <button type="button" class="biz-btn-primary" onclick="openForm('add')">+ 객실 등록</button>
    </div>
    <table class="biz-table">
      <thead>
        <tr>
          <th>객실명</th>
          <th>1박 요금</th>
          <th>정원</th>
          <th>반려동물 제한</th>
          <th>관리</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty roomList}">
            <tr><td colspan="5" style="text-align:center;color:#999;padding:24px 0">등록된 객실이 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="room" items="${roomList}">
              <tr>
                <td>${room.name}</td>
                <td class="price-cell"><fmt:formatNumber value="${room.pricePerNight}" pattern="#,###"/>원</td>
                <td>${room.capacity > 0 ? room.capacity : '-'}명</td>
                <td>${room.petLimit > 0 ? room.petLimit : '-'}마리</td>
                <td>
                  <button type="button" class="biz-btn"
                      data-id="${room.roomId}"
                      data-name="${room.name}"
                      data-price="${room.pricePerNight}"
                      data-capacity="${room.capacity}"
                      data-petlimit="${room.petLimit}"
                      onclick="openForm('edit', this)">수정</button>
                  <button type="button" class="biz-btn danger"
                      onclick="confirmDelete(${room.roomId})">삭제</button>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <%-- ═══ 등록/수정 폼 ═══ --%>
  <div class="biz-card" id="formCard" style="display:none">
    <div class="biz-card-head"><span id="formTitle">객실 등록</span></div>
    <form id="roomForm" action="${contextPath}/biz/stay/rooms" method="post"
          style="padding:20px;max-width:640px">

      <input type="hidden" id="rRoomId" name="roomId" value="">

      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>객실이름<span class="req">*</span></label>
          <input type="text" id="rName" name="name" placeholder="객실 이름을 입력하세요" required>
        </div>
        <div class="biz-form-row">
          <label>1박 요금<span class="req">*</span></label>
          <input type="number" id="rPrice" name="pricePerNight" placeholder="숫자만 입력 (예: 80000)" min="0" required>
        </div>
        <div class="biz-form-row">
          <label>정원</label>
          <input type="number" id="rCapacity" name="capacity" placeholder="숙박 가능 인원" min="0">
        </div>
        <div class="biz-form-row">
          <label>반려동물 수 제한</label>
          <input type="number" id="rPetLimit" name="petLimit" placeholder="동반 가능한 반려동물 수" min="0">
        </div>
      </div>

      <div class="room-form-actions">
        <button type="button" class="biz-btn-ghost" onclick="closeForm()">취소</button>
        <button type="submit" class="biz-btn-primary" id="submitBtn">객실 등록</button>
      </div>
    </form>
  </div>

  <%-- 삭제용 히든 폼 --%>
  <form id="deleteForm" action="${contextPath}/biz/stay/rooms/delete" method="post" style="display:none">
    <input type="hidden" id="delRoomId" name="roomId" value="">
  </form>
</main>

<%-- 저장 완료 토스트 --%>
<c:if test="${not empty msg}">
  <div class="biz-toast" id="saveToast">
    <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
    <span>${msg}</span>
  </div>
</c:if>

<script>
  function openForm(mode, btn) {
    document.getElementById('roomForm').reset();
    document.getElementById('rRoomId').value = '';

    if (mode === 'edit' && btn) {
      document.getElementById('rRoomId').value     = btn.dataset.id;
      document.getElementById('rName').value       = btn.dataset.name;
      document.getElementById('rPrice').value      = btn.dataset.price;
      document.getElementById('rCapacity').value   = btn.dataset.capacity || '';
      document.getElementById('rPetLimit').value   = btn.dataset.petlimit || '';
      document.getElementById('formTitle').textContent = '객실 수정';
      document.getElementById('submitBtn').textContent = '수정완료';
    } else {
      document.getElementById('formTitle').textContent = '객실 등록';
      document.getElementById('submitBtn').textContent = '객실 등록';
    }

    document.getElementById('formCard').style.display = 'block';
    document.getElementById('formCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function closeForm() {
    document.getElementById('formCard').style.display = 'none';
  }

  function confirmDelete(roomId) {
    if (!confirm('선택한 객실을 삭제하시겠습니까?')) return;
    document.getElementById('delRoomId').value = roomId;
    document.getElementById('deleteForm').submit();
  }

  window.addEventListener('DOMContentLoaded', function() {
    var t = document.getElementById('saveToast');
    if (t) { t.classList.add('on'); setTimeout(function(){ t.classList.remove('on'); }, 2500); }
  });
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
