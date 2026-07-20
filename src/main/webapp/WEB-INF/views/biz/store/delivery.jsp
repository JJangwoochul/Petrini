<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="delivery" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 지윤 26.07.20 수정: 하드코딩(JS mock 배열 deliveries[]) -> 실데이터 연동
     Controller: BizStoreController.storeDelivery() / bulkDelivery()
     Service: BizStoreService.getDeliveryList / getDeliverySummary / bulkRegisterDelivery
     개별 "송장수정" 저장은 새로 안 만들고, 주문관리(orders.jsp) 때 만든
     POST /biz/store/orders/{id}/status API를 그대로 재사용함
     화면 레이아웃(CSS, HTML 뼈대)은 원본 그대로 유지 --%>
<style>
  .dlv-summary{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:16px}
  .dlv-summary-card{background:#fff;border:1px solid var(--biz-border);border-radius:12px;padding:16px 18px}
  .dlv-summary-card .label{font-size:12px;color:#888;margin-bottom:6px}
  .dlv-summary-card .val{font-size:22px;font-weight:800;color:#1A1A2E}
  .dlv-summary-card .val span{font-size:13px;font-weight:600;color:#888;margin-left:2px}
  .dlv-summary-card.warn .val{color:#E24B4A}

  .dlv-filter{display:flex;flex-wrap:wrap;align-items:center;gap:10px;padding:18px 20px}
  .dlv-filter select,.dlv-filter input{border:1px solid var(--biz-border);border-radius:8px;padding:8px 10px;font-size:13px;color:#333}
  .dlv-filter .btn-search{background:var(--biz-primary);color:#fff;border:none;border-radius:8px;padding:9px 18px;font-size:13px;font-weight:700;cursor:pointer}
  .dlv-filter .btn-reset{background:#fff;border:1px solid var(--biz-border);border-radius:8px;padding:9px 16px;font-size:13px;font-weight:600;color:#555;cursor:pointer}
  .dlv-table-head{display:flex;align-items:center;justify-content:space-between;padding:0 20px}

  .dlv-bulk-box{padding:20px}
  .dlv-bulk-box textarea{width:100%;min-height:120px;border:1px solid var(--biz-border);border-radius:8px;padding:10px;font-size:13px;font-family:monospace}
  .dlv-bulk-hint{font-size:12px;color:#888;margin:6px 0 14px}
  .dlv-bulk-actions{display:flex;justify-content:flex-end;gap:8px}
</style>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">배송 관리</h1>
    <p class="biz-page-desc">택배사·송장번호를 등록하고 배송 현황을 추적하세요.</p>
  </div>

  <%-- 지윤 26.07.20 수정: id="sumReady" 등 빈 값(JS render()가 채우던 것) -> ${summary.READY} 등 Controller가 넘겨준 실제 집계값 --%>
  <div class="dlv-summary">
    <div class="dlv-summary-card"><div class="label">배송준비</div><div class="val">${summary.READY}<span>건</span></div></div>
    <div class="dlv-summary-card"><div class="label">배송중</div><div class="val">${summary.SHIPPING}<span>건</span></div></div>
    <div class="dlv-summary-card"><div class="label">배송완료</div><div class="val">${summary.DONE}<span>건</span></div></div>
    <div class="dlv-summary-card warn"><div class="label">배송지연 (3일 이상 배송중)</div><div class="val">${summary.DELAY}<span>건</span></div></div>
  </div>

  <%-- 지윤 26.07.20 수정: onclick="applyFilter()" (JS로 로컬 배열 필터링) -> method="get" 폼 제출 (서버에 실제 쿼리 파라미터로 필터 요청) --%>
  <div class="biz-card" style="margin-bottom:16px">
    <form class="dlv-filter" method="get" action="${contextPath}/biz/store/delivery">
      <select name="carrier">
        <option value="">택배사 전체</option>
        <option value="cj"     ${selectedCarrier == 'cj' ? 'selected' : ''}>CJ대한통운</option>
        <option value="hanjin" ${selectedCarrier == 'hanjin' ? 'selected' : ''}>한진택배</option>
        <option value="lotte"  ${selectedCarrier == 'lotte' ? 'selected' : ''}>롯데택배</option>
        <option value="post"   ${selectedCarrier == 'post' ? 'selected' : ''}>우체국택배</option>
      </select>
      <select name="statusCd">
        <option value="">배송상태 전체</option>
        <option value="READY"    ${selectedStatusCd == 'READY' ? 'selected' : ''}>배송준비</option>
        <option value="SHIPPING" ${selectedStatusCd == 'SHIPPING' ? 'selected' : ''}>배송중</option>
        <option value="DONE"     ${selectedStatusCd == 'DONE' ? 'selected' : ''}>배송완료</option>
      </select>
      <input type="text" name="keyword" value="${selectedKeyword}" placeholder="주문번호 또는 구매자명">
      <button type="submit" class="btn-search">검색</button>
      <button type="button" class="btn-reset" onclick="location.href='${contextPath}/biz/store/delivery'">초기화</button>
    </form>
  </div>

  <div class="biz-card" style="margin-bottom:16px">
    <div class="dlv-table-head">
      <%-- 지윤 26.07.20 수정: id="totalCount">0</span> (JS가 채우던 것) -> ${deliveryList.size()} 서버값 바로 출력 --%>
      <div class="biz-card-head" style="padding:20px 0 12px"><span>배송 목록</span><small>총 ${deliveryList.size()}건</small></div>
      <button type="button" class="biz-btn-primary" onclick="openBulk()">+ 송장 일괄등록</button>
    </div>
    <table class="biz-table">
      <thead><tr><th>주문번호</th><th>구매자</th><th>택배사</th><th>송장번호</th><th>상태</th><th>발송일</th><th>관리</th></tr></thead>
      <%-- 지윤 26.07.20 수정: <tbody id="dlvBody"></tbody> (JS render()가 채우던 빈 껍데기) -> JSTL로 ${deliveryList} 바로 렌더링 --%>
      <tbody>
        <c:choose>
          <c:when test="${empty deliveryList}">
            <tr><td colspan="7" style="text-align:center;color:#999;padding:24px 0">해당하는 배송 건이 없습니다.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="d" items="${deliveryList}">
              <tr>
                <td>#${d.orderNo}</td>
                <td>${d.buyerName}</td>
                <%-- 지윤 26.07.20 수정: JS carrierLabel 딕셔너리 조회 -> JSTL c:choose로 택배사코드 -> 한글명 직접 분기 --%>
                <td>
                  <c:choose>
                    <c:when test="${d.courierName == 'cj'}">CJ대한통운</c:when>
                    <c:when test="${d.courierName == 'hanjin'}">한진택배</c:when>
                    <c:when test="${d.courierName == 'lotte'}">롯데택배</c:when>
                    <c:when test="${d.courierName == 'post'}">우체국택배</c:when>
                    <c:otherwise>-</c:otherwise>
                  </c:choose>
                </td>
                <td>${empty d.trackingNo ? '-' : d.trackingNo}</td>
                <td>
                  <c:choose>
                    <c:when test="${d.orderStatus == 'READY'}"><span class="bs-badge bs-empty">배송준비</span></c:when>
                    <c:when test="${d.orderStatus == 'SHIPPING'}"><span class="bs-badge bs-empty">배송중</span></c:when>
                    <c:when test="${d.orderStatus == 'DONE'}"><span class="bs-badge bs-empty">배송완료</span></c:when>
                  </c:choose>
                  <%-- 지윤 26.07.20 수정: isDelayed(d) JS 함수 계산 -> Service에서 이미 계산해서 넣어준 d.delayed(boolean) 그대로 사용 --%>
                  <c:if test="${d.delayed}"><span class="bs-badge bs-cancel" style="margin-left:4px">지연</span></c:if>
                </td>
                <td>${empty d.shipDate ? '-' : d.shipDate}</td>
                <%-- 지윤 26.07.20 수정: onclick="openEdit('ORD-2026-0892')" (주문번호 문자열로 로컬 배열 검색)
                     -> onclick="openEdit(25, 'ORD-2026-0892', ...)" (진짜 ORDER_ID + 현재값들을 그대로 넘겨서 모달에 채움, AJAX 재조회 없이 바로 채움) --%>
                <td><button class="biz-btn" onclick="openEdit(${d.orderId}, '${d.orderNo}', '${d.orderStatus}', '${d.courierName}', '${d.trackingNo}')">${empty d.trackingNo ? '송장등록' : '수정'}</button></td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </div>

  <%-- 아래 일괄등록/수정 폼 HTML 뼈대는 원본 그대로, 안 건드림 --%>
  <div class="biz-card" id="bulkCard" style="display:none">
    <div class="biz-card-head"><span>송장 일괄등록</span></div>
    <div class="dlv-bulk-box">
      <p class="dlv-bulk-hint">한 줄에 하나씩, <b>주문번호,택배사코드,송장번호</b> 형식으로 입력하세요. 택배사코드: cj / hanjin / lotte / post<br>예) ORD-2026-0892,cj,651234567890</p>
      <textarea id="bulkText" placeholder="ORD-2026-0892,cj,651234567890&#10;ORD-2026-0891,hanjin,482910384710"></textarea>
      <div class="dlv-bulk-actions">
        <button type="button" class="biz-btn-ghost" onclick="closeBulk()">취소</button>
        <button type="button" class="biz-btn-primary" onclick="submitBulk()">일괄 등록</button>
      </div>
    </div>
  </div>

  <div class="biz-card" id="editCard" style="display:none">
    <div class="biz-card-head"><span>송장 수정</span></div>
    <form style="padding:20px;max-width:480px">
      <div class="biz-form-fields">
        <div class="biz-form-row">
          <label>주문번호</label>
          <input type="text" id="eOrderNo" readonly style="background:#FAFBFA">
        </div>
        <div class="biz-form-row">
          <label>배송상태<span class="req">*</span></label>
          <%-- 지윤 26.07.20 수정: value="ready" 등 -> value="READY" 등 실제 DB(TB_ORDER.ORDER_STATUS) 코드값으로 통일 --%>
          <select id="eStatus">
            <option value="READY">배송준비</option>
            <option value="SHIPPING">배송중</option>
            <option value="DONE">배송완료</option>
          </select>
        </div>
        <div class="biz-form-row">
          <label>택배사<span class="req">*</span></label>
          <select id="eCarrier">
            <option value="cj">CJ대한통운</option>
            <option value="hanjin">한진택배</option>
            <option value="lotte">롯데택배</option>
            <option value="post">우체국택배</option>
          </select>
        </div>
        <div class="biz-form-row">
          <label>송장번호<span class="req">*</span></label>
          <input type="text" id="eTrackingNo" placeholder="송장번호를 입력하세요">
        </div>
      </div>
      <div class="dlv-bulk-actions" style="margin-top:16px">
        <button type="button" class="biz-btn-ghost" onclick="closeEdit()">취소</button>
        <button type="button" class="biz-btn-primary" onclick="submitEdit()">저장</button>
      </div>
    </form>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  <span id="saveToastMsg">처리되었습니다.</span>
</div>

<script>
  var contextPath = '${contextPath}';
  var eOrderId = null;

  //지윤 26.07.20 삭제: var carrierLabel = {...}, var statusLabel = {...} - 목록 표시는 이제 JSTL c:choose로 서버에서 렌더링해서 JS에서 안 씀 (수정 모달의 select 옵션 라벨은 HTML에 이미 고정 텍스트로 있어서 딕셔너리 자체가 불필요해짐)
  //지윤 26.07.20 삭제: var deliveries = [ {...}, ... ] 하드코딩 배열 5건 통째로 삭제 (서버가 실데이터를 줌)
  //지윤 26.07.20 삭제: var filtered = deliveries.slice() - 필터링이 서버 GET 파라미터 방식으로 바뀌면서 필요없어짐

  //지윤 26.07.20 삭제: function applyFilter() {...}, function resetFilter() {...}
  //-> 필터 폼이 이제 실제 <form method="get">이라 그냥 제출/링크 이동만으로 처리, JS 함수 필요없어짐

  //지윤 26.07.20 삭제: function isDelayed(d) {...} - Service(BizStoreServiceImpl.isDelayed)에서 이미 계산해서 넘겨주므로 JS에서 재계산할 필요 없어짐

  function openBulk() {
    document.getElementById('bulkCard').style.display = 'block';
    document.getElementById('editCard').style.display = 'none';
    document.getElementById('bulkCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  function closeBulk() {
    document.getElementById('bulkCard').style.display = 'none';
    document.getElementById('bulkText').value = '';
  }

  //지윤 26.07.20 수정: function submitBulk() - JS로 deliveries 배열 안에서 직접 찾아 값 바꾸던 것(진짜 저장 안 됨)
  //-> fetch()로 서버(/biz/store/delivery/bulk)에 텍스트 그대로 전송, 파싱/저장은 서버(BizStoreServiceImpl.bulkRegisterDelivery)가 처리
  function submitBulk() {
    var bulkText = document.getElementById('bulkText').value.trim();
    if (!bulkText) { alert('입력된 내용이 없습니다.'); return; }

    fetch(contextPath + '/biz/store/delivery/bulk', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'bulkText=' + encodeURIComponent(bulkText)
    })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        closeBulk();
        if (result.failLines && result.failLines.length > 0) {
          alert(result.okCount + '건 등록 완료, ' + result.failLines.length + '건은 형식이 맞지 않거나 존재하지 않는 주문이라 실패했습니다:\n' + result.failLines.join('\n'));
        } else {
          alert(result.okCount + '건의 송장이 등록되었습니다.');
        }
        location.reload();
      });
  }

  //지윤 26.07.20 수정: function openEdit(orderNo) - deliveries.find()로 로컬 배열에서 찾던 것
  //-> 목록 렌더링 시점에 이미 값을 다 갖고 있어서(JSTL onclick 인자로 넘김) 별도 AJAX 조회 없이 바로 모달에 채움
  function openEdit(orderId, orderNo, status, carrier, trackingNo) {
    eOrderId = orderId;
    document.getElementById('eOrderNo').value = orderNo;
    document.getElementById('eStatus').value = status;
    document.getElementById('eCarrier').value = carrier || 'cj';
    document.getElementById('eTrackingNo').value = (trackingNo === 'null' ? '' : trackingNo);

    document.getElementById('bulkCard').style.display = 'none';
    document.getElementById('editCard').style.display = 'block';
    document.getElementById('editCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
  function closeEdit() {
    document.getElementById('editCard').style.display = 'none';
  }

  //지윤 26.07.20 수정: function submitEdit() - deliveries 배열 값만 바꾸고 render() 다시 그리던 것(진짜 저장 안 됨)
  //-> 주문관리(orders.jsp) 때 만든 POST /biz/store/orders/{id}/status API를 그대로 재사용해서 실제 DB 저장
  function submitEdit() {
    var trackingNo = document.getElementById('eTrackingNo').value.trim();
    if (!trackingNo) { alert('송장번호를 입력해주세요.'); return; }

    var formData = new URLSearchParams();
    formData.set('orderStatus', document.getElementById('eStatus').value);
    formData.set('courierName', document.getElementById('eCarrier').value);
    formData.set('trackingNo', trackingNo);

    fetch(contextPath + '/biz/store/orders/' + eOrderId + '/status', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: formData.toString()
    })
      .then(function (res) { return res.text(); })
      .then(function (result) {
        if (result === 'OK') {
          location.reload();
        } else {
          alert('저장에 실패했습니다.');
        }
      });
  }

  //지윤 26.07.20 삭제: function todayStr() {...} - 발송일을 서버(TB_ORDER_DELIVERY.REGISTERED_AT = SYSDATE)에서 자동으로 찍어줘서 JS에서 날짜 계산 필요없어짐
  //지윤 26.07.20 삭제: function showToast(msg) {...} - 지금은 alert + location.reload() 방식으로 대체 (필요하면 나중에 다시 연결 가능)
  //지윤 26.07.20 삭제: function render() {...} - JS로 deliveries 배열 필터링해서 <tbody>/요약카드 DOM 새로 그리던 함수. JSTL이 서버에서 다 그려줘서 필요없어짐
  //지윤 26.07.20 삭제: render(); (페이지 로드 시 초기 렌더링 호출) - 위와 같은 이유로 삭제
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
