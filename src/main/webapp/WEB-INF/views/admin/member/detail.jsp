<%--
  - 박유정 / 2026-07-16
  - GET /admin/member/detail?id= → ${member}
  - 오늘: 프로필·기본정보만 DB 연동 (활동현황 등은 내일)
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="member-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
/* ── 회원 상세 전용 ── */
.mem-profile-card {
    background:#fff; border:1px solid #E4E6ED; border-radius:12px;
    padding:28px; display:flex; gap:24px; align-items:flex-start;
    margin-bottom:20px;
}
.mem-avatar {
    width:88px; height:88px; border-radius:50%;
    object-fit:cover; border:3px solid #E4E6ED; flex-shrink:0;
}
.mem-profile-info { flex:1; }
.mem-name   { font-size:22px; font-weight:800; color:#1A1A2E; margin-bottom:6px; }
.mem-email  { font-size:14px; color:#999; margin-bottom:12px; }
.mem-badges { display:flex; gap:8px; flex-wrap:wrap; }
.mem-badge  { font-size:12px; font-weight:700; padding:4px 12px; border-radius:20px; }
.mb-role-user  { background:#EEF2FF; color:#3B5BDB; }
.mb-role-biz   { background:#EAF7F2; color:#1F8464; }
.mb-role-admin { background:#FEE2E2; color:#DC2626; }
.mb-active  { background:#DCFCE7; color:#16A34A; }
.mb-banned  { background:#FEE2E2; color:#DC2626; }
.mem-profile-actions { display:flex; flex-direction:column; gap:8px; flex-shrink:0; }

/* 섹션 그리드 */
.mem-detail-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:20px; }
.mem-info-section { background:#fff; border:1px solid #E4E6ED; border-radius:12px; padding:22px; }
.mem-info-section.full { grid-column:1/-1; }
.mis-title {
    font-size:14px; font-weight:800; color:#1A1A2E;
    margin:0 0 16px; padding-bottom:12px;
    border-bottom:1px solid #E4E6ED;
    display:flex; align-items:center; gap:8px;
}
.mis-title svg { width:16px; height:16px; stroke:#3B5BDB; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
.mis-row { display:flex; justify-content:space-between; align-items:center; padding:9px 0; border-bottom:1px solid #F5F5F5; font-size:14px; }
.mis-row:last-child { border-bottom:none; }
.mis-row label { color:#999; font-size:13px; }
.mis-row span  { color:#1A1A2E; font-weight:600; }

/* 포인트 관리 */
.point-summary-row { display:grid; grid-template-columns:repeat(3,1fr); gap:12px; margin-bottom:18px; }
.point-box { background:#F8F9FF; border:1px solid #E4E6ED; border-radius:8px; padding:16px; text-align:center; }
.point-box .pb-label { font-size:12px; color:#999; margin-bottom:6px; }
.point-box .pb-val   { font-size:20px; font-weight:800; color:#3B5BDB; }
.point-box .pb-unit  { font-size:12px; color:#888; }
.point-input-row { display:flex; gap:10px; align-items:flex-end; margin-bottom:14px; }
.point-input-group { display:flex; flex-direction:column; gap:5px; flex:1; }
.point-input-group label { font-size:12px; font-weight:600; color:#555; }
.point-input-group select,
.point-input-group input {
    border:1px solid #E4E6ED; border-radius:8px;
    padding:9px 12px; font-size:14px; color:#1A1A2E;
    outline:none; font-family:inherit;
}
.point-input-group select:focus,
.point-input-group input:focus { border-color:#3B5BDB; }
.point-input-group input { width:100%; box-sizing:border-box; }
.btn-point-apply {
    padding:9px 20px; border:none; border-radius:8px;
    background:#3B5BDB; color:#fff;
    font-size:13px; font-weight:700; cursor:pointer;
    white-space:nowrap; flex-shrink:0;
    transition:background .15s;
}
.btn-point-apply:hover { background:#2F4AC7; }
.point-history { border:1px solid #E4E6ED; border-radius:8px; overflow:hidden; }

/* 등급 변경 셀렉트 */
.grade-select-row { display:flex; gap:10px; align-items:center; }
.grade-select-row select {
    flex:1; border:1px solid #E4E6ED; border-radius:8px;
    padding:9px 12px; font-size:14px; color:#1A1A2E; outline:none;
}
.grade-select-row select:focus { border-color:#3B5BDB; }

/* 위험 영역 */
.danger-zone { border:1px solid #FCA5A5; border-radius:8px; padding:18px; background:#FFF5F5; }
.danger-zone p { font-size:13px; color:#DC2626; margin:0 0 12px; line-height:1.6; }
.danger-btns { display:flex; gap:10px; }
</style>

<main class="adm-main">
    <%-- 상단 breadcrumb --%>
    <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:#999;margin-bottom:20px">
        <a href="${contextPath}/admin/member/list" style="color:#999;text-decoration:none">회원 관리</a>
        <span>›</span>
        <span style="color:#1A1A2E;font-weight:600">회원 상세</span>
    </div>

    <%-- 프로필 카드 --%>
    <div class="mem-profile-card">
        <img class="mem-avatar"
             src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=176&q=80&auto=format&fit=crop"
             alt="프로필"
             onerror="this.src='https://placehold.co/88x88/EEF2FF/3B5BDB?text=U'">
                <div class="mem-profile-info">
            <div class="mem-name">${member.memberName}</div>
            <div class="mem-email">${member.email}</div>
            <div class="mem-badges">
                <c:choose>
                    <c:when test="${member.roleType eq 'BIZ'}">
                        <span class="mem-badge mb-role-biz">사업자</span>
                    </c:when>
                    <c:otherwise>
                        <span class="mem-badge mb-role-user">일반회원</span>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${member.statusCd eq 'NORMAL'}">
                        <span class="mem-badge mb-active">활성</span>
                    </c:when>
                    <c:when test="${member.statusCd eq 'SUSPENDED'}">
                        <span class="mem-badge mb-banned">정지</span>
                    </c:when>
                    <c:when test="${member.statusCd eq 'WITHDRAWN'}">
                        <span class="mem-badge" style="background:#F3F4F6;color:#666">탈퇴</span>
                    </c:when>
                    <c:otherwise>
                        <span class="mem-badge">${member.statusCd}</span>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${member.gradeCd eq 'GOLD'}">
                        <span class="mem-badge" style="background:#FFF8E1;color:#F59E0B">골드 등급</span>
                    </c:when>
                    <c:when test="${member.gradeCd eq 'SILVER'}">
                        <span class="mem-badge" style="background:#F3F4F6;color:#666">실버 등급</span>
                    </c:when>
                    <c:otherwise>
                        <span class="mem-badge" style="background:#FFF7ED;color:#C2410C">브론즈 등급</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="mem-profile-actions">
            <a href="${contextPath}/admin/member/list" class="adm-btn gray" style="text-decoration:none;display:inline-flex;align-items:center;gap:6px">
                <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
                목록으로
            </a>
        </div>
    </div>

    <div class="mem-detail-grid">

        <%-- 기본 정보 — 2026-07-16 박유정 DB 연동 --%>
        <div class="mem-info-section">
            <div class="mis-title">
                <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                기본 정보
            </div>
            <div class="mis-row"><label>회원 ID</label><span>#${member.memberNo}</span></div>
            <div class="mis-row"><label>이름</label><span>${member.memberName}</span></div>
            <div class="mis-row"><label>이메일</label><span>${member.email}</span></div>
            <div class="mis-row"><label>전화번호</label><span>${member.phone}</span></div>
            <div class="mis-row"><label>생년월일</label><span>—</span></div>
            <div class="mis-row"><label>성별</label><span>—</span></div>
            <div class="mis-row"><label>주소</label>
                <span>
                    <c:if test="${not empty member.zipCode}">(${member.zipCode}) </c:if>
                    ${member.addr1} ${member.addr2}
                </span>
            </div>
            <div class="mis-row"><label>가입일</label>
                <span>
                    <c:if test="${not empty member.joinDate}">
                        ${member.joinDate.year}.${member.joinDate.monthValue}.${member.joinDate.dayOfMonth}
                    </c:if>
                </span>
            </div>
            <div class="mis-row"><label>최근 로그인</label>
                <span>
                    <c:if test="${not empty member.lastLoginDate}">
                        ${member.lastLoginDate.year}.${member.lastLoginDate.monthValue}.${member.lastLoginDate.dayOfMonth}
                        ${member.lastLoginDate.hour}:
                        <c:if test="${member.lastLoginDate.minute < 10}">0</c:if>${member.lastLoginDate.minute}
                    </c:if>
                    <c:if test="${empty member.lastLoginDate}">—</c:if>
                </span>
            </div>
            <div class="mis-row"><label>가입 경로</label><span>—</span></div>
        </div>

        <%-- 활동 현황 (내일 DB 연동) --%>
        <div class="mem-info-section">
            <div class="mis-title">
                <svg viewBox="0 0 24 24"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                활동 현황
            </div>
            <div class="mis-row"><label>총 주문 수</label><span>12건</span></div>
            <div class="mis-row"><label>총 결제 금액</label><span>428,600원</span></div>
            <div class="mis-row"><label>취소/반품</label><span>1건</span></div>
            <div class="mis-row"><label>병원 예약</label><span>3건</span></div>
            <div class="mis-row"><label>커뮤니티 게시글</label><span>8건</span></div>
            <div class="mis-row"><label>신고 횟수</label><span>0건</span></div>
            <div class="mis-row"><label>보유 포인트</label><span style="color:#3B5BDB;font-weight:800">${member.pointBalance} P</span></div>
            <div class="mis-row"><label>사용 쿠폰</label><span>2장</span></div>
            <div class="mis-row"><label>관심 상품</label><span>5개</span></div>
            <div class="mis-row"><label>등록 반려동물</label><span>2마리 (몽이, 나비)</span></div>
        </div>

        <%-- 등급 변경 --%>
        <div class="mem-info-section">
            <div class="mis-title">
                <svg viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                등급 변경
            </div>
            <p style="font-size:13px;color:#999;margin:0 0 14px">현재 등급: <strong style="color:#F59E0B">골드</strong></p>
            <div class="grade-select-row">
                <select>
                    <option>일반 (브론즈)</option>
                    <option selected>골드</option>
                    <option>플래티넘</option>
                    <option>VIP</option>
                </select>
                <button class="adm-btn blue" onclick="alert('등급이 변경되었습니다.')">변경</button>
            </div>
            <div style="margin-top:14px;font-size:12px;color:#999;line-height:1.6">
                · 브론즈: 0~9만원 구매<br>
                · 골드: 10~29만원 구매<br>
                · 플래티넘: 30~99만원 구매<br>
                · VIP: 100만원 이상 구매
            </div>
        </div>

        <%-- 포인트 관리 --%>
        <div class="mem-info-section">
            <div class="mis-title">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/></svg>
                포인트 관리
            </div>
            <div class="point-summary-row">
                <div class="point-box">
                    <div class="pb-label">보유</div>
                    <div class="pb-val">1,200<span class="pb-unit"> P</span></div>
                </div>
                <div class="point-box">
                    <div class="pb-label">총 적립</div>
                    <div class="pb-val">1,434<span class="pb-unit"> P</span></div>
                </div>
                <div class="point-box">
                    <div class="pb-label">총 사용</div>
                    <div class="pb-val">234<span class="pb-unit"> P</span></div>
                </div>
            </div>
            <div class="point-input-row">
                <div class="point-input-group">
                    <label>구분</label>
                    <select><option value="add">지급</option><option value="sub">차감</option></select>
                </div>
                <div class="point-input-group" style="flex:2">
                    <label>포인트</label>
                    <input type="number" placeholder="0" min="1">
                </div>
                <div class="point-input-group" style="flex:2">
                    <label>사유</label>
                    <input type="text" placeholder="관리자 지급">
                </div>
                <button class="btn-point-apply" onclick="alert('포인트가 처리되었습니다.')">처리</button>
            </div>
            <div class="point-history">
                <table class="adm-table" style="font-size:13px">
                    <thead><tr><th>날짜</th><th>내용</th><th>구분</th><th style="text-align:right">포인트</th></tr></thead>
                    <tbody>
                        <tr><td>2025.06.25</td><td>주문 적립</td><td><span class="adm-badge active">적립</span></td><td style="text-align:right;color:#3B5BDB;font-weight:700">+489 P</td></tr>
                        <tr><td>2025.06.10</td><td>주문 적립</td><td><span class="adm-badge active">적립</span></td><td style="text-align:right;color:#3B5BDB;font-weight:700">+445 P</td></tr>
                        <tr><td>2025.05.28</td><td>주문 취소 차감</td><td><span class="adm-badge cancel">차감</span></td><td style="text-align:right;color:#DC2626;font-weight:700">-234 P</td></tr>
                        <tr><td>2025.05.15</td><td>웰컴 포인트</td><td><span class="adm-badge active">적립</span></td><td style="text-align:right;color:#3B5BDB;font-weight:700">+500 P</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- 최근 주문 --%>
        <div class="mem-info-section full">
            <div class="mis-title">
                <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
                최근 주문 내역
            </div>
            <table class="adm-table">
                <thead><tr><th>주문번호</th><th>상품</th><th>금액</th><th>상태</th><th>주문일</th><th>처리</th></tr></thead>
                <tbody>
                    <tr><td>#ORD-2025-0892</td><td>로얄캐닌 사료 4kg 외 1건</td><td>74,900원</td><td><span class="adm-badge shipping">배송중</span></td><td>2025.06.25</td><td><button class="adm-btn blue">상세</button></td></tr>
                    <tr><td>#ORD-2025-0888</td><td>노즈워크 매트 오렌지</td><td>18,500원</td><td><span class="adm-badge done">배송완료</span></td><td>2025.06.20</td><td><button class="adm-btn blue">상세</button></td></tr>
                    <tr><td>#ORD-2025-0874</td><td>수제 져키 트릿 200g × 2</td><td>26,000원</td><td><span class="adm-badge cancel">취소</span></td><td>2025.06.10</td><td><button class="adm-btn blue">상세</button></td></tr>
                </tbody>
            </table>
        </div>

        <%-- 위험 영역 --%>
        <div class="mem-info-section full">
            <div class="mis-title" style="color:#DC2626">
                <svg viewBox="0 0 24 24" style="stroke:#DC2626"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                위험 영역
            </div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
                <div class="danger-zone">
                    <p><strong>계정 정지</strong><br>해당 회원의 서비스 이용을 일시 정지합니다. 로그인 및 모든 서비스 이용이 불가합니다.</p>
                    <div class="danger-btns">
                        <button class="adm-btn red" onclick="if(confirm('김민준 회원을 정지하시겠습니까?'))alert('계정이 정지되었습니다.')">계정 정지</button>
                    </div>
                </div>
                <div class="danger-zone">
                    <p><strong>강제 탈퇴 (익명화)</strong><br>개인정보를 익명화하고 계정을 영구 삭제합니다. 이 작업은 되돌릴 수 없습니다.</p>
                    <div class="danger-btns">
                        <button class="adm-btn red" onclick="if(confirm('정말 강제 탈퇴 처리하시겠습니까?\\n이 작업은 되돌릴 수 없습니다.'))alert('강제 탈퇴 처리되었습니다.\\n개인정보가 익명화되었습니다.')">강제 탈퇴</button>
                    </div>
                </div>
            </div>
        </div>

    </div><%-- /mem-detail-grid --%>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
