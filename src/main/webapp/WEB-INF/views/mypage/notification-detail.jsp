<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="notifications" />
<c:set var="notiType" value="${empty param.type ? 'order' : param.type}" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<style>
.noti-detail-back{display:inline-flex;align-items:center;gap:6px;font-size:14px;color:var(--text-muted);text-decoration:none;margin-bottom:20px}
.noti-detail-back:hover{color:var(--primary)}
.noti-detail-back svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.noti-detail-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:28px}
.noti-detail-type{display:inline-flex;align-items:center;gap:8px;font-size:12px;font-weight:700;padding:4px 12px;border-radius:20px;margin-bottom:14px}
.noti-type-order{background:#EEF2FF;color:#3B5BDB}
.noti-type-resv{background:#E0F2FE;color:#0284C7}
.noti-type-notice{background:#FFF8E1;color:#F59E0B}
.noti-type-chat{background:#F3E8FF;color:#7C3AED}
.noti-detail-title{font-size:20px;font-weight:800;color:var(--text-main);margin-bottom:10px;line-height:1.4}
.noti-detail-time{font-size:13px;color:var(--text-muted);margin-bottom:24px;padding-bottom:20px;border-bottom:1px solid var(--border)}
.noti-detail-body{font-size:15px;color:var(--text-sub);line-height:1.8;margin-bottom:28px}
.noti-detail-box{background:#F8FAFC;border:1px solid var(--border);border-radius:var(--radius-sm);padding:18px;margin-bottom:24px}
.noti-detail-box dt{font-size:12px;font-weight:700;color:var(--text-muted);margin-bottom:4px}
.noti-detail-box dd{font-size:14px;font-weight:600;color:var(--text-main);margin:0 0 14px}
.noti-detail-box dd:last-child{margin-bottom:0}
.noti-detail-actions{display:flex;gap:10px;flex-wrap:wrap}
.noti-detail-actions a,.noti-detail-actions button{padding:10px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:700;cursor:pointer;text-decoration:none}
.btn-noti-primary{background:var(--primary);color:#fff;border:none}
.btn-noti-outline{background:#fff;color:var(--text-sub);border:1px solid var(--border)}
</style>

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<div class="mp-section active">
    <a href="${contextPath}/mypage/notifications" class="noti-detail-back">
        <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
        알림함으로
    </a>

    <div class="noti-detail-card">
        <c:choose>
        <%-- 주문 출고 --%>
        <c:when test="${notiType eq 'order'}">
            <span class="noti-detail-type noti-type-order">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                주문 알림
            </span>
            <h2 class="noti-detail-title">주문하신 상품이 출고되었습니다</h2>
            <div class="noti-detail-time">2025.07.01 14:32</div>
            <div class="noti-detail-body">
                안녕하세요, <strong>${memberInfo.memberName}</strong>님.<br>
                주문하신 <strong>로얄캐닌 미디엄 어덜트 사료 4kg</strong> 상품이 출고되었습니다.
                택배사에서 배송이 시작되면 알림을 다시 보내드립니다.
            </div>
            <dl class="noti-detail-box">
                <dt>주문번호</dt><dd>#ORD-2025-0892</dd>
                <dt>송장번호</dt><dd>CJ대한통운 123-456-789012</dd>
                <dt>배송지</dt><dd>서울특별시 강남구 테헤란로 123, 101동 1204호</dd>
            </dl>
            <div class="noti-detail-actions">
                <a href="${contextPath}/mypage/orders" class="btn-noti-primary">주문내역 보기</a>
                <a href="${contextPath}/store/order-complete" class="btn-noti-outline">배송 조회</a>
            </div>
        </c:when>

        <%-- 주문 취소 --%>
        <c:when test="${notiType eq 'order-cancel'}">
            <span class="noti-detail-type noti-type-order">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                주문 알림
            </span>
            <h2 class="noti-detail-title">주문 취소가 완료되었습니다</h2>
            <div class="noti-detail-time">2025.05.28 11:20</div>
            <div class="noti-detail-body">
                주문 <strong>#ORD-20250528-002</strong> 취소가 완료되었습니다.<br>
                환불은 결제 수단에 따라 2~3 영업일 내 처리됩니다.
            </div>
            <dl class="noti-detail-box">
                <dt>주문번호</dt><dd>#ORD-20250528-002</dd>
                <dt>환불 예정 금액</dt><dd>26,000원</dd>
                <dt>결제 수단</dt><dd>신용카드 (일시불)</dd>
            </dl>
            <div class="noti-detail-actions">
                <a href="${contextPath}/mypage/orders" class="btn-noti-primary">주문내역 보기</a>
            </div>
        </c:when>

        <%-- 예약 확정 --%>
        <c:when test="${notiType eq 'resv'}">
            <span class="noti-detail-type noti-type-resv">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                예약 알림
            </span>
            <h2 class="noti-detail-title">병원 예약이 확정되었습니다</h2>
            <div class="noti-detail-time">2025.07.01 13:32</div>
            <div class="noti-detail-body">
                <strong>행복 동물병원</strong> 예약이 확정되었습니다.<br>
                예약 시간 10분 전까지 방문해 주세요. 변경·취소는 마이페이지 예약내역에서 가능합니다.
            </div>
            <dl class="noti-detail-box">
                <dt>업체명</dt><dd>행복 동물병원</dd>
                <dt>예약 일시</dt><dd>2025.07.05 (토) 오전 10:00</dd>
                <dt>반려동물</dt><dd>초코 (말티즈)</dd>
                <dt>예약 번호</dt><dd>#RSV-2025-0712</dd>
            </dl>
            <div class="noti-detail-actions">
                <a href="${contextPath}/mypage/reserve" class="btn-noti-primary">예약내역 보기</a>
                <a href="${contextPath}/hospital/detail" class="btn-noti-outline">업체 정보</a>
            </div>
        </c:when>

        <%-- 공지 --%>
        <c:when test="${notiType eq 'notice'}">
            <span class="noti-detail-type noti-type-notice">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/></svg>
                공지 알림
            </span>
            <h2 class="noti-detail-title">7월 여름맞이 최대 30% 할인 이벤트</h2>
            <div class="noti-detail-time">2025.07.01 11:00</div>
            <div class="noti-detail-body">
                PetCare 여름맞이 대축제가 시작되었습니다!<br>
                사료·간식·용품 전 품목 최대 30% 할인과 추가 쿠폰 혜택을 만나보세요.
                이벤트 기간: 2025.07.01 ~ 2025.07.31
            </div>
            <dl class="noti-detail-box">
                <dt>이벤트 기간</dt><dd>2025.07.01 ~ 2025.07.31</dd>
                <dt>할인 범위</dt><dd>쇼핑몰 전 품목 최대 30%</dd>
            </dl>
            <div class="noti-detail-actions">
                <a href="${contextPath}/event" class="btn-noti-primary">이벤트 보러가기</a>
                <a href="${contextPath}/member/cs/notice?id=1" class="btn-noti-outline">공지 전문 보기</a>
            </div>
        </c:when>

        <%-- 메시지/채팅 --%>
        <c:otherwise>
            <span class="noti-detail-type noti-type-chat">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
                메시지 알림
            </span>
            <h2 class="noti-detail-title">예약 취소 안내 메시지</h2>
            <div class="noti-detail-time">2025.06.30 16:22</div>
            <div class="noti-detail-body">
                <strong>냥냥 그루밍샵</strong>에서 예약 취소 안내 메시지를 보냈습니다.<br><br>
                안녕하세요. 요청하신 6월 28일 오후 2시 예약이 업체 사정으로 취소되었습니다.
                불편을 드려 죄송합니다. 다른 시간대로 재예약을 원하시면 답장해 주세요.
            </div>
            <dl class="noti-detail-box">
                <dt>보낸 업체</dt><dd>냥냥 그루밍샵</dd>
                <dt>취소된 예약</dt><dd>2025.06.28 (토) 오후 2:00</dd>
            </dl>
            <div class="noti-detail-actions">
                <a href="${contextPath}/mypage/reserve" class="btn-noti-primary">예약내역 보기</a>
                <a href="${contextPath}/grooming" class="btn-noti-outline">다시 예약하기</a>
            </div>
        </c:otherwise>
        </c:choose>

        <button type="button" class="btn-noti-outline" style="margin-top:12px" onclick="location.href='${contextPath}/mypage/notifications'">목록으로</button>
    </div>
</div>

</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
