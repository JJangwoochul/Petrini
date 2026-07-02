<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="cs" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
.cs-hero{background:linear-gradient(135deg,#1F8464 0%,#2BAB82 60%,#5BC8A8 100%);padding:48px 0;text-align:center;color:#fff}
.cs-hero h1{font-size:28px;font-weight:800;margin:0 0 8px}
.cs-hero p{font-size:14px;opacity:.9;margin:0}
.cs-wrap{max-width:var(--inner-width);margin:36px auto 80px;padding:0 20px}
.cs-contact{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:36px}
.cs-contact-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;text-align:center}
.cs-contact-card svg{width:32px;height:32px;stroke:var(--primary);fill:none;stroke-width:1.8;margin-bottom:12px}
.cs-contact-card h3{font-size:15px;font-weight:800;margin:0 0 6px;color:var(--text-main)}
.cs-contact-card p{font-size:13px;color:var(--text-muted);margin:0}
.cs-contact-card strong{display:block;font-size:18px;font-weight:800;color:var(--primary);margin-top:8px}
.cs-section{margin-bottom:36px}
.cs-section-title{font-size:18px;font-weight:800;color:var(--text-main);margin-bottom:16px;padding-bottom:12px;border-bottom:2px solid var(--border)}
.cs-faq-item{border:1px solid var(--border);border-radius:var(--radius-sm);margin-bottom:10px;overflow:hidden}
.cs-faq-q{width:100%;padding:16px 18px;background:#fff;border:none;text-align:left;font-size:14px;font-weight:700;color:var(--text-main);cursor:pointer;display:flex;justify-content:space-between;align-items:center}
.cs-faq-q:hover{background:#F8FAFC}
.cs-faq-a{display:none;padding:0 18px 16px;font-size:14px;color:var(--text-sub);line-height:1.7}
.cs-faq-item.open .cs-faq-a{display:block}
.cs-notice-list{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden}
.cs-notice-item{display:flex;align-items:center;gap:12px;padding:14px 18px;border-bottom:1px solid var(--border);text-decoration:none;color:inherit;transition:var(--transition)}
.cs-notice-item:last-child{border-bottom:none}
.cs-notice-item:hover{background:#F8FAFC}
.cs-notice-badge{font-size:11px;font-weight:700;padding:3px 8px;border-radius:4px;background:var(--primary-light);color:var(--primary-dark);flex-shrink:0}
.cs-notice-title{flex:1;font-size:14px;font-weight:600;color:var(--text-main);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.cs-notice-date{font-size:12px;color:var(--text-muted);flex-shrink:0}
@media(max-width:768px){.cs-contact{grid-template-columns:1fr}}
</style>

<div class="cs-hero">
    <div class="cs-wrap" style="margin:0 auto;padding:0 20px">
        <h1>고객센터</h1>
        <p>PetCare 이용 중 궁금한 점을 빠르게 해결해 드립니다</p>
    </div>
</div>

<div class="cs-wrap">
    <div class="cs-contact">
        <div class="cs-contact-card">
            <svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/></svg>
            <h3>전화 문의</h3>
            <p>평일 09:00 ~ 18:00</p>
            <strong>1588-0000</strong>
        </div>
        <div class="cs-contact-card">
            <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
            <h3>이메일 문의</h3>
            <p>24시간 접수</p>
            <strong>help@petcare.kr</strong>
        </div>
        <div class="cs-contact-card">
            <svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
            <h3>1:1 문의</h3>
            <p>문의 내역 확인 및 작성</p>
            <strong><a href="${contextPath}/member/cs/inquiry" style="color:var(--primary);text-decoration:none">문의하기 →</a></strong>
        </div>
    </div>

    <section class="cs-section">
        <h2 class="cs-section-title">자주 묻는 질문</h2>
        <div class="cs-faq-item">
            <button type="button" class="cs-faq-q" onclick="this.parentElement.classList.toggle('open')">
                예약 취소는 어떻게 하나요?
                <span>+</span>
            </button>
            <div class="cs-faq-a">마이페이지 &gt; 예약내역에서 해당 예약의 취소 버튼을 눌러주세요. 업체별 취소 정책에 따라 수수료가 발생할 수 있습니다.</div>
        </div>
        <div class="cs-faq-item">
            <button type="button" class="cs-faq-q" onclick="this.parentElement.classList.toggle('open')">
                주문 배송은 얼마나 걸리나요?
                <span>+</span>
            </button>
            <div class="cs-faq-a">결제 완료 후 영업일 기준 1~3일 내 출고되며, 지역에 따라 배송에 1~2일이 추가 소요됩니다.</div>
        </div>
        <div class="cs-faq-item">
            <button type="button" class="cs-faq-q" onclick="this.parentElement.classList.toggle('open')">
                사업자 등록은 어떻게 신청하나요?
                <span>+</span>
            </button>
            <div class="cs-faq-a">마이페이지 &gt; 사업자센터 &gt; 사업자 등록 신청에서 업종과 서류를 제출해 주세요. 관리자 승인 후 이용 가능합니다.</div>
        </div>
        <div class="cs-faq-item">
            <button type="button" class="cs-faq-q" onclick="this.parentElement.classList.toggle('open')">
                포인트는 어떻게 적립되나요?
                <span>+</span>
            </button>
            <div class="cs-faq-a">쇼핑 결제 금액의 1%가 포인트로 적립됩니다. 이벤트 기간에는 추가 적립 혜택이 제공될 수 있습니다.</div>
        </div>
    </section>

    <section class="cs-section">
        <h2 class="cs-section-title">공지사항</h2>
        <div class="cs-notice-list">
            <a href="${contextPath}/member/cs/notice?id=1" class="cs-notice-item">
                <span class="cs-notice-badge">공지</span>
                <span class="cs-notice-title">7월 여름맞이 최대 30% 할인 이벤트 안내</span>
                <span class="cs-notice-date">2025.07.01</span>
            </a>
            <a href="${contextPath}/member/cs/notice?id=2" class="cs-notice-item">
                <span class="cs-notice-badge">공지</span>
                <span class="cs-notice-title">PetCare 서비스 이용약관 개정 안내</span>
                <span class="cs-notice-date">2025.06.20</span>
            </a>
            <a href="${contextPath}/member/cs/notice?id=3" class="cs-notice-item">
                <span class="cs-notice-badge">안내</span>
                <span class="cs-notice-title">시스템 점검 안내 (6/15 02:00~04:00)</span>
                <span class="cs-notice-date">2025.06.10</span>
            </a>
        </div>
    </section>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
