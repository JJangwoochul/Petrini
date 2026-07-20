<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="orders" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- 지윤 26.07.20 수정: 하드코딩된 주문카드 3개 -> 실데이터 연동
     Controller: MypageOrderController.orders()
     Service: MypageOrderService.getOrderList()
     화면 레이아웃(카드 구조, CSS 클래스)은 원본 그대로 유지, 데이터 표시 로직만 실데이터로 교체 --%>
<div class="mp-section active">
    <h2 class="mp-title">주문내역</h2>
    <p class="mp-desc">최근 6개월 주문 내역입니다.</p>

    <%-- 지윤 26.07.20 수정: onclick="필터버튼 active 클래스만 토글" (실제 필터링 안 됨, 장식만 있던 버튼)
         -> <a href="?statusCd=..."> 실제 GET 요청으로 서버에서 필터링 --%>
    <div class="order-filter">
        <a href="${contextPath}/mypage/orders" class="filter-btn ${empty selectedStatusCd ? 'on' : ''}">전체</a>
        <a href="${contextPath}/mypage/orders?statusCd=READY" class="filter-btn ${selectedStatusCd == 'READY' ? 'on' : ''}">배송준비</a>
        <a href="${contextPath}/mypage/orders?statusCd=SHIPPING" class="filter-btn ${selectedStatusCd == 'SHIPPING' ? 'on' : ''}">배송중</a>
        <a href="${contextPath}/mypage/orders?statusCd=DONE" class="filter-btn ${selectedStatusCd == 'DONE' ? 'on' : ''}">배송완료</a>
        <a href="${contextPath}/mypage/orders?statusCd=CANCEL" class="filter-btn ${selectedStatusCd == 'CANCEL' ? 'on' : ''}">취소/반품</a>
    </div>

    <%-- 지윤 26.07.20 수정: 주문 카드 1/2/3 하드코딩 -> <c:forEach>로 ${orderList} 실데이터 반복 렌더링 --%>
    <c:choose>
        <c:when test="${empty orderList}">
            <p class="mp-empty" style="padding:40px 0;text-align:center;color:var(--text-muted)">주문 내역이 없습니다.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="o" items="${orderList}">
                <div class="order-card">
                    <div class="order-card-head">
                        <span>${o.orderDate} 주문 <strong>#${o.orderNo}</strong></span>
                        <%-- 지윤 26.07.20 수정: badge-ready/badge-done/badge-cancel 하드코딩 -> 실제 ORDER_STATUS 값에 따라 JSTL로 분기 --%>
                        <c:choose>
                            <c:when test="${o.orderStatus == 'PAID'}"><span class="badge-status badge-ready">결제완료</span></c:when>
                            <c:when test="${o.orderStatus == 'READY'}"><span class="badge-status badge-ready">배송준비</span></c:when>
                            <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge-status badge-ready">배송중</span></c:when>
                            <c:when test="${o.orderStatus == 'DONE'}"><span class="badge-status badge-done">배송완료</span></c:when>
                            <c:when test="${o.orderStatus == 'CANCEL'}"><span class="badge-status badge-cancel">취소완료</span></c:when>
                        </c:choose>
                    </div>

                    <%-- 지윤 26.07.20 수정: <div class="order-item"> 각 상품 블록을 <c:forEach>로 ${o.itemList} 반복 렌더링 --%>
                    <c:forEach var="it" items="${o.itemList}">
                        <div class="order-item">
                            <%-- 지윤 26.07.20 수정: unsplash 고정 이미지 URL -> 실제 상품 썸네일 (로컬업로드/외부URL 둘 다 지원하는 store 모듈 공통 패턴) --%>
                            <c:choose>
                                <c:when test="${not empty it.thumbnailUrl}">
                                    <img class="order-thumb"
                                         src="${fn:startsWith(it.thumbnailUrl, 'http') ? it.thumbnailUrl : contextPath.concat('/upload/').concat(it.thumbnailUrl)}"
                                         alt="${it.productName}"
                                         onerror="this.src='https://placehold.co/72x72/EAF7F2/2BAB82?text=IMG'">
                                </c:when>
                                <c:otherwise>
                                    <img class="order-thumb" src="https://placehold.co/72x72/EAF7F2/2BAB82?text=IMG" alt="${it.productName}">
                                </c:otherwise>
                            </c:choose>
                            <div class="order-info">
                                <div class="name">${it.productName}</div>
                                <%-- 지윤 26.07.20 수정: "수량 1개 · 옵션: 기본" 고정 문구 -> 실제 수량 + 옵션(기본이면 생략, products.jsp와 동일 컨벤션) --%>
                                <div class="meta">
                                    수량 ${it.qty}개
                                    <c:if test="${not empty it.optionSize}">
                                        · 옵션: <c:if test="${not empty it.optionColor && it.optionColor != '기본'}">${it.optionColor} / </c:if>${it.optionSize}
                                    </c:if>
                                </div>
                            </div>
                            <div class="order-price" style="${o.orderStatus == 'CANCEL' ? 'text-decoration:line-through;color:var(--text-muted)' : ''}">
                                <fmt:formatNumber value="${it.totalPrice}" pattern="#,###"/>원
                            </div>
                        </div>
                    </c:forEach>

                    <%-- 지윤 26.07.20 수정: 카드마다 버튼 하드코딩 -> 상태별로 JSTL 분기.
                         "배송조회"/"리뷰작성"/"교환·반품"/"환불내역"은 아직 실제로 연결할 기능(배송추적, 리뷰작성, 반품신청) 자체가
                         프로젝트에 없어서 클릭하면 안내 문구만 뜨는 자리표시자임. "재구매"만 실제 상품 상세페이지로 이동하는 진짜 기능임 --%>
                    <div class="order-card-foot">
                        <c:if test="${o.orderStatus == 'SHIPPING'}">
                            <button class="btn-sm" onclick="alert('배송조회 기능은 준비 중입니다.')">배송조회</button>
                        </c:if>
                        <c:if test="${o.orderStatus == 'DONE'}">
                            <button class="btn-sm danger" onclick="alert('교환/반품 기능은 준비 중입니다.')">교환/반품</button>
                            <button class="btn-sm" onclick="alert('리뷰작성 기능은 준비 중입니다.')">리뷰작성</button>
                            <c:if test="${not empty o.itemList}">
                                <button class="btn-sm" onclick="location.href='${contextPath}/store/detail?id=${o.itemList[0].productId}'">재구매</button>
                            </c:if>
                        </c:if>
                        <c:if test="${o.orderStatus == 'CANCEL'}">
                            <button class="btn-sm" onclick="alert('환불내역 기능은 준비 중입니다.')">환불내역</button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<%-- 지윤 26.07.20 삭제: <script> 안에 있던 filter-btn 클릭 시 active 클래스만 토글하던 JS -
     이제 필터 버튼 자체가 실제 <a href="?statusCd=..."> 링크라서 페이지 이동만으로 처리, JS 불필요해짐 --%>

</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
