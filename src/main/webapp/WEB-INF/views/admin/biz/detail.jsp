<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="biz-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
.biz-detail-grid { display:grid; grid-template-columns:1fr 300px; gap:20px; align-items:flex-start; }
.bds { background:#fff; border:1px solid #E4E6ED; border-radius:12px; padding:22px; margin-bottom:20px; }
.bds-title {
    font-size:14px; font-weight:800; color:#1A1A2E;
    margin:0 0 16px; padding-bottom:12px; border-bottom:1px solid #E4E6ED;
    display:flex; align-items:center; gap:8px;
}
.bds-title svg { width:16px; height:16px; stroke:#3B5BDB; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
.bds-row { display:flex; justify-content:space-between; align-items:flex-start; padding:10px 0; border-bottom:1px solid #F5F5F5; font-size:14px; }
.bds-row:last-child { border-bottom:none; }
.bds-row label { color:#999; font-size:13px; flex-shrink:0; min-width:120px; }
.bds-row span  { color:#1A1A2E; font-weight:600; text-align:right; word-break:break-all; }

/* 업종 아이콘 */
.biz-type-icon {
    width:52px; height:52px; border-radius:12px;
    display:flex; align-items:center; justify-content:center; flex-shrink:0;
    background:#E0F2FE;
}
.biz-type-icon svg { width:26px; height:26px; stroke:#0284C7; fill:none; stroke-width:1.8; stroke-linecap:round; stroke-linejoin:round; }

/* 서류 뷰어 */
.doc-viewer {
    border:1px solid #E4E6ED; border-radius:8px; overflow:hidden;
    margin-bottom:12px;
}
.doc-viewer-head {
    display:flex; justify-content:space-between; align-items:center;
    padding:10px 14px; background:#FAFBFC; border-bottom:1px solid #E4E6ED;
    font-size:13px; font-weight:700; color:#1A1A2E;
}
.doc-viewer img { width:100%; display:block; max-height:220px; object-fit:cover; cursor:zoom-in; }
.doc-viewer-foot { padding:8px 14px; font-size:12px; color:#999; display:flex; justify-content:space-between; }

/* 승인 카드 */
.approve-card { background:#fff; border:1px solid #E4E6ED; border-radius:12px; padding:22px; position:sticky; top:20px; }
.approve-card h3 { font-size:15px; font-weight:800; color:#1A1A2E; margin:0 0 18px; padding-bottom:12px; border-bottom:1px solid #E4E6ED; }
.approve-status-box { background:#FFF8E1; border:1px solid #FDE68A; border-radius:8px; padding:14px; margin-bottom:18px; display:flex; align-items:center; gap:10px; }
.approve-status-box svg { width:20px; height:20px; stroke:#F59E0B; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; flex-shrink:0; }
.approve-status-box span { font-size:13px; color:#92400E; font-weight:600; }
.approve-checklist { display:flex; flex-direction:column; gap:8px; margin-bottom:18px; }
.approve-check { display:flex; align-items:center; gap:8px; font-size:13px; color:#555; cursor:pointer; }
.approve-check input[type=checkbox] { width:15px; height:15px; accent-color:#3B5BDB; flex-shrink:0; }
.approve-reject-area { margin-bottom:14px; }
.approve-reject-area label { font-size:13px; font-weight:600; color:#555; display:block; margin-bottom:6px; }
.approve-reject-area textarea {
    width:100%; border:1px solid #E4E6ED; border-radius:8px;
    padding:10px 12px; font-size:13px; color:#1A1A2E;
    outline:none; resize:vertical; min-height:80px; font-family:inherit;
    box-sizing:border-box; line-height:1.6;
}
.approve-reject-area textarea:focus { border-color:#3B5BDB; }
.approve-btn-row { display:flex; flex-direction:column; gap:8px; }
.btn-approve {
    width:100%; padding:13px; border:none; border-radius:8px;
    background:#16A34A; color:#fff; font-size:15px; font-weight:800;
    cursor:pointer; transition:background .15s; display:flex; align-items:center; justify-content:center; gap:8px;
}
.btn-approve:hover { background:#15803D; }
.btn-approve svg { width:16px; height:16px; stroke:#fff; fill:none; stroke-width:2.5; stroke-linecap:round; stroke-linejoin:round; }
.btn-reject {
    width:100%; padding:13px; border:2px solid #DC2626; border-radius:8px;
    background:#fff; color:#DC2626; font-size:15px; font-weight:800;
    cursor:pointer; transition:all .15s; display:flex; align-items:center; justify-content:center; gap:8px;
}
.btn-reject:hover { background:#DC2626; color:#fff; }
.btn-reject svg { width:16px; height:16px; stroke:currentColor; fill:none; stroke-width:2.5; stroke-linecap:round; stroke-linejoin:round; }
</style>

<main class="adm-main">

    <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:#999;margin-bottom:20px">
        <a href="${contextPath}/admin/biz/list" style="color:#999;text-decoration:none">사업자 승인 관리</a>
        <span>›</span>
        <span style="color:#1A1A2E;font-weight:600">행복 동물병원 상세</span>
    </div>

    <%-- 상단 헤더 --%>
    <div style="display:flex;align-items:center;gap:16px;margin-bottom:24px">
        <div class="biz-type-icon">
            <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><rect x="9" y="10" width="6" height="11" rx="1"/><line x1="12" y1="13" x2="12" y2="17"/><line x1="10" y1="15" x2="14" y2="15"/></svg>
        </div>
        <div>
            <h1 style="font-size:22px;font-weight:800;color:#1A1A2E;margin:0 0 4px">행복 동물병원</h1>
            <div style="display:flex;gap:8px;align-items:center">
                <span class="adm-badge" style="background:#E0F2FE;color:#0284C7">동물병원</span>
                <span class="adm-badge wait">승인 대기</span>
                <span style="font-size:12px;color:#999">신청일: 2025.06.25 14:32</span>
            </div>
        </div>
    </div>

    <div class="biz-detail-grid">
        <div>
            <%-- 사업자 기본 정보 --%>
            <div class="bds">
                <div class="bds-title">
                    <svg viewBox="0 0 24 24"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"/></svg>
                    사업자 기본 정보
                </div>
                <div class="bds-row"><label>업체명</label><span>행복 동물병원</span></div>
                <div class="bds-row"><label>업종</label><span>동물병원</span></div>
                <div class="bds-row"><label>사업자 등록번호</label><span style="display:flex;align-items:center;gap:8px">123-45-67890 <span class="adm-badge active" style="font-size:11px">국세청 인증 완료</span></span></div>
                <div class="bds-row"><label>대표자명</label><span>김철수</span></div>
                <div class="bds-row"><label>사업장 전화번호</label><span>02-1234-5678</span></div>
                <div class="bds-row"><label>사업장 주소</label><span>서울특별시 마포구 합정동 123-4 (우: 04001)</span></div>
                <div class="bds-row"><label>업체 소개</label><span style="text-align:left;line-height:1.6;font-weight:400">반려동물 전문 동물병원으로 내과, 외과, 피부과, 안과 진료를 제공합니다. 2010년 개원 이래 15년간 지역 반려동물 의료를 담당해왔습니다.</span></div>
            </div>

            <%-- 담당자 정보 --%>
            <div class="bds">
                <div class="bds-title">
                    <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    담당자 정보
                </div>
                <div class="bds-row"><label>담당자 이름</label><span>김철수</span></div>
                <div class="bds-row"><label>담당자 연락처</label><span style="display:flex;align-items:center;gap:8px">010-1234-5678 <span class="adm-badge active" style="font-size:11px">인증 완료</span></span></div>
                <div class="bds-row"><label>담당자 이메일</label><span>happy@hospital.com</span></div>
                <div class="bds-row"><label>PetCare 계정</label><span>minjun@email.com (회원 #12847)</span></div>
            </div>

            <%-- 제출 서류 --%>
            <div class="bds">
                <div class="bds-title">
                    <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                    제출 서류
                </div>

                <div class="doc-viewer">
                    <div class="doc-viewer-head">
                        사업자등록증
                        <div style="display:flex;gap:6px">
                            <button class="adm-btn blue" onclick="alert('새 창에서 원본 파일을 확인합니다.')">원본 보기</button>
                            <button class="adm-btn gray">다운로드</button>
                        </div>
                    </div>
                    <img src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=600&q=70&auto=format&fit=crop"
                         alt="사업자등록증"
                         onerror="this.src='https://placehold.co/600x220/EEF2FF/3B5BDB?text=사업자등록증+미리보기'">
                    <div class="doc-viewer-foot">
                        <span>파일명: business_license_행복동물병원.pdf</span>
                        <span>2.4 MB · 2025.06.25 업로드</span>
                    </div>
                </div>

                <div class="doc-viewer">
                    <div class="doc-viewer-head">
                        영업신고증 (동물병원 개설 신고증)
                        <div style="display:flex;gap:6px">
                            <button class="adm-btn blue" onclick="alert('새 창에서 원본 파일을 확인합니다.')">원본 보기</button>
                            <button class="adm-btn gray">다운로드</button>
                        </div>
                    </div>
                    <img src="https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=600&q=70&auto=format&fit=crop"
                         alt="영업신고증"
                         onerror="this.src='https://placehold.co/600x220/EEF2FF/3B5BDB?text=영업신고증+미리보기'">
                    <div class="doc-viewer-foot">
                        <span>파일명: vet_license_행복동물병원.pdf</span>
                        <span>1.8 MB · 2025.06.25 업로드</span>
                    </div>
                </div>
            </div>

            <%-- 약관 동의 내역 --%>
            <div class="bds">
                <div class="bds-title">
                    <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/></svg>
                    약관 동의 내역
                </div>
                <div class="bds-row"><label>[필수] 파트너 서비스 이용약관</label><span style="color:#16A34A">동의 · 2025.06.25</span></div>
                <div class="bds-row"><label>[필수] 개인정보 수집·이용 동의</label><span style="color:#16A34A">동의 · 2025.06.25</span></div>
                <div class="bds-row"><label>[선택] 마케팅 정보 수신 동의</label><span style="color:#3B5BDB">동의 · 2025.06.25</span></div>
            </div>
        </div>

        <%-- 사이드: 승인 처리 --%>
        <div>
            <div class="approve-card">
                <h3>승인 처리</h3>
                <div class="approve-status-box">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    <span>관리자 검토 대기 중</span>
                </div>

                <p style="font-size:13px;font-weight:700;color:#1A1A2E;margin:0 0 10px">검토 체크리스트</p>
                <div class="approve-checklist">
                    <label class="approve-check"><input type="checkbox">사업자등록번호 국세청 인증 확인</label>
                    <label class="approve-check"><input type="checkbox">사업자등록증 서류 일치 여부</label>
                    <label class="approve-check"><input type="checkbox">영업신고증 / 허가증 유효성 확인</label>
                    <label class="approve-check"><input type="checkbox">담당자 연락처 인증 확인</label>
                    <label class="approve-check"><input type="checkbox">중복 신청 여부 확인</label>
                </div>

                <div class="approve-reject-area">
                    <label>반려 사유 (반려 시 필수 입력)</label>
                    <textarea placeholder="반려 사유를 입력하면 신청자에게 이메일로 발송됩니다."></textarea>
                </div>

                <div class="approve-btn-row">
                    <button class="btn-approve"
                            onclick="if(confirm('행복 동물병원을 승인하시겠습니까?\n\n승인 시:\n· 사업자 권한(ROLE_BUSINESS) 부여\n· 승인 완료 이메일 자동 발송\n· 플랫폼에 병원 정보 노출'))alert('승인 완료!\n행복 동물병원에 이메일이 발송되었습니다.')">
                        <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                        승인하기
                    </button>
                    <button class="btn-reject"
                            onclick="if(confirm('반려 처리하시겠습니까?\n반려 사유가 신청자에게 이메일로 발송됩니다.'))alert('반려 처리되었습니다.\n신청자에게 이메일이 발송되었습니다.')">
                        <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        반려하기
                    </button>
                    <button class="adm-btn gray" style="width:100%;padding:11px;font-size:14px" onclick="location.href='${contextPath}/admin/biz/list'">목록으로</button>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
