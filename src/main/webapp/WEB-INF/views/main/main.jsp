<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="home" />

<%-- ===== HEADER ===== --%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main>
    <%-- ===================================================
         HERO BANNER SLIDER
    ===================================================== --%>
    <div class="hero-section inner">
        <div class="hero-slides">

            <%-- Slide 1 --%>
            <div class="hero-slide active">
                <div class="hero-text">
                    <span class="hero-badge">반려동물 통합 케어</span>
                    <h2 class="hero-title">우리 아이의<br>모든 순간을 함께해요</h2>
                    <p class="hero-desc">쇼핑부터 병원 예약, 여가까지<br>펫케어 하나로 간편하게!</p>
                    <a href="/store" class="hero-cta">지금 시작하기</a>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=480&q=80"
                         alt="강아지와 고양이" onerror="this.src='https://placehold.co/480x300/EAF7F2/2BAB82?text=PetCare'">
                    <div class="hero-float f1">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
                            <path d="M12 2v20M2 12h20" stroke="#2BAB82" stroke-width="2.5" stroke-linecap="round"/>
                            <circle cx="12" cy="12" r="10" stroke="#2BAB82" stroke-width="2" fill="none"/>
                        </svg>
                    </div>
                    <div class="hero-float f2">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <rect x="3" y="4" width="18" height="18" rx="3" stroke="#5B8DEF" stroke-width="2" fill="none"/>
                            <path d="M3 9h18M8 2v4M16 2v4" stroke="#5B8DEF" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>
                    <div class="hero-float f3">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z" fill="#FF6B6B" stroke="#FF6B6B" stroke-width="1.5" stroke-linejoin="round"/>
                        </svg>
                    </div>
                </div>
            </div>

            <%-- Slide 2 --%>
            <div class="hero-slide">
                <div class="hero-text">
                    <span class="hero-badge">🏥 병원 예약 서비스</span>
                    <h2 class="hero-title">가까운 동물병원<br>빠르게 예약하세요</h2>
                    <p class="hero-desc">검증된 전문의와 함께<br>우리 아이 건강을 지켜드려요</p>
                    <a href="/hospital" class="hero-cta">병원 예약하기</a>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=480&q=80"
                         alt="동물병원" onerror="this.src='https://placehold.co/480x300/EAF7F2/5B8DEF?text=병원예약'">
                    <div class="hero-float f1">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
                            <path d="M12 2v20M2 12h20" stroke="#5B8DEF" stroke-width="2.5" stroke-linecap="round"/>
                        </svg>
                    </div>
                    <div class="hero-float f2">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <circle cx="12" cy="12" r="10" stroke="#2BAB82" stroke-width="2"/>
                            <path d="M12 6v6l4 2" stroke="#2BAB82" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>
                    <div class="hero-float f3">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="#FFC700">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </div>
                </div>
            </div>

            <%-- Slide 3 --%>
            <div class="hero-slide">
                <div class="hero-text">
                    <span class="hero-badge">🛍️ 반려동물 용품 쇼핑</span>
                    <h2 class="hero-title">우리 아이를 위한<br>최고의 선물</h2>
                    <p class="hero-desc">사료부터 장난감, 의류까지<br>엄선된 프리미엄 상품만 모았어요</p>
                    <a href="/store" class="hero-cta">쇼핑 시작하기</a>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1601758003122-53c40e686a19?w=480&q=80"
                         alt="반려동물 용품" onerror="this.src='https://placehold.co/480x300/EAF7F2/2BAB82?text=쇼핑'">
                    <div class="hero-float f1">
                        <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
                            <circle cx="9" cy="21" r="1" fill="#2BAB82"/>
                            <circle cx="20" cy="21" r="1" fill="#2BAB82"/>
                            <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" stroke="#2BAB82" stroke-width="2" stroke-linecap="round"/>
                        </svg>
                    </div>
                    <div class="hero-float f2">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z" fill="#FF6B6B"/>
                        </svg>
                    </div>
                    <div class="hero-float f3">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="#FFC700">
                            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <%-- 슬라이드 컨트롤 --%>
        <div class="hero-controls">
            <span class="slide-indicator">1 / 3</span>
            <div class="slide-dots">
                <span class="slide-dot active"></span>
                <span class="slide-dot"></span>
                <span class="slide-dot"></span>
            </div>
            <button class="slide-nav-btn btn-prev" aria-label="이전">&#8249;</button>
            <button class="slide-nav-btn btn-pause" aria-label="일시정지">❚❚</button>
            <button class="slide-nav-btn btn-next" aria-label="다음">&#8250;</button>
        </div>
    </div>

    <%-- ===================================================
         QUICK LINKS
    ===================================================== --%>
    <section class="quick-section">
        <div class="quick-grid">
            <a href="/hospital" class="quick-item">
                <div class="quick-icon">
                    <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                        <path d="M14 4v20M4 14h20" stroke="#5B8DEF" stroke-width="2.4" stroke-linecap="round"/>
                        <circle cx="14" cy="14" r="11" stroke="#5B8DEF" stroke-width="2" fill="none"/>
                    </svg>
                </div>
                <span class="quick-label">병원 찾기</span>
            </a>
            <a href="/store" class="quick-item">
                <div class="quick-icon">
                    <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                        <path d="M6 6h3l2 9h10l2-7H9" stroke="#E05252" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="13" cy="22" r="1.5" fill="#E05252"/>
                        <circle cx="19" cy="22" r="1.5" fill="#E05252"/>
                    </svg>
                </div>
                <span class="quick-label">상품 쇼핑</span>
            </a>
            <a href="/give/animal/list" class="quick-item">
                <div class="quick-icon">
                    <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                        <ellipse cx="14" cy="17" rx="7" ry="6.5" fill="none" stroke="#F5A623" stroke-width="2"/>
                        <ellipse cx="7"  cy="11" rx="2.5" ry="3" fill="none" stroke="#F5A623" stroke-width="1.8"/>
                        <ellipse cx="11" cy="8.5" rx="2.5" ry="3" fill="none" stroke="#F5A623" stroke-width="1.8"/>
                        <ellipse cx="17" cy="8.5" rx="2.5" ry="3" fill="none" stroke="#F5A623" stroke-width="1.8"/>
                        <ellipse cx="21" cy="11" rx="2.5" ry="3" fill="none" stroke="#F5A623" stroke-width="1.8"/>
                    </svg>
                </div>
                <span class="quick-label">유기견 찾기</span>
            </a>
            <a href="/stay" class="quick-item">
                <div class="quick-icon">
                    <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                        <path d="M5 23V12l9-7 9 7v11" stroke="#5B8DEF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                        <rect x="10" y="15" width="8" height="8" rx="1" stroke="#5B8DEF" stroke-width="1.8" fill="none"/>
                    </svg>
                </div>
                <span class="quick-label">여가/서비스</span>
            </a>
            <a href="/community" class="quick-item">
                <div class="quick-icon">
                    <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                        <path d="M21 15c0 1.1-.9 2-2 2H9l-4 4V7c0-1.1.9-2 2-2h12c1.1 0 2 .9 2 2v8z" stroke="#A855F7" stroke-width="2" fill="none" stroke-linejoin="round"/>
                    </svg>
                </div>
                <span class="quick-label">커뮤니티</span>
            </a>
            <a href="/event" class="quick-item">
                <div class="quick-icon">
                    <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
                        <path d="M14 5l1.8 5.5H21l-4.8 3.5 1.8 5.5L14 16l-4 3.5 1.8-5.5L7 10.5h5.2z" fill="none" stroke="#F59E0B" stroke-width="2" stroke-linejoin="round"/>
                        <path d="M14 19v4M10 22l4-3 4 3" stroke="#F59E0B" stroke-width="1.8" stroke-linecap="round"/>
                    </svg>
                </div>
                <span class="quick-label">이벤트/혜택</span>
            </a>
        </div>
    </section>

    <%-- ===================================================
         PROMO BANNERS (쿠폰 + 오늘의 특가)
    ===================================================== --%>
    <section class="promo-section">
        <%-- 신규 회원 쿠폰 --%>
        <div class="promo-card coupon">
            <div class="promo-text">
                <span class="promo-badge">신규 회원 혜택</span>
                <p class="promo-title">첫 구매 10% 할인 쿠폰<br>지금 바로 받아가세요!</p>
                <a href="/event/coupon" class="promo-btn">쿠폰 받기</a>
            </div>
            <div class="promo-graphic">
                <svg class="coupon-svg" viewBox="0 0 100 68" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <rect x="2" y="2" width="96" height="64" rx="10" fill="#2BAB82"/>
                    <circle cx="2" cy="34" r="8" fill="#EAF7F2"/>
                    <circle cx="98" cy="34" r="8" fill="#EAF7F2"/>
                    <line x1="30" y1="8" x2="30" y2="60" stroke="rgba(255,255,255,.3)" stroke-width="1.5" stroke-dasharray="4 3"/>
                    <text x="55" y="28" text-anchor="middle" fill="white" font-size="22" font-weight="800" font-family="sans-serif">10%</text>
                    <text x="55" y="48" text-anchor="middle" fill="rgba(255,255,255,.85)" font-size="11" font-family="sans-serif">COUPON</text>
                    <text x="15" y="40" text-anchor="middle" fill="white" font-size="16" font-weight="700" font-family="sans-serif">할인</text>
                </svg>
            </div>
        </div>

        <%-- 오늘의 특가 --%>
        <div class="promo-card sale">
            <div class="promo-text">
                <span class="promo-badge">오늘의 특가</span>
                <p class="promo-title">엄선된 인기 상품을<br>특별한 가격에!</p>
                <a href="/store?type=sale" class="promo-btn">특가 상품 보러가기</a>
            </div>
            <div class="promo-graphic">
                <img src="https://images.unsplash.com/photo-1589924691995-400dc9a04a86?w=180&q=80"
                     alt="반려동물 사료"
                     style="height:110px; object-fit:contain;"
                     onerror="this.src='https://placehold.co/180x110/FEF9EE/E67E00?text=특가'">
            </div>
        </div>
    </section>

    <%-- ===================================================
         추천 카테고리
    ===================================================== --%>
    <section class="section-wrap">
        <div class="section-head">
            <h2 class="section-title">추천 카테고리</h2>
            <a href="/store" class="section-more">더보기</a>
        </div>
        <div class="category-grid">
            <a href="/store?cat=food" class="category-card">
                <div class="category-img">
                    <img src="https://images.unsplash.com/photo-1589924691995-400dc9a04a86?w=300&q=75"
                         alt="사료/간식" onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=사료'">
                </div>
                <div class="category-name">사료/간식</div>
            </a>
            <a href="/store?cat=toy" class="category-card">
                <div class="category-img">
                    <img src="https://images.unsplash.com/photo-1535268244197-63e388f0b7d8?w=300&q=75"
                         alt="장난감" onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=장난감'">
                </div>
                <div class="category-name">장난감</div>
            </a>
            <a href="/store?cat=hygiene" class="category-card">
                <div class="category-img">
                    <img src="https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=300&q=75"
                         alt="위생/미용" onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=위생'">
                </div>
                <div class="category-name">위생/미용</div>
            </a>
            <a href="/store?cat=clothes" class="category-card">
                <div class="category-img">
                    <img src="https://images.unsplash.com/photo-1601758003122-53c40e686a19?w=300&q=75"
                         alt="의류/악세서리" onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=의류'">
                </div>
                <div class="category-name">의류/악세서리</div>
            </a>
            <a href="/store?cat=house" class="category-card">
                <div class="category-img">
                    <img src="https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=300&q=75"
                         alt="하우스/침구" onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=침구'">
                </div>
                <div class="category-name">하우스/침구</div>
            </a>
            <a href="/store?cat=health" class="category-card">
                <div class="category-img">
                    <img src="https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=300&q=75"
                         alt="건강/영양제" onerror="this.src='https://placehold.co/300x300/EAF7F2/2BAB82?text=건강'">
                </div>
                <div class="category-name">건강/영양제</div>
            </a>
        </div>
    </section>

    <%-- ===================================================
         광고 배너 (입점/제휴사)
    ===================================================== --%>
    <%@ include file="/WEB-INF/views/common/ad-banner.jsp" %>

    <%-- ===================================================
         병원 예약 인기 지역
    ===================================================== --%>
    <section class="section-wrap">
        <div class="section-head">
            <h2 class="section-title">병원 예약 인기 지역</h2>
            <a href="/hospital" class="section-more">더보기</a>
        </div>
        <div class="hospital-grid">
            <a href="/hospital/1" class="hospital-card">
                <div class="hospital-img">
                    <img src="https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&q=75"
                         alt="24시 행복 동물병원" onerror="this.src='https://placehold.co/400x150/EAF7F2/2BAB82?text=병원'">
                    <span class="hospital-badge">24시간</span>
                    <button class="hospital-wish" aria-label="찜하기">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                    </button>
                </div>
                <div class="hospital-body">
                    <p class="hospital-name">24시 행복 동물병원</p>
                    <div class="hospital-rating">
                        <span class="star-icon">★</span>
                        <span class="rating-score">4.8</span>
                        <span class="rating-count">(120)</span>
                    </div>
                    <p class="hospital-location">서울 강남구</p>
                    <div class="hospital-tags">
                        <span class="tag">24시간 진료</span>
                        <span class="tag">주차가능</span>
                    </div>
                </div>
            </a>

            <a href="/hospital/2" class="hospital-card">
                <div class="hospital-img">
                    <img src="https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=400&q=75"
                         alt="위드펫 동물병원" onerror="this.src='https://placehold.co/400x150/EAF7F2/5B8DEF?text=병원'">
                    <span class="hospital-badge">예약제</span>
                    <button class="hospital-wish" aria-label="찜하기">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                    </button>
                </div>
                <div class="hospital-body">
                    <p class="hospital-name">위드펫 동물병원</p>
                    <div class="hospital-rating">
                        <span class="star-icon">★</span>
                        <span class="rating-score">4.7</span>
                        <span class="rating-count">(99)</span>
                    </div>
                    <p class="hospital-location">서울 서초구</p>
                    <div class="hospital-tags">
                        <span class="tag">예약제</span>
                        <span class="tag">고양이 진료</span>
                    </div>
                </div>
            </a>

            <a href="/hospital/3" class="hospital-card">
                <div class="hospital-img">
                    <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&q=75"
                         alt="도그앤펫 동물의료센터" onerror="this.src='https://placehold.co/400x150/EAF7F2/2BAB82?text=병원'">
                    <span class="hospital-badge">의과 전문</span>
                    <button class="hospital-wish" aria-label="찜하기">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                    </button>
                </div>
                <div class="hospital-body">
                    <p class="hospital-name">도그앤펫 동물의료센터</p>
                    <div class="hospital-rating">
                        <span class="star-icon">★</span>
                        <span class="rating-score">4.6</span>
                        <span class="rating-count">(156)</span>
                    </div>
                    <p class="hospital-location">경기 성남시</p>
                    <div class="hospital-tags">
                        <span class="tag">의과 전문</span>
                        <span class="tag">주차가능</span>
                    </div>
                </div>
            </a>

            <a href="/hospital/4" class="hospital-card">
                <div class="hospital-img">
                    <img src="https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=400&q=75"
                         alt="늘봄 동물병원" onerror="this.src='https://placehold.co/400x150/EAF7F2/2BAB82?text=병원'">
                    <span class="hospital-badge">예약제</span>
                    <button class="hospital-wish" aria-label="찜하기">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#888" stroke-width="2">
                            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 0 0 0-7.78z"/>
                        </svg>
                    </button>
                </div>
                <div class="hospital-body">
                    <p class="hospital-name">늘봄 동물병원</p>
                    <div class="hospital-rating">
                        <span class="star-icon">★</span>
                        <span class="rating-score">4.6</span>
                        <span class="rating-count">(87)</span>
                    </div>
                    <p class="hospital-location">경기 고양시</p>
                    <div class="hospital-tags">
                        <span class="tag">예약제</span>
                        <span class="tag">강아지 전문</span>
                    </div>
                </div>
            </a>
        </div>
    </section>

    <%-- ===================================================
         실시간 인기 게시글
    ===================================================== --%>
    <section class="section-wrap">
        <div class="section-head">
            <h2 class="section-title">실시간 인기 게시글</h2>
            <a href="/community" class="section-more">더보기</a>
        </div>
        <div class="community-grid">
            <a href="/community/1" class="community-item">
                <div class="community-thumb">
                    <img src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=120&q=70"
                         alt="강아지" onerror="this.src='https://placehold.co/120x120/EAF7F2/2BAB82?text=🐶'">
                </div>
                <div class="community-content">
                    <p class="community-title">강아지 사료 추천 부탁드려요!</p>
                    <p class="community-desc">우리 강아지가 잘 먹는 사료를 찾고 있어요 :)</p>
                    <div class="community-meta">
                        <span class="time">댕댕이맘 · 10분 전</span>
                        <span class="comment">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            12
                        </span>
                    </div>
                </div>
            </a>

            <a href="/community/2" class="community-item">
                <div class="community-thumb">
                    <img src="https://images.unsplash.com/photo-1615789591457-74a63395c990?w=120&q=70"
                         alt="유기견" onerror="this.src='https://placehold.co/120x120/EAF7F2/2BAB82?text=🐾'">
                </div>
                <div class="community-content">
                    <p class="community-title">유기견 입양 후 3개월 후기</p>
                    <p class="community-desc">우리 가족이 된 아이, 정말 행복해요 🐾</p>
                    <div class="community-meta">
                        <span class="time">행복한입양 · 3시간 전</span>
                        <span class="comment">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            21
                        </span>
                    </div>
                </div>
            </a>

            <a href="/community/3" class="community-item">
                <div class="community-thumb">
                    <img src="https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=120&q=70"
                         alt="고양이" onerror="this.src='https://placehold.co/120x120/EAF7F2/2BAB82?text=🐱'">
                </div>
                <div class="community-content">
                    <p class="community-title">고양이 눈물 자국 없애는 방법 있을까요?</p>
                    <p class="community-desc">눈물 자국이 자꾸 생겨서 고민이에요ㅠㅠ</p>
                    <div class="community-meta">
                        <span class="time">냥님사 · 1시간 전</span>
                        <span class="comment">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            8
                        </span>
                    </div>
                </div>
            </a>

            <a href="/community/4" class="community-item">
                <div class="community-thumb">
                    <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=120&q=70"
                         alt="강아지 피부" onerror="this.src='https://placehold.co/120x120/EAF7F2/2BAB82?text=🐶'">
                </div>
                <div class="community-content">
                    <p class="community-title">강아지 피부 가려움증 해결 방법</p>
                    <p class="community-desc">긁는 게 너무 심해서 병원 다녀왔어요</p>
                    <div class="community-meta">
                        <span class="time">수의사왕팬 · 4시간 전</span>
                        <span class="comment">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            17
                        </span>
                    </div>
                </div>
            </a>

            <a href="/community/5" class="community-item">
                <div class="community-thumb">
                    <img src="https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=120&q=70"
                         alt="애견 카페" onerror="this.src='https://placehold.co/120x120/EAF7F2/2BAB82?text=🏠'">
                </div>
                <div class="community-content">
                    <p class="community-title">주말에 가기 좋은 애견동반 카페 추천</p>
                    <p class="community-desc">서울 근교 애견동반 가능한 카페 추천해요!</p>
                    <div class="community-meta">
                        <span class="time">여행아마 · 2시간 전</span>
                        <span class="comment">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            15
                        </span>
                    </div>
                </div>
            </a>

            <a href="/community/6" class="community-item">
                <div class="community-thumb">
                    <img src="https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=120&q=70"
                         alt="펫드라이어" onerror="this.src='https://placehold.co/120x120/EAF7F2/2BAB82?text=💨'">
                </div>
                <div class="community-content">
                    <p class="community-title">펫드라이어 사용 후기</p>
                    <p class="community-desc">드라이어를 정말 잘 편하네요! 추천합니다 👍</p>
                    <div class="community-meta">
                        <span class="time">꼼꼼리뷰 · 5시간 전</span>
                        <span class="comment">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                            </svg>
                            9
                        </span>
                    </div>
                </div>
            </a>
        </div>
    </section>

</main>

<%-- ===== FOOTER ===== --%>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script src="${contextPath}/resources/js/main.js"></script>
