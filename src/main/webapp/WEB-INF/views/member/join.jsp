<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${contextPath}/resources/css/join.css?v=3">

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main>
  <!-- ══════════════════════════════════════
       ② 스텝 인디케이터 + 폼 카드
  ══════════════════════════════════════ -->
  <div class="join-body">

    <!-- 스텝 인디케이터 -->
    <div class="step-wrap">
      <ul class="step-list" id="stepList">
        <li class="step-item active" id="stepItem1">
          <div class="step-circle" id="stepCircle1">1</div>
          <span class="step-label">약관 동의</span>
        </li>
        <li class="step-item" id="stepItem2">
          <div class="step-circle" id="stepCircle2">2</div>
          <span class="step-label">기본 정보</span>
        </li>
        <li class="step-item" id="stepItem3">
          <div class="step-circle" id="stepCircle3">3</div>
          <span class="step-label">반려동물 등록</span>
        </li>
      </ul>
    </div>

    <!-- 카드 -->
    <div class="join-card-wrap">
      <div class="join-card">


        <!-- ════════════════════════════
             STEP 1 : 약관 동의
        ════════════════════════════ -->
        <div id="step1">
          <h2 class="join-card-title">약관 동의</h2>
          <p class="join-card-sub">서비스 이용을 위해 약관에 동의해 주세요.</p>

          <div class="terms-box">

            <!-- 전체 동의 -->
            <label class="terms-all">
              <input type="checkbox" id="agreeAll">
              전체 동의하기
            </label>

            <!-- 서비스 이용약관 (필수) -->
            <label class="terms-item">
              <input type="checkbox" id="agreeService" class="req-agree">
              서비스 이용약관 동의
              <span class="terms-req">필수</span>
              <span class="terms-view" onclick="event.preventDefault(); alert('서비스 이용약관 내용입니다.')">보기</span>
            </label>

            <!-- 개인정보처리방침 (필수) -->
            <label class="terms-item">
              <input type="checkbox" id="agreePrivacy" class="req-agree">
              개인정보 수집 및 이용 동의
              <span class="terms-req">필수</span>
              <span class="terms-view" onclick="event.preventDefault(); alert('개인정보처리방침 내용입니다.')">보기</span>
            </label>

            <!-- 위치정보 (선택) -->
            <label class="terms-item">
              <input type="checkbox" id="agreeLocation">
              위치기반 서비스 이용 동의
              <span class="terms-opt">선택</span>
            </label>

            <!-- 마케팅 (선택) -->
            <label class="terms-item">
              <input type="checkbox" id="agreeMarketing">
              마케팅 정보 수신 동의 (이메일/SMS)
              <span class="terms-opt">선택</span>
            </label>

          </div>

          <p id="termsError" class="field-error" style="margin-bottom:10px;">필수 약관에 모두 동의해 주세요.</p>

          <div class="join-nav" style="margin-top:20px;">
            <button type="button" class="btn-next" id="btnStep1Next">
              다음 단계
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="5" y1="12" x2="19" y2="12"/>
                <polyline points="12 5 19 12 12 19"/>
              </svg>
            </button>
          </div>

          <a href="${pageContext.request.contextPath}/login" class="login-link" style="margin-top:12px;">
            이미 계정이 있으신가요?&nbsp;<strong>로그인</strong>
          </a>
        </div>
        <%-- /step1 --%>


        <!-- ════════════════════════════
             STEP 2 : 기본 정보 입력
        ════════════════════════════ -->
        <div id="step2" style="display:none;">
          <h2 class="join-card-title">기본 정보 입력</h2>
          <p class="join-card-sub">회원 정보를 입력해 주세요.</p>

          <form id="joinForm" novalidate>

            <!-- 이름 -->
            <div class="form-field">
              <label class="form-label" for="memberName">이름 <span class="req">*</span></label>
              <input type="text" id="memberName" name="memberName"
                     class="form-input no-icon" placeholder="이름을 입력해 주세요">
              <p class="field-error" id="errName">이름을 입력해 주세요.</p>
            </div>

            <!-- 이메일 + 중복 확인 -->
            <div class="form-field">
              <label class="form-label" for="email">이메일 <span class="req">*</span></label>
              <div class="field-btn-wrap">
                <input type="email" id="email" name="email"
                       class="form-input no-icon" placeholder="example@email.com">
                <button type="button" class="btn-check" id="btnCheckEmail">중복 확인</button>
              </div>
              <p class="field-hint">로그인 아이디로 사용됩니다.</p>
              <p class="field-ok"   id="okEmail">사용 가능한 이메일입니다.</p>
              <p class="field-error" id="errEmail">올바른 이메일 형식을 입력해 주세요.</p>
            </div>

            <!-- 비밀번호 -->
            <div class="form-field">
              <label class="form-label" for="password">비밀번호 <span class="req">*</span></label>
              <div style="position:relative;">
                <input type="password" id="password" name="password"
                       class="form-input no-icon" placeholder="8자 이상, 영문+숫자+특수문자"
                       style="padding-right:44px">
                <button type="button" class="pw-toggle" id="pwToggle1" aria-label="비밀번호 보기">
                  <svg id="eye1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </svg>
                </button>
              </div>
              <!-- 비밀번호 강도 -->
              <div class="pw-strength" id="pwStrength">
                <div class="pw-bar" id="bar1"></div>
                <div class="pw-bar" id="bar2"></div>
                <div class="pw-bar" id="bar3"></div>
              </div>
              <p class="pw-strength-txt" id="pwStrengthTxt"></p>
              <p class="field-error" id="errPw">8자 이상, 영문·숫자·특수문자를 포함해야 합니다.</p>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="form-field">
              <label class="form-label" for="passwordConfirm">비밀번호 확인 <span class="req">*</span></label>
              <div style="position:relative;">
                <input type="password" id="passwordConfirm" name="passwordConfirm"
                       class="form-input no-icon" placeholder="비밀번호를 다시 입력해 주세요"
                       style="padding-right:44px">
                <button type="button" class="pw-toggle" id="pwToggle2" aria-label="비밀번호 확인 보기">
                  <svg id="eye2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </svg>
                </button>
              </div>
              <p class="field-ok"    id="okPwConfirm">비밀번호가 일치합니다.</p>
              <p class="field-error" id="errPwConfirm">비밀번호가 일치하지 않습니다.</p>
            </div>

            <!-- 전화번호 -->
            <div class="form-field">
              <label class="form-label" for="phone">전화번호 <span class="req">*</span></label>
              <input type="tel" id="phone" name="phone"
                     class="form-input no-icon" placeholder="010-0000-0000"
                     oninput="this.value=this.value.replace(/[^0-9]/g,'').replace(/(\d{3})(\d{4})(\d{4})/,'$1-$2-$3')">
              <p class="field-error" id="errPhone">올바른 전화번호를 입력해 주세요.</p>
            </div>

            <!-- 생년월일 + 성별 2열 -->
            <div class="form-row">
              <div class="form-field">
                <label class="form-label" for="birthDate">생년월일 <span class="req">*</span></label>
                <input type="date" id="birthDate" name="birthDate" class="form-input no-icon">
                <p class="field-error" id="errBirth">생년월일을 입력해 주세요.</p>
              </div>
              <div class="form-field">
                <label class="form-label" for="gender">성별</label>
                  <select id="gender" name="gender" class="form-select no-icon">
                    <option value="">선택 안함</option>
                    <option value="M">남성</option>
                    <option value="F">여성</option>
                  </select>
              </div>
            </div>

            <!-- 주소 -->
            <div class="form-field">
              <label class="form-label" for="zipcode">주소</label>
              <div class="field-btn-wrap" style="margin-bottom:8px;">
                <input type="text" id="zipcode" name="zipcode"
                       class="form-input no-icon" placeholder="우편번호" readonly>
                <button type="button" class="btn-check" id="btnSearchAddr">주소 찾기</button>
              </div>
              <input type="text" id="addr1" name="addr1"
                     class="form-input no-icon" placeholder="기본 주소" readonly
                     style="margin-bottom:8px;">
              <input type="text" id="addr2" name="addr2"
                     class="form-input no-icon" placeholder="상세 주소 (동, 호수 등)">
            </div>

          </form>
          <%-- /joinForm --%>

          <div class="join-nav">
            <button type="button" class="btn-prev" id="btnStep2Prev">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="19" y1="12" x2="5" y2="12"/>
                <polyline points="12 19 5 12 12 5"/>
              </svg>
              이전
            </button>
            <button type="button" class="btn-next" id="btnStep2Next">
              다음 단계
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="5" y1="12" x2="19" y2="12"/>
                <polyline points="12 5 19 12 12 19"/>
              </svg>
            </button>
          </div>
        </div>
        <%-- /step2 --%>


        <!-- ════════════════════════════
             STEP 3 : 반려동물 등록 (선택)
        ════════════════════════════ -->
        <div id="step3" style="display:none;">
          <h2 class="join-card-title">반려동물 등록</h2>
          <p class="join-card-sub">나중에 마이페이지에서 언제든 추가할 수 있어요.</p>

          <!-- 동물 종류 선택 -->
          <div class="form-field">
            <label class="form-label">반려동물 종류</label>
            <div class="pet-type-grid">
              <button type="button" class="pet-type-btn" data-type="dog" id="typeDog">
                <!-- 강아지 SVG -->
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M10 5.172C10 3.782 8.423 2.679 6.5 3c-2 .336-3.5 2.198-3.5 4.25C3 10.237 5.5 14 9 14c3.5 0 6-3.763 6-6.75 0-2.052-1.5-3.914-3.5-4.25C9.577 2.679 8 3.782 8 5.172"/>
                  <path d="M14.267 8C16 7.5 17.5 8.5 18 10c.5 1.5-.5 3-2 3.5s-3 0-3.5-1.5"/>
                  <path d="M9 14c0 4 1 6 3 7s4-1 4-5"/>
                </svg>
                강아지
              </button>
              <button type="button" class="pet-type-btn" data-type="cat" id="typeCat">
                <!-- 고양이 SVG -->
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M12 5C9.5 5 7 7 7 10c0 3 1.5 5.5 5 6s5-3 5-6c0-3-2.5-5-5-5z"/>
                  <path d="M7 10 L4 6 L7 8"/>
                  <path d="M17 10 L20 6 L17 8"/>
                  <path d="M10 14 Q12 16 14 14"/>
                  <line x1="9" y1="12" x2="7" y2="12"/>
                  <line x1="15" y1="12" x2="17" y2="12"/>
                </svg>
                고양이
              </button>
              <button type="button" class="pet-type-btn" data-type="etc" id="typeEtc">
                <!-- 기타 SVG -->
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
                기타
              </button>
            </div>
            <input type="hidden" id="petType" name="petType" value="">
          </div>

          <!-- 반려동물 이름 -->
          <div class="form-field">
            <label class="form-label" for="petName">이름</label>
            <div style="position:relative;">
              <span class="field-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
              </span>
              <input type="text" id="petName" name="petName"
                     class="form-input" placeholder="반려동물 이름">
            </div>
          </div>

          <!-- 품종 + 나이 2열 -->
          <div class="form-row">
            <div class="form-field">
              <label class="form-label" for="petBreed">품종</label>
              <div style="position:relative;">
                <span class="field-icon">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="8" y1="6" x2="21" y2="6"/>
                    <line x1="8" y1="12" x2="21" y2="12"/>
                    <line x1="8" y1="18" x2="21" y2="18"/>
                    <line x1="3" y1="6"  x2="3.01" y2="6"/>
                    <line x1="3" y1="12" x2="3.01" y2="12"/>
                    <line x1="3" y1="18" x2="3.01" y2="18"/>
                  </svg>
                </span>
                <input type="text" id="petBreed" name="petBreed"
                       class="form-input" placeholder="예) 말티즈, 스코티시폴드">
              </div>
            </div>
            <div class="form-field">
              <label class="form-label" for="petAge">나이 (세)</label>
              <div style="position:relative;">
                <span class="field-icon">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/>
                    <polyline points="12 6 12 12 16 14"/>
                  </svg>
                </span>
                <input type="number" id="petAge" name="petAge" min="0" max="30"
                       class="form-input" placeholder="0">
              </div>
            </div>
          </div>

          <!-- 몸무게 -->
          <div class="form-field">
            <label class="form-label" for="petWeight">몸무게 (kg)</label>
            <div style="position:relative;">
              <span class="field-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                  <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                  <line x1="3" y1="6" x2="21" y2="6"/>
                  <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
              </span>
              <input type="number" id="petWeight" name="petWeight" min="0" step="0.1"
                     class="form-input" placeholder="0.0">
            </div>
          </div>

          <!-- 사진 업로드 -->
          <div class="form-field">
            <label class="form-label">대표 사진 <span style="font-weight:400; color:var(--text-muted);">(선택)</span></label>
            <div class="pet-photo-wrap">
              <div class="pet-photo-preview" id="petPhotoPreview">
                <div class="pet-photo-placeholder">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                  </svg>
                </div>
              </div>
              <div>
                <button type="button" class="btn-photo-upload" id="btnPhotoUpload">
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                    <polyline points="17 8 12 3 7 8"/>
                    <line x1="12" y1="3" x2="12" y2="15"/>
                  </svg>
                  사진 업로드
                </button>
                <p class="field-hint" style="margin-top:8px;">JPG, PNG 최대 5MB</p>
                <input type="file" id="petPhoto" name="petPhoto"
                       accept="image/*" style="display:none;">
              </div>
            </div>
          </div>

          <%-- 2026/07/07 장우철 — Step3: 넘어가기(펫 없이 가입) + 가입완료(펫 포함) 50:50 --%>
          <div class="join-nav">
            <button type="button" class="btn-prev" id="btnStep3Prev">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="19" y1="12" x2="5" y2="12"/>
                <polyline points="12 19 5 12 12 5"/>
              </svg>
              이전
            </button>
            <div class="join-nav-submit-row">
              <button type="button" class="btn-submit-half" id="btnSkip">
                넘어가기
              </button>
              <button type="button" class="btn-submit-half" id="btnSubmit">
                가입 완료
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="20 6 9 17 4 12"/>
                </svg>
              </button>
            </div>
          </div>
          <%--
            [변경 전] Step3 버튼 — 가입 완료 단일 버튼 (UI 목업, DB 미연동)
            변경 이유: 2026/07/07 서버 POST /join 연동 + 넘어가기(펫 선택) 2분할
            <div class="join-nav">
              <button type="button" class="btn-prev" id="btnStep3Prev">… 이전</button>
              <button type="button" class="btn-submit" id="btnSubmit">가입 완료</button>
            </div>
          --%>

          <p style="text-align:center; font-size:12px; color:var(--text-muted); margin-top:14px;">
            반려동물 정보는 나중에 마이페이지에서 추가하실 수 있습니다.
          </p>
        </div>
        <%-- /step3 --%>


        <!-- ════════════════════════════
             STEP 4 : 가입 완료
        ════════════════════════════ -->
        <div id="step4" style="display:none;">
          <div class="join-done">
            <div class="join-done-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"/>
              </svg>
            </div>
            <h3>가입이 완료되었습니다!</h3>
            <p>
              PetCare 회원이 되신 것을 환영합니다.<br>
              다양한 반려동물 서비스를 마음껏 이용해 보세요. 🐾
            </p>
            <div class="join-done-btns">
              <a href="${pageContext.request.contextPath}/login" class="btn-go-login">로그인하기</a>
              <a href="${pageContext.request.contextPath}/"     class="btn-go-home">메인으로</a>
            </div>
          </div>
        </div>
        <%-- /step4 --%>


      </div>
    </div>
    <%-- /join-card-wrap --%>

  </div>
  <%-- /join-body --%>

