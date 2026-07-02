<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="notifications" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- ── 알림함 ── --%>
<div class="mp-section active">
    <h2 class="mp-title">알림함</h2>
    <p class="mp-desc">읽지 않은 알림 <strong style="color:var(--accent)">3개</strong></p>
    <div class="noti-actions">
        <button class="btn-sm">전체 읽음</button>
        <button class="btn-sm danger">전체 삭제</button>
    </div>
    <div class="mp-tab-bar">
        <button class="mp-tab on">전체</button>
        <button class="mp-tab">주문</button>
        <button class="mp-tab">예약</button>
        <button class="mp-tab">공지</button>
    </div>
    <div class="noti-list">
        <div class="noti-item unread">
            <div class="noti-dot"></div>
            <div class="noti-icon order">
                <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </div>
            <div class="noti-body">
                <div class="noti-msg">주문하신 <b>로얄캐닌 미디엄 어덜트 사료</b>가 출고되었습니다. 송장번호: 123-456-7890</div>
                <div class="noti-time">방금 전</div>
            </div>
        </div>
        <div class="noti-item unread">
            <div class="noti-dot"></div>
            <div class="noti-icon resv">
                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="16" y1="2" x2="16" y2="6"/></svg>
            </div>
            <div class="noti-body">
                <div class="noti-msg"><b>행복 동물병원</b> 예약이 확정되었습니다. — 7월 5일 오전 10:00</div>
                <div class="noti-time">1시간 전</div>
            </div>
        </div>
        <div class="noti-item unread">
            <div class="noti-dot"></div>
            <div class="noti-icon notice">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            </div>
            <div class="noti-body">
                <div class="noti-msg">[공지] 7월 여름맞이 최대 30% 할인 이벤트가 시작되었습니다!</div>
                <div class="noti-time">3시간 전</div>
            </div>
        </div>
        <div class="noti-item">
            <div class="noti-dot read"></div>
            <div class="noti-icon chat">
                <svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
            </div>
            <div class="noti-body">
                <div class="noti-msg"><b>냥냥 그루밍샵</b>에서 예약 취소 안내 메시지를 보냈습니다.</div>
                <div class="noti-time">어제 오후 4:22</div>
            </div>
        </div>
        <div class="noti-item">
            <div class="noti-dot read"></div>
            <div class="noti-icon order">
                <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </div>
            <div class="noti-body">
                <div class="noti-msg">주문 <b>#ORD-20250528-002</b> 취소가 완료되었습니다. 환불은 2~3 영업일 내 처리됩니다.</div>
                <div class="noti-time">2025.05.28</div>
            </div>
        </div>
    </div>
</div>



<script>
document.querySelectorAll('.mp-tab-bar .mp-tab').forEach(function(tab) {
    tab.addEventListener('click', function() {
        var bar = this.closest('.mp-tab-bar');
        bar.querySelectorAll('.mp-tab').forEach(function(t){ t.classList.remove('on'); });
        this.classList.add('on');
    });
});
</script>

</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
