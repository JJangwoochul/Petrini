<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="hotel" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .complete-wrap{max-width:560px;margin:60px auto 80px;padding:0 20px;text-align:center}
  .complete-icon{width:80px;height:80px;border-radius:50%;background:#E8EAF9;display:flex;align-items:center;justify-content:center;margin:0 auto 24px}
  .complete-icon svg{width:40px;height:40px;stroke:#4F6BC4;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .complete-title{font-size:24px;font-weight:800;color:var(--text-main);margin-bottom:8px}
  .complete-desc{font-size:15px;color:var(--text-muted);margin-bottom:32px}
  .complete-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;text-align:left;margin-bottom:24px}
  .complete-card h3{font-size:14px;font-weight:700;color:var(--text-main);margin:0 0 16px;padding-bottom:12px;border-bottom:1px solid var(--border)}
  .complete-row{display:flex;justify-content:space-between;font-size:14px;margin-bottom:10px}
  .complete-row:last-child{margin-bottom:0}
  .complete-row span:first-child{color:var(--text-muted)}
  .complete-row span:last-child{color:var(--text-main);font-weight:600;text-align:right}
  .complete-notice{background:var(--bg-page);border-radius:var(--radius-sm);padding:14px 16px;font-size:13px;color:var(--text-sub);line-height:1.6;text-align:left;margin-bottom:24px}
  .complete-notice strong{color:#4F6BC4}
  .complete-btns{display:flex;gap:12px}
  .btn-complete-my{flex:1;padding:13px;border:2px solid #4F6BC4;border-radius:var(--radius-sm);background:#fff;color:#4F6BC4;font-size:15px;font-weight:700;cursor:pointer}
  .btn-complete-store{flex:1;padding:13px;border:none;border-radius:var(--radius-sm);background:#4F6BC4;color:#fff;font-size:15px;font-weight:700;cursor:pointer}
</style>
<div class="complete-wrap">
  <div class="complete-icon"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div>
  <div class="complete-title">예약이 완료되었습니다!</div>
  <div class="complete-desc">예약번호 <strong>#RSV-2025-0281</strong><br>예약 내역은 마이페이지에서 확인하세요.</div>
  <div class="complete-card">
    <h3>예약 정보</h3>
    <div class="complete-row"><span>예약번호</span><span>#RSV-2025-0281</span></div>
    <div class="complete-row"><span>숙소</span><span>강아지숲 펫 빌라 — 독채 풀빌라</span></div>
    <div class="complete-row"><span>이용 기간</span><span>2025.07.05(토) ~ 07.06(일) · 1박</span></div>
    <div class="complete-row"><span>인원 / 반려동물</span><span>3명 · 몽이 (골든 리트리버)</span></div>
    <div class="complete-row"><span>결제 금액</span><span style="color:#4F6BC4;font-size:16px;font-weight:800">188,000원</span></div>
  </div>
  <div class="complete-notice">
    체크인은 오후 <strong>3시</strong>부터, 체크아웃은 오전 <strong>11시</strong>까지입니다. 예약 변경·취소는 마이페이지 &gt; 예약내역에서 가능합니다.
  </div>
  <div class="complete-btns">
    <button class="btn-complete-my" onclick="location.href='${contextPath}/mypage/reserve'">예약 내역 보기</button>
    <button class="btn-complete-store" onclick="location.href='${contextPath}/hotel'">둘러보기 계속하기</button>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
