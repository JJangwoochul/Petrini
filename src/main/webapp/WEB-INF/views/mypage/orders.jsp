<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="orders" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- ── 주문내역 ── --%>
<div class="mp-section active">
    <h2 class="mp-title">주문내역</h2>
    <p class="mp-desc">최근 6개월 주문 내역입니다.</p>
    <div class="order-filter">
        <button class="filter-btn on">전체</button>
        <button class="filter-btn">배송준비</button>
        <button class="filter-btn">배송중</button>
        <button class="filter-btn">배송완료</button>
        <button class="filter-btn">취소/반품</button>
    </div>
    <%-- 주문 카드 1 --%>
    <div class="order-card">
        <div class="order-card-head">
            <span>2025.06.20 주문 <strong>#ORD-20250620-001</strong></span>
            <span class="badge-status badge-ready">배송중</span>
        </div>
        <div class="order-item">
            <img class="order-thumb"
                 src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=150&q=70&auto=format&fit=crop"
                 alt="사료"
                 onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=IMG'">
            <div class="order-info">
                <div class="name">로얄캐닌 미디엄 어덜트 사료 4kg</div>
                <div class="meta">수량 1개 · 옵션: 기본</div>
            </div>
            <div class="order-price">48,900원</div>
        </div>
        <div class="order-card-foot">
            <button class="btn-sm">배송조회</button>
            <button class="btn-sm">리뷰작성</button>
        </div>
    </div>
    <%-- 주문 카드 2 --%>
    <div class="order-card">
        <div class="order-card-head">
            <span>2025.06.10 주문 <strong>#ORD-20250610-003</strong></span>
            <span class="badge-status badge-done">배송완료</span>
        </div>
        <div class="order-item">
            <img class="order-thumb"
                 src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=150&q=70&auto=format&fit=crop"
                 alt="간식"
                 onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=IMG'">
            <div class="order-info">
                <div class="name">강아지 수제 져키 트릿 200g</div>
                <div class="meta">수량 2개</div>
            </div>
            <div class="order-price">26,000원</div>
        </div>
        <div class="order-item">
            <img class="order-thumb"
                 src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=150&q=70&auto=format&fit=crop"
                 alt="장난감"
                 onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=IMG'">
            <div class="order-info">
                <div class="name">노즈워크 매트 오렌지</div>
                <div class="meta">수량 1개</div>
            </div>
            <div class="order-price">18,500원</div>
        </div>
        <div class="order-card-foot">
            <button class="btn-sm danger">교환/반품</button>
            <button class="btn-sm">리뷰작성</button>
            <button class="btn-sm">재구매</button>
        </div>
    </div>
    <%-- 주문 카드 3 (취소) --%>
    <div class="order-card">
        <div class="order-card-head">
            <span>2025.05.28 주문 <strong>#ORD-20250528-002</strong></span>
            <span class="badge-status badge-cancel">취소완료</span>
        </div>
        <div class="order-item">
            <img class="order-thumb"
                 src="https://images.unsplash.com/photo-1596854407944-bf87f6fdd049?w=150&q=70&auto=format&fit=crop"
                 alt="하네스"
                 onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=IMG'">
            <div class="order-info">
                <div class="name">강아지 H형 하네스 M사이즈 블루</div>
                <div class="meta">수량 1개</div>
            </div>
            <div class="order-price" style="text-decoration:line-through;color:var(--text-muted)">22,000원</div>
        </div>
        <div class="order-card-foot">
            <button class="btn-sm">환불내역</button>
        </div>
    </div>
</div>



<script>
document.querySelectorAll('.order-filter .filter-btn').forEach(function(btn){
    btn.addEventListener('click', function(){
        this.closest('.order-filter').querySelectorAll('.filter-btn').forEach(function(b){ b.classList.remove('on'); });
        this.classList.add('on');
    });
});
</script>

</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
