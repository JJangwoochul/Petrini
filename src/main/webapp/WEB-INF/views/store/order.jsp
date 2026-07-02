<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="store" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .order-wrap{max-width:900px;margin:32px auto 80px;padding:0 20px}
  .order-title{font-size:24px;font-weight:800;color:var(--text-main);margin-bottom:28px}
  .order-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;margin-bottom:20px}
  .order-section h3{font-size:16px;font-weight:800;color:var(--text-main);margin:0 0 18px;padding-bottom:14px;border-bottom:1px solid var(--border)}
  .order-form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
  .order-form-group{display:flex;flex-direction:column;gap:6px}
  .order-form-group.full{grid-column:1/-1}
  .order-form-group label{font-size:13px;font-weight:600;color:var(--text-sub)}
  .order-form-group input,.order-form-group select{border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;color:var(--text-main);outline:none;transition:border-color .2s;font-family:inherit}
  .order-form-group input:focus,.order-form-group select:focus{border-color:var(--primary)}
  .addr-row{display:flex;gap:8px}
  .addr-row input{flex:1}
  .addr-btn{padding:10px 14px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:#fff;color:var(--primary);font-size:13px;font-weight:600;cursor:pointer;white-space:nowrap}
  .order-product-row{display:flex;gap:14px;align-items:center;padding:14px 0;border-bottom:1px solid var(--border)}
  .order-product-row:last-child{border-bottom:none}
  .order-product-thumb{width:60px;height:60px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .order-product-name{flex:1;font-size:14px;font-weight:600;color:var(--text-main)}
  .order-product-price{font-size:14px;font-weight:700;color:var(--text-main)}
  .coupon-input{display:flex;gap:8px}
  .coupon-input input{flex:1;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit}
  .coupon-input input:focus{border-color:var(--primary)}
  .order-total-box{background:var(--bg-page);border-radius:var(--radius-sm);padding:18px;display:flex;flex-direction:column;gap:10px}
  .order-total-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub)}
  .order-total-row.final{font-size:18px;font-weight:800;color:var(--text-main);padding-top:10px;border-top:1px solid var(--border);margin-top:4px}
  .order-total-row.final span:last-child{color:var(--primary-dark)}
  .btn-pay{width:100%;padding:16px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:17px;font-weight:800;cursor:pointer;margin-top:16px;transition:var(--transition)}
  .btn-pay:hover{background:var(--primary-dark)}
</style>
<div class="order-wrap">
  <h1 class="order-title">주문서 작성</h1>

  <div class="order-section">
    <h3>주문 상품</h3>
    <div class="order-product-row">
      <img class="order-product-thumb" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=120&q=70&auto=format&fit=crop" alt="사료" onerror="this.src='https://placehold.co/60x60/EAF7F2/2BAB82?text=IMG'">
      <div class="order-product-name">로얄캐닌 미디엄 어덜트 사료 4kg × 1</div>
      <div class="order-product-price">48,900원</div>
    </div>
    <div class="order-product-row">
      <img class="order-product-thumb" src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=120&q=70&auto=format&fit=crop" alt="매트" onerror="this.src='https://placehold.co/60x60/EAF7F2/2BAB82?text=IMG'">
      <div class="order-product-name">노즈워크 매트 오렌지 × 2</div>
      <div class="order-product-price">37,000원</div>
    </div>
    <div class="order-product-row">
      <img class="order-product-thumb" src="https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=120&q=70&auto=format&fit=crop" alt="간식" onerror="this.src='https://placehold.co/60x60/EAF7F2/2BAB82?text=IMG'">
      <div class="order-product-name">수제 져키 트릿 200g × 1</div>
      <div class="order-product-price">13,000원</div>
    </div>
  </div>

  <div class="order-section">
    <h3>배송지 입력</h3>
    <div class="order-form-grid">
      <div class="order-form-group"><label>받는 분</label><input type="text" value="${memberInfo.memberName}" placeholder="이름"></div>
      <div class="order-form-group"><label>연락처</label><input type="tel" placeholder="010-0000-0000"></div>
      <div class="order-form-group full">
        <label>주소</label>
        <div class="addr-row"><input type="text" placeholder="우편번호" style="max-width:120px"><button class="addr-btn">주소 검색</button></div>
        <input type="text" placeholder="기본 주소" style="margin-top:8px">
        <input type="text" placeholder="상세 주소" style="margin-top:8px">
      </div>
    </div>
  </div>

  <div class="order-section">
    <h3>주문 시 요청사항</h3>
    <div class="order-form-grid">
      <div class="order-form-group full">
        <label>배송 메모</label>
        <select>
          <option>문 앞에 놓아주세요</option>
          <option>경비실에 맡겨주세요</option>
          <option>부재 시 연락 부탁드려요</option>
          <option>직접 입력</option>
        </select>
      </div>
    </div>
  </div>

  <div class="order-section">
    <h3>쿠폰 / 포인트</h3>
    <div class="coupon-input"><input type="text" placeholder="쿠폰 코드 입력"><button class="addr-btn">적용</button></div>
    <div class="order-form-grid" style="margin-top:14px">
      <div class="order-form-group">
        <label>보유 포인트 2,400P</label>
        <input type="number" placeholder="사용할 포인트 입력" value="0">
      </div>
    </div>
  </div>

  <div class="order-section">
    <h3>결제 예정 금액</h3>
    <div class="order-total-box">
      <div class="order-total-row"><span>상품 금액</span><span>98,900원</span></div>
      <div class="order-total-row"><span>배송비</span><span style="color:var(--primary)">무료</span></div>
      <div class="order-total-row"><span>쿠폰/포인트 할인</span><span style="color:var(--accent)">-0원</span></div>
      <div class="order-total-row final"><span>결제 예정 금액</span><span>98,900원</span></div>
    </div>
    <button class="btn-pay" onclick="location.href='${contextPath}/store/payment'">결제수단 선택하기</button>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
