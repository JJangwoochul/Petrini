<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="mypage" />
<c:set var="sec"         value="health" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<style>
/* ── 건강수첩 전용 ── */
.health-pet-tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 24px;
    flex-wrap: wrap;
}
.health-pet-tab {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 18px;
    border: 2px solid var(--border);
    border-radius: 50px;
    background: var(--bg-card);
    cursor: pointer;
    transition: var(--transition);
    text-decoration: none;
    color: var(--text-sub);
    font-size: 14px;
    font-weight: 600;
}
.health-pet-tab:hover { border-color: var(--primary); color: var(--primary-dark); }
.health-pet-tab.active { border-color: var(--primary); background: var(--primary-light); color: var(--primary-dark); }
.health-pet-tab img {
    width: 32px; height: 32px;
    border-radius: 50%; object-fit: cover;
}
.health-pet-tab .tab-name  { font-size: 14px; font-weight: 700; }
.health-pet-tab .tab-breed { font-size: 11px; color: var(--text-muted); font-weight: 400; }

/* 반려동물 프로필 카드 */
.health-pet-profile {
    display: flex;
    align-items: center;
    gap: 20px;
    background: var(--bg-page);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    padding: 20px 24px;
    margin-bottom: 24px;
}
.health-pet-avatar {
    width: 80px; height: 80px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #fff;
    box-shadow: var(--shadow-sm);
    flex-shrink: 0;
}
.health-pet-info { flex: 1; }
.health-pet-name { font-size: 20px; font-weight: 800; color: var(--text-main); margin-bottom: 4px; }
.health-pet-meta { font-size: 13px; color: var(--text-muted); }
.health-pet-stats {
    display: flex;
    gap: 24px;
    margin-left: auto;
    flex-shrink: 0;
}
.hps-item { text-align: center; }
.hps-label { font-size: 11px; color: var(--text-muted); margin-bottom: 4px; }
.hps-val   { font-size: 18px; font-weight: 800; color: var(--primary-dark); }
.hps-unit  { font-size: 11px; color: var(--text-sub); }

