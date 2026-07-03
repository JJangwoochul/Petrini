<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="contract" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<style>
    .contract-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 8px 32px;
    }
    .contract-row {
        display: flex;
        justify-content: space-between;
        padding: 10px 0;
        border-bottom: 1px solid #F0F2F0;
        font-size: 13px;
    }
    .contract-row span:first-child { color: #999; }
    .contract-row span:last-child  { color: #1A1A2E; font-weight: 600; }
    .contract-row.status span:last-child { color: #2BAB82; }
    .contract-row.fee span:last-child { color: #1A1A2E; }

    .contract-bottom {
        display: grid;
        grid-template-columns: 1.3fr 1fr;
        gap: 16px;
        margin-top: 16px;
    }

    .banner-preview {
        background: linear-gradient(135deg, #E0F2FE, #EAF7F2);
        border-radius: 12px;
        padding: 20px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        gap: 6px;
        min-height: 100%;
    }
    .banner-preview p.title { font-size: 15px; font-weight: 800; color: #1A1A2E; margin: 0; }
    .banner-preview p.desc  { font-size: 12px; color: #666; margin: 0 0 8px; }
    .banner-preview a.go-btn {
        align-self: flex-start;
        background: #2BAB82; color: #fff;
        font-size: 12px; font-weight: 700;
        padding: 7px 16px; border-radius: 20px;
        text-decoration: none;
    }
</style>

<main class="biz-main hospital-dashboard">
  <div class="biz-page-head">
    <h1 class="biz-page-title">계약 관리</h1>
    <p class="biz-page-desc">숙박 제휴 계약 기간과 배너 광고 노출 현황을 확인하세요.</p>
  </div>

  <div class="biz-card" style="padding: 20px;">
    <p style="font-size:14px; font-weight:700; color:#1A1A2E; margin:0 0 8px;">계약 정보</p>
    <div class="contract-grid">
      <div class="contract-row"><span>계약 유형</span><span>숙박 제휴 (매출 수수료 방식)</span></div>
      <div class="contract-row"><span>계약 종료일</span><span>2026-12-31</span></div>
      <div class="contract-row status"><span>계약 상태</span><span>계약중</span></div>
      <div class="contract-row"><span>남은 기간</span><span>185일</span></div>
      <div class="contract-row"><span>가입일</span><span>2026-01-01</span></div>
      <div class="contract-row"><span>수수료 방식</span><span>매출액 기준 수수료</span></div>
      <div class="contract-row"><span>계약 시작일</span><span>2026-01-01</span></div>
      <div class="contract-row fee"><span>적용 수수료율</span><span>12% (프리미엄 등급)</span></div>
    </div>
  </div>

  <div class="contract-bottom">
    <div class="biz-card" style="padding: 20px;">
      <p style="font-size:14px; font-weight:700; color:#1A1A2E; margin:0 0 8px;">배너 / 광고 정보</p>
      <div class="contract-row"><span>광고 상품</span><span>메인 숙소 추천 배너</span></div>
      <div class="contract-row"><span>노출 위치</span><span>메인 페이지 숙박 영역 상단</span></div>
      <div class="contract-row"><span>광고 기간</span><span>2026-06-01 ~ 2026-06-30</span></div>
      <div class="contract-row status"><span>노출 상태</span><span>노출중</span></div>
      <div class="contract-row"><span>이미지 등록일</span><span>2026-05-28</span></div>
      <div class="contract-row"><span>클릭 수</span><span>1,245회</span></div>
      <div class="contract-row" style="border-bottom:none;"><span>노출 수</span><span>12,583회</span></div>
    </div>

    <div class="biz-card" style="padding: 0;">
      <div class="banner-preview">
        <p class="title">🐾 포근한 숙소</p>
        <p class="desc">반려견과 함께하는 편안한 힐링 여행</p>
        <a href="${contextPath}/biz/stay" class="go-btn">숙소 보기 &gt;</a>
      </div>
    </div>
  </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>