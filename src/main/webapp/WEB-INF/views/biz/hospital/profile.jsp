<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="profile" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">병원 정보</h1>
    <p class="biz-page-desc">병원명·주소·운영시간 등 유저에게 노출되는 병원 정보를 관리하세요.</p>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span>병원 정보</span><small>* 표시 항목은 필수 입력입니다</small></div>

    <form class="biz-form-grid" id="hospitalInfoForm">
      <div>
        <div class="biz-form-image-box" id="imgPreviewBox">
          <img id="imgPreview"
               src="https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=600&q=80"
               alt="병원 대표 이미지">
        </div>
        <input type="file" id="imgFile" accept="image/*" style="display:none">
        <button type="button" class="biz-btn-ghost" style="width:100%" onclick="document.getElementById('imgFile').click()">이미지 변경</button>
        <p class="biz-form-image-hint">권장 사이즈 1200×800 / JPG, PNG</p>
      </div>

      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>병원명<span class="req">*</span></label>
          <input type="text" id="hName" value="행복동물병원" placeholder="병원명을 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>주소<span class="req">*</span></label>
          <input type="text" id="hAddress" value="대전광역시 서구 둔산로 020" placeholder="사업장 주소를 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>전화번호<span class="req">*</span></label>
          <input type="tel" id="hPhone" value="042-000-000" placeholder="예) 042-000-0000">
        </div>
        <div class="biz-form-row">
          <label>운영시간<span class="req">*</span></label>
          <input type="text" id="hHours" value="평일 09:00~18:00 / 토 09:00~14:00" placeholder="예) 평일 09:00~18:00">
        </div>
        <div class="biz-form-row">
          <label>진료과목</label>
          <input type="text" id="hDept" value="내과, 외과, 예방접종" placeholder="예) 내과, 외과, 예방접종">
        </div>
        <div class="biz-form-row">
          <label>병원소개</label>
          <textarea id="hIntro" placeholder="병원을 소개하는 문구를 입력하세요">반려동물의 건강을 최우선으로 진료하는 병원입니다.</textarea>
        </div>
        <div class="biz-form-row">
          <label>해시태그</label>
          <input type="text" id="hTagInput" value="#예방접종 #예방가능 #내과 #외과" placeholder="공백으로 구분해서 입력하세요 (예: #예방접종 #내과)">
          <div class="biz-form-hashtags" id="hTagPreview"></div>
        </div>

        <div class="biz-form-actions">
          <button type="button" class="biz-btn-primary" onclick="saveInfo()">저장</button>
        </div>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  병원 정보가 저장되었습니다.
</div>

<script>
  document.getElementById('imgFile').addEventListener('change', function (e) {
    var file = e.target.files[0];
    if (!file) return;
    document.getElementById('imgPreview').src = URL.createObjectURL(file);
  });

  function renderTags() {
    var raw = document.getElementById('hTagInput').value.trim();
    var box = document.getElementById('hTagPreview');
    box.innerHTML = '';
    if (!raw) return;
    raw.split(/\s+/).forEach(function (t) {
      if (!t) return;
      var span = document.createElement('span');
      span.className = 'biz-form-hashtag';
      span.textContent = t.startsWith('#') ? t : '#' + t;
      box.appendChild(span);
    });
  }
  document.getElementById('hTagInput').addEventListener('input', renderTags);
  renderTags();

  function saveInfo() {
    var required = [
      { id: 'hName',   label: '병원명' },
      { id: 'hAddress',label: '주소' },
      { id: 'hPhone',  label: '전화번호' },
      { id: 'hHours',  label: '운영시간' }
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