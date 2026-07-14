<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="lodge" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<%-- 7/2, 사업자(숙박) 숙소관리 UI 구성 — 숙소 기본정보 + 대표이미지 + 편의시설 체크박스 --%>
<style>
  .stay-info-grid{display:grid;grid-template-columns:1fr 260px;gap:24px;align-items:start}
  .stay-amenities{display:grid;grid-template-columns:repeat(4,1fr);gap:12px 16px;margin-top:8px}
  .stay-amenity{display:flex;align-items:center;gap:8px;font-size:14px;color:#333;cursor:pointer}
  .stay-amenity input{width:16px;height:16px;accent-color:var(--biz-primary);cursor:pointer}
  .stay-save-row{display:flex;justify-content:center;margin-top:24px}
  .stay-save-row .biz-btn-primary{min-width:200px}
  @media (max-width:720px){ .stay-info-grid{grid-template-columns:1fr} }
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">숙소 관리</h1>
    <p class="biz-page-desc">숙소 기본정보와 편의시설을 등록하고 관리하세요.</p>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span>숙소 기본정보</span><small>* 표시 항목은 필수 입력입니다</small></div>

    <form id="stayInfoForm" style="padding:20px">
      <div class="stay-info-grid">
        <div class="biz-form-fields">
          <div class="biz-form-row">
            <label>숙소명<span class="req">*</span></label>
            <input type="text" id="sName" value="포근한 숙소" placeholder="숙소명을 입력하세요">
          </div>
          <div class="biz-form-row">
            <label>숙소주소<span class="req">*</span></label>
            <input type="text" id="sAddress" value="대전광역시 유성구 대학로 020" placeholder="사업장 주소를 입력하세요">
          </div>
          <div class="biz-form-row">
            <label>연락처<span class="req">*</span></label>
            <input type="tel" id="sPhone" value="042-000-000" placeholder="예) 042-000-0000">
          </div>
          <div class="biz-form-row">
            <label>체크인 시간<span class="req">*</span></label>
            <select id="sCheckIn">
              <option value="14:00">14:00</option>
              <option value="15:00" selected>15:00</option>
              <option value="16:00">16:00</option>
            </select>
          </div>
          <div class="biz-form-row">
            <label>체크아웃 시간<span class="req">*</span></label>
            <select id="sCheckOut">
              <option value="10:00">10:00</option>
              <option value="11:00" selected>11:00</option>
              <option value="12:00">12:00</option>
            </select>
          </div>
          <div class="biz-form-row">
            <label>숙소소개</label>
            <textarea id="sIntro" placeholder="숙소를 소개하는 문구를 입력하세요">반려동물과 보호자가 함께 편안하게 머물 수 있는 숙소입니다.</textarea>
          </div>
        </div>

        <div>
          <p style="font-size:13px;font-weight:700;color:#1A1A2E;margin:0 0 8px">대표 이미지</p>
          <div class="biz-form-image-box" id="imgPreviewBox">
            <img id="imgPreview"
                 src="https://images.unsplash.com/photo-1568495248636-6432b97bd949?w=600&q=80"
                 alt="숙소 대표 이미지">
          </div>
          <input type="file" id="imgFile" accept="image/*" style="display:none">
          <button type="button" class="biz-btn-ghost" style="width:100%" onclick="document.getElementById('imgFile').click()">이미지 변경</button>
          <p class="biz-form-image-hint">권장 사이즈 1200×800 / JPG, PNG</p>
        </div>
      </div>

      <div style="border-top:1px solid var(--biz-border);margin-top:22px;padding-top:18px">
        <p style="font-size:13px;font-weight:700;color:#1A1A2E;margin:0 0 4px">편의시설</p>
        <div class="stay-amenities">
          <label class="stay-amenity"><input type="checkbox" value="wifi" checked>WIFI</label>
          <label class="stay-amenity"><input type="checkbox" value="parking" checked>주차장</label>
          <label class="stay-amenity"><input type="checkbox" value="aircon" checked>에어컨</label>
          <label class="stay-amenity"><input type="checkbox" value="pool">수영장</label>
          <label class="stay-amenity"><input type="checkbox" value="elevator">엘리베이터</label>
          <label class="stay-amenity"><input type="checkbox" value="nonsmoking" checked>금연</label>
          <label class="stay-amenity"><input type="checkbox" value="breakfast">조식제공</label>
          <label class="stay-amenity"><input type="checkbox" value="bbq" checked>바비큐장</label>
        </div>
      </div>

      <div class="stay-save-row">
        <button type="button" class="biz-btn-primary" onclick="saveInfo()">등록</button>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  숙소 정보가 등록되었습니다.
</div>

<script>
  document.getElementById('imgFile').addEventListener('change', function (e) {
    var file = e.target.files[0];
    if (!file) return;
    document.getElementById('imgPreview').src = URL.createObjectURL(file);
  });

  function saveInfo() {
    var required = [
      { id: 'sName',     label: '숙소명' },
      { id: 'sAddress',  label: '숙소주소' },
      { id: 'sPhone',    label: '연락처' }
    ];
    for (var i = 0; i < required.length; i++) {
      var el = document.getElementById(required[i].id);
      if (!el.value.trim()) {
        alert(required[i].label + '을(를) 입력해주세요.');
        el.focus();
        return;
      }
    }
    var toast = document.getElementById('saveToast');
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2200);
  }
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>