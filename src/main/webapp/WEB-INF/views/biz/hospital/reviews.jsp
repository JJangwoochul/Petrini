<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="reviews" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<%-- 7/2, 사업자(병원) 리뷰 관리 UI — 2026/07/14 장우철 DB 목록·답글 저장 연동 --%>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">리뷰 관리</h1>
    <p class="biz-page-desc">병원 이용 후 남겨진 리뷰를 확인하고 답글을 작성하세요.</p>
  </div>

  <c:if test="${not empty msg}">
    <div style="margin-bottom:12px;padding:12px 16px;background:#E8F8F1;color:#1F8464;border-radius:8px;font-size:14px">${msg}</div>
  </c:if>
  <c:if test="${not empty errorMsg}">
    <div style="margin-bottom:12px;padding:12px 16px;background:#FEF2F2;color:#B91C1C;border-radius:8px;font-size:14px">${errorMsg}</div>
  </c:if>

  <div class="biz-card">
    <div style="padding:20px 20px 0">
      <div class="biz-tabs">
        <button type="button" class="biz-tab active" data-tab="all" onclick="switchTab('all')">전체<span class="biz-tab-count" id="cntAll"></span></button>
        <%-- 신고 기능(2단계) 연동 전: 탭 UI만 유지, 건수는 0 --%>
        <button type="button" class="biz-tab" data-tab="reported" onclick="switchTab('reported')">신고관리<span class="biz-tab-count" id="cntReported"></span></button>
        <div class="biz-tabs-right">
          <select class="biz-select-sm" id="sortSelect" onchange="renderList()">
            <option value="latest">최신순</option>
            <option value="high">평점 높은순</option>
            <option value="low">평점 낮은순</option>
          </select>
        </div>
      </div>
    </div>

    <div class="biz-review-list" id="reviewList"></div>
  </div>
</main>

<div class="biz-toast" id="saveToast">
  <svg viewBox="0 0 24 24" fill="none" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
  답글이 등록되었습니다.
</div>

<%-- 답글 서버 저장 폼 --%>
<form id="replyForm" method="post" action="${contextPath}/biz/hospital/reviews/reply" style="display:none">
  <input type="hidden" name="reviewId" id="replyReviewId" value="">
  <input type="hidden" name="bizReply" id="replyBizReply" value="">
</form>

<script>
  // 2026/07/14 장우철 — 서버 TB_REVIEW 목록 (목업 제거)
  var reviews = ${empty reviewListJson ? '[]' : reviewListJson};
  var currentTab = 'all';
  var openReplyId = null;
  var contextPath = '${contextPath}';

  function starsHtml(rating) {
    var n = Math.round(Number(rating) || 0);
    var html = '';
    for (var i = 1; i <= 5; i++) {
      html += '<svg viewBox="0 0 24 24" class="' + (i <= n ? 'on' : 'off') + '"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>';
    }
    return html;
  }

  function escapeHtml(str) {
    return String(str == null ? '' : str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function switchTab(tab) {
    currentTab = tab;
    openReplyId = null;
    document.querySelectorAll('.biz-tab').forEach(function (b) { b.classList.toggle('active', b.dataset.tab === tab); });
    renderList();
  }

  function toggleReply(id) {
    openReplyId = (openReplyId === id) ? null : id;
    renderList();
  }

  function renderList() {
    var list = reviews.filter(function (r) { return currentTab === 'all' || r.reported; });

    var sort = document.getElementById('sortSelect').value;
    if (sort === 'high') list = list.slice().sort(function (a, b) { return Number(b.rating) - Number(a.rating); });
    else if (sort === 'low') list = list.slice().sort(function (a, b) { return Number(a.rating) - Number(b.rating); });
    else list = list.slice().sort(function (a, b) { return String(b.date).localeCompare(String(a.date)); });

    document.getElementById('cntAll').textContent = reviews.length;
    document.getElementById('cntReported').textContent = reviews.filter(function (r) { return r.reported; }).length;

    var box = document.getElementById('reviewList');
    box.innerHTML = '';

    if (list.length === 0) {
      box.innerHTML = '<div class="biz-review-empty">' +
        (currentTab === 'reported' ? '신고된 리뷰가 없습니다. (신고 기능은 다음 단계에서 연동)' : '등록된 리뷰가 없습니다.') +
        '</div>';
      return;
    }

    list.forEach(function (r) {
      var item = document.createElement('div');
      item.className = 'biz-review-item';

      var replyBoxHtml = '';
      if (openReplyId === r.id) {
        replyBoxHtml =
          '<div class="biz-reply-box">' +
            '<textarea id="replyInput-' + r.id + '" placeholder="답글 내용을 입력해주세요">' + escapeHtml(r.reply || '') + '</textarea>' +
            '<div class="biz-reply-box-actions">' +
              '<button type="button" class="btn-cancel" onclick="toggleReply(' + r.id + ')">취소</button>' +
              '<button type="button" class="btn-submit" onclick="submitReply(' + r.id + ')">등록</button>' +
            '</div>' +
          '</div>';
      }

      item.innerHTML =
        '<div class="biz-review-main">' +
          '<div class="biz-review-stars">' + starsHtml(r.rating) + '</div>' +
          '<div class="biz-review-top">' +
            '<span class="biz-review-author">' + escapeHtml(r.author) + '</span>' +
            '<span class="biz-review-date">' + escapeHtml(r.date) + '</span>' +
            (r.reported ? '<span class="biz-review-reported">신고접수</span>' : '') +
          '</div>' +
          '<div class="biz-review-content">' + escapeHtml(r.content) + '</div>' +
          (r.reply && openReplyId !== r.id ? '<div class="biz-review-reply"><b>병원 답글</b>' + escapeHtml(r.reply) + '</div>' : '') +
          replyBoxHtml +
        '</div>' +
        '<div class="biz-review-actions">' +
          '<button type="button" class="biz-btn" onclick="toggleReply(' + r.id + ')">' + (r.reply ? '답글수정' : '답글쓰기') + '</button>' +
        '</div>';
      box.appendChild(item);
    });
  }

  // 2026/07/14 장우철 — 답글 POST → TB_REVIEW.BIZ_REPLY
  function submitReply(id) {
    var text = document.getElementById('replyInput-' + id).value.trim();
    if (!text) { alert('답글 내용을 입력해주세요.'); return; }
    if (!confirm('답글을 저장할까요?')) return;
    document.getElementById('replyReviewId').value = id;
    document.getElementById('replyBizReply').value = text;
    document.getElementById('replyForm').submit();
  }

  renderList();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
