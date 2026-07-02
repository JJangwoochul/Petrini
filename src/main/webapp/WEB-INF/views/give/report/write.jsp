<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="give" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
.rw-wrap{max-width:720px;margin:32px auto 80px;padding:0 20px}
.rw-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:6px}
.rw-desc{font-size:14px;color:var(--text-muted);margin-bottom:28px}
.rw-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:22px;margin-bottom:18px}
.rw-section-title{font-size:14px;font-weight:800;color:var(--text-main);margin:0 0 16px;padding-bottom:12px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:8px}
.rw-section-title svg{width:15px;height:15px;stroke:var(--primary);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.rw-grid{display:grid;grid-template-columns:1fr 1fr;gap:13px}
.rw-group{display:flex;flex-direction:column;gap:5px}
.rw-group.full{grid-column:1/-1}
.rw-group label{font-size:13px;font-weight:600;color:var(--text-sub)}
.rw-group label .req{color:var(--accent);margin-left:2px}
.rw-group input,.rw-group select,.rw-group textarea{border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 13px;font-size:14px;color:var(--text-main);outline:none;font-family:inherit;width:100%;box-sizing:border-box;transition:border-color .2s}
.rw-group input:focus,.rw-group select:focus,.rw-group textarea:focus{border-color:var(--primary)}
.rw-group textarea{min-height:100px;resize:vertical;line-height:1.6}

/* 특징 태그 */
.feature-tags{display:flex;flex-wrap:wrap;gap:7px;margin-top:8px}
.ftag{padding:6px 14px;border:1px solid var(--border);border-radius:50px;font-size:12px;font-weight:600;color:var(--text-sub);cursor:pointer;transition:var(--transition)}
.ftag:hover,.ftag.on{border-color:var(--primary);background:var(--primary-light);color:var(--primary-dark)}

/* 지도 영역 */
.map-area{border:1px solid var(--border);border-radius:var(--radius-sm);overflow:hidden;background:var(--bg-page);height:200px;display:flex;align-items:center;justify-content:center;color:var(--text-muted);flex-direction:column;gap:10px;cursor:pointer;position:relative}
.map-area img{width:100%;height:100%;object-fit:cover;display:block}
.map-pin-overlay{position:absolute;bottom:12px;left:50%;transform:translateX(-50%);background:rgba(0,0,0,.6);color:#fff;font-size:12px;padding:5px 14px;border-radius:20px}

/* 사진 업로드 */
.photo-upload-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:10px}
.photo-add-box{aspect-ratio:1/1;border:2px dashed var(--border);border-radius:var(--radius-sm);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;cursor:pointer;transition:var(--transition);color:#999;font-size:12px}
.photo-add-box:hover{border-color:var(--primary);color:var(--primary);background:var(--primary-light)}
.photo-add-box svg{width:24px;height:24px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.photo-slot img{width:100%;aspect-ratio:1/1;object-fit:cover;border-radius:var(--radius-sm);display:block}

.rw-btn-row{display:flex;justify-content:flex-end;gap:10px}
.btn-cancel-rw{padding:12px 24px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;color:var(--text-sub);font-size:14px;font-weight:600;cursor:pointer}
.btn-submit-rw{padding:12px 28px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:14px;font-weight:700;cursor:pointer;transition:var(--transition)}
.btn-submit-rw:hover{background:var(--primary-dark)}
</style>

<div class="rw-wrap">
  <h1 class="rw-title">유기동물 발견 신고</h1>
  <p class="rw-desc">발견한 동물의 정보를 등록해 주인을 찾거나 보호소 연계를 도와주세요.</p>

  <%-- 기본 정보 --%>
  <div class="rw-section">
    <div class="rw-section-title">
      <svg viewBox="0 0 24 24"><circle cx="4.5" cy="9.5" r="2"/><circle cx="9" cy="5.5" r="2"/><circle cx="15" cy="5.5" r="2"/><circle cx="19.5" cy="9.5" r="2"/><path d="M12 13c-3.87 0-7 1.79-7 4v1h14v-1c0-2.21-3.13-4-7-4z"/></svg>
      동물 기본 정보
    </div>
    <div class="rw-grid">
      <div class="rw-group">
        <label>동물 종류 <span class="req">*</span></label>
        <select><option value="">선택하세요</option><option>강아지</option><option>고양이</option><option>기타</option></select>
      </div>
      <div class="rw-group">
        <label>추정 크기</label>
        <select><option value="">선택하세요</option><option>소형 (5kg 미만)</option><option>중형 (5~15kg)</option><option>대형 (15kg 이상)</option></select>
      </div>
      <div class="rw-group">
        <label>털 색상</label>
        <input type="text" placeholder="예) 황갈색, 검은색, 흰색">
      </div>
      <div class="rw-group">
        <label>성별 (추정)</label>
        <select><option value="">모름</option><option>수컷</option><option>암컷</option></select>
      </div>
    </div>
    <div class="rw-group" style="margin-top:13px">
      <label>외형 특징 (해당하는 항목 선택)</label>
      <div class="feature-tags">
        <span class="ftag" onclick="this.classList.toggle('on')">목줄 있음</span>
        <span class="ftag" onclick="this.classList.toggle('on')">목줄 없음</span>
        <span class="ftag" onclick="this.classList.toggle('on')">목걸이 있음</span>
        <span class="ftag" onclick="this.classList.toggle('on')">부상 있음</span>
        <span class="ftag" onclick="this.classList.toggle('on')">임신/수유 중</span>
        <span class="ftag" onclick="this.classList.toggle('on')">매우 야위었음</span>
        <span class="ftag" onclick="this.classList.toggle('on')">겁을 많이 먹음</span>
        <span class="ftag" onclick="this.classList.toggle('on')">사람에게 친근함</span>
      </div>
    </div>
  </div>

  <%-- 발견 위치 --%>
  <div class="rw-section">
    <div class="rw-section-title">
      <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
      발견 위치
    </div>
    <div class="rw-grid" style="margin-bottom:13px">
      <div class="rw-group">
        <label>발견 일시 <span class="req">*</span></label>
        <input type="datetime-local">
      </div>
      <div class="rw-group">
        <label>주소 입력</label>
        <div style="display:flex;gap:8px">
          <input type="text" placeholder="주소 직접 입력" style="flex:1">
          <button type="button" style="padding:10px 14px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:#fff;color:var(--primary);font-size:13px;font-weight:600;cursor:pointer;white-space:nowrap">검색</button>
        </div>
      </div>
    </div>
    <%-- 카카오맵 자리 --%>
    <div class="map-area" onclick="alert('카카오맵 API 연동 예정\n지도를 클릭하여 위치를 지정하세요.')">
      <img src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=720&q=70&auto=format&fit=crop"
           alt="지도" onerror="this.style.display='none'">
      <div class="map-pin-overlay">
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
        클릭하여 발견 위치 지정 (카카오맵 API 연동 예정)
      </div>
    </div>
  </div>

  <%-- 사진 업로드 --%>
  <div class="rw-section">
    <div class="rw-section-title">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
      발견 사진 (최대 5장)
    </div>
    <div class="photo-upload-grid">
      <div class="photo-slot">
        <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=200&q=70&auto=format&fit=crop" alt="미리보기" onerror="this.parentElement.innerHTML='<div class=photo-add-box onclick=alert(업로드)><svg viewBox=0 0 24 24><rect x=3 y=3 width=18 height=18 rx=2/><circle cx=8.5 cy=8.5 r=1.5/><polyline points=21 15 16 10 5 21/></svg><span>사진 추가</span></div>'">
      </div>
      <div class="photo-add-box" onclick="alert('사진 업로드')">
        <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
        <span>사진 추가</span>
      </div>
      <div class="photo-add-box" onclick="alert('사진 업로드')">
        <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
        <span>사진 추가</span>
      </div>
      <div class="photo-add-box" onclick="alert('사진 업로드')">
        <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
        <span>사진 추가</span>
      </div>
    </div>
  </div>

  <%-- 상세 설명 & 연락처 --%>
  <div class="rw-section">
    <div class="rw-section-title">
      <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
      상세 설명 및 연락처
    </div>
    <div class="rw-grid">
      <div class="rw-group full">
        <label>상황 설명 <span class="req">*</span></label>
        <textarea placeholder="발견 당시 상황, 동물의 상태, 현재 위치 등을 자세히 적어주세요."></textarea>
      </div>
      <div class="rw-group">
        <label>신고자 연락처 <span class="req">*</span></label>
        <input type="tel" placeholder="010-0000-0000">
      </div>
      <div class="rw-group">
        <label>현재 임시 보호 여부</label>
        <select><option>아니요 (제보만)</option><option>예 (임시 보호 중)</option></select>
      </div>
    </div>
  </div>

  <div class="rw-btn-row">
    <button class="btn-cancel-rw" onclick="history.back()">취소</button>
    <button class="btn-submit-rw" onclick="alert('발견 신고가 등록되었습니다.\n주변 회원들에게 알림이 발송됩니다.')">신고 등록하기</button>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
