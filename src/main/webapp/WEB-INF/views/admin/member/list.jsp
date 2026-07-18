<%--
  - 박유정 / 2026-07-16
  - GET /admin/member/list → ${list}, ${totalCount}
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="member-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">회원 관리</h1>
            <p class="adm-page-desc">전체 회원 목록을 조회하고 관리하세요.</p>
        </div>
        <div class="adm-page-actions">
            <button class="adm-filter-btn outline">
                <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                Excel 내보내기
            </button>
        </div>
    </div>

    <%-- 2026-07-16 박유정 — 처리 결과 flash (상세 redirect) --%>
    <c:if test="${not empty errorMsg}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
    </c:if>

    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">회원 목록</span>
            <span class="adm-card-head-sub">총 ${totalCount}명</span>
        </div>
        <div class="adm-card-body" style="padding-bottom:0">
            <%-- 2026-07-16 박유정 — GET 검색 (keyword, roleType, statusCd) --%>
            <form method="get" action="${contextPath}/admin/member/list" class="adm-filter-bar">
                <input type="text" name="keyword" class="adm-filter-input"
                       placeholder="이름, 이메일, 전화번호로 검색" value="${keyword}">
                <select name="roleType" class="adm-filter-select">
                    <option value="" ${roleType eq '' ? 'selected' : ''}>역할 전체</option>
                    <option value="GENERAL" ${roleType eq 'GENERAL' ? 'selected' : ''}>일반회원</option>
                    <option value="BIZ" ${roleType eq 'BIZ' ? 'selected' : ''}>사업자</option>
                </select>
                <select name="statusCd" class="adm-filter-select">
                    <option value="" ${statusCd eq '' ? 'selected' : ''}>상태 전체</option>
                    <option value="NORMAL" ${statusCd eq 'NORMAL' ? 'selected' : ''}>활성</option>
                    <option value="SUSPENDED" ${statusCd eq 'SUSPENDED' ? 'selected' : ''}>정지</option>
                    <option value="WITHDRAWN" ${statusCd eq 'WITHDRAWN' ? 'selected' : ''}>탈퇴</option>
                </select>
                <button type="submit" class="adm-filter-btn primary">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    검색
                </button>
            </form>
        </div>
        <div class="adm-table-wrap">
            <table class="adm-table">
                <thead>
                    <tr>
                        <th><input type="checkbox" id="checkAllMembers" aria-label="전체 선택"></th>
                        <th>번호</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>전화번호</th>
                        <th>역할</th>
                        <th>상태</th>
                        <th>가입일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty list}">
                            <tr>
                                <td colspan="9" style="text-align:center;color:#999;padding:40px 0">
                                    회원이 없습니다.
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td><input type="checkbox" class="member-row-check" value="${item.memberNo}"></td>
                                    <td>${item.memberNo}</td>
                                    <td><strong>${item.memberName}</strong></td>
                                    <td>${item.email}</td>
                                    <td>${item.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.roleType eq 'BIZ'}">
                                                <span class="adm-badge pending">사업자</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="adm-badge active">일반</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.statusCd eq 'NORMAL'}">
                                                <span class="adm-badge active">활성</span>
                                            </c:when>
                                            <c:when test="${item.statusCd eq 'SUSPENDED'}">
                                                <span class="adm-badge banned">정지</span>
                                            </c:when>
                                            <c:when test="${item.statusCd eq 'WITHDRAWN'}">
                                                <span class="adm-badge cancel">탈퇴</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="adm-badge">${item.statusCd}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty item.joinDate}">
                                            ${item.joinDate.year}.${item.joinDate.monthValue}.${item.joinDate.dayOfMonth}
                                        </c:if>
                                    </td>
                                    <td style="white-space:nowrap">
                                        <a href="${contextPath}/admin/member/detail?id=${item.memberNo}" class="adm-btn blue">상세</a>
                                        <%-- STEP 7 — 정지/복구 버튼 연동 예정 --%>
                                        <c:if test="${item.statusCd eq 'NORMAL'}">
                                            <button type="button" class="adm-btn gray" style="margin-left:4px">정지</button>
                                        </c:if>
                                        <c:if test="${item.statusCd eq 'SUSPENDED'}">
                                            <button type="button" class="adm-btn green" style="margin-left:4px">복구</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        <div style="padding:16px 20px;border-top:1px solid #E4E6ED;display:flex;justify-content:space-between;align-items:center">
            <div style="display:flex;gap:8px">
                <button class="adm-btn red">선택 정지</button>
                <button class="adm-btn gray">선택 탈퇴처리</button>
            </div>
            <div class="adm-pagination" style="margin:0">
                <c:if test="${page > 1}">
                    <a href="${contextPath}/admin/member/list?keyword=${keyword}&roleType=${roleType}&statusCd=${statusCd}&page=${page - 1}"
                       class="adm-page-btn">
                        <svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
                    </a>
                </c:if>
                <span class="adm-page-btn active">${page}</span>
                <c:if test="${page * 20 < totalCount}">
                    <a href="${contextPath}/admin/member/list?keyword=${keyword}&roleType=${roleType}&statusCd=${statusCd}&page=${page + 1}"
                       class="adm-page-btn">
                        <svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                    </a>
                </c:if>
            </div>
            <span style="font-size:12px;color:#999">페이지당 20건</span>
        </div>
    </div>
</main>

<%-- 2026-07-16 박유정 — 목록 전체 선택 체크박스 --%>
<script>
(function () {
    var checkAll = document.getElementById('checkAllMembers');
    if (!checkAll) return;

    checkAll.addEventListener('change', function () {
        document.querySelectorAll('.member-row-check').forEach(function (cb) {
            cb.checked = checkAll.checked;
        });
    });

    document.querySelectorAll('.member-row-check').forEach(function (cb) {
        cb.addEventListener('change', function () {
            var rows = document.querySelectorAll('.member-row-check');
            checkAll.checked = rows.length > 0
                && Array.from(rows).every(function (row) { return row.checked; });
        });
    });
})();
</script>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
