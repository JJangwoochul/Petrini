<%-- give/talent/_list.jsp — give/index.jsp 에서 include --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="give" />
<c:set var="giveTab"     value="talent" />

<%@ include file="/WEB-INF/views/give/index.jsp" %>

<style>
    .talent-toolbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:12px; }
    .talent-filters { display:flex; gap:8px; flex-wrap:wrap; }
    .talent-chip {
        padding:7px 16px; border:1px solid var(--border); border-radius:50px;
        font-size:13px; color:var(--text-sub); background:#fff; cursor:pointer; transition:var(--transition);
    }
    .talent-chip:hover,.talent-chip.on { border-color:var(--primary); background:var(--primary-light); color:var(--primary-dark); font-weight:600; }
    .btn-talent-write {
        padding:9px 20px; border:none; border-radius:50px;
        background:var(--primary); color:#fff; font-size:14px; font-weight:700;
        cursor:pointer; display:flex; align-items:center; gap:6px;
    }
    .btn-talent-write svg { width:14px; height:14px; stroke:#fff; fill:none; stroke-width:2.5; stroke-linecap:round; stroke-linejoin:round; }

    /* 재능나눔 카드 — 가로형 */
    .talent-list { display:flex; flex-direction:column; gap:16px; margin-bottom:32px; }
    .talent-card {
        background:var(--bg-card); border:1px solid var(--border);
        border-radius:var(--radius-md); padding:22px;
        display:flex; gap:20px; align-items:flex-start;
        transition:var(--transition); cursor:pointer;
    }
    .talent-card:hover { box-shadow:var(--shadow-md); transform:translateY(-1px); }
    .talent-icon {
        width:60px; height:60px; border-radius:var(--radius-md);
        display:flex; align-items:center; justify-content:center; flex-shrink:0;
    }
    .talent-icon svg { width:28px; height:28px; fill:none; stroke-width:1.8; stroke-linecap:round; stroke-linejoin:round; }
    .ti-grooming  { background:#FDF2F8; } .ti-grooming svg  { stroke:#DB2777; }
    .ti-hospital  { background:#E0F2FE; } .ti-hospital svg  { stroke:#0284C7; }
    .ti-photo     { background:#F3E8FF; } .ti-photo svg     { stroke:#9333EA; }
    .ti-transport { background:#FFF7ED; } .ti-transport svg { stroke:#EA580C; }
    .ti-edu       { background:#DCFCE7; } .ti-edu svg       { stroke:#16A34A; }

    .talent-body { flex:1; min-width:0; }
    .talent-tags { display:flex; gap:6px; flex-wrap:wrap; margin-bottom:8px; }
    .talent-tag  { font-size:11px; font-weight:700; padding:3px 9px; border-radius:20px; }
    .tt-grooming { background:#FDF2F8; color:#DB2777; }
    .tt-hospital { background:#E0F2FE; color:#0284C7; }
    .tt-photo    { background:#F3E8FF; color:#9333EA; }
    .tt-transport{ background:#FFF7ED; color:#EA580C; }
    .tt-edu      { background:#DCFCE7; color:#16A34A; }
    .tt-new      { background:#FFF8E1; color:#F59E0B; }

    .talent-title { font-size:16px; font-weight:700; color:var(--text-main); margin-bottom:6px; }
    .talent-desc  { font-size:13px; color:var(--text-muted); line-height:1.6; margin-bottom:10px; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
    .talent-meta-row { display:flex; gap:16px; flex-wrap:wrap; font-size:13px; color:var(--text-muted); }
    .talent-meta-item { display:flex; align-items:center; gap:5px; }
    .talent-meta-item svg { width:13px; height:13px; stroke:currentColor; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }

    .talent-right { display:flex; flex-direction:column; align-items:flex-end; gap:10px; flex-shrink:0; min-width:140px; }
    .talent-provider { text-align:right; }
    .talent-provider .prov-name { font-size:13px; font-weight:700; color:var(--text-main); }
    .talent-provider .prov-type { font-size:11px; color:var(--text-muted); margin-top:2px; }
    .talent-progress { width:100%; }
    .talent-prog-label { display:flex; justify-content:space-between; font-size:11px; color:var(--text-muted); margin-bottom:4px; }
    .talent-prog-bar   { height:5px; background:var(--border); border-radius:3px; overflow:hidden; }
    .talent-prog-fill  { height:100%; background:var(--primary); border-radius:3px; }
    .talent-apply-btn {
        padding:9px 20px; border:none; border-radius:var(--radius-sm);
        background:var(--primary); color:#fff; font-size:13px; font-weight:700;
        cursor:pointer; transition:var(--transition); white-space:nowrap; width:100%;
    }
    .talent-apply-btn:hover { background:var(--primary-dark); }
    .talent-apply-btn:disabled { background:var(--border); color:var(--text-muted); cursor:not-allowed; }

    /* 사업자 재능나눔 배너 */
    .talent-biz-banner {
        background: linear-gradient(135deg, #1F8464 0%, #2BAB82 100%);
        border-radius:var(--radius-md); padding:24px 28px;
        display:flex; align-items:center; gap:20px;
        margin-bottom:28px; color:#fff;
    }
    .talent-biz-banner svg { width:40px; height:40px; stroke:#fff; fill:none; stroke-width:1.6; stroke-linecap:round; stroke-linejoin:round; flex-shrink:0; }
    .tbz-text h3 { font-size:17px; font-weight:800; margin:0 0 4px; }
    .tbz-text p  { font-size:13px; opacity:.85; margin:0; }
    .btn-biz-talent {
        margin-left:auto; padding:10px 22px; border:2px solid #fff;
        border-radius:50px; background:transparent; color:#fff;
        font-size:14px; font-weight:700; cursor:pointer; flex-shrink:0;
        transition:var(--transition); white-space:nowrap;
    }
    .btn-biz-talent:hover { background:#fff; color:var(--primary-dark); }
</style>

<div class="give-content">

    <%-- 사업자 재능나눔 유도 배너 --%>
    <div class="talent-biz-banner">
        <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
        <div class="tbz-text">
            <h3>사업자 파트너 재능나눔 참여</h3>
            <p>애견미용사·수의사·사진작가 등 전문 기술로 유기동물을 도와주세요.<br>사업자센터에서 재능나눔을 신청하고 브랜드 가치도 높여보세요!</p>
        </div>
        <button class="btn-biz-talent" onclick="location.href='${contextPath}/mypage/biz'">사업자센터에서 신청</button>
    </div>

    <div class="talent-toolbar">
        <div class="talent-filters">
            <span class="talent-chip on" onclick="selTalent(this)">전체</span>
            <span class="talent-chip" onclick="selTalent(this)">애견미용</span>
            <span class="talent-chip" onclick="selTalent(this)">무료 진료</span>
            <span class="talent-chip" onclick="selTalent(this)">사진 촬영</span>
            <span class="talent-chip" onclick="selTalent(this)">운송 도움</span>
            <span class="talent-chip" onclick="selTalent(this)">사진 촬영</span>
            <span class="talent-chip" onclick="selTalent(this)">교육</span>
        </div>
        
    </div>

    <div class="talent-list">
        <%-- 재능나눔 카드 1 — 애견미용 (사업자) --%>
        <div class="talent-card" onclick="location.href='${contextPath}/give/talent/detail?id=1'">
            <div class="talent-icon ti-grooming">
                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
            </div>
            <div class="talent-body">
                <div class="talent-tags">
                    <span class="talent-tag tt-grooming">애견미용</span>
                    <span class="talent-tag tt-new">사업자 제공</span>
                </div>
                <div class="talent-title">유기견 무료 미용 서비스 — 입양 전 그루밍</div>
                <div class="talent-desc">냥냥 그루밍샵에서 보호소 유기견에게 무료로 미용 서비스를 제공합니다. 깨끗하게 손질된 외모로 입양률을 높이는 데 기여해요. 매월 10마리 선착순 진행합니다.</div>
                <div class="talent-meta-row">
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>매월 마지막 일요일</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 강남구 청담동</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>소요시간 약 1~2시간</div>
                </div>
            </div>
            <div class="talent-right">
                <div class="talent-provider">
                    <div class="prov-name">냥냥 그루밍샵</div>
                    <div class="prov-type">애견미용실 · 사업자 파트너</div>
                </div>
                <div class="talent-progress">
                    <div class="talent-prog-label"><span>이번 달 신청</span><span>7 / 10마리</span></div>
                    <div class="talent-prog-bar"><div class="talent-prog-fill" style="width:70%"></div></div>
                </div>
                <button class="talent-apply-btn" onclick="event.stopPropagation();location.href='${contextPath}/give/talent/detail?id=1'">상세보기</button>
            </div>
        </div>

        <%-- 재능나눔 카드 2 — 무료 진료 (사업자) --%>
        <div class="talent-card" onclick="location.href='${contextPath}/give/talent/detail?id=2'">
            <div class="talent-icon ti-hospital">
                <svg viewBox="0 0 24 24"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
            </div>
            <div class="talent-body">
                <div class="talent-tags">
                    <span class="talent-tag tt-hospital">무료 진료</span>
                    <span class="talent-tag tt-new">사업자 제공</span>
                </div>
                <div class="talent-title">유기견 무료 건강검진 및 예방접종 캠페인</div>
                <div class="talent-desc">행복 동물병원 수의사가 보호소 유기견에게 무료 기본 건강검진과 예방접종을 제공합니다. 건강한 반려동물이 더 빠르게 새 가족을 만날 수 있도록 돕습니다.</div>
                <div class="talent-meta-row">
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>2025.07.20 (일) 10:00 ~ 16:00</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 마포구 합정동</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>마리당 30분 내외</div>
                </div>
            </div>
            <div class="talent-right">
                <div class="talent-provider">
                    <div class="prov-name">행복 동물병원</div>
                    <div class="prov-type">동물병원 · 사업자 파트너</div>
                </div>
                <div class="talent-progress">
                    <div class="talent-prog-label"><span>신청 현황</span><span>12 / 20마리</span></div>
                    <div class="talent-prog-bar"><div class="talent-prog-fill" style="width:60%"></div></div>
                </div>
                <button class="talent-apply-btn" onclick="event.stopPropagation();location.href='${contextPath}/give/talent/detail?id=2'">상세보기</button>
            </div>
        </div>

        <%-- 재능나눔 카드 3 — 사진 촬영 (일반 사용자) --%>
        <div class="talent-card" onclick="location.href='${contextPath}/give/talent/detail?id=3'">
            <div class="talent-icon ti-photo">
                <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="12" cy="10" r="3"/><path d="M8.5 21l7-9-7 9z"/></svg>
            </div>
            <div class="talent-body">
                <div class="talent-tags">
                    <span class="talent-tag tt-photo">사진 촬영</span>
                </div>
                <div class="talent-title">입양 홍보 사진 촬영 — 프로필 사진 제작 지원</div>
                <div class="talent-desc">사진 작가 지망생이 유기동물 보호소를 방문해 입양 홍보용 프로필 사진을 촬영해드립니다. 예쁜 사진 한 장이 동물의 삶을 바꿀 수 있어요.</div>
                <div class="talent-meta-row">
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>협의 후 방문 일정 조율</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 전 지역 보호소</div>
                </div>
            </div>
            <div class="talent-right">
                <div class="talent-provider">
                    <div class="prov-name">박사진작가</div>
                    <div class="prov-type">일반 회원 · 재능나눔</div>
                </div>
                <div class="talent-progress">
                    <div class="talent-prog-label"><span>총 진행</span><span>3회 완료</span></div>
                    <div class="talent-prog-bar"><div class="talent-prog-fill" style="width:30%"></div></div>
                </div>
                <button class="talent-apply-btn" onclick="event.stopPropagation();location.href='${contextPath}/give/talent/detail?id=3'">상세보기</button>
            </div>
        </div>

        <%-- 재능나눔 카드 4 — 운송 --%>
        <div class="talent-card" onclick="location.href='${contextPath}/give/talent/detail?id=4'">
            <div class="talent-icon ti-transport">
                <svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
            </div>
            <div class="talent-body">
                <div class="talent-tags">
                    <span class="talent-tag tt-transport">운송 도움</span>
                </div>
                <div class="talent-title">유기동물 입양 차량 지원 — 보호소 → 새 집</div>
                <div class="talent-desc">차량이 없어 입양을 망설이는 분들을 위해 보호소에서 새 집까지 이동을 도와드립니다. 서울·경기 지역 차량 운전 가능하신 분의 봉사 신청을 기다립니다.</div>
                <div class="talent-meta-row">
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>수시 (요청 시 협의)</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울·경기 지역</div>
                </div>
            </div>
            <div class="talent-right">
                <div class="talent-provider">
                    <div class="prov-name">김자원봉사</div>
                    <div class="prov-type">일반 회원 · 재능나눔</div>
                </div>
                <div class="talent-progress">
                    <div class="talent-prog-label"><span>총 진행</span><span>8회 완료</span></div>
                    <div class="talent-prog-bar"><div class="talent-prog-fill" style="width:80%"></div></div>
                </div>
                <button class="talent-apply-btn" onclick="event.stopPropagation();location.href='${contextPath}/give/talent/detail?id=4'">상세보기</button>
            </div>
        </div>

        <%-- 재능나눔 카드 5 — 사진 촬영 (사업자 사진관) --%>
        <div class="talent-card" onclick="location.href='${contextPath}/give/talent/detail?id=5'">
            <div class="talent-icon" style="background:#F3E8FF">
                <svg viewBox="0 0 24 24" fill="none" stroke="#9333EA" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
            </div>
            <div class="talent-body">
                <div class="talent-tags">
                    <span class="talent-tag" style="background:#F3E8FF;color:#9333EA">사진 촬영</span>
                    <span class="talent-tag tt-new">사업자 제공</span>
                </div>
                <div class="talent-title">유기동물 입양 홍보 프로필 사진 촬영 — 보호소 출장 지원</div>
                <div class="talent-desc">냥냥 사진관에서 보호소를 직접 방문해 유기동물 입양 홍보용 프로필 사진을 무료로 촬영해 드립니다. 예쁜 사진 한 장이 입양률을 높일 수 있어요.</div>
                <div class="talent-meta-row">
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>매월 둘째 주 토요일</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 전 지역 보호소 방문</div>
                    <div class="talent-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>마리당 20~30분</div>
                </div>
            </div>
            <div class="talent-right">
                <div class="talent-provider">
                    <div class="prov-name">냥냥 사진관</div>
                    <div class="prov-type">애완동물 사진관 · 사업자 파트너</div>
                </div>
                <div class="talent-progress">
                    <div class="talent-prog-label"><span>이번 달 신청</span><span>3 / 5마리</span></div>
                    <div class="talent-prog-bar"><div class="talent-prog-fill" style="width:60%"></div></div>
                </div>
                <button class="talent-apply-btn" onclick="event.stopPropagation();location.href='${contextPath}/give/talent/detail?id=5'">상세보기</button>
            </div>
        </div>

    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
function selTalent(el) {
    document.querySelectorAll('.talent-chip').forEach(c => c.classList.remove('on'));
    el.classList.add('on');
}
</script>
