<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="reserve" />

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<style>
.rd-card{background:#fff;border:1px solid #E2E8E4;border-radius:12px;padding:24px;margin-bottom:16px}
.rd-row{display:flex;justify-content:space-between;gap:16px;padding:12px 0;border-bottom:1px solid #F5F6F4;font-size:14px}
.rd-row:last-child{border-bottom:none}
.rd-row span:first-child{color:#888;flex-shrink:0;min-width:90px}
.rd-row span:last-child{color:#1A1A2E;font-weight:600;text-align:right}
.rd-reason{background:#FEF2F2;border-radius:8px;padding:14px 16px;margin-top:8px;font-size:13px;color:#991B1B;line-height:1.6}
/* 2026/07/13 장우철 — 리뷰 작성 폼 */
.rd-review{background:#F8FFFC;border:1px solid #C6EDE0;border-radius:12px;padding:20px;margin-bottom:16px}
.rd-review h3{font-size:16px;font-weight:800;margin:0 0 12px;color:#1A1A2E}
.rd-stars{display:flex;gap:8px;margin-bottom:12px;flex-wrap:wrap}
.rd-stars label{cursor:pointer;font-size:14px;color:#555}
.rd-stars input{margin-right:4px}
.rd-review textarea{width:100%;min-height:90px;border:1px solid #E2E8E4;border-radius:8px;padding:10px 12px;font-size:14px;resize:vertical;box-sizing:border-box}
.rd-review .btn-review{margin-top:12px;background:#2BAB82;color:#fff;border:none;border-radius:8px;padding:10px 18px;font-weight:700;cursor:pointer}
</style>

<div class="mypage-wrap">
<%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>
<div class="mypage-content">

<%-- 2026/07/11 장우철 — 마이페이지 예약 상세 (2차) --%>
<div class="mp-section active">
  <h2 class="mp-title">예약 상세</h2>
  <p class="mp-desc">예약번호 <strong><c:out value="${reservation.resvNo}"/></strong></p>

  <div class="rd-card">
    <div class="rd-row">
      <span>상태</span>
      <span>
        <c:choose>
          <c:when test="${reservation.statusCd eq 'PENDING'}"><span class="badge-status badge-wait">예약신청</span></c:when>
          <c:when test="${reservation.statusCd eq 'CONFIRMED'}"><span class="badge-status badge-ready">예약확정</span></c:when>
          <c:when test="${reservation.statusCd eq 'DONE'}"><span class="badge-status badge-done">진료완료</span></c:when>
          <c:otherwise><span class="badge-status badge-cancel">취소</span></c:otherwise>
        </c:choose>
      </span>
    </div>
    <div class="rd-row">
      <span>병원</span>
      <span><c:out value="${not empty reservation.hospitalName ? reservation.hospitalName : '-'}"/></span>
    </div>
    <div class="rd-row">
      <span>주소</span>
      <span><c:out value="${not empty reservation.hospitalAddr ? reservation.hospitalAddr : '-'}"/></span>
    </div>
    <div class="rd-row">
      <span>예약일시</span>
      <span>
        <fmt:formatDate value="${reservation.resvDate}" pattern="yyyy-MM-dd"/>
        <c:if test="${not empty reservation.resvTime}"> ${reservation.resvTime}</c:if>
      </span>
    </div>
    <div class="rd-row">
      <span>반려동물</span>
      <span>
        <c:out value="${reservation.petName}"/>
        <c:if test="${not empty reservation.petSpecies}"> (<c:out value="${reservation.petSpecies}"/>
          <c:if test="${not empty reservation.petBreed}"> / <c:out value="${reservation.petBreed}"/></c:if>)</c:if>
      </span>
    </div>
    <div class="rd-row">
      <span>증상</span>
      <span><c:out value="${not empty reservation.symptoms ? reservation.symptoms : '-'}"/></span>
    </div>
    <div class="rd-row">
      <span>요청사항</span>
      <span><c:out value="${not empty reservation.requestMemo ? reservation.requestMemo : '-'}"/></span>
    </div>
    <c:if test="${reservation.statusCd eq 'CANCEL' or reservation.statusCd eq 'REJECTED'}">
      <div class="rd-row" style="display:block;border-bottom:none;padding-bottom:0">
        <span style="display:block;margin-bottom:6px">취소 사유</span>
        <div class="rd-reason">
          <c:out value="${not empty reservation.rejectReason ? reservation.rejectReason : '사유가 등록되지 않았습니다.'}"/>
        </div>
      </div>
    </c:if>
  </div>

  <%-- 2026/07/13 장우철 — 진료완료 + 미작성 시 리뷰·별점 작성 --%>
  <c:if test="${not empty msg}">
    <p style="color:#166534;font-size:14px;margin-bottom:12px"><c:out value="${msg}"/></p>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <p style="color:#B91C1C;font-size:14px;margin-bottom:12px"><c:out value="${errorMsg}"/></p>
  </c:if>

  <%-- 2026/07/13 장우철 — 진료완료 안내 --%>
  <c:if test="${reservation.statusCd eq 'DONE'}">
    <p style="font-size:14px;color:#1F8464;background:#E8F8F1;border-radius:8px;padding:12px 14px;margin-bottom:16px;line-height:1.5">
      진료가 완료되었습니다. 병원·반려동물 정보를 확인하고
      <c:if test="${reservation.reviewedYn ne 'Y'}">아래에서 리뷰를 작성해 주세요.</c:if>
      <c:if test="${reservation.reviewedYn eq 'Y'}">작성하신 리뷰는 병원 상세에 반영됩니다.</c:if>
    </p>
  </c:if>

  <c:if test="${reservation.statusCd eq 'DONE' and reservation.reviewedYn ne 'Y'}">
    <div class="rd-review">
      <h3>병원 리뷰 작성</h3>
      <p style="font-size:13px;color:#666;margin:0 0 12px">진료받으신 병원에 별점과 후기를 남겨 주세요.</p>
      <form method="post" action="${contextPath}/mypage/reserve/review">
        <input type="hidden" name="resvId" value="${reservation.resvId}">
        <div class="rd-stars">
          <label><input type="radio" name="rating" value="5" checked> ★5</label>
          <label><input type="radio" name="rating" value="4"> ★4</label>
          <label><input type="radio" name="rating" value="3"> ★3</label>
          <label><input type="radio" name="rating" value="2"> ★2</label>
          <label><input type="radio" name="rating" value="1"> ★1</label>
        </div>
        <textarea name="content" maxlength="2000" placeholder="진료 경험, 친절도, 시설 등을 자유롭게 작성해 주세요." required></textarea>
        <button type="submit" class="btn-review">리뷰 등록</button>
      </form>
    </div>
  </c:if>
  <c:if test="${reservation.statusCd eq 'DONE' and reservation.reviewedYn eq 'Y'}">
    <p style="font-size:14px;color:#166534;margin-bottom:16px">이 예약에 대한 리뷰를 작성하셨습니다.</p>
  </c:if>

  <button type="button" class="btn-sm" onclick="location.href='${contextPath}/mypage/reserve'">← 목록으로</button>
</div>

</div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
