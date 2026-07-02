<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- 신뢰 배지 -->
<section class="trust-bar">
    <div class="trust-inner">
        <div class="trust-item">
            <svg width="36" height="36" viewBox="0 0 36 36" fill="none">
                <rect width="36" height="36" rx="18" fill="#EAF7F2"/>
                <path d="M8 20l5 5 15-15" stroke="#2BAB82" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M26 10h2a2 2 0 0 1 2 2v2" stroke="#2BAB82" stroke-width="1.8" stroke-linecap="round"/>
                <rect x="6" y="14" width="14" height="10" rx="2" stroke="#2BAB82" stroke-width="1.8" fill="none"/>
            </svg>
            <div>
                <strong>무료 배송</strong>
                <span>3만원 이상 구매시</span>
            </div>
        </div>
        <div class="trust-item">
            <svg width="36" height="36" viewBox="0 0 36 36" fill="none">
                <rect width="36" height="36" rx="18" fill="#EAF7F2"/>
                <rect x="7" y="10" width="22" height="16" rx="3" stroke="#2BAB82" stroke-width="1.8" fill="none"/>
                <path d="M7 15h22" stroke="#2BAB82" stroke-width="1.8"/>
                <path d="M12 21h4M20 21h4" stroke="#2BAB82" stroke-width="1.8" stroke-linecap="round"/>
            </svg>
            <div>
                <strong>안심 결제</strong>
                <span>다양한 결제 수단</span>
            </div>
        </div>
        <div class="trust-item">
            <svg width="36" height="36" viewBox="0 0 36 36" fill="none">
                <rect width="36" height="36" rx="18" fill="#EAF7F2"/>
                <circle cx="18" cy="16" r="5" stroke="#2BAB82" stroke-width="1.8" fill="none"/>
                <path d="M10 28c0-4 3.6-7 8-7s8 3 8 7" stroke="#2BAB82" stroke-width="1.8" stroke-linecap="round"/>
            </svg>
            <div>
                <strong>전문 상담</strong>
                <span>1:1 상담 서비스</span>
            </div>
        </div>
        <div class="trust-item">
            <svg width="36" height="36" viewBox="0 0 36 36" fill="none">
                <rect width="36" height="36" rx="18" fill="#EAF7F2"/>
                <path d="M18 8l2.4 7.2H28l-6.4 4.6 2.4 7.2L18 22.6l-6 4.4 2.4-7.2L8 15.2h7.6z" stroke="#2BAB82" stroke-width="1.8" fill="none" stroke-linejoin="round"/>
            </svg>
            <div>
                <strong>멤버십 혜택</strong>
                <span>등급별 특별 혜택</span>
            </div>
        </div>
    </div>
</section>

<footer class="pc-footer">
    <div class="footer-inner">
        <div class="footer-left">
            <a href="/" class="footer-logo">
                <svg width="26" height="26" viewBox="0 0 32 32" fill="none">
                    <ellipse cx="16" cy="20" rx="9" ry="8" fill="#2BAB82"/>
                    <ellipse cx="8"  cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="13" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="19" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="24" cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <path d="M14.5 20.5 C14.5 19 16 18 16 18 C16 18 17.5 19 17.5 20.5 C17.5 22 16 23 16 23 C16 23 14.5 22 14.5 20.5Z" fill="white" opacity="0.85"/>
                </svg>
                <span>PetCare</span>
            </a>
            <p class="footer-desc">PetCare는 반려동물과 함께하는<br>행복한 삶을 응원합니다.</p>
        </div>

        <div class="footer-center">
            <nav class="footer-nav">
                <a href="/about">회사소개</a>
                <span class="divider">|</span>
                <a href="/terms">이용약관</a>
                <span class="divider">|</span>
                <a href="/privacy"><strong>개인정보처리방침</strong></a>
                <span class="divider">|</span>
                <a href="/location-terms">위치기반서비스 이용약관</a>
                <span class="divider">|</span>
                <a href="/cs">제휴문의</a>
            </nav>
            <p class="footer-copy">© 2024 PetCare. All rights reserved.</p>
        </div>

        <div class="footer-right">
            <div class="footer-cs">
                <span class="cs-label">고객센터</span>
                <span class="cs-number">1588-1234</span>
                <span class="cs-hours">평일 09:00 - 18:00 (토/일/공휴일 휴무)</span>
            </div>
            <div class="footer-social">
                <a href="#" class="social-btn" aria-label="Instagram">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <rect x="2" y="2" width="20" height="20" rx="5" ry="5"/>
                        <circle cx="12" cy="12" r="4"/>
                        <circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/>
                    </svg>
                </a>
                <a href="#" class="social-btn" aria-label="YouTube">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M22.54 6.42a2.78 2.78 0 0 0-1.95-1.96C18.88 4 12 4 12 4s-6.88 0-8.59.46A2.78 2.78 0 0 0 1.46 6.42 29 29 0 0 0 1 12a29 29 0 0 0 .46 5.58 2.78 2.78 0 0 0 1.95 1.96C5.12 20 12 20 12 20s6.88 0 8.59-.46a2.78 2.78 0 0 0 1.95-1.96A29 29 0 0 0 23 12a29 29 0 0 0-.46-5.58z"/>
                        <polygon points="9.75 15.02 15.5 12 9.75 8.98 9.75 15.02" fill="currentColor" stroke="none"/>
                    </svg>
                </a>
                <a href="#" class="social-btn" aria-label="Blog">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                        <path d="M7 9h10M7 12h6"/>
                    </svg>
                </a>
            </div>
        </div>
    </div>
</footer>
