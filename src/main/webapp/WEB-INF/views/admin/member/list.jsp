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

    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">회원 목록</span>
            <span class="adm-card-head-sub">총 12,847명</span>
        </div>
        <div class="adm-card-body" style="padding-bottom:0">
            <div class="adm-filter-bar">
                <input type="text" class="adm-filter-input" placeholder="이름, 이메일, 전화번호로 검색">
                <select class="adm-filter-select">
                    <option value="">역할 전체</option>
                    <option>일반회원</option>
                    <option>사업자</option>
                    <option>관리자</option>
                </select>
                <select class="adm-filter-select">
                    <option value="">상태 전체</option>
                    <option>활성</option>
                    <option>정지</option>
                    <option>탈퇴</option>
                </select>
                <button class="adm-filter-btn primary">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    검색
                </button>
            </div>
        </div>
        <div class="adm-table-wrap">
            <table class="adm-table">
                <thead>
                    <tr>
                        <th><input type="checkbox"></th>
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
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>12847</td>
                        <td><strong>김민준</strong></td>
                        <td>minjun@email.com</td>
                        <td>010-1234-5678</td>
                        <td><span class="adm-badge active">일반</span></td>
                        <td><span class="adm-badge active">활성</span></td>
                        <td>2025.06.25</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/member/detail?id=12847" class="adm-btn blue">상세</a>
                            <button class="adm-btn gray" style="margin-left:4px">정지</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>12846</td>
                        <td><strong>이서연</strong></td>
                        <td>seoyeon@email.com</td>
                        <td>010-2345-6789</td>
                        <td><span class="adm-badge active">일반</span></td>
                        <td><span class="adm-badge active">활성</span></td>
                        <td>2025.06.24</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/member/detail?id=12846" class="adm-btn blue">상세</a>
                            <button class="adm-btn gray" style="margin-left:4px">정지</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>12845</td>
                        <td><strong>박지호</strong></td>
                        <td>jiho@email.com</td>
                        <td>010-3456-7890</td>
                        <td><span class="adm-badge pending">사업자</span></td>
                        <td><span class="adm-badge active">활성</span></td>
                        <td>2025.06.20</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/member/detail?id=12845" class="adm-btn blue">상세</a>
                            <button class="adm-btn gray" style="margin-left:4px">정지</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>12844</td>
                        <td><strong>최유나</strong></td>
                        <td>yuna@email.com</td>
                        <td>010-4567-8901</td>
                        <td><span class="adm-badge active">일반</span></td>
                        <td><span class="adm-badge banned">정지</span></td>
                        <td>2025.06.15</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/member/detail?id=12844" class="adm-btn blue">상세</a>
                            <button class="adm-btn green" style="margin-left:4px">해제</button>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>12843</td>
                        <td><strong>정태양</strong></td>
                        <td>taeyang@email.com</td>
                        <td>010-5678-9012</td>
                        <td><span class="adm-badge active">일반</span></td>
                        <td><span class="adm-badge cancel">탈퇴</span></td>
                        <td>2025.05.10</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/member/detail?id=12843" class="adm-btn blue">상세</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="padding:16px 20px;border-top:1px solid #E4E6ED;display:flex;justify-content:space-between;align-items:center">
            <div style="display:flex;gap:8px">
                <button class="adm-btn red">선택 정지</button>
                <button class="adm-btn gray">선택 탈퇴처리</button>
            </div>
            <div class="adm-pagination" style="margin:0">
                <button class="adm-page-btn"><svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg></button>
                <button class="adm-page-btn active">1</button>
                <button class="adm-page-btn">2</button>
                <button class="adm-page-btn">3</button>
                <button class="adm-page-btn">···</button>
                <button class="adm-page-btn">643</button>
                <button class="adm-page-btn"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></button>
            </div>
            <span style="font-size:12px;color:#999">페이지당 20건</span>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
