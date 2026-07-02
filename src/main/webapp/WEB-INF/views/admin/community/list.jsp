<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="community-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">커뮤니티 관리</h1>
            <p class="adm-page-desc">게시글을 모니터링하고 신고 게시글을 처리하세요.</p>
        </div>
    </div>

    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">게시글 목록</span>
            <span class="adm-card-head-sub" style="color:#DC2626;font-weight:700">신고 대기 4건</span>
        </div>
        <div class="adm-card-body" style="padding-bottom:0">
            <div class="adm-filter-bar">
                <input type="text" class="adm-filter-input" placeholder="제목, 작성자로 검색">
                <select class="adm-filter-select">
                    <option value="">게시판 전체</option>
                    <option>동네소식</option>
                    <option>분실·보호</option>
                    <option>무료나눔</option>
                    <option>집사생활</option>
                </select>
                <select class="adm-filter-select">
                    <option value="">상태 전체</option>
                    <option>정상</option>
                    <option>신고 대기</option>
                    <option>숨김</option>
                    <option>삭제</option>
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
                    <tr><th>번호</th><th>게시판</th><th>제목</th><th>작성자</th><th>조회</th><th>신고</th><th>상태</th><th>작성일</th><th>처리</th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td>4821</td><td>집사생활</td>
                        <td><strong>우리 강아지 훈련 방법 공유해요!</strong></td>
                        <td>김민준</td><td>1,284</td>
                        <td style="color:#DC2626;font-weight:700">3건</td>
                        <td><span class="adm-badge wait">신고 대기</span></td>
                        <td>2025.06.25</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/community/detail?id=4821" class="adm-btn blue">보기</a>
                            <button class="adm-btn gray" style="margin-left:4px">숨김</button>
                            <button class="adm-btn red" style="margin-left:4px">삭제</button>
                        </td>
                    </tr>
                    <tr>
                        <td>4820</td><td>분실·보호</td>
                        <td><strong>[분실] 강남구 역삼동 흰색 말티즈 찾습니다</strong></td>
                        <td>이서연</td><td>892</td>
                        <td>0건</td>
                        <td><span class="adm-badge active">정상</span></td>
                        <td>2025.06.25</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/community/detail?id=4820" class="adm-btn blue">보기</a>
                            <button class="adm-btn gray" style="margin-left:4px">숨김</button>
                            <button class="adm-btn red" style="margin-left:4px">삭제</button>
                        </td>
                    </tr>
                    <tr>
                        <td>4819</td><td>동네소식</td>
                        <td><strong>합정동 근처 펫 카페 새로 생겼어요</strong></td>
                        <td>박지호</td><td>456</td>
                        <td style="color:#DC2626;font-weight:700">1건</td>
                        <td><span class="adm-badge wait">신고 대기</span></td>
                        <td>2025.06.24</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/community/detail?id=4819" class="adm-btn blue">보기</a>
                            <button class="adm-btn gray" style="margin-left:4px">숨김</button>
                            <button class="adm-btn red" style="margin-left:4px">삭제</button>
                        </td>
                    </tr>
                    <tr>
                        <td>4818</td><td>무료나눔</td>
                        <td><strong>고양이 사료 나눔합니다 (서울 마포구)</strong></td>
                        <td>최유나</td><td>321</td>
                        <td>0건</td>
                        <td><span class="adm-badge cancel">숨김</span></td>
                        <td>2025.06.23</td>
                        <td style="white-space:nowrap">
                            <a href="${contextPath}/admin/community/detail?id=4818" class="adm-btn blue">보기</a>
                            <button class="adm-btn green" style="margin-left:4px">복원</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="padding:16px 20px;border-top:1px solid #E4E6ED;display:flex;justify-content:center">
            <div class="adm-pagination" style="margin:0">
                <button class="adm-page-btn"><svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg></button>
                <button class="adm-page-btn active">1</button>
                <button class="adm-page-btn">2</button>
                <button class="adm-page-btn">3</button>
                <button class="adm-page-btn"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></button>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