</main>


<!-- ══════════════════════════════════════
     회원가입 스크립트
══════════════════════════════════════ -->
<script>
(function () {

  /* ── 현재 스텝 상태 ── */
  var cur = 1;
  var emailChecked = false;

  /* ── 유틸 ── */
  function show(id) { document.getElementById(id).style.display = ''; }
  function hide(id) { document.getElementById(id).style.display = 'none'; }
  function showEl(el) { el.style.display = ''; }
  function hideEl(el) { el.style.display = 'none'; }
  function ok(errId, okId)  { if(okId)  document.getElementById(okId).classList.add('show');  document.getElementById(errId).classList.remove('show'); }
  function err(errId, okId) { if(okId)  document.getElementById(okId).classList.remove('show'); document.getElementById(errId).classList.add('show'); }
  function clearMsg(errId, okId) {
    document.getElementById(errId).classList.remove('show');
    if(okId) document.getElementById(okId).classList.remove('show');
  }

  /* ── 스텝 인디케이터 갱신 ── */
  function updateStep(step) {
    for (var i = 1; i <= 3; i++) {
      var item   = document.getElementById('stepItem'   + i);
      var circle = document.getElementById('stepCircle' + i);
      item.classList.remove('active', 'done');
      if (i < step) {
        item.classList.add('done');
        circle.innerHTML =
          '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>';
      } else if (i === step) {
        item.classList.add('active');
        circle.textContent = i;
      } else {
        circle.textContent = i;
      }
    }
  }

  function goStep(n) {
    hide('step' + cur);
    cur = n;
    if (n <= 3) {
      show('step' + n);
      updateStep(n);
    } else {
      /* 완료 화면 */
      show('step4');
      /* 스텝 인디케이터 모두 done */
      for (var i = 1; i <= 3; i++) {
        var item   = document.getElementById('stepItem' + i);
        var circle = document.getElementById('stepCircle' + i);
        item.classList.remove('active');
        item.classList.add('done');
        circle.innerHTML =
          '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>';
      }
    }
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  /* ──────────────────────────────
     STEP 1 : 약관 동의
  ────────────────────────────── */
  var agreeAll     = document.getElementById('agreeAll');
  var reqAgrees    = document.querySelectorAll('.req-agree');
  var allCheckboxes= document.querySelectorAll('#step1 input[type="checkbox"]');

  agreeAll.addEventListener('change', function () {
    allCheckboxes.forEach(function (cb) { cb.checked = agreeAll.checked; });
  });
  allCheckboxes.forEach(function (cb) {
    cb.addEventListener('change', function () {
      var allChecked = Array.from(allCheckboxes).every(function (c) { return c.checked; });
      agreeAll.checked = allChecked;
    });
  });

  document.getElementById('btnStep1Next').addEventListener('click', function () {
    var allReq = Array.from(reqAgrees).every(function (cb) { return cb.checked; });
    if (!allReq) {
      document.getElementById('termsError').classList.add('show');
      return;
    }
    document.getElementById('termsError').classList.remove('show');
    goStep(2);
  });

  /* ──────────────────────────────
     STEP 2 : 기본 정보 입력
  ────────────────────────────── */

  /* 비밀번호 토글 */
  function makePwToggle(toggleId, inputId, eyeId) {
    var eyeOpen = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
    var eyeOff  = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/>';
    document.getElementById(toggleId).addEventListener('click', function () {
      var inp = document.getElementById(inputId);
      var eye = document.getElementById(eyeId);
      var isHidden = inp.type === 'password';
      inp.type = isHidden ? 'text' : 'password';
      eye.innerHTML = isHidden ? eyeOff : eyeOpen;
    });
  }
  makePwToggle('pwToggle1', 'password',        'eye1');
  makePwToggle('pwToggle2', 'passwordConfirm', 'eye2');

  /* 비밀번호 강도 */
  document.getElementById('password').addEventListener('input', function () {
    var v = this.value;
    var score = 0;
    if (v.length >= 8) score++;
    if (/[a-zA-Z]/.test(v) && /[0-9]/.test(v)) score++;
    if (/[^a-zA-Z0-9]/.test(v)) score++;
    var labels = ['', '약함', '보통', '강함'];
    var bars   = [document.getElementById('bar1'), document.getElementById('bar2'), document.getElementById('bar3')];
    var cls    = ['', 'lv1', 'lv2', 'lv3'];
    bars.forEach(function (b, i) {
      b.className = 'pw-bar' + (i < score ? ' ' + cls[score] : '');
    });
    document.getElementById('pwStrengthTxt').textContent = v.length ? '비밀번호 강도: ' + labels[score] : '';
  });

  /* 비밀번호 확인 일치 검사 */
  document.getElementById('passwordConfirm').addEventListener('input', function () {
    var pw  = document.getElementById('password').value;
    var cpw = this.value;
    if (!cpw) { clearMsg('errPwConfirm', 'okPwConfirm'); return; }
    if (pw === cpw) ok('errPwConfirm', 'okPwConfirm');
    else            err('errPwConfirm', 'okPwConfirm');
  });

  /* ── 2026/07/07 장우철 — join(회원가입) 이메일 중복 확인 Ajax ──
   * GET /join/check-email → EmailCheckResultVO JSON
   */
  document.getElementById('btnCheckEmail').addEventListener('click', function () {
    var emailEl = document.getElementById('email');
    var v = emailEl.value.trim();
    var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!re.test(v)) {
      document.getElementById('errEmail').textContent = '올바른 이메일 형식을 입력해 주세요.';
      err('errEmail', 'okEmail');
      return;
    }

    var ctx = '${contextPath}';
    fetch(ctx + '/join/check-email?email=' + encodeURIComponent(v))
      .then(function (res) { return res.json(); })
      .then(function (data) {
        if (data.available) {
          document.getElementById('okEmail').textContent = data.message;
          ok('errEmail', 'okEmail');
          emailChecked = true;
          emailEl.classList.add('is-valid');
        } else {
          document.getElementById('errEmail').textContent = data.message;
          err('errEmail', 'okEmail');
          emailChecked = false;
          emailEl.classList.remove('is-valid');
        }
      })
      .catch(function () {
        document.getElementById('errEmail').textContent = '중복 확인 중 오류가 발생했습니다.';
        err('errEmail', 'okEmail');
      });
  });

  /* ── [변경 전] 이메일 중복 확인 (시뮬레이션) ──
   * 변경 이유: 2026/07/07 서버 GET /join/check-email 실조회로 교체
   *
  document.getElementById('btnCheckEmail').addEventListener('click', function () {
    var emailEl = document.getElementById('email');
    var v = emailEl.value.trim();
    var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!re.test(v)) {
      err('errEmail', 'okEmail');
      return;
    }
    clearMsg('errEmail', 'okEmail');
    ok('errEmail', 'okEmail');
    emailChecked = true;
    emailEl.classList.add('is-valid');
  });
   */

  /* 이메일 변경 시 중복 확인 초기화 */
  document.getElementById('email').addEventListener('input', function () {
    emailChecked = false;
    this.classList.remove('is-valid');
    clearMsg('errEmail', 'okEmail');
  });

  /* 주소 찾기 (카카오 주소 API 연동 예시) */
  document.getElementById('btnSearchAddr').addEventListener('click', function () {
    /* 카카오 주소 API가 로드된 경우 */
    if (typeof daum !== 'undefined' && daum.Postcode) {
      new daum.Postcode({
        oncomplete: function (data) {
          document.getElementById('zipcode').value = data.zonecode;
          document.getElementById('addr1').value   = data.roadAddress || data.jibunAddress;
          document.getElementById('addr2').focus();
        }
      }).open();
    } else {
      alert('주소 검색 API를 불러오지 못했습니다.\n실제 프로젝트에서 카카오 주소 API를 연동해 주세요.');
    }
  });

  /* Step 2 유효성 검사 */
  function validateStep2() {
    var valid = true;

    var name = document.getElementById('memberName').value.trim();
    if (!name) { err('errName', null); valid = false; }
    else        clearMsg('errName', null);

    var email = document.getElementById('email').value.trim();
    var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!re.test(email)) {
      err('errEmail', 'okEmail'); valid = false;
    } else if (!emailChecked) {
      document.getElementById('errEmail').textContent = '이메일 중복 확인을 해주세요.';
      err('errEmail', 'okEmail'); valid = false;
    } else {
      clearMsg('errEmail', 'okEmail');
    }

    var pw  = document.getElementById('password').value;
    var pwRe = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{8,}$/;
    if (!pwRe.test(pw)) { err('errPw', null); valid = false; }
    else                  clearMsg('errPw', null);

    var cpw = document.getElementById('passwordConfirm').value;
    if (pw !== cpw) { err('errPwConfirm', 'okPwConfirm'); valid = false; }

    var phone = document.getElementById('phone').value.trim();
    var phoneRe = /^01[0-9]-\d{4}-\d{4}$/;
    if (!phoneRe.test(phone)) { err('errPhone', null); valid = false; }
    else                        clearMsg('errPhone', null);

    var birth = document.getElementById('birthDate').value;
    if (!birth) { err('errBirth', null); valid = false; }
    else         clearMsg('errBirth', null);

    return valid;
  }

  document.getElementById('btnStep2Prev').addEventListener('click', function () { goStep(1); });
  document.getElementById('btnStep2Next').addEventListener('click', function () {
    if (validateStep2()) goStep(3);
  });

  /* ──────────────────────────────
     STEP 3 : 반려동물 등록
     2026/07/07 장우철 — 서버 연동(POST /join), 넘어가기 버튼
  ────────────────────────────── */

  /* 동물 종류 버튼 */
  document.querySelectorAll('.pet-type-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      document.querySelectorAll('.pet-type-btn').forEach(function (b) { b.classList.remove('selected'); });
      this.classList.add('selected');
      document.getElementById('petType').value = this.dataset.type;
    });
  });

  /* 사진 미리보기 */
  document.getElementById('btnPhotoUpload').addEventListener('click', function () {
    document.getElementById('petPhoto').click();
  });
  document.getElementById('petPhoto').addEventListener('change', function () {
    if (!this.files || !this.files[0]) return;
    var reader = new FileReader();
    reader.onload = function (e) {
      var preview = document.getElementById('petPhotoPreview');
      preview.innerHTML = '<img src="' + e.target.result + '" alt="반려동물 사진">';
    };
    reader.readAsDataURL(this.files[0]);
  });

  /* ── 2026/07/07 장우철 — join(회원가입) POST /join 공통 처리 ──
   * skipPet=true  → 반려동물 필드 미전송 (넘어가기) — Service 가 TB_PET INSERT 스킵
   * skipPet=false → 펫 필드 전송 — petName 있을 때만 TB_PET INSERT (백엔드 hasPetInfo)
   * Java 수정 불필요: MemberAuthServiceImpl.register() 가 petName 빈 값이면 펫 등록 안 함
   */
  function submitJoin(skipPet) {
    var fd = new FormData();

    function yn(id) {
      var el = document.getElementById(id);
      return el && el.checked ? 'Y' : 'N';
    }

    /* Step 1 약관 → TB_MEMBER_AGREEMENT */
    fd.append('agreeService',   yn('agreeService'));
    fd.append('agreePrivacy',   yn('agreePrivacy'));
    fd.append('agreeLocation',  yn('agreeLocation'));
    fd.append('agreeMarketing', yn('agreeMarketing'));

    /* Step 2 회원 정보 → TB_MEMBER */
    fd.append('memberName', document.getElementById('memberName').value.trim());
    fd.append('email', document.getElementById('email').value.trim());
    fd.append('password', document.getElementById('password').value);
    fd.append('passwordConfirm', document.getElementById('passwordConfirm').value);
    fd.append('phone', document.getElementById('phone').value.trim());
    fd.append('zipcode', document.getElementById('zipcode').value);
    fd.append('addr1', document.getElementById('addr1').value);
    fd.append('addr2', document.getElementById('addr2').value);

    /* Step 3 반려동물 — 넘어가기면 아예 안 보냄 */
    if (!skipPet) {
      fd.append('petType', document.getElementById('petType').value);
      fd.append('petName', document.getElementById('petName').value.trim());
      fd.append('petBreed', document.getElementById('petBreed').value.trim());
      fd.append('petAge', document.getElementById('petAge').value);
      fd.append('petWeight', document.getElementById('petWeight').value);
    }

    var ctx = '${contextPath}';
    fetch(ctx + '/join', { method: 'POST', body: fd })
      .then(function (res) { return res.text(); })
      .then(function (text) {
        if (text === 'OK') {
          goStep(4);
          return;
        }
        if (text.indexOf('ERROR:') === 0) {
          var code = text.replace('ERROR:', '');
          var msg = {
            duplicate: '이미 가입된 이메일입니다.',
            password: '비밀번호 규칙을 확인해 주세요.',
            password_mismatch: '비밀번호가 일치하지 않습니다.',
            terms: '필수 약관에 동의해 주세요.',
            phone: '전화번호 형식을 확인해 주세요.',
            email: '이메일 형식을 확인해 주세요.',
            name: '이름을 입력해 주세요.'
          };
          alert(msg[code] || '가입 처리 중 오류가 발생했습니다. (' + code + ')');
          return;
        }
        alert('가입 처리 중 알 수 없는 응답입니다.');
      })
      .catch(function () {
        alert('서버와 통신하지 못했습니다.');
      });
  }

  document.getElementById('btnStep3Prev').addEventListener('click', function () { goStep(2); });

  /* 2026/07/07 장우철 — 넘어가기: 회원+약관만 가입, 반려동물은 마이페이지에서 추후 등록 */
  document.getElementById('btnSkip').addEventListener('click', function () {
    submitJoin(true);
  });

  /* 2026/07/07 장우철 — 가입 완료: 입력한 반려동물 정보가 있으면 함께 등록 */
  document.getElementById('btnSubmit').addEventListener('click', function () {
    submitJoin(false);
  });

  /* ── [변경 전] 가입 완료 — UI 목업만 (DB 저장 없이 step4 로 이동) ──
   * 변경 이유: 2026/07/07 POST /join 서버 연동 (submitJoin 함수로 분리)
   *
  document.getElementById('btnStep3Prev').addEventListener('click', function () { goStep(2); });
  document.getElementById('btnSubmit').addEventListener('click', function () {
    goStep(4);
  });
   */

})();
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
