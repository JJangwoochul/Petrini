<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="edit" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- ── 회원정보 수정 ── --%>
<div class="mp-section active">
    <h2 class="mp-title">회원정보 수정</h2>
    <p class="mp-desc">비밀번호 확인 후 개인정보를 수정하세요.</p>
    <%-- 프로필 사진 --%>
    <div class="edit-section">
        <div class="edit-section-title">
            <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            프로필 사진
        </div>
        <div class="edit-avatar-row">
            <img class="edit-avatar-img"
                 src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150&q=80&auto=format&fit=crop"
                 alt="프로필"
                 onerror="this.src='https://placehold.co/80x80/EAF7F2/2BAB82?text=ME'">
            <div class="edit-avatar-btns">
                <button class="btn-sm">사진 변경</button>
                <button class="btn-sm danger">사진 삭제</button>
            </div>
        </div>
    </div>
    <%-- 현재 비밀번호 확인 --%>
    <div class="edit-section">
        <div class="edit-section-title">
            <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
            비밀번호 변경
        </div>
        <div class="edit-grid">
            <div class="edit-group full">
                <label>현재 비밀번호 <span class="req">*</span></label>
                <div class="edit-pw-wrap">
                    <input type="password" placeholder="현재 비밀번호를 입력하세요">
                    <button class="edit-pw-eye" type="button"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></button>
                </div>
            </div>
            <div class="edit-group">
                <label>새 비밀번호</label>
                <div class="edit-pw-wrap">
                    <input type="password" placeholder="영문+숫자+특수문자 8자 이상">
                    <button class="edit-pw-eye" type="button"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></button>
                </div>
                <div class="pw-strength"><span></span><span></span><span></span><span></span></div>
            </div>
            <div class="edit-group">
                <label>새 비밀번호 확인</label>
                <div class="edit-pw-wrap">
                    <input type="password" placeholder="비밀번호를 다시 입력하세요">
                    <button class="edit-pw-eye" type="button"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg></button>
                </div>
            </div>
        </div>
    </div>
    <%-- 기본 정보 --%>
    <div class="edit-section">
        <div class="edit-section-title">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
            기본 정보
        </div>
        <div class="edit-grid">
            <div class="edit-group">
                <label>이름</label>
                <input type="text" value="${memberInfo.memberName}" readonly>
            </div>
            <div class="edit-group">
                <label>아이디</label>
                <input type="text" value="${memberInfo.memberId}" readonly>
            </div>
            <div class="edit-group">
                <label>이메일</label>
                <input type="email" placeholder="example@email.com">
            </div>
            <div class="edit-group">
                <label>전화번호 <span class="req">*</span></label>
                <div class="edit-input-row">
                    <input type="tel" placeholder="010-0000-0000">
                    <button class="btn-verify" type="button">인증</button>
                </div>
            </div>
            <div class="edit-group">
                <label>생년월일</label>
                <input type="date">
            </div>
            <div class="edit-group">
                <label>성별</label>
                <select>
                    <option value="">선택 안함</option>
                    <option>남성</option>
                    <option>여성</option>
                </select>
            </div>
            <div class="edit-group full">
                <label>주소</label>
                <div class="edit-input-row">
                    <input type="text" placeholder="우편번호" style="max-width:120px">
                    <button class="btn-verify" type="button">주소 검색</button>
                </div>
                <input type="text" placeholder="기본 주소" style="margin-top:8px">
                <input type="text" placeholder="상세 주소" style="margin-top:8px">
            </div>
        </div>
    </div>

    <%-- 2026/07/27 장우철 — 카드등록 (토스 빌링 + Ajax) --%>
    <div class="edit-section" id="editCardSection">
        <div class="edit-section-title">
            <svg viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
            결제 카드
        </div>
        <div id="editCardEmpty" class="edit-card-box">
            <p class="edit-card-desc">등록된 카드가 없습니다. 간편결제를 위해 카드를 등록해 주세요.</p>
            <button type="button" class="btn-verify" id="btnEditCardRegister">카드 등록하기</button>
        </div>
        <div id="editCardRegistered" class="edit-card-box registered" style="display:none;">
            <div class="edit-card-info">
                <span class="edit-card-badge">등록됨</span>
                <strong id="editCardLabel">-</strong>
                <span class="edit-card-sub" id="editCardSub">토스 빌링키로 등록된 카드입니다.</span>
            </div>
            <div class="edit-card-actions">
                <button type="button" class="btn-sm" id="btnEditCardChange">카드 추가</button>
                <button type="button" class="btn-sm danger" id="btnEditCardRemove">등록 해제</button>
            </div>
        </div>
    </div>

    <div class="edit-submit-area">
        <button class="btn-primary" style="padding:13px 52px; font-size:15px;">저장하기</button>
    </div>

    <%-- HYJ 26.07.29 회원 탈퇴 --%>
    <div style="text-align:center; margin-top:48px; padding-top:24px; border-top:1px solid #eee;">
        <a href="${contextPath}/mypage/withdraw"
           style="color:#999; font-size:13px; text-decoration:underline;">회원 탈퇴</a>
    </div>
</div>



</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%-- 2026/07/27 장우철 — 토스 빌링 SDK + 카드등록 Ajax --%>
<script src="https://js.tosspayments.com/v2/standard"></script>
<script src="${contextPath}/resources/js/billing-card.js"></script>
<script>
/* 2026/07/27 장우철 — 회원정보 카드등록 (목록 Ajax + requestBillingAuth) */
(function () {
  var empty = document.getElementById('editCardEmpty');
  var registered = document.getElementById('editCardRegistered');
  var labelEl = document.getElementById('editCardLabel');
  var currentCardId = null;

  function showRegistered(label, cardId) {
    currentCardId = cardId;
    labelEl.textContent = label || '등록된 카드';
    empty.style.display = 'none';
    registered.style.display = 'flex';
  }
  function showEmpty() {
    currentCardId = null;
    empty.style.display = 'block';
    registered.style.display = 'none';
  }

  async function refreshCards() {
    try {
      var data = await PetcareBilling.loadCards();
      if (!data.ok || !data.cards || data.cards.length === 0) {
        showEmpty();
        return;
      }
      // 최신 카드 1장 표시 (여러 장 가능, UI는 대표 1장)
      var c = data.cards[0];
      showRegistered(c.label, c.billingCardId);
    } catch (e) {
      console.error(e);
    }
  }

  function openToss() {
    PetcareBilling.openRegister('/mypage/edit').catch(function (e) {
      console.error(e);
      alert('카드 등록 창을 열지 못했습니다.');
    });
  }

  document.getElementById('btnEditCardRegister').addEventListener('click', openToss);
  document.getElementById('btnEditCardChange').addEventListener('click', openToss);
  document.getElementById('btnEditCardRemove').addEventListener('click', async function () {
    if (!confirm('등록된 카드를 해제할까요?')) return;
    if (currentCardId == null) { showEmpty(); return; }
    var res = await PetcareBilling.deleteCard(currentCardId, false);
    if (res.ok) refreshCards();
    else alert(res.message || '삭제에 실패했습니다.');
  });

  PetcareBilling.notifyFromQuery();
  refreshCards();
})();
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
