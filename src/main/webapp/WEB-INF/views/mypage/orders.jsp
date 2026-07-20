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
                        <div style="display:flex;align-items:center;gap:10px">
                            <%-- 지윤 26.07.20 수정: badge-ready/badge-done/badge-cancel 하드코딩 -> 실제 ORDER_STATUS 값에 따라 JSTL로 분기 --%>
                            <c:choose>
                                <c:when test="${o.orderStatus == 'PAID'}"><span class="badge-status badge-ready">결제완료</span></c:when>
                                <c:when test="${o.orderStatus == 'READY'}"><span class="badge-status badge-ready">배송준비</span></c:when>
                                <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="badge-status badge-ready">배송중</span></c:when>
                                <c:when test="${o.orderStatus == 'DONE'}"><span class="badge-status badge-done">배송완료</span></c:when>
                                <c:when test="${o.orderStatus == 'CANCEL'}"><span class="badge-status badge-cancel">취소완료</span></c:when>
                            </c:choose>
                            <%-- 지윤 26.07.20 추가: 주문상세보기 - 결제내역/배송지까지 자세히 보여주는 읽기전용 페이지로 이동 --%>
                            <a href="${contextPath}/mypage/orders/detail?orderId=${o.orderId}" style="font-size:13px;color:var(--text-muted);text-decoration:none">주문상세보기 &gt;</a>
                        </div>
                    </div>

                    <%-- 지윤 26.07.20 수정: <div class="order-item"> 각 상품 블록을 <c:forEach>로 ${o.itemList} 반복 렌더링
                         지윤 26.07.20 수정: 교환/반품·리뷰작성·재구매를 카드 하단(주문 단위) -> 이 상품 줄 안(상품 단위)으로 이동.
                         한 주문에 상품이 여러 개면 상품마다 리뷰/재구매 대상이 다르기 때문 --%>
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
                        <%-- 지윤 26.07.20 추가: 상품별 액션 버튼 (교환/반품, 리뷰작성, 재구매). "배송조회"/"환불내역"은 주문 전체에 대한 거라 카드 하단에 그대로 둠 --%>
                        <div class="order-item-actions" style="display:flex;justify-content:flex-end;gap:8px;padding:0 0 14px">
                            <c:if test="${o.orderStatus == 'DONE'}">
                                <button class="btn-sm danger" onclick="alert('교환/반품 기능은 준비 중입니다.')">교환/반품</button>
                                <c:choose>
                                    <c:when test="${it.reviewed}">
                                        <button class="btn-sm" disabled>리뷰완료</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-sm" onclick="openReviewModal(${it.orderItemId}, '${fn:escapeXml(it.productName)}', '${fn:escapeXml(it.thumbnailUrl)}', '${fn:escapeXml(it.optionColor)}', '${fn:escapeXml(it.optionSize)}')">리뷰작성</button>
                                    </c:otherwise>
                                </c:choose>
                                <button class="btn-sm" onclick="location.href='${contextPath}/store/detail?id=${it.productId}'">재구매</button>
                            </c:if>
                        </div>
                    </c:forEach>

                    <%-- 지윤 26.07.20 수정: "배송조회"/"환불내역"은 상품별이 아니라 주문(배송) 전체에 대한 액션이라 카드 하단에 유지.
                         "교환/반품"/"리뷰작성"/"재구매"는 위 상품 줄 안으로 옮김 --%>
                    <c:if test="${o.orderStatus == 'SHIPPING' || o.orderStatus == 'CANCEL'}">
                        <div class="order-card-foot">
                            <c:if test="${o.orderStatus == 'SHIPPING'}">
                                <button class="btn-sm" onclick="alert('배송조회 기능은 준비 중입니다.')">배송조회</button>
                            </c:if>
                            <c:if test="${o.orderStatus == 'CANCEL'}">
                                <button class="btn-sm" onclick="alert('환불내역 기능은 준비 중입니다.')">환불내역</button>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<%-- 지윤 26.07.20 수정: 모달 내용이 빈약하다는 피드백 반영 - 상품 썸네일/옵션 표시, 별점 라벨, 글자수 카운터, 사진첨부(최대 5장) 추가
     hidden form + JS로 값 복사하던 방식 -> 모달 자체를 multipart/form-data form으로 바꿔서 그대로 submit --%>
