<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="order-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">주문 관리</h1>
            <p class="adm-page-desc">전체 주문 내역을 조회하고 상태를 변경하세요.</p>
        </div>
    </div>

    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">주문 목록</span>
            <span class="adm-card-head-sub">총 4,821건</span>
        </div>
        <div class="adm-card-body" style="padding-bottom:0">
            <div class="adm-filter-bar">
                <input type="text" class="adm-filter-input" placeholder="주문번호, 회원명으로 검색">
                <select class="adm-filter-select">
                    <option value="">주문 상태 전체</option>
                    <option>결제완료</option>
                    <option>배송중</option>
                    <option>배송완료</option>
                    <option>취소</option>
                    <option>반품</option>
                </select>
                <input type="date" class="adm-filter-select">
                <span style="font-size:13px;color:#999">~</span>
                <input type="date" class="adm-filter-select">
                <button class="adm-filter-btn primary">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    검색
                </button>
            </div>
        </div>
        <div class="adm-table-wrap">
            <table class="adm-table">
                <thead>
                    <tr><th>주문번호</th><th>주문자</th><th>상품</th><th>금액</th><th>결제수단</th><th>상태</th><th>주문일</th><th>처리</th></tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#ORD-2025-0892</td><td>김민준</td>
                        <td>로얄캐닌 사료 4kg 외 1건</td>
                        <td>74,900원</td><td>카드</td>
                        <td><span class="adm-badge shipping">배송중</span></td>
                        <td>2025.06.25</td>
                        <td><button class="adm-btn blue">상세</button></td>
                    </tr>
                    <tr>
                        <td>#ORD-2025-0891</td><td>이서연</td>
                        <td>노즈워크 매트 오렌지</td>
                        <td>18,500원</td><td>카카오페이</td>
                        <td><span class="adm-badge done">배송완료</span></td>
                        <td>2025.06.24</td>
                        <td><button class="adm-btn blue">상세</button></td>
                    </tr>
                    <tr>
                        <td>#ORD-2025-0890</td><td>박지호</td>
                        <td>H형 하네스 M 블루</td>
                        <td>22,000원</td><td>카드</td>
                        <td><span class="adm-badge wait">결제완료</span></td>
                        <td>2025.06.24</td>
                        <td>
                            <button class="adm-btn blue">상세</button>
                            <button class="adm-btn green" style="margin-left:4px">배송처리</button>
                        </td>
                    </tr>
                    <tr>
                        <td>#ORD-2025-0889</td><td>최유나</td>
                        <td>수제 져키 200g × 2</td>
                        <td>26,000원</td><td>네이버페이</td>
                        <td><span class="adm-badge cancel">취소</span></td>
                        <td>2025.06.23</td>
                        <td><button class="adm-btn blue">상세</button></td>
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
                <button class="adm-page-btn">···</button>
                <button class="adm-page-btn">242</button>
                <button class="adm-page-btn"><svg viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg></button>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
