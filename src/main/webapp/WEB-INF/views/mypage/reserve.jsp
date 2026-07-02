<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="reserve" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- ── 예약내역 ── --%>
<div class="mp-section active">
    <h2 class="mp-title">예약내역</h2>
    <p class="mp-desc">병원·숙소 예약 현황을 확인하고 취소하세요.</p>
    <div class="order-filter" style="margin-bottom:20px">
        <button class="filter-btn on">전체</button>
        <button class="filter-btn">예약확정</button>
        <button class="filter-btn">이용완료</button>
        <button class="filter-btn">취소</button>
    </div>
    <div class="resv-card">
        <img class="resv-thumb"
             src="https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=180&q=70&auto=format&fit=crop"
             alt="동물병원"
             onerror="this.src='https://placehold.co/88x88/EAF7F2/2BAB82?text=병원'">
        <div class="resv-info">
            <span class="category">동물병원</span>
            <div class="rname">행복 동물병원 — 정기 건강검진</div>
            <div class="rmeta">
                <span><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>2025년 7월 5일 (토) 오전 10:00</span>
                <span><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 마포구 합정동</span>
                <span><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>대상 반려동물: 몽이 (골든 리트리버)</span>
            </div>
        </div>
        <div class="resv-right">
            <span class="badge-status badge-ready">예약확정</span>
            <button class="btn-sm danger">예약취소</button>
        </div>
    </div>
    <div class="resv-card">
        <img class="resv-thumb"
             src="https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=180&q=70&auto=format&fit=crop"
             alt="펫호텔"
             onerror="this.src='https://placehold.co/88x88/EAF7F2/2BAB82?text=숙소'">
        <div class="resv-info">
            <span class="category">펫 호텔</span>
            <div class="rname">강아지숲 펫 호텔 — 1박 스탠다드룸</div>
            <div class="rmeta">
                <span><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>2025년 6월 28일 ~ 6월 29일 (1박)</span>
                <span><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>경기 고양시 일산동구</span>
                <span><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>대상 반려동물: 몽이 (골든 리트리버)</span>
            </div>
        </div>
        <div class="resv-right">
            <span class="badge-status badge-done">이용완료</span>
            <button class="btn-sm">리뷰작성</button>
        </div>
    </div>
    <div class="resv-card">
        <img class="resv-thumb"
             src="https://images.unsplash.com/photo-1560743641-3914f2c45636?w=180&q=70&auto=format&fit=crop"
             alt="미용"
             onerror="this.src='https://placehold.co/88x88/EAF7F2/2BAB82?text=미용'">
        <div class="resv-info">
            <span class="category">반려동물 미용</span>
            <div class="rname">냥냥 그루밍샵 — 전체 미용</div>
            <div class="rmeta">
                <span><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>2025년 6월 15일 (일) 오후 2:00</span>
                <span><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 강남구 청담동</span>
                <span><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>대상 반려동물: 나비 (페르시안 고양이)</span>
            </div>
        </div>
        <div class="resv-right">
            <span class="badge-status badge-cancel">취소</span>
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
