<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="product-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">상품 관리</h1>
            <p class="adm-page-desc">사업자 등록 상품을 승인·반려하고 관리하세요.</p>
        </div>
    </div>

    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">상품 목록</span>
            <span class="adm-card-head-sub" style="color:#E74C3C;font-weight:700">승인 대기 5건</span>
        </div>
        <div class="adm-card-body" style="padding-bottom:0">
            <div class="adm-filter-bar">
                <input type="text" class="adm-filter-input" placeholder="상품명, 사업자명으로 검색">
                <select class="adm-filter-select">
                    <option value="">승인 상태 전체</option>
                    <option>승인 대기</option>
                    <option>승인</option>
                    <option>반려</option>
                </select>
                <select class="adm-filter-select">
                    <option value="">카테고리 전체</option>
                    <option>사료/간식</option>
                    <option>용품/장난감</option>
                    <option>의류/패션</option>
                    <option>건강/미용</option>
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
                        <th>상품 이미지</th>
                        <th>상품명</th>
                        <th>사업자</th>
                        <th>카테고리</th>
                        <th>가격</th>
                        <th>재고</th>
                        <th>상태</th>
                        <th>등록일</th>
                        <th>처리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><img src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=48&q=70&auto=format&fit=crop" style="width:44px;height:44px;border-radius:8px;object-fit:cover" alt="사료" onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=IMG'"></td>
                        <td><strong>로얄캐닌 미디엄 어덜트 4kg</strong></td>
                        <td>펫마켓스토어</td>
                        <td>사료/간식</td>
                        <td>48,900원</td>
                        <td>145개</td>
                        <td><span class="adm-badge wait">승인 대기</span></td>
                        <td>2025.06.25</td>
                        <td style="white-space:nowrap">
                            <button class="adm-btn green">승인</button>
                            <button class="adm-btn red" style="margin-left:4px">반려</button>
                        </td>
                    </tr>
                    <tr>
                        <td><img src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=48&q=70&auto=format&fit=crop" style="width:44px;height:44px;border-radius:8px;object-fit:cover" alt="장난감" onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=IMG'"></td>
                        <td><strong>노즈워크 매트 오렌지</strong></td>
                        <td>펫마켓스토어</td>
                        <td>용품/장난감</td>
                        <td>18,500원</td>
                        <td>88개</td>
                        <td><span class="adm-badge active">승인</span></td>
                        <td>2025.06.20</td>
                        <td style="white-space:nowrap">
                            <button class="adm-btn blue">수정</button>
                            <button class="adm-btn red" style="margin-left:4px">삭제</button>
                        </td>
                    </tr>
                    <tr>
                        <td><img src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=48&q=70&auto=format&fit=crop" style="width:44px;height:44px;border-radius:8px;object-fit:cover" alt="간식" onerror="this.src='https://placehold.co/44x44/EAF7F2/2BAB82?text=IMG'"></td>
                        <td><strong>수제 져키 트릿 200g</strong></td>
                        <td>펫마켓스토어</td>
                        <td>사료/간식</td>
                        <td>13,000원</td>
                        <td>220개</td>
                        <td><span class="adm-badge wait">승인 대기</span></td>
                        <td>2025.06.25</td>
                        <td style="white-space:nowrap">
                            <button class="adm-btn green">승인</button>
                            <button class="adm-btn red" style="margin-left:4px">반려</button>
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
