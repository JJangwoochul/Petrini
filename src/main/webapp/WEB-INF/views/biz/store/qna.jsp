<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="qna" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">Q&amp;A 관리</h1>
    <p class="biz-page-desc">상품 문의를 확인하고 답변을 작성하세요.</p>
  </div>

  <c:if test="${not empty msg}"><div class="biz-card" style="padding:14px 20px;margin-bottom:16px;color:#2BAB82;font-weight:700">${msg}</div></c:if>
  <c:if test="${not empty errorMsg}"><div class="biz-card" style="padding:14px 20px;margin-bottom:16px;color:#E24B4A;font-weight:700">${errorMsg}</div></c:if>

  <div class="biz-card">
    <c:choose>
      <c:when test="${empty qnaList}">
        <div class="biz-review-empty">등록된 문의가 없습니다.</div>
      </c:when>
      <c:otherwise>
        <div class="biz-review-list">
          <c:forEach var="q" items="${qnaList}">
            <div class="biz-review-item">
              <div class="biz-review-main">
                <div class="biz-review-top">
                  <span class="biz-review-author">${q.nickname}</span>
                 <span class="biz-review-date">${q.regDate}</span>
                  <c:if test="${empty q.answer}"><span class="biz-review-reported">미답변</span></c:if>
                </div>
                <div class="biz-review-content"><b>상품명</b> ${q.productName}</div>
                <div class="biz-review-content" style="margin-top:6px">${q.question}</div>

                <c:choose>
                  <c:when test="${not empty q.answer}">
                    <div class="biz-review-reply"><b>답변</b>${q.answer}</div>
                  </c:when>
                  <c:otherwise>
                    <form method="post" action="${contextPath}/biz/store/qna/answer" class="biz-reply-box">
                      <input type="hidden" name="qnaId" value="${q.qnaId}">
                      <textarea name="answer" placeholder="답변 내용을 입력해주세요" required></textarea>
                      <div class="biz-reply-box-actions">
                        <button type="submit" class="btn-submit">등록</button>
                      </div>
                    </form>
                  </c:otherwise>
                </c:choose>
              </div>
              <c:if test="${not empty q.answer}">
                <div class="biz-review-actions">
                  <button class="biz-btn" onclick="this.closest('.biz-review-item').querySelector('.biz-edit-box').style.display='block'; this.style.display='none'">답변수정</button>
                </div>
                <form method="post" action="${contextPath}/biz/store/qna/answer" class="biz-reply-box biz-edit-box" style="display:none">
                  <input type="hidden" name="qnaId" value="${q.qnaId}">
                  <textarea name="answer" required>${q.answer}</textarea>
                  <div class="biz-reply-box-actions">
                    <button type="submit" class="btn-submit">수정</button>
                  </div>
                </form>
              </c:if>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>