/* 진료 타임라인 */
.health-timeline { position: relative; }
.health-timeline::before {
    content: '';
    position: absolute;
    left: 19px; top: 0; bottom: 0;
    width: 2px;
    background: var(--border);
}
.health-record {
    display: flex;
    gap: 20px;
    margin-bottom: 16px;
    position: relative;
}
.health-record-dot {
    width: 40px; height: 40px;
    border-radius: 50%;
    background: var(--primary-light);
    border: 2px solid var(--primary);
    display: flex; align-items: center; justify-content: center;
    flex-shrink: 0;
    z-index: 1;
}
.health-record-dot svg {
    width: 18px; height: 18px;
    stroke: var(--primary); fill: none;
    stroke-width: 1.8; stroke-linecap: round; stroke-linejoin: round;
}
.health-record-card {
    flex: 1;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-md);
    overflow: hidden;
    transition: var(--transition);
}
.health-record-card:hover { box-shadow: var(--shadow-sm); }
.health-record-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 14px 18px;
    border-bottom: 1px solid var(--border);
    background: var(--bg-page);
}
.health-record-date    { font-size: 13px; color: var(--text-muted); }
.health-record-hospital{ font-size: 14px; font-weight: 700; color: var(--text-main); margin-left: 10px; }
.health-record-type {
    font-size: 11px; font-weight: 700;
    padding: 3px 10px; border-radius: 20px;
}
.type-check   { background: #E0F2FE; color: #0284C7; }
.type-treat   { background: #DCFCE7; color: #16A34A; }
.type-vaccine { background: #F3E8FF; color: #9333EA; }
.type-surgery { background: #FEE2E2; color: #DC2626; }

.health-record-body { padding: 16px 18px; }
.health-record-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
    margin-bottom: 12px;
}
.hrg-item label { font-size: 11px; color: var(--text-muted); font-weight: 600; display: block; margin-bottom: 3px; }
.hrg-item span  { font-size: 14px; color: var(--text-main); }
.health-record-memo {
    background: var(--bg-page);
    border-radius: var(--radius-sm);
    padding: 10px 14px;
    font-size: 13px;
    color: var(--text-sub);
    line-height: 1.6;
    border-left: 3px solid var(--primary);
}
.health-record-memo label { font-size: 11px; color: var(--text-muted); font-weight: 600; display: block; margin-bottom: 4px; }
.health-record-foot {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 18px;
    border-top: 1px solid var(--border);
    font-size: 12px;
    color: var(--text-muted);
}
.health-next-visit {
    display: flex; align-items: center; gap: 5px;
    color: var(--primary); font-weight: 600;
}
.health-next-visit svg {
    width: 13px; height: 13px;
    stroke: currentColor; fill: none;
    stroke-width: 2; stroke-linecap: round; stroke-linejoin: round;
}

/* 빈 상태 */
.health-empty {
    display: flex; flex-direction: column;
    align-items: center; gap: 14px;
    padding: 60px 20px; text-align: center;
}
.health-empty-icon {
    width: 64px; height: 64px; border-radius: 50%;
    background: var(--primary-light);
    display: flex; align-items: center; justify-content: center;
}
.health-empty-icon svg {
    width: 30px; height: 30px;
    stroke: var(--primary); fill: none;
    stroke-width: 1.6; stroke-linecap: round; stroke-linejoin: round;
}
</style>

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>

<div class="mypage-content">
<div class="mp-section active">
    <h2 class="mp-title">건강수첩</h2>
    <p class="mp-desc">반려동물의 진료 기록을 확인하세요.</p>

    <%-- 반려동물 탭 --%>
    <div class="health-pet-tabs">
        <a href="#" class="health-pet-tab active">
            <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=64&q=70&auto=format&fit=crop"
                 alt="몽이"
                 onerror="this.src='https://placehold.co/32x32/EAF7F2/2BAB82?text=🐶'">
            <div>
                <div class="tab-name">몽이</div>
                <div class="tab-breed">골든 리트리버</div>
            </div>
        </a>
        <a href="#" class="health-pet-tab">
            <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=64&q=70&auto=format&fit=crop"
                 alt="나비"
                 onerror="this.src='https://placehold.co/32x32/EAF7F2/2BAB82?text=🐱'">
            <div>
                <div class="tab-name">나비</div>
                <div class="tab-breed">페르시안</div>
            </div>
        </a>
    </div>

    <%-- 선택된 반려동물 프로필 --%>
    <div class="health-pet-profile">
        <img class="health-pet-avatar"
             src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=160&q=80&auto=format&fit=crop"
             alt="몽이"
             onerror="this.src='https://placehold.co/80x80/EAF7F2/2BAB82?text=DOG'">
        <div class="health-pet-info">
            <div class="health-pet-name">몽이</div>
            <div class="health-pet-meta">골든 리트리버 · 수컷 · 중성화 O · 2021.03.15생 (4살)</div>
        </div>
        <div class="health-pet-stats">
            <div class="hps-item">
                <div class="hps-label">최근 체중</div>
                <div class="hps-val">28.2<span class="hps-unit"> kg</span></div>
            </div>
            <div class="hps-item">
                <div class="hps-label">최근 체온</div>
                <div class="hps-val">38.5<span class="hps-unit"> ℃</span></div>
            </div>
            <div class="hps-item">
                <div class="hps-label">총 방문</div>
                <div class="hps-val">5<span class="hps-unit"> 회</span></div>
            </div>
        </div>
    </div>

    <%-- 진료 타임라인 --%>
    <div class="health-timeline">

        <%-- 기록 1 --%>
        <div class="health-record">
            <div class="health-record-dot">
                <svg viewBox="0 0 24 24"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
            </div>
            <div class="health-record-card">
                <div class="health-record-head">
                    <div>
                        <span class="health-record-date">2025.06.20</span>
                        <span class="health-record-hospital">행복동물병원</span>
                    </div>
                    <span class="health-record-type type-treat">진료</span>
                </div>
                <div class="health-record-body">
                    <div class="health-record-grid">
                        <div class="hrg-item">
                            <label>주증상</label>
                            <span>피부 트러블, 긁음 반복</span>
                        </div>
                        <div class="hrg-item">
                            <label>진단명</label>
                            <span>알레르기성 피부염</span>
                        </div>
                        <div class="hrg-item">
                            <label>처방</label>
                            <span>덱사메타손 5일치, 항히스타민제</span>
                        </div>
                        <div class="hrg-item">
                            <label>체중 / 체온</label>
                            <span>28.2 kg / 38.5 ℃</span>
                        </div>
                    </div>
                    <div class="health-record-memo">
                        <label>수의사 메모</label>
                        알레르기 원인 파악을 위해 식이 일지 작성 권장. 2주 후 재방문 시 호전 여부 확인 필요.
                    </div>
                </div>
                <div class="health-record-foot">
                    <span>담당: 김철수 수의사</span>
                    <span class="health-next-visit">
                        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="16" y1="2" x2="16" y2="6"/></svg>
                        다음 방문 권장: 2025.07.05
                    </span>
                </div>
            </div>
        </div>

        <%-- 기록 2 --%>
        <div class="health-record">
            <div class="health-record-dot">
                <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            </div>
            <div class="health-record-card">
                <div class="health-record-head">
                    <div>
                        <span class="health-record-date">2025.04.15</span>
                        <span class="health-record-hospital">행복동물병원</span>
                    </div>
                    <span class="health-record-type type-vaccine">예방접종</span>
                </div>
                <div class="health-record-body">
                    <div class="health-record-grid">
                        <div class="hrg-item">
                            <label>접종 항목</label>
                            <span>종합백신 (DHPPL) 5차</span>
                        </div>
                        <div class="hrg-item">
                            <label>다음 접종 예정</label>
                            <span>2026.04.15 (1년 후)</span>
                        </div>
                        <div class="hrg-item">
                            <label>이상반응</label>
                            <span>없음</span>
                        </div>
                        <div class="hrg-item">
                            <label>체중 / 체온</label>
                            <span>27.8 kg / 38.3 ℃</span>
                        </div>
                    </div>
                </div>
                <div class="health-record-foot">
                    <span>담당: 김철수 수의사</span>
                    <span class="health-next-visit">
                        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="16" y1="2" x2="16" y2="6"/></svg>
                        다음 방문 권장: 2026.04.15
                    </span>
                </div>
            </div>
        </div>

        <%-- 기록 3 --%>
        <div class="health-record">
            <div class="health-record-dot">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            </div>
            <div class="health-record-card">
                <div class="health-record-head">
                    <div>
                        <span class="health-record-date">2025.01.08</span>
                        <span class="health-record-hospital">행복동물병원</span>
                    </div>
                    <span class="health-record-type type-check">정기검진</span>
                </div>
                <div class="health-record-body">
                    <div class="health-record-grid">
                        <div class="hrg-item">
                            <label>주증상</label>
                            <span>정기 건강검진</span>
                        </div>
                        <div class="hrg-item">
                            <label>진단명</label>
                            <span>이상 없음 (건강)</span>
                        </div>
                        <div class="hrg-item">
                            <label>검사 항목</label>
                            <span>혈액검사, 심장사상충, 구강검진</span>
                        </div>
                        <div class="hrg-item">
                            <label>체중 / 체온</label>
                            <span>27.5 kg / 38.4 ℃</span>
                        </div>
                    </div>
                    <div class="health-record-memo">
                        <label>수의사 메모</label>
                        전반적으로 건강 양호. 치석이 약간 있어 6개월 후 스케일링 검토 권장.
                    </div>
                </div>
                <div class="health-record-foot">
                    <span>담당: 이영희 수의사</span>
                    <span class="health-next-visit">
                        <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="16" y1="2" x2="16" y2="6"/></svg>
                        다음 방문 권장: 2025.07.08
                    </span>
                </div>
            </div>
        </div>

    </div><%-- /health-timeline --%>
</div>
</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
