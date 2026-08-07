<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 2026/07/31 장우철 — 관리자 숙소 환불신청 상세 --%>
<%-- 2026/08/06 장우철 — 승인=전액환불+이용유지(보상숙박), STATUS APPROVED/REJECTED --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage" value="stay-refund" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
  .box{background:#fff;border:1px solid #E4E6ED;border-radius:12px;padding:20px;margin-bottom:16px}
  .row{display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid #F3F4F6;font-size:14px}
  .row:last-child{border-bottom:none}
  textarea{width:100%;min-height:90px;border:1px solid #E4E6ED;border-radius:8px;padding:10px;box-sizing:border-box}
  .btn{border:none;border-radius:8px;padding:10px 16px;font-weight:700;cursor:pointer}
  .btn-ok{background:#16A34A;color:#fff}
  .btn-no{background:#DC2626;color:#fff}
</style>

<main class="adm-main">
  <div class="adm-page-head">
    <div class="adm-page-head-left">
      <h1 class="adm-page-title">환불 신청 상세</h1>
      <p class="adm-page-desc">문의 #${inquiry.inquiryId}</p>
    </div>
    <a href="${contextPath}/admin/inquiry/stay-refund" class="adm-filter-btn outline" style="text-decoration:none">← 목록</a>
  </div>

  <c:if test="${not empty successMsg}">
    <div style="background:#ECFDF5;border:1px solid #BBF7D0;color:#166534;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${successMsg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
  </c:if>

  <div class="box">
    <div class="row">
      <span>문의상태</span>
      <span>
        <c:choose>
          <c:when test="${inquiry.statusCd eq 'WAIT'}">대기</c:when>
          <c:when test="${inquiry.statusCd eq 'APPROVED'}">승인(환불·이용유지)</c:when>
          <c:when test="${inquiry.statusCd eq 'REJECTED'}">거절</c:when>
          <c:when test="${inquiry.statusCd eq 'DONE'}">처리완료(레거시)</c:when>
          <c:otherwise><c:out value="${inquiry.statusCd}"/></c:otherwise>
        </c:choose>
      </span>
    </div>
    <div class="row"><span>예약번호</span><span><c:out value="${inquiry.resvNo}"/> (<c:out value="${inquiry.resvStatusCd}"/>)</span></div>
    <div class="row"><span>숙소</span><span><c:out value="${inquiry.stayName}"/></span></div>
    <div class="row"><span>회원</span><span><c:out value="${inquiry.memberName}"/> / <c:out value="${inquiry.memberEmail}"/></span></div>
    <div class="row"><span>결제금액</span><span><fmt:formatNumber value="${inquiry.totalAmount}" pattern="#,###"/>원</span></div>
    <div class="row"><span>제목</span><span><c:out value="${inquiry.title}"/></span></div>
    <div class="row" style="display:block">
      <div style="color:#888;margin-bottom:6px">내용</div>
      <div style="white-space:pre-wrap"><c:out value="${inquiry.body}"/></div>
    </div>
    <c:if test="${not empty inquiry.answer}">
      <div class="row" style="display:block">
        <div style="color:#888;margin-bottom:6px">답변</div>
        <div style="white-space:pre-wrap"><c:out value="${inquiry.answer}"/></div>
      </div>
    </c:if>
  </div>

  <c:if test="${inquiry.statusCd eq 'WAIT'}">
    <div class="box">
      <h3 style="margin-top:0">처리</h3>
      <p style="font-size:13px;color:#666;line-height:1.6">
        <strong>승인</strong> 시 결제금은 <strong>전액 환불</strong>되고, 예약·이용은 <strong>유지</strong>됩니다(보상 숙박).
        CS에서 신중히 확인해 주세요.<br>
        <strong>거절</strong> 시 예약은 그대로이며 유저는 재신청할 수 없습니다.
      </p>
      <form method="post" action="${contextPath}/admin/inquiry/stay-refund/approve" style="margin-bottom:16px"
            onsubmit="return confirm('전액 환불 + 이용 유지(보상 숙박)로 승인할까요?');">
        <!--HYJ 26.08.05-->
        <input type="hidden" name="_csrf" value="${_csrf}">

        <input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">
        <textarea name="answer" placeholder="승인 안내 메모 (선택)"></textarea>
        <button type="submit" class="btn btn-ok" style="margin-top:10px">승인 · 전액 환불(이용 유지)</button>
      </form>
      <form method="post" action="${contextPath}/admin/inquiry/stay-refund/reject"
            onsubmit="return confirm('환불 신청을 거절할까요?');">
        <!--HYJ 26.08.05-->
        <input type="hidden" name="_csrf" value="${_csrf}">

        <input type="hidden" name="inquiryId" value="${inquiry.inquiryId}">
        <textarea name="answer" placeholder="거절 사유 (필수)" required></textarea>
        <button type="submit" class="btn btn-no" style="margin-top:10px">거절</button>
      </form>
    </div>
  </c:if>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
