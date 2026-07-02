<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="wishlist" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- ── 관심상품 ── --%>
<div class="mp-section active">
    <h2 class="mp-title">관심상품</h2>
    <p class="mp-desc">찜한 상품 <strong>5</strong>개</p>
    <div class="wishlist-grid">
        <div class="wish-card">
            <div class="wish-thumb-wrap">
                <img class="wish-thumb"
                     src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=300&q=70&auto=format&fit=crop"
                     alt="사료"
                     onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=상품'">
                <button class="wish-heart"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
            </div>
            <div class="wish-body">
                <div class="w-brand">로얄캐닌</div>
                <div class="w-name">미디엄 어덜트 사료 4kg</div>
                <div><span class="w-price">48,900원</span><span class="w-origin">55,000원</span></div>
            </div>
            <div class="wish-footer"><button class="btn-cart">장바구니 담기</button></div>
        </div>
        <div class="wish-card">
            <div class="wish-thumb-wrap">
                <img class="wish-thumb"
                     src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=300&q=70&auto=format&fit=crop"
                     alt="장난감"
                     onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=상품'">
                <button class="wish-heart"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
            </div>
            <div class="wish-body">
                <div class="w-brand">PetPlay</div>
                <div class="w-name">노즈워크 매트 오렌지</div>
                <div><span class="w-price">18,500원</span></div>
            </div>
            <div class="wish-footer"><button class="btn-cart">장바구니 담기</button></div>
        </div>
        <div class="wish-card">
            <div class="wish-thumb-wrap">
                <img class="wish-thumb"
                     src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=300&q=70&auto=format&fit=crop"
                     alt="간식"
                     onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=상품'">
                <button class="wish-heart"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
            </div>
            <div class="wish-body">
                <div class="w-brand">냠냠</div>
                <div class="w-name">수제 져키 트릿 200g</div>
                <div><span class="w-price">13,000원</span></div>
            </div>
            <div class="wish-footer"><button class="btn-cart">장바구니 담기</button></div>
        </div>
        <div class="wish-card">
            <div class="wish-thumb-wrap">
                <img class="wish-thumb"
                     src="https://images.unsplash.com/photo-1596854407944-bf87f6fdd049?w=300&q=70&auto=format&fit=crop"
                     alt="하네스"
                     onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=상품'">
                <button class="wish-heart"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
            </div>
            <div class="wish-body">
                <div class="w-brand">WalkMe</div>
                <div class="w-name">H형 하네스 M사이즈 블루</div>
                <div><span class="w-price">22,000원</span><span class="w-origin">28,000원</span></div>
            </div>
            <div class="wish-footer"><button class="btn-cart">장바구니 담기</button></div>
        </div>
        <div class="wish-card">
            <div class="wish-thumb-wrap">
                <img class="wish-thumb"
                     src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=300&q=70&auto=format&fit=crop"
                     alt="침대"
                     onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=상품'">
                <button class="wish-heart"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></button>
            </div>
            <div class="wish-body">
                <div class="w-brand">PetNest</div>
                <div class="w-name">메모리폼 반려견 침대 L</div>
                <div><span class="w-price">59,000원</span></div>
            </div>
            <div class="wish-footer"><button class="btn-cart">장바구니 담기</button></div>
        </div>
    </div>
</div>



</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
