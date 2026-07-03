<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="info" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 7/3, 사업자(쇼핑몰) 사업자 정보 UI 구성 — 매장 자체 정보와 별개로,
     사업자 등록 정보(대표자명/사업자등록번호/업종/사업장 주소·전화번호/사업자등록증)를 관리하는 화면 --%>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">사업자 정보 등록</h1>
    <p class="biz-page-desc">사업자 등록 정보를 확인하고 수정하세요.</p>
  </div>

  <div class="biz-card">
    <div class="biz-card-head"><span>사업자 정보</span><small>* 표시 항목은 필수 입력입니다</small></div>

    <form id="bizInfoForm" style="padding:20px;max-width:640px">
      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>대표자 명<span class="req">*</span></label>
          <input type="text" id="bOwner" value="박펫몰" placeholder="대표자 명을 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>사업자 등록번호<span class="req">*</span></label>
          <input type="text" id="bRegNo" value="234-56-78901" placeholder="000-00-00000">
        </div>
        <div class="biz-form-row">
          <label>업종<span class="req">*</span></label>
          <select id="bType">
            <option value="stay">반려동물 숙박업</option>
            <option value="hospital">동물병원</option>
            <option value="grooming">미용업</option>
            <option value="store" selected>반려용품 판매업</option>
          </select>
        </div>
        <div class="biz-form-row">
          <label>사업장 주소<span class="req">*</span></label>
          <input type="text" id="bAddress" value="서울특별시 강남구 테헤란로 020" placeholder="사업장 주소를 입력하세요">
        </div>
        <div class="biz-form-row">
          <label>사업장 전화번호<span class="req">*</span></label>
          <input type="tel" id="bPhone" value="02-000-0000" placeholder="예) 02-000-0000">
        </div>
        <div class="biz-form-row">
          <label>사업자 등록증 첨부</label>
          <div style="display:flex;gap:10px;align-items:center">
            <input type="text" id="bFileName" value="사업자등록증.pdf" readonly style="flex:1;background:#FAFBFA">
            <button type="button" class="biz-btn-ghost" style="white-space:nowrap" onclick="document.getElementById('bFile').click()">파일선택</button>
            <input type="file" id="bFile" accept="image/*,.pdf" style="display:none">
          </div>
        </div>
      </div>

      <div class="biz-form-actions" style="margin-top:20px">
        <button type="button" class="biz-btn-primary" onclick="saveInfo()">저장</button>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  사업자 정보가 저장되었습니다.
</div>

<script>
  document.getElementById('bFile').addEventListener('change', function (e) {
    var file = e.target.files[0];
    if (!file) return;
    document.getElementById('bFileName').value = file.name;
  });

  function saveInfo() {
    var required = [
      { id: 'bOwner',   label: '대표자 명' },
      { id: 'bRegNo',   label: '사업자 등록번호' },
      { id: 'bAddress', label: '사업장 주소' },
      { id: 'bPhone',   label: '사업장 전화번호' }
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