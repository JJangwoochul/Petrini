<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="orders" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 지윤 26.07.20 수정: 하드코딩(JS mock 배열 orders[]) -> 실데이터 연동
     Controller: BizStoreController.storeOrders() / getOrderDetailJson() / updateOrderStatus()
     Service: BizStoreService.getOrderList / getOrderDetail / updateOrderStatus
     화면 레이아웃(CSS, HTML 뼈대)은 원본 그대로 유지, 데이터 표시/저장 로직만 실데이터로 교체 --%>
<style>
  .order-detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:24px;padding:20px}
  .order-detail-grid h4{font-size:13px;font-weight:700;color:#1A1A2E;margin:0 0 10px}
  .order-info-row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #F0F2F0;font-size:13px}
  .order-info-row span:first-child{color:#999}
  .order-info-row span:last-child{color:#1A1A2E;font-weight:600}
  .order-ship-manage{display:flex;flex-direction:column;gap:10px;margin-top:14px}
  .order-ship-manage label{font-size:12px;color:#666;display:block;margin-bottom:4px}
  .order-ship-manage select,.order-ship-manage input{width:100%;border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px}
  .order-items-table{padding:0 20px 20px}
  .order-total-row{display:flex;justify-content:flex-end;gap:16px;padding:14px 4px;font-size:14px;font-weight:700;color:#1A1A2E;border-top:1px solid var(--biz-border)}
  .order-detail-actions{display:flex;justify-content:center;gap:10px;padding:0 20px 20px}
  .order-detail-actions .biz-btn-primary{min-width:120px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">주문 관리</h1>
    <p class="biz-page-desc">주문 확인·출고 처리·취소/반품 처리</p>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div style="padding:20px 20px 0">
      <%-- 지윤 26.07.20 수정: <button onclick="switchTab(...)"> (JS로 배열 필터링) -> <a href="?statusCd=..."> (서버에 GET 요청, statusCd 파라미터로 필터)
           탭 옆 숫자도 JS로 orders.filter().length 세던 것 -> Controller가 넘겨준 statusCounts(Map)로 표시 --%>
      <div class="biz-tabs">
        <a href="${contextPath}/biz/store/orders" class="biz-tab ${empty selectedStatusCd ? 'active' : ''}">전체<span class="biz-tab-count">${statusCounts.PAID + statusCounts.READY + statusCounts.SHIPPING + statusCounts.DONE + statusCounts.CANCEL}</span></a>
        <a href="${contextPath}/biz/store/orders?statusCd=PAID" class="biz-tab ${selectedStatusCd == 'PAID' ? 'active' : ''}">결제완료<span class="biz-tab-count">${statusCounts.PAID}</span></a>
        <a href="${contextPath}/biz/store/orders?statusCd=READY" class="biz-tab ${selectedStatusCd == 'READY' ? 'active' : ''}">배송준비<span class="biz-tab-count">${statusCounts.READY}</span></a>
        <a href="${contextPath}/biz/store/orders?statusCd=SHIPPING" class="biz-tab ${selectedStatusCd == 'SHIPPING' ? 'active' : ''}">배송중<span class="biz-tab-count">${statusCounts.SHIPPING}</span></a>
        <a href="${contextPath}/biz/store/orders?statusCd=DONE" class="biz-tab ${selectedStatusCd == 'DONE' ? 'active' : ''}">배송완료<span class="biz-tab-count">${statusCounts.DONE}</span></a>
        <a href="${contextPath}/biz/store/orders?statusCd=CANCEL" class="biz-tab ${selectedStatusCd == 'CANCEL' ? 'active' : ''}">취소/반품<span class="biz-tab-count">${statusCounts.CANCEL}</span></a>
      </div>
    </div>

    <table class="biz-table">
      <thead><tr><th>주문번호</th><th>구매자</th><th>상품명</th><th>결제금액</th><th>상태</th><th>관리</th></tr></thead>
      <%-- 지윤 26.07.20 수정: <tbody id="orderBody"></tbody> (JS render()가 채워넣던 빈 껍데기)
           -> JSTL <c:forEach>로 ${orderList}(Controller가 넘겨준 실데이터) 바로 렌더링. render() 함수 자체가 필요없어져서 삭제됨 --%>
      <tbody>
        <c:choose>
          <c:when test="${empty orderList}">
            <tr><td colspan="6" style="text-align:center;color:#999;padding:24px 0">해당하는 주문이 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="o" items="${orderList}">
              <tr>
                <td>#${o.orderNo}</td>
                <td>${o.buyerName}</td>
                <td>
                  ${o.firstProductName}
                  <c:if test="${o.itemCount > 1}"> 외 ${o.itemCount - 1}건</c:if>
                </td>
                <td><fmt:formatNumber value="${o.payAmount}" pattern="#,###"/>원</td>
                <%-- 지윤 26.07.20 수정: JS statusBadgeClass 딕셔너리 조회 -> JSTL c:choose로 상태별 배지 클래스 직접 분기 --%>
                <td>
                  <c:choose>
                    <c:when test="${o.orderStatus == 'PAID'}"><span class="bs-badge bs-wait">결제완료</span></c:when>
                    <c:when test="${o.orderStatus == 'READY'}"><span class="bs-badge bs-empty">배송준비</span></c:when>
                    <c:when test="${o.orderStatus == 'SHIPPING'}"><span class="bs-badge bs-ready">배송중</span></c:when>
                    <c:when test="${o.orderStatus == 'DONE'}"><span class="bs-badge bs-done">배송완료</span></c:when>
                    <c:when test="${o.orderStatus == 'CANCEL'}"><span class="bs-badge bs-cancel">취소/반품</span></c:when>
                    <c:otherwise><span class="bs-badge bs-empty">${o.orderStatus}</span></c:otherwise>
                  </c:choose>
                </td>
                <%-- 지윤 26.07.20 수정: onclick="openDetail('ORD-2026-0892')" (문자열 주문코드로 배열 검색)
                     -> onclick="openDetail(25)" (진짜 ORDER_ID 숫자키로 AJAX 조회) --%>
                <td><button class="biz-btn" onclick="openDetail(${o.orderId})">상세</button></td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <%-- 아래 상세보기 HTML 뼈대(레이아웃)는 원본 그대로, 안 건드림 --%>
  <div class="biz-card" id="detailCard" style="display:none">
    <div class="biz-card-head"><span>주문 상세정보</span></div>

    <div class="order-detail-grid">
      <div>
        <h4>주문 정보</h4>
        <div class="order-info-row"><span>주문번호</span><span id="dOrderNo"></span></div>
        <div class="order-info-row"><span>주문일</span><span id="dOrderDate"></span></div>
        <div class="order-info-row"><span>구매자</span><span id="dBuyer"></span></div>
        <div class="order-info-row"><span>연락처</span><span id="dPhone"></span></div>
        <div class="order-info-row"><span>이메일</span><span id="dEmail"></span></div>
        <div class="order-info-row"><span>결제금액</span><span id="dPayAmount"></span></div>
        <div class="order-info-row"><span>결제방법</span><span id="dPayMethod"></span></div>
        <div class="order-info-row"><span>주문상태</span><span id="dStatusLabel"></span></div>
      </div>

      <div>
        <h4>배송 정보</h4>
        <div class="order-info-row"><span>수령인</span><span id="dReceiver"></span></div>
        <div class="order-info-row"><span>연락처</span><span id="dReceiverPhone"></span></div>
        <div class="order-info-row"><span>배송지</span><span id="dAddress"></span></div>
        <%-- 지윤 26.07.20 삭제: <div class="order-info-row"><span>배송메모</span><span id="dMemo"></span></div>
             TB_ORDER_DELIVERY에 MEMO 컬럼은 있지만 이번 작업 범위에서 조회 안 함 -> 화면에서도 뺌 (필요하면 나중에 추가) --%>

        <div class="order-ship-manage">
          <div>
            <label>주문상태</label>
            <%-- 지윤 26.07.20 수정: value="paid" 등 소문자 임의값 -> value="PAID" 등 실제 DB(TB_ORDER.ORDER_STATUS) 코드값으로 통일 --%>
            <select id="dStatusSelect">
              <option value="PAID">결제완료</option>
              <option value="READY">배송준비</option>
              <option value="SHIPPING">배송중</option>
              <option value="DONE">배송완료</option>
              <option value="CANCEL">취소/반품</option>
            </select>
          </div>
          <div>
            <label>택배사</label>
            <select id="dCarrier">
              <option value="">선택 안 함</option>
              <option value="cj">CJ대한통운</option>
              <option value="hanjin">한진택배</option>
              <option value="lotte">롯데택배</option>
              <option value="post">우체국택배</option>
            </select>
          </div>
          <div>
            <label>송장번호</label>
            <input type="text" id="dTrackingNo" placeholder="송장번호를 입력하세요">
          </div>
        </div>
      </div>
    </div>

    <div class="order-items-table">
      <table class="biz-table">
        <thead><tr><th>상품명</th><th>옵션</th><th>수량</th><th>상품금액</th><th>합계</th></tr></thead>
        <tbody id="orderItemsBody"></tbody>
      </table>
      <div class="order-total-row">
        <span>총 결제금액</span>
        <span id="dTotalAmount"></span>
      </div>
    </div>

    <div class="order-detail-actions">
      <button type="button" class="biz-btn-ghost" onclick="closeDetail()">이전 목록으로</button>
      <button type="button" class="biz-btn-primary" id="saveBtn" onclick="saveStatus()">상태변경</button>
    </div>
  </div>
</main>

<%-- 지윤 26.07.20 참고: 이 토스트 팝업은 원본엔 showToast()가 호출하던 건데,
     지금은 상태변경 성공 시 location.reload()로 바로 새로고침하는 방식이라 안 쓰임.
     화면에 남겨는 두지만 지금은 죽은 코드 - 필요하면 saveStatus()에서 다시 연결 가능 --%>
<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var contextPath = '${contextPath}';

  //지윤 26.07.20 수정: statusLabel 딕셔너리는 그대로 유지(상세보기 라벨 표시용), key만 소문자(paid) -> 대문자(PAID)로 변경
  //지윤 26.07.20 삭제: statusBadgeClass 딕셔너리 - 목록 배지는 이제 JSTL c:choose로 서버에서 렌더링해서 JS에서 더 이상 안 씀
  var statusLabel = { PAID:'결제완료', READY:'배송준비', SHIPPING:'배송중', DONE:'배송완료', CANCEL:'취소/반품' };

  //지윤 26.07.20 삭제: var orders = [ {...}, {...}, ... ] 하드코딩 배열 5건 통째로 삭제 (이제 서버가 실데이터를 줌)
  //지윤 26.07.20 삭제: var currentTab = 'all' - 탭 필터링이 서버 GET 파라미터 방식으로 바뀌면서 필요없어짐
  var currentOrderId = null;

  function fmtWon(n){ return (n || 0).toLocaleString('ko-KR') + '원'; }

  //지윤 26.07.20 삭제: function switchTab(tab) {...} - JS로 탭 active 토글 + orders 배열 필터링하던 함수.
  //탭이 이제 실제 <a href="?statusCd=...">라 페이지 이동만으로 처리, JS 함수 자체가 필요없어져서 삭제

  //지윤 26.07.20 수정: function openDetail(id) - orders.find(x => x.id === id)로 로컬 배열에서 찾던 것
  //-> fetch()로 서버(/biz/store/orders/{id})에 AJAX 요청해서 실제 DB 값 받아오는 방식으로 교체
  function openDetail(orderId) {
    fetch(contextPath + '/biz/store/orders/' + orderId)
      .then(function (res) { return res.json(); })
      .then(function (o) {
        if (!o) { alert('조회에 실패했습니다.'); return; }
        currentOrderId = orderId;

        document.getElementById('dOrderNo').textContent    = o.orderNo;
        document.getElementById('dOrderDate').textContent  = o.orderDate;
        document.getElementById('dBuyer').textContent      = o.buyerName;
        //지윤 26.07.20 추가: 구매자 연락처/이메일 - 원본은 목업 데이터 그대로 표시, 지금은 TB_MEMBER 조인해서 가져온 실제 값
        document.getElementById('dPhone').textContent      = o.buyerPhone || '-';
        document.getElementById('dEmail').textContent      = o.buyerEmail || '-';
        document.getElementById('dPayAmount').textContent  = fmtWon(o.payAmount);
        //지윤 26.07.20 수정: 결제방법 - 원본은 o.payMethod 목업 문자열, 지금은 TB_PAYMENT.PAY_METHOD 조인값
        document.getElementById('dPayMethod').textContent  = o.payMethod || '-';
        document.getElementById('dStatusLabel').textContent = statusLabel[o.orderStatus] || o.orderStatus;

        document.getElementById('dReceiver').textContent      = o.recvName;
        document.getElementById('dReceiverPhone').textContent = o.recvPhone;
        //지윤 26.07.20 수정: 배송지 - 원본은 o.address 문자열 하나, 지금은 ZIP_CODE+ADDR1+ADDR2를 조합해서 표시
        document.getElementById('dAddress').textContent       = (o.zipCode ? '[' + o.zipCode + '] ' : '') + o.addr1 + ' ' + (o.addr2 || '');

        document.getElementById('dStatusSelect').value = o.orderStatus;
        //지윤 26.07.20 수정: 택배사/송장번호 - 원본은 o.carrier/o.trackingNo(주문 객체 안 하드코딩), 지금은 TB_ORDER_DELIVERY 조인값(courierName/trackingNo)
        document.getElementById('dCarrier').value       = o.courierName || '';
        document.getElementById('dTrackingNo').value    = o.trackingNo || '';

        //지윤 26.07.20 수정: o.items(목업 배열) forEach -> o.itemList(TB_ORDER_ITEM 실데이터) forEach로 교체
        var itemsBody = document.getElementById('orderItemsBody');
        itemsBody.innerHTML = '';
        (o.itemList || []).forEach(function (it) {
          //지윤 26.07.20 추가: 옵션 표시 - "기본"이면 색상 생략하는 규칙(products.jsp와 동일 컨벤션) 적용
          var optionText = '';
          if (it.optionColor && it.optionColor !== '기본') optionText += it.optionColor + ' / ';
          optionText += it.optionSize || '';
          var tr = document.createElement('tr');
          tr.innerHTML =
            '<td>' + it.productName + '</td>' +
            '<td>' + optionText + '</td>' +
            '<td>' + it.qty + '개</td>' +
            '<td>' + fmtWon(it.unitPrice) + '</td>' +
            '<td>' + fmtWon(it.totalPrice) + '</td>';
          itemsBody.appendChild(tr);
        });
        document.getElementById('dTotalAmount').textContent = fmtWon(o.payAmount);

        document.getElementById('detailCard').style.display = 'block';
        document.getElementById('detailCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
      });
  }

  //지윤 26.07.20 수정: closeDetail()은 원본 그대로 (화면 숨기기만 하는 단순 함수라 안 건드림)
  function closeDetail() {
    document.getElementById('detailCard').style.display = 'none';
  }

  //지윤 26.07.20 수정: function saveStatus() - orders.find()로 로컬 배열 값만 바꾸고 render() 다시 그리던 것(진짜 저장 안 됨)
  //-> fetch()로 서버(/biz/store/orders/{id}/status)에 실제 POST, 성공하면 location.reload()로 최신 데이터 다시 불러옴
  function saveStatus() {
    if (!currentOrderId) return;
    var formData = new URLSearchParams();
    formData.set('orderStatus', document.getElementById('dStatusSelect').value);
    formData.set('courierName', document.getElementById('dCarrier').value);
    formData.set('trackingNo', document.getElementById('dTrackingNo').value.trim());

    fetch(contextPath + '/biz/store/orders/' + currentOrderId + '/status', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: formData.toString()
    })
      .then(function (res) { return res.text(); })
      .then(function (result) {
        if (result === 'OK') {
          location.reload();
        } else {
          alert('상태 변경에 실패했습니다.');
        }
      });
  }

  //지윤 26.07.20 삭제: function showToast(msg) {...} - saveStatus()가 이제 location.reload() 방식이라 토스트 팝업 호출 안 함
  //지윤 26.07.20 삭제: function render() {...} - JS로 orders 배열 필터링해서 <tbody> DOM 새로 그리던 함수. 이제 JSTL이 서버에서 다 그려줘서 필요없어짐
  //지윤 26.07.20 삭제: render(); (페이지 로드 시 초기 렌더링 호출) - 위와 같은 이유로 삭제
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
