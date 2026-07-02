<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="biz-talent" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
/* ── 탭 ── */
.talent-tab-bar { display:flex; gap:0; border-bottom:2px solid #E4E6ED; margin-bottom:20px; }
.talent-tab {
    padding:10px 22px; font-size:14px; font-weight:600;
    color:#999; border:none; background:none; cursor:pointer;
    border-bottom:2px solid transparent; margin-bottom:-2px; transition:all .15s;
}
.talent-tab.on { color:#3B5BDB; border-bottom-color:#3B5BDB; }

/* ── 신청 카드 ── */
.ta-card {
    background:#fff; border:1px solid #E4E6ED;
    border-radius:12px; overflow:hidden;
    margin-bottom:16px; transition:box-shadow .2s;
}
.ta-card:hover { box-shadow:0 4px 16px rgba(0,0,0,.07); }
.ta-head {
    display:flex; align-items:center; gap:14px;
    padding:16px 20px; border-bottom:1px solid #E4E6ED; background:#FAFBFC;
}
.ta-biz-icon {
    width:44px; height:44px; border-radius:10px;
    display:flex; align-items:center; justify-content:center; flex-shrink:0;
}
.ta-biz-icon svg { width:22px; height:22px; fill:none; stroke-width:1.8; stroke-linecap:round; stroke-linejoin:round; }
.ta-biz-name  { font-size:15px; font-weight:800; color:#1A1A2E; }
.ta-biz-type  { font-size:12px; color:#999; margin-top:2px; }
.ta-date      { margin-left:auto; font-size:12px; color:#999; flex-shrink:0; }

.ta-body {
    display:grid; grid-template-columns:repeat(4,1fr);
    border-bottom:1px solid #E4E6ED;
}
.ta-field { padding:14px 18px; border-right:1px solid #E4E6ED; }
.ta-field:last-child { border-right:none; }
.ta-field label { font-size:11px; color:#999; font-weight:600; display:block; margin-bottom:4px; }
.ta-field span  { font-size:13px; color:#1A1A2E; font-weight:500; }

.ta-desc {
    padding:14px 18px; border-bottom:1px solid #E4E6ED;
    font-size:13px; color:#555; line-height:1.7;
    border-left:3px solid #3B5BDB; margin:0 18px 0;
    background:#F8F9FF; border-radius:0 6px 6px 0;
    margin:12px 18px; border-left:3px solid #3B5BDB;
    padding:12px 14px;
}

.ta-foot {
    display:flex; justify-content:space-between; align-items:center;
    padding:12px 18px;
}
.ta-reject-wrap { display:flex; gap:8px; align-items:center; }
.ta-reject-input {
    border:1px solid #E4E6ED; border-radius:6px;
    padding:7px 12px; font-size:13px; color:#333;
    outline:none; width:260px; display:none; font-family:inherit;
}
.ta-reject-input:focus { border-color:#3B5BDB; }
.ta-action-btns { display:flex; gap:8px; }
</style>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">재능나눔 승인 관리</h1>
            <p class="adm-page-desc">사업자가 신청한 재능나눔을 검토하고 승인하면 나눔 탭에 게시됩니다.</p>
        </div>
    </div>

    <%-- 플로우 안내 --%>
    <div style="display:flex;align-items:center;gap:0;margin-bottom:24px;background:#fff;border:1px solid #E4E6ED;border-radius:12px;overflow:hidden">
        <div style="flex:1;padding:16px 20px;text-align:center;border-right:1px solid #E4E6ED">
            <div style="font-size:12px;color:#999;margin-bottom:4px">STEP 1</div>
            <div style="font-size:14px;font-weight:700;color:#1A1A2E">사업자 신청</div>
            <div style="font-size:12px;color:#999;margin-top:2px">사업자센터에서 신청서 작성</div>
        </div>
        <div style="color:#C7D2FE;font-size:20px;padding:0 4px">›</div>
        <div style="flex:1;padding:16px 20px;text-align:center;border-right:1px solid #E4E6ED;background:#EEF2FF">
            <div style="font-size:12px;color:#3B5BDB;margin-bottom:4px;font-weight:700">STEP 2 (현재)</div>
            <div style="font-size:14px;font-weight:800;color:#3B5BDB">관리자 승인</div>
            <div style="font-size:12px;color:#3B5BDB;margin-top:2px">내용 검토 후 승인·반려</div>
        </div>
        <div style="color:#C7D2FE;font-size:20px;padding:0 4px">›</div>
        <div style="flex:1;padding:16px 20px;text-align:center">
            <div style="font-size:12px;color:#999;margin-bottom:4px">STEP 3</div>
            <div style="font-size:14px;font-weight:700;color:#1A1A2E">나눔 탭 게시</div>
            <div style="font-size:12px;color:#999;margin-top:2px">/give?tab=talent 자동 노출</div>
        </div>
    </div>

    <%-- 탭 --%>
    <div class="talent-tab-bar">
        <button class="talent-tab on" onclick="selTab(this,'wait')">
            승인 대기 <span style="background:#EEF2FF;color:#3B5BDB;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">3</span>
        </button>
        <button class="talent-tab" onclick="selTab(this,'active')">게시 중 <span style="background:#DCFCE7;color:#16A34A;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">8</span></button>
        <button class="talent-tab" onclick="selTab(this,'rejected')">반려 <span style="background:#F1F3F7;color:#999;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">2</span></button>
    </div>

    <%-- 승인 대기 목록 --%>
    <div id="tab-wait">

        <%-- 신청 1 — 애견미용 --%>
        <div class="ta-card">
            <div class="ta-head">
                <div class="ta-biz-icon" style="background:#FDF2F8">
                    <svg viewBox="0 0 24 24" stroke="#DB2777"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
                </div>
                <div>
                    <div class="ta-biz-name">냥냥 그루밍샵</div>
                    <div class="ta-biz-type">애견미용실 · 서울 강남구 청담동</div>
                </div>
                <span class="adm-badge wait" style="margin-left:12px">승인 대기</span>
                <span class="ta-date">신청일: 2025.06.25</span>
            </div>
            <div class="ta-body">
                <div class="ta-field"><label>나눔 유형</label><span>애견 미용</span></div>
                <div class="ta-field"><label>제목</label><span>유기견 무료 미용 서비스</span></div>
                <div class="ta-field"><label>진행 일정</label><span>매월 마지막 일요일</span></div>
                <div class="ta-field"><label>모집 수량</label><span>월 10마리</span></div>
            </div>
            <div class="ta-desc">
                보호소 유기견에게 무료 미용 서비스(컷, 드라이, 발톱 정리, 귀 청소)를 제공합니다. 예쁜 모습으로 입양 확률을 높이는 데 기여하고자 합니다. 매월 마지막 일요일, 선착순 10마리 진행 예정입니다.
            </div>
            <div class="ta-foot">
                <div style="font-size:13px;color:#555">
                    제공 장소: 냥냥 그루밍샵 (강남구 청담동) &nbsp;·&nbsp; 문의: 02-1234-5678
                </div>
                <div class="ta-reject-wrap">
                    <input type="text" class="ta-reject-input" id="rej1" placeholder="반려 사유 입력">
                    <div class="ta-action-btns">
                        <button class="adm-btn gray" onclick="toggleReject('rej1')">반려</button>
                        <button class="adm-btn green" onclick="approve('냥냥 그루밍샵')">승인 → 나눔 탭 게시</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 신청 2 — 무료 진료 --%>
        <div class="ta-card">
            <div class="ta-head">
                <div class="ta-biz-icon" style="background:#E0F2FE">
                    <svg viewBox="0 0 24 24" stroke="#0284C7"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                </div>
                <div>
                    <div class="ta-biz-name">행복 동물병원</div>
                    <div class="ta-biz-type">동물병원 · 서울 마포구 합정동</div>
                </div>
                <span class="adm-badge wait" style="margin-left:12px">승인 대기</span>
                <span class="ta-date">신청일: 2025.06.24</span>
            </div>
            <div class="ta-body">
                <div class="ta-field"><label>나눔 유형</label><span>무료 진료</span></div>
                <div class="ta-field"><label>제목</label><span>유기견 무료 건강검진 캠페인</span></div>
                <div class="ta-field"><label>진행 일정</label><span>2025.07.20 (일)</span></div>
                <div class="ta-field"><label>모집 수량</label><span>20마리</span></div>
            </div>
            <div class="ta-desc">
                유기견 기본 건강검진(청진, 혈액검사)과 예방접종(DHPPL, 광견병)을 무료로 제공합니다. 건강한 동물이 더 빠르게 새 가족을 만날 수 있도록 돕습니다.
            </div>
            <div class="ta-foot">
                <div style="font-size:13px;color:#555">
                    제공 장소: 행복 동물병원 (마포구 합정동) &nbsp;·&nbsp; 문의: 02-5678-1234
                </div>
                <div class="ta-reject-wrap">
                    <input type="text" class="ta-reject-input" id="rej2" placeholder="반려 사유 입력">
                    <div class="ta-action-btns">
                        <button class="adm-btn gray" onclick="toggleReject('rej2')">반려</button>
                        <button class="adm-btn green" onclick="approve('행복 동물병원')">승인 → 나눔 탭 게시</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 신청 3 — 사진 촬영 --%>
        <div class="ta-card">
            <div class="ta-head">
                <div class="ta-biz-icon" style="background:#F3E8FF">
                    <svg viewBox="0 0 24 24" stroke="#9333EA"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </div>
                <div>
                    <div class="ta-biz-name">냥냥 사진관</div>
                    <div class="ta-biz-type">애완동물 사진관 · 서울 서초구</div>
                </div>
                <span class="adm-badge wait" style="margin-left:12px">승인 대기</span>
                <span class="ta-date">신청일: 2025.06.23</span>
            </div>
            <div class="ta-body">
                <div class="ta-field"><label>나눔 유형</label><span>사진 촬영</span></div>
                <div class="ta-field"><label>제목</label><span>입양 홍보 사진 무료 촬영</span></div>
                <div class="ta-field"><label>진행 일정</label><span>매월 둘째 주 토요일</span></div>
                <div class="ta-field"><label>모집 수량</label><span>월 5마리</span></div>
            </div>
            <div class="ta-desc">
                보호소를 직접 방문해 유기동물 입양 홍보용 프로필 사진을 무료로 촬영합니다. 마리당 20~30분 소요되며, 디지털 파일로 제공합니다.
            </div>
            <div class="ta-foot">
                <div style="font-size:13px;color:#555">
                    제공 장소: 서울 전 지역 보호소 방문 &nbsp;·&nbsp; 문의: 010-1234-5678
                </div>
                <div class="ta-reject-wrap">
                    <input type="text" class="ta-reject-input" id="rej3" placeholder="반려 사유 입력">
                    <div class="ta-action-btns">
                        <button class="adm-btn gray" onclick="toggleReject('rej3')">반려</button>
                        <button class="adm-btn green" onclick="approve('냥냥 사진관')">승인 → 나눔 탭 게시</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- 게시 중 --%>
    <div id="tab-active" style="display:none">
        <table class="adm-table">
            <thead><tr><th>업체명</th><th>유형</th><th>제목</th><th>진행 수량</th><th>게시일</th><th>상태</th><th>처리</th></tr></thead>
            <tbody>
                <tr>
                    <td>냥냥 그루밍샵</td><td>애견 미용</td>
                    <td>유기견 무료 미용 서비스</td>
                    <td>7 / 10마리</td><td>2025.05.01</td>
                    <td><span class="adm-badge active">게시 중</span></td>
                    <td>
                        <button class="adm-btn red" onclick="if(confirm('게시를 중단하시겠습니까?'))alert('게시 중단되었습니다.')">게시 중단</button>
                    </td>
                </tr>
                <tr>
                    <td>행복 동물병원</td><td>무료 진료</td>
                    <td>유기견 무료 건강검진 캠페인</td>
                    <td>12 / 20마리</td><td>2025.05.15</td>
                    <td><span class="adm-badge active">게시 중</span></td>
                    <td>
                        <button class="adm-btn red" onclick="if(confirm('게시를 중단하시겠습니까?'))alert('게시 중단되었습니다.')">게시 중단</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <%-- 반려 --%>
    <div id="tab-rejected" style="display:none">
        <table class="adm-table">
            <thead><tr><th>업체명</th><th>유형</th><th>제목</th><th>반려 사유</th><th>반려일</th></tr></thead>
            <tbody>
                <tr>
                    <td>펫케어 미용샵</td><td>애견 미용</td>
                    <td>무료 미용 봉사</td>
                    <td>서비스 내용이 구체적이지 않음</td>
                    <td>2025.06.10</td>
                </tr>
            </tbody>
        </table>
    </div>
</main>

<script>
function selTab(btn, id) {
    document.querySelectorAll('.talent-tab').forEach(t => t.classList.remove('on'));
    btn.classList.add('on');
    ['wait','active','rejected'].forEach(t => {
        document.getElementById('tab-' + t).style.display = t === id ? 'block' : 'none';
    });
}
function toggleReject(id) {
    var el = document.getElementById(id);
    el.style.display = el.style.display === 'none' ? 'block' : 'none';
}
function approve(name) {
    if(confirm(name + '의 재능나눔을 승인하시겠습니까?\n승인 즉시 /give?tab=talent 에 게시됩니다.')) {
        alert('승인 완료!\n' + name + ' 재능나눔이 나눔 탭에 게시되었습니다.\n사업자에게 이메일 알림이 발송됩니다.');
    }
}
</script>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
