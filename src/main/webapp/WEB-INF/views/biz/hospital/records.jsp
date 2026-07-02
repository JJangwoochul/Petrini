<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="records" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<style>
    /* ── 진료기록 목록 전용 ── */
    .rec-search-bar {
        display: flex;
        gap: 10px;
        margin-bottom: 20px;
        align-items: center;
        flex-wrap: wrap;
    }
    .rec-search-input {
        flex: 1; min-width: 200px;
        border: 1px solid #E2E8E4;
        border-radius: 8px;
        padding: 9px 14px;
        font-size: 14px;
        color: #1A1A2E;
        outline: none;
        transition: border-color .2s;
    }
    .rec-search-input:focus { border-color: #2BAB82; }
    .rec-search-select {
        border: 1px solid #E2E8E4;
        border-radius: 8px;
        padding: 9px 14px;
        font-size: 14px;
        color: #555;
        background: #fff;
        outline: none;
        cursor: pointer;
    }
    .rec-search-btn {
        padding: 9px 20px;
        background: #2BAB82;
        color: #fff;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        display: flex; align-items: center; gap: 6px;
        transition: background .2s;
    }
    .rec-search-btn:hover { background: #1F8464; }
    .rec-search-btn svg {
        width: 15px; height: 15px;
        stroke: #fff; fill: none;
        stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
    }
    .rec-write-btn {
        padding: 9px 20px;
        background: #fff;
        color: #2BAB82;
        border: 1px solid #2BAB82;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        display: flex; align-items: center; gap: 6px;
        text-decoration: none;
        transition: all .2s;
    }
    .rec-write-btn:hover { background: #2BAB82; color: #fff; }
    .rec-write-btn svg {
        width: 15px; height: 15px;
        stroke: currentColor; fill: none;
        stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
    }

    /* 진료 유형 뱃지 */
    .rec-type {
        display: inline-block;
        padding: 3px 10px;
        border-radius: 20px;
        font-size: 12px; font-weight: 600;
    }
    .rec-check   { background: #E0F2FE; color: #0284C7; }
    .rec-treat   { background: #DCFCE7; color: #16A34A; }
    .rec-vaccine { background: #F3E8FF; color: #9333EA; }
    .rec-surgery { background: #FEE2E2; color: #DC2626; }

    /* 진료기록 카드 */
    .rec-card {
        background: #fff;
        border: 1px solid #E2E8E4;
        border-radius: 12px;
        margin-bottom: 14px;
        overflow: hidden;
        transition: box-shadow .2s;
    }
    .rec-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,.08); }
    .rec-card-head {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 14px 20px;
        border-bottom: 1px solid #E2E8E4;
        background: #FAFBFA;
    }
    .rec-pet-thumb {
        width: 44px; height: 44px;
        border-radius: 50%;
        object-fit: cover;
        flex-shrink: 0;
    }
    .rec-pet-info .pet-name { font-size: 15px; font-weight: 700; color: #1A1A2E; }
    .rec-pet-info .pet-meta { font-size: 12px; color: #999; margin-top: 2px; }
    .rec-head-right { margin-left: auto; display: flex; align-items: center; gap: 10px; }
    .rec-date { font-size: 13px; color: #999; }

    .rec-card-body {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 0;
        padding: 0;
    }
    .rec-field {
        padding: 14px 20px;
        border-right: 1px solid #E2E8E4;
    }
    .rec-field:last-child { border-right: none; }
    .rec-field label { font-size: 11px; color: #999; font-weight: 600; display: block; margin-bottom: 4px; }
    .rec-field span  { font-size: 14px; color: #1A1A2E; }

    .rec-card-foot {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 20px;
        border-top: 1px solid #E2E8E4;
        font-size: 12px;
        color: #999;
    }
    .rec-foot-vet { display: flex; align-items: center; gap: 5px; }
    .rec-foot-vet svg {
        width: 13px; height: 13px;
        stroke: #999; fill: none;
        stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
    }
    .rec-action-btns { display: flex; gap: 8px; }

    /* 페이지네이션 */
    .rec-pagination {
        display: flex;
        justify-content: center;
        gap: 6px;
        margin-top: 24px;
    }
    .rec-page-btn {
        width: 34px; height: 34px;
        border-radius: 8px;
        border: 1px solid #E2E8E4;
        background: #fff;
        font-size: 13px;
        color: #555;
        cursor: pointer;
        display: flex; align-items: center; justify-content: center;
        transition: all .15s;
    }
    .rec-page-btn:hover  { border-color: #2BAB82; color: #2BAB82; }
    .rec-page-btn.active { background: #2BAB82; border-color: #2BAB82; color: #fff; font-weight: 700; }
    .rec-page-btn svg {
        width: 14px; height: 14px;
        stroke: currentColor; fill: none;
        stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
    }

    /* ── 진료기록 작성/수정 모달 ── */
    .rm-modal-bg {
        display: none; position: fixed; inset: 0;
        background: rgba(0,0,0,.5); z-index: 1000;
        align-items: center; justify-content: center;
        padding: 20px;
    }
    .rm-modal-bg.open { display: flex; }
    .rm-modal {
        background: #fff; border-radius: 16px;
        width: 100%; max-width: 640px; max-height: 90vh;
        overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,.2);
        animation: rmSlideUp .25s ease;
    }
    @keyframes rmSlideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
    .rm-header {
        display: flex; justify-content: space-between; align-items: center;
        padding: 20px 24px 16px; border-bottom: 1px solid #E2E8E4;
        position: sticky; top: 0; background: #fff; z-index: 1;
    }
    .rm-header h3 { font-size: 18px; font-weight: 800; color: #1A1A2E; margin: 0; }
    .rm-close {
        width: 32px; height: 32px; border: none; background: #F0F4F8;
        border-radius: 50%; cursor: pointer; display: flex; align-items: center; justify-content: center;
        font-size: 18px; line-height: 1; color: #999; transition: all .2s;
    }
    .rm-close:hover { background: #E2E8E4; }
    .rm-body { padding: 22px 24px; }

    /* 환자 정보 (수정 시 표시) */
    .rm-patient-card {
        display: flex; align-items: center; gap: 14px;
        background: #FAFBFA; border: 1px solid #E2E8E4; border-radius: 10px;
        padding: 14px 16px; margin-bottom: 20px;
    }
    .rm-patient-thumb { width: 52px; height: 52px; border-radius: 50%; object-fit: cover; flex-shrink: 0; border: 2px solid #E2E8E4; }
    .rm-patient-name { font-size: 15px; font-weight: 700; color: #1A1A2E; }
    .rm-patient-meta { font-size: 12.5px; color: #999; margin-top: 3px; }
    .rm-patient-badge { margin-left: auto; font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 20px; background: #EAF7F2; color: #1F8464; white-space: nowrap; }

    /* 환자 검색 (신규 작성 시 표시) */
    .rm-patient-search { display: flex; gap: 8px; margin-bottom: 20px; }
    .rm-patient-search input {
        flex: 1; border: 1px solid #E2E8E4; border-radius: 8px;
        padding: 10px 14px; font-size: 14px; outline: none; transition: border-color .2s;
        box-sizing: border-box;
    }
    .rm-patient-search input:focus { border-color: #2BAB82; }

    .rm-section-label {
        font-size: 13px; font-weight: 700; color: #2BAB82;
        margin: 4px 0 12px; padding-top: 14px; border-top: 1px solid #F0F4F8;
    }
    .rm-section-label:first-of-type { padding-top: 0; border-top: none; }

    .rm-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 4px; }
    .rm-group { display: flex; flex-direction: column; gap: 5px; }
    .rm-group.full { grid-column: 1 / -1; }
    .rm-group label { font-size: 13px; font-weight: 600; color: #555; }
    .rm-group label .req { color: #FF6B6B; margin-left: 2px; }
    .rm-group input, .rm-group select, .rm-group textarea {
        border: 1px solid #E2E8E4; border-radius: 8px;
        padding: 9px 13px; font-size: 14px; color: #1A1A2E;
        outline: none; font-family: inherit; width: 100%; box-sizing: border-box;
        transition: border-color .2s;
    }
    .rm-group input:focus, .rm-group select:focus, .rm-group textarea:focus { border-color: #2BAB82; }
    .rm-group textarea { min-height: 64px; resize: vertical; line-height: 1.6; }
    .rm-input-unit { display: flex; align-items: center; gap: 8px; }
    .rm-input-unit input { flex: 1; }
    .rm-input-unit span { font-size: 13px; color: #555; white-space: nowrap; flex-shrink: 0; }
    .rm-hint { font-size: 11px; color: #aaa; margin-top: 2px; }

    .rm-type-group { display: flex; gap: 8px; flex-wrap: wrap; }
    .rm-type-item { display: none; }
    .rm-type-label {
        padding: 7px 16px; border: 1px solid #E2E8E4; border-radius: 50px;
        font-size: 13px; font-weight: 600; color: #555; cursor: pointer; transition: all .15s;
    }
    .rm-type-item:checked + .rm-type-label { background: #EAF7F2; border-color: #2BAB82; color: #1F8464; }

    .rm-footer {
        display: flex; gap: 10px; padding: 16px 24px;
        border-top: 1px solid #E2E8E4; position: sticky; bottom: 0; background: #fff;
    }
    .btn-rm-cancel { flex: 1; padding: 12px; border: 1px solid #E2E8E4; border-radius: 8px; background: #fff; color: #555; font-size: 14px; font-weight: 700; cursor: pointer; transition: all .15s; }
    .btn-rm-cancel:hover { border-color: #2BAB82; color: #2BAB82; }
    .btn-rm-save {
        flex: 2; padding: 12px; border: none; border-radius: 8px;
        background: #2BAB82; color: #fff; font-size: 14px; font-weight: 800; cursor: pointer;
        display: flex; align-items: center; justify-content: center; gap: 8px; transition: background .15s;
    }
    .btn-rm-save:hover { background: #1F8464; }
    .btn-rm-save svg { width: 16px; height: 16px; stroke: #fff; fill: none; stroke-width: 2.2; stroke-linecap: round; stroke-linejoin: round; }

    @media (max-width: 600px) {
        .rm-grid { grid-template-columns: 1fr; }
    }
</style>

<main class="biz-main">
    <div class="biz-page-head">
        <h1 class="biz-page-title">진료기록 관리</h1>
        <p class="biz-page-desc">내원 환자의 진료기록을 조회하고 관리하세요.</p>
    </div>

    <%-- 검색 바 --%>
    <div class="rec-search-bar">
        <input type="text" class="rec-search-input" placeholder="보호자명 또는 반려동물명으로 검색">
        <select class="rec-search-select">
            <option value="">진료 유형 전체</option>
            <option>정기검진</option>
            <option>진료</option>
            <option>예방접종</option>
            <option>수술</option>
        </select>
        <select class="rec-search-select">
            <option value="">기간 전체</option>
            <option>최근 1개월</option>
            <option>최근 3개월</option>
            <option>최근 6개월</option>
            <option>최근 1년</option>
        </select>
        <button class="rec-search-btn">
            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            조회
        </button>
        <button type="button" class="rec-write-btn" onclick="openRecordModal(null)">
            <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            진료기록 작성
        </button>
    </div>

    <%-- 진료기록 카드 1 --%>
    <div class="rec-card">
        <div class="rec-card-head">
            <img class="rec-pet-thumb"
                 src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=88&q=70&auto=format&fit=crop"
                 alt="몽이"
                 onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=DOG'">
            <div class="rec-pet-info">
                <div class="pet-name">몽이</div>
                <div class="pet-meta">골든 리트리버 / 수컷 / 4세 · 보호자: 최유나</div>
            </div>
            <div class="rec-head-right">
                <span class="rec-date">2025.06.26</span>
                <span class="rec-type rec-treat">진료</span>
            </div>
        </div>
        <div class="rec-card-body">
            <div class="rec-field"><label>주증상</label><span>피부 트러블, 긁음</span></div>
            <div class="rec-field"><label>진단명</label><span>알레르기성 피부염</span></div>
            <div class="rec-field"><label>처방</label><span>덱사메타손 5일치</span></div>
            <div class="rec-field"><label>체중 / 체온</label><span>28.2 kg / 38.5 ℃</span></div>
        </div>
        <div class="rec-card-foot">
            <span class="rec-foot-vet">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                김철수 수의사
            </span>
            <div class="rec-action-btns">
                <button class="biz-btn">상세보기</button>
                <button class="biz-btn" onclick="openRecordModal({
                    thumb:'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=128&q=80&auto=format&fit=crop',
                    name:'몽이', meta:'골든 리트리버 · 수컷 · 4세 · 보호자: 최유나', date:'2025.06.26',
                    type:'진료', symptom:'피부 트러블, 긁음', diagnosis:'알레르기성 피부염',
                    exam:'', prescription:'덱사메타손 5일치', weight:'28.2', temp:'38.5',
                    heartRate:'', breath:'', memo:'', nextVisit:'', vet:'김철수 수의사'
                })">수정</button>
            </div>
        </div>
    </div>

    <%-- 진료기록 카드 2 --%>
    <div class="rec-card">
        <div class="rec-card-head">
            <img class="rec-pet-thumb"
                 src="https://images.unsplash.com/photo-1552053831-71594a27632d?w=88&q=70&auto=format&fit=crop"
                 alt="루비"
                 onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=DOG'">
            <div class="rec-pet-info">
                <div class="pet-name">루비</div>
                <div class="pet-meta">푸들 / 암컷 / 1세 · 보호자: 최유나</div>
            </div>
            <div class="rec-head-right">
                <span class="rec-date">2025.06.24</span>
                <span class="rec-type rec-surgery">수술</span>
            </div>
        </div>
        <div class="rec-card-body">
            <div class="rec-field"><label>주증상</label><span>중성화 수술</span></div>
            <div class="rec-field"><label>진단명</label><span>수술 완료 (이상 없음)</span></div>
            <div class="rec-field"><label>처방</label><span>항생제 7일치, 소염제</span></div>
            <div class="rec-field"><label>체중 / 체온</label><span>3.8 kg / 38.2 ℃</span></div>
        </div>
        <div class="rec-card-foot">
            <span class="rec-foot-vet">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                이영희 수의사
            </span>
            <div class="rec-action-btns">
                <button class="biz-btn">상세보기</button>
                <button class="biz-btn" onclick="openRecordModal({
                    thumb:'https://images.unsplash.com/photo-1552053831-71594a27632d?w=128&q=80&auto=format&fit=crop',
                    name:'루비', meta:'푸들 · 암컷 · 1세 · 보호자: 최유나', date:'2025.06.24',
                    type:'수술', symptom:'중성화 수술', diagnosis:'수술 완료 (이상 없음)',
                    exam:'', prescription:'항생제 7일치, 소염제', weight:'3.8', temp:'38.2',
                    heartRate:'', breath:'', memo:'', nextVisit:'', vet:'이영희 수의사'
                })">수정</button>
            </div>
        </div>
    </div>

    <%-- 진료기록 카드 3 --%>
    <div class="rec-card">
        <div class="rec-card-head">
            <img class="rec-pet-thumb"
                 src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=88&q=70&auto=format&fit=crop"
                 alt="나비"
                 onerror="this.src='https://placehold.co/44x44/F3E8FF/9333EA?text=CAT'">
            <div class="rec-pet-info">
                <div class="pet-name">나비</div>
                <div class="pet-meta">페르시안 / 암컷 / 2세 · 보호자: 이서연</div>
            </div>
            <div class="rec-head-right">
                <span class="rec-date">2025.06.20</span>
                <span class="rec-type rec-vaccine">예방접종</span>
            </div>
        </div>
        <div class="rec-card-body">
            <div class="rec-field"><label>접종 항목</label><span>고양이 종합백신 3차</span></div>
            <div class="rec-field"><label>이상반응</label><span>없음</span></div>
            <div class="rec-field"><label>다음 접종</label><span>2026.06.20</span></div>
            <div class="rec-field"><label>체중 / 체온</label><span>4.2 kg / 38.6 ℃</span></div>
        </div>
        <div class="rec-card-foot">
            <span class="rec-foot-vet">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                김철수 수의사
            </span>
            <div class="rec-action-btns">
                <button class="biz-btn">상세보기</button>
                <button class="biz-btn" onclick="openRecordModal({
                    thumb:'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=128&q=70&auto=format&fit=crop',
                    name:'나비', meta:'페르시안 · 암컷 · 2세 · 보호자: 이서연', date:'2025.06.20',
                    type:'예방접종', symptom:'고양이 종합백신 3차', diagnosis:'이상반응 없음',
                    exam:'', prescription:'', weight:'4.2', temp:'38.6',
                    heartRate:'', breath:'', memo:'', nextVisit:'2026-06-20', vet:'김철수 수의사'
                })">수정</button>
            </div>
        </div>
    </div>

    <%-- 진료기록 카드 4 --%>
    <div class="rec-card">
        <div class="rec-card-head">
            <img class="rec-pet-thumb"
                 src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=88&q=70&auto=format&fit=crop"
                 alt="몽이"
                 onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=DOG'">
            <div class="rec-pet-info">
                <div class="pet-name">몽이</div>
                <div class="pet-meta">골든 리트리버 / 수컷 / 4세 · 보호자: 최유나</div>
            </div>
            <div class="rec-head-right">
                <span class="rec-date">2025.04.15</span>
                <span class="rec-type rec-vaccine">예방접종</span>
            </div>
        </div>
        <div class="rec-card-body">
            <div class="rec-field"><label>접종 항목</label><span>종합백신 (DHPPL) 5차</span></div>
            <div class="rec-field"><label>이상반응</label><span>없음</span></div>
            <div class="rec-field"><label>다음 접종</label><span>2026.04.15</span></div>
            <div class="rec-field"><label>체중 / 체온</label><span>27.8 kg / 38.3 ℃</span></div>
        </div>
        <div class="rec-card-foot">
            <span class="rec-foot-vet">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                김철수 수의사
            </span>
            <div class="rec-action-btns">
                <button class="biz-btn">상세보기</button>
            </div>
        </div>
    </div>

    <%-- 페이지네이션 --%>
    <div class="rec-pagination">
        <button class="rec-page-btn"><svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg></button>
        <button class="rec-page-btn active">1</button>
        <button class="rec-page-btn">2</button>
        <button class="rec-page-btn">3</button>
        <button class="rec-page-btn"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></button>
    </div>

</main>

<%-- ── 진료기록 작성/수정 모달 ── --%>
<div class="rm-modal-bg" id="recordModalBg" onclick="if(event.target===this) closeRecordModal()">
  <div class="rm-modal">
    <div class="rm-header">
      <h3 id="rm-title">진료기록 작성</h3>
      <button type="button" class="rm-close" onclick="closeRecordModal()">×</button>
    </div>
    <div class="rm-body">

      <%-- 환자 정보 (수정 시 표시) --%>
      <div class="rm-patient-card" id="rm-patient-card" style="display:none">
        <img class="rm-patient-thumb" id="rm-patient-thumb" src="" alt="환자">
        <div>
          <div class="rm-patient-name" id="rm-patient-name"></div>
          <div class="rm-patient-meta" id="rm-patient-meta"></div>
        </div>
        <span class="rm-patient-badge" id="rm-patient-badge"></span>
      </div>

      <%-- 환자 검색 (신규 작성 시 표시) --%>
      <div class="rm-patient-search" id="rm-patient-search">
        <input type="text" id="rm-pet-name-search" placeholder="반려동물명 *">
        <input type="text" id="rm-guardian-search" placeholder="보호자명">
      </div>

      <div class="rm-section-label">진료 정보</div>
      <div class="rm-grid">
        <div class="rm-group full">
          <label>진료 유형 <span class="req">*</span></label>
          <div class="rm-type-group">
            <input type="radio" name="rmRecType" id="rm-type-check" class="rm-type-item" value="정기검진">
            <label for="rm-type-check" class="rm-type-label">정기검진</label>
            <input type="radio" name="rmRecType" id="rm-type-treat" class="rm-type-item" value="진료" checked>
            <label for="rm-type-treat" class="rm-type-label">진료</label>
            <input type="radio" name="rmRecType" id="rm-type-vaccine" class="rm-type-item" value="예방접종">
            <label for="rm-type-vaccine" class="rm-type-label">예방접종</label>
            <input type="radio" name="rmRecType" id="rm-type-surgery" class="rm-type-item" value="수술">
            <label for="rm-type-surgery" class="rm-type-label">수술</label>
          </div>
        </div>
        <div class="rm-group full">
          <label>주증상 <span class="req">*</span></label>
          <input type="text" id="rm-symptom" placeholder="예) 피부 트러블, 긁음 반복">
        </div>
        <div class="rm-group">
          <label>진단명 <span class="req">*</span></label>
          <input type="text" id="rm-diagnosis" placeholder="예) 알레르기성 피부염">
        </div>
        <div class="rm-group">
          <label>검사 항목</label>
          <input type="text" id="rm-exam" placeholder="예) 혈액검사, 심장사상충">
        </div>
        <div class="rm-group full">
          <label>처방 내용</label>
          <textarea id="rm-prescription" placeholder="처방한 약물명, 용량, 투약 기간 등을 입력하세요."></textarea>
        </div>
      </div>

      <div class="rm-section-label">신체 계측</div>
      <div class="rm-grid">
        <div class="rm-group">
          <label>체중</label>
          <div class="rm-input-unit"><input type="number" id="rm-weight" placeholder="0.0" step="0.1"><span>kg</span></div>
        </div>
        <div class="rm-group">
          <label>체온</label>
          <div class="rm-input-unit"><input type="number" id="rm-temp" placeholder="0.0" step="0.1"><span>℃</span></div>
          <span class="rm-hint">정상 범위: 개 37.5~39.2℃ / 고양이 38.1~39.2℃</span>
        </div>
        <div class="rm-group">
          <label>심박수</label>
          <div class="rm-input-unit"><input type="number" id="rm-heart" placeholder="0"><span>bpm</span></div>
        </div>
        <div class="rm-group">
          <label>호흡수</label>
          <div class="rm-input-unit"><input type="number" id="rm-breath" placeholder="0"><span>회/분</span></div>
        </div>
      </div>

      <div class="rm-section-label">추가 정보</div>
      <div class="rm-grid">
        <div class="rm-group full">
          <label>수의사 메모</label>
          <textarea id="rm-memo" placeholder="보호자에게 전달할 주의사항, 재방문 권장 이유, 관리 방법 등을 입력하세요."></textarea>
        </div>
        <div class="rm-group">
          <label>다음 방문 권장일</label>
          <input type="date" id="rm-next-visit">
          <span class="rm-hint">입력 시 보호자에게 알림이 발송됩니다.</span>
        </div>
        <div class="rm-group">
          <label>담당 수의사</label>
          <select id="rm-vet">
            <option>김철수 수의사</option>
            <option>이영희 수의사</option>
          </select>
        </div>
      </div>

    </div>
    <div class="rm-footer">
      <button type="button" class="btn-rm-cancel" onclick="closeRecordModal()">취소</button>
      <button type="button" class="btn-rm-save" onclick="saveRecord()">
        <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
        저장
      </button>
    </div>
  </div>
</div>

<script>
    function selRecType(v) {
        const map = {'정기검진':'rm-type-check','진료':'rm-type-treat','예방접종':'rm-type-vaccine','수술':'rm-type-surgery'};
        const id = map[v] || 'rm-type-treat';
        document.getElementById(id).checked = true;
    }

    function openRecordModal(data) {
        const isEdit = !!data;
        document.getElementById('rm-title').textContent = isEdit ? '진료기록 수정' : '진료기록 작성';
        document.getElementById('rm-patient-card').style.display = isEdit ? 'flex' : 'none';
        document.getElementById('rm-patient-search').style.display = isEdit ? 'none' : 'flex';

        if (isEdit) {
            document.getElementById('rm-patient-thumb').src = data.thumb || '';
            document.getElementById('rm-patient-name').textContent = data.name || '';
            document.getElementById('rm-patient-meta').textContent = data.meta || '';
            document.getElementById('rm-patient-badge').textContent = (data.date || '') + ' 작성';
            document.getElementById('rm-symptom').value = data.symptom || '';
            document.getElementById('rm-diagnosis').value = data.diagnosis || '';
            document.getElementById('rm-exam').value = data.exam || '';
            document.getElementById('rm-prescription').value = data.prescription || '';
            document.getElementById('rm-weight').value = data.weight || '';
            document.getElementById('rm-temp').value = data.temp || '';
            document.getElementById('rm-heart').value = data.heartRate || '';
            document.getElementById('rm-breath').value = data.breath || '';
            document.getElementById('rm-memo').value = data.memo || '';
            document.getElementById('rm-next-visit').value = data.nextVisit || '';
            const vetSel = document.getElementById('rm-vet');
            if (data.vet) {
                [...vetSel.options].forEach((o, i) => { if (o.text === data.vet) vetSel.selectedIndex = i; });
            }
            selRecType(data.type || '진료');
        } else {
            document.getElementById('rm-pet-name-search').value = '';
            document.getElementById('rm-guardian-search').value = '';
            document.getElementById('rm-symptom').value = '';
            document.getElementById('rm-diagnosis').value = '';
            document.getElementById('rm-exam').value = '';
            document.getElementById('rm-prescription').value = '';
            document.getElementById('rm-weight').value = '';
            document.getElementById('rm-temp').value = '';
            document.getElementById('rm-heart').value = '';
            document.getElementById('rm-breath').value = '';
            document.getElementById('rm-memo').value = '';
            document.getElementById('rm-next-visit').value = '';
            document.getElementById('rm-vet').selectedIndex = 0;
            selRecType('진료');
        }

        document.getElementById('recordModalBg').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeRecordModal() {
        document.getElementById('recordModalBg').classList.remove('open');
        document.body.style.overflow = '';
    }

    function saveRecord() {
        const isCreate = document.getElementById('rm-patient-search').style.display !== 'none';
        if (isCreate && !document.getElementById('rm-pet-name-search').value.trim()) {
            alert('반려동물명을 입력해 주세요.');
            return;
        }
        if (!document.getElementById('rm-symptom').value.trim()) {
            alert('주증상을 입력해 주세요.');
            return;
        }
        if (!document.getElementById('rm-diagnosis').value.trim()) {
            alert('진단명을 입력해 주세요.');
            return;
        }
        if (confirm('진료를 완료 처리하고 기록을 저장하시겠습니까?\n저장 후 보호자에게 알림이 발송됩니다.')) {
            closeRecordModal();
            alert('진료기록이 저장되었습니다.');
        }
    }
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
