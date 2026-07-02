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
                    <p class="hero-desc">쇼핑부터 병원 예약, 여가까지<br>펫린이 하나로 간편하게!</p>
                    <a href="/store" class="hero-cta">지금 시작하기</a>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=480&q=80"
                         alt="강아지와 고양이" onerror="this.src='https://placehold.co/480x300/EAF7F2/2BAB82?text=펫린이'">
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
                    <%-- <a href="/hospital" class="hero-cta">병원 예약하기</a> --%>
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
                    <%-- <a href="/store" class="hero-cta">쇼핑 시작하기</a> --%>
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

    <%-- 인기상품 --%>
    <section class="section-wrap">
        <div class="section-head">
            <h2 class="section-title">인기상품</h2>
            <a href="${contextPath}/store" class="section-more">더보기</a>
        </div>
        <div class="home-product-grid">
            <a href="${contextPath}/store/detail?id=1" class="home-product-card">
                <img class="home-product-thumb" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=400&q=70&auto=format&fit=crop" alt="로얄캐닌 사료"
                     onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
                <div class="home-product-body">
                    <div class="home-product-name">로얄캐닌 미디엄 어덜트 사료 4kg</div>
                    <div class="home-product-price"><span class="home-product-rate">11%</span>48,900원</div>
                </div>
            </a>
            <a href="${contextPath}/store/detail?id=2" class="home-product-card">
                <img class="home-product-thumb" src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&q=70&auto=format&fit=crop" alt="노즈워크 매트"
                     onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
                <div class="home-product-body">
                    <div class="home-product-name">노즈워크 매트 오렌지</div>
                    <div class="home-product-price">18,500원</div>
                </div>
            </a>
            <a href="${contextPath}/store/detail?id=3" class="home-product-card">
                <img class="home-product-thumb" src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=400&q=70&auto=format&fit=crop" alt="수제 져키"
                     onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
                <div class="home-product-body">
                    <div class="home-product-name">수제 져키 트릿 200g</div>
                    <div class="home-product-price"><span class="home-product-rate">15%</span>13,000원</div>
                </div>
            </a>
            <a href="${contextPath}/store/detail?id=4" class="home-product-card">
                <img class="home-product-thumb" src="https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=400&q=70&auto=format&fit=crop" alt="펫 하네스"
                     onerror="this.src='https://placehold.co/400x400/EAF7F2/2BAB82?text=상품'">
                <div class="home-product-body">
                    <div class="home-product-name">H형 하네스 M 블루</div>
                    <div class="home-product-price">22,000원</div>
                </div>
            </a>
        </div>
    </section>


    <%-- 커뮤니티 --%>
    <section class="section-wrap">
        <div class="section-head">
            <h2 class="section-title">커뮤니티</h2>
            <a href="${contextPath}/community" class="section-more">더보기</a>
        </div>
        <div class="community-grid">
            <a href="${contextPath}/community/detail?id=1" class="community-item">
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

            <a href="${contextPath}/community/detail?id=2" class="community-item">
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

            <a href="${contextPath}/community/detail?id=3" class="community-item">
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

            <a href="${contextPath}/community/detail?id=4" class="community-item">
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

            <a href="${contextPath}/community/detail?id=5" class="community-item">
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

            <a href="${contextPath}/community/detail?id=6" class="community-item">
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