<div id="reviewModalBg" class="review-modal-bg" style="display:none">
  <form id="reviewForm" class="review-modal" method="post" action="${contextPath}/mypage/orders/review"
        enctype="multipart/form-data" onsubmit="return validateReviewForm()">
    <button type="button" class="review-modal-close" onclick="closeReviewModal()">✕</button>
    <h3>⭐ 리뷰 작성</h3>

    <input type="hidden" name="orderItemId" id="reviewFormOrderItemId">

    <div class="review-modal-product-row">
      <img id="reviewModalThumb" src="" alt="" onerror="this.src='https://placehold.co/56x56/EAF7F2/2BAB82?text=IMG'">
      <div>
        <p id="reviewModalProductName" class="review-modal-product-name"></p>
        <p id="reviewModalOption" class="review-modal-option"></p>
      </div>
    </div>

    <div class="review-modal-stars" id="reviewModalStars">
      <span data-v="1">★</span><span data-v="2">★</span><span data-v="3">★</span><span data-v="4">★</span><span data-v="5">★</span>
    </div>
    <p id="reviewModalRatingLabel" class="review-modal-rating-label">별점을 선택해주세요</p>
    <input type="hidden" name="rating" id="reviewFormRating">

    <textarea name="content" id="reviewModalContent" maxlength="500"
              placeholder="상품은 어떠셨나요? 다른 분들에게 도움이 되는 후기를 남겨주세요."
              oninput="document.getElementById('reviewCharCount').textContent = this.value.length"></textarea>
    <div class="review-modal-counter"><span id="reviewCharCount">0</span>/500</div>

    <div class="review-modal-photo-section">
      <p class="review-modal-photo-label">사진 첨부 <span>(선택, 최대 5장)</span></p>
      <label class="review-modal-photo-add">
        <input type="file" name="images" id="reviewPhotoInput" accept="image/*" multiple onchange="handlePhotoSelect(this)">
        <span class="review-modal-photo-plus">+</span>
        <span id="reviewPhotoHint">사진 선택</span>
      </label>
      <div class="review-modal-photo-preview" id="reviewPhotoPreview"></div>
    </div>

    <div class="review-modal-actions">
      <button type="button" class="btn-sm" onclick="closeReviewModal()">취소</button>
      <button type="submit" class="btn-sm primary">등록</button>
    </div>
  </form>
</div>

<script>
  //지윤 26.07.20 수정: 모달이 곧 form이라 hidden form 복사 로직 삭제, submit 직전 검증만 남김
  var reviewRating = 0;

  function openReviewModal(orderItemId, productName, thumbnailUrl, optionColor, optionSize) {
    document.getElementById('reviewFormOrderItemId').value = orderItemId;
    document.getElementById('reviewModalProductName').textContent = productName;

    var optText = '';
    if (optionSize && optionSize !== 'undefined' && optionSize !== '') {
      optText = '옵션: ' + ((optionColor && optionColor !== '기본' && optionColor !== 'undefined') ? optionColor + ' / ' : '') + optionSize;
    }
    document.getElementById('reviewModalOption').textContent = optText;

    var thumb = document.getElementById('reviewModalThumb');
    thumb.src = (thumbnailUrl && thumbnailUrl !== 'undefined' && thumbnailUrl !== '')
      ? (thumbnailUrl.indexOf('http') === 0 ? thumbnailUrl : '${contextPath}/upload/' + thumbnailUrl)
      : 'https://placehold.co/56x56/EAF7F2/2BAB82?text=IMG';

    document.getElementById('reviewModalContent').value = '';
    document.getElementById('reviewCharCount').textContent = '0';
    document.getElementById('reviewPhotoInput').value = '';
    document.getElementById('reviewPhotoPreview').innerHTML = '';
    document.getElementById('reviewPhotoHint').textContent = '사진 선택';
    setStars(0);
    document.getElementById('reviewModalBg').style.display = 'flex';
  }

  function closeReviewModal() {
    document.getElementById('reviewModalBg').style.display = 'none';
  }

  var ratingLabels = ['별점을 선택해주세요', '아쉬워요', '별로예요', '보통이에요', '좋아요', '최고예요!'];

  function setStars(v) {
    reviewRating = v;
    document.getElementById('reviewFormRating').value = v;
    document.getElementById('reviewModalRatingLabel').textContent = ratingLabels[v];
    document.querySelectorAll('#reviewModalStars span').forEach(function (s) {
      s.classList.toggle('on', Number(s.dataset.v) <= v);
    });
  }

  document.querySelectorAll('#reviewModalStars span').forEach(function (s) {
    s.addEventListener('click', function () { setStars(Number(s.dataset.v)); });
  });

  //지윤 26.07.20 추가: 사진 선택 시 썸네일 미리보기 (최대 5장, 넘으면 경고만 하고 그대로 진행)
  function handlePhotoSelect(input) {
    var files = Array.from(input.files || []);
    if (files.length > 5) { alert('사진은 최대 5장까지 첨부할 수 있어요.'); }
    document.getElementById('reviewPhotoHint').textContent = files.length + '장 선택됨';

    var preview = document.getElementById('reviewPhotoPreview');
    preview.innerHTML = '';
    files.slice(0, 5).forEach(function (file) {
      var reader = new FileReader();
      reader.onload = function (e) {
        var img = document.createElement('img');
        img.src = e.target.result;
        preview.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  }

  function validateReviewForm() {
    if (reviewRating === 0) { alert('별점을 선택해주세요.'); return false; }
    var content = document.getElementById('reviewModalContent').value.trim();
    if (!content) { alert('리뷰 내용을 입력해주세요.'); return false; }
    return true;
  }
</script>

<%-- 지윤 26.07.20 삭제: <script> 안에 있던 filter-btn 클릭 시 active 클래스만 토글하던 JS -
     이제 필터 버튼 자체가 실제 <a href="?statusCd=..."> 링크라서 페이지 이동만으로 처리, JS 불필요해짐 --%>

</div><%-- /mypage-content --%>
</div><%-- /mypage-wrap --%>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>