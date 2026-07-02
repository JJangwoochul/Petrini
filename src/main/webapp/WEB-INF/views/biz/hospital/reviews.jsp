<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="reviews" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<%-- 7/2, 사업자(병원) 리뷰 관리 UI 구성 — 답글은 모달 대신 카드 내 인라인으로 처리 --%>
<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">리뷰 관리</h1>
    <p class="biz-page-desc">병원 이용 후 남겨진 리뷰를 확인하고 답글을 작성하세요.</p>
  </div>

  <div class="biz-card">
    <div style="padding:20px 20px 0">
      <div class="biz-tabs">
        <button type="button" class="biz-tab active" data-tab="all" onclick="switchTab('all')">전체<span class="biz-tab-count" id="cntAll"></span></button>
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

<script>
  // 목업 리뷰 데이터 (실 연동 전 화면 확인용)
  var reviews = [
    { id: 1, author: '김민준', date: '2026-06-28', rating: 5, content: '예방접종 때문에 방문했는데 선생님이 아주 친절하게 설명해주셨어요. 강아지도 크게 무서워하지 않고 잘 다녀왔습니다.', reported: false, reply: '소중한 후기 감사합니다 :) 다음에도 편하게 방문해주세요!' },
    { id: 2, author: '이서연', date: '2026-06-25', rating: 4, content: '전반적으로 만족스러웠는데 대기시간이 조금 길었어요. 그래도 진료는 꼼꼼하게 봐주셨습니다.', reported: false, reply: null },
    { id: 3, author: '박도현', date: '2026-06-22', rating: 2, content: '예약 시간보다 40분이나 늦게 진료받았습니다. 사전 안내라도 해주셨으면 좋았을 것 같아요.', reported: true, reply: null },
    { id: 4, author: '최아린', date: '2026-06-20', rating: 5, content: '수술 후 관리까지 꼼꼼히 챙겨주셔서 감사했어요. 믿고 맡길 수 있는 병원입니다.', reported: false, reply: '감사한 말씀 남겨주셔서 저희도 힘이 납니다. 건강히 잘 지내길 바라요!' },
    { id: 5, author: '한지우', date: '2026-06-18', rating: 1, content: '전화 응대가 불친절했습니다. 개선 부탁드려요.', reported: true, reply: null }
  ];

  var currentTab = 'all';
  var openReplyId = null;

  function starsHtml(rating) {
    var html = '';
    for (var i = 1; i <= 5; i++) {
      html += '<svg viewBox="0 0 24 24" class="' + (i <= rating ? 'on' : 'off') + '"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>';
    }
    return html;
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
    if (sort === 'high') list = list.slice().sort(function (a, b) { return b.rating - a.rating; });
    else if (sort === 'low') list = list.slice().sort(function (a, b) { return a.rating - b.rating; });

    document.getElementById('cntAll').textContent = reviews.length;
    document.getElementById('cntReported').textContent = reviews.filter(function (r) { return r.reported; }).length;

    var box = document.getElementById('reviewList');
    box.innerHTML = '';

    if (list.length === 0) {
      box.innerHTML = '<div class="biz-review-empty">표시할 리뷰가 없습니다.</div>';
      return;
    }

    list.forEach(function (r) {
      var item = document.createElement('div');
      item.className = 'biz-review-item';

      var replyBoxHtml = '';
      if (openReplyId === r.id) {
        replyBoxHtml =
          '<div class="biz-reply-box">' +
            '<textarea id="replyInput-' + r.id + '" placeholder="답글을 입력하세요">' + (r.reply || '') + '</textarea>' +
            '<div class="biz-reply-box-actions">' +
              '<button class="btn-cancel" onclick="toggleReply(' + r.id + ')">취소</button>' +
              '<button class="btn-submit" onclick="submitReply(' + r.id + ')">등록</button>' +
            '</div>' +
          '</div>';
      }

      item.innerHTML =
        '<div class="biz-review-main">' +
          '<div class="biz-review-stars">' + starsHtml(r.rating) + '</div>' +
          '<div class="biz-review-top">' +
            '<span class="biz-review-author">' + r.author + '</span>' +
            '<span class="biz-review-date">' + r.date + '</span>' +
            (r.reported ? '<span class="biz-review-reported">신고접수</span>' : '') +
          '</div>' +
          '<div class="biz-review-content">' + r.content + '</div>' +
          (r.reply && openReplyId !== r.id ? '<div class="biz-review-reply"><b>병원 답글</b>' + r.reply + '</div>' : '') +
          replyBoxHtml +
        '</div>' +
        '<div class="biz-review-actions">' +
          '<button class="biz-btn" onclick="toggleReply(' + r.id + ')">' + (r.reply ? '답글수정' : '답글쓰기') + '</button>' +
        '</div>';
      box.appendChild(item);
    });
  }

  function submitReply(id) {
    var text = document.getElementById('replyInput-' + id).value.trim();
    if (!text) { alert('답글 내용을 입력해주세요.'); return; }
    var r = reviews.find(function (x) { return x.id === id; });
    r.reply = text;
    openReplyId = null;
    renderList();

    var toast = document.getElementById('saveToast');
    toast.classList.add('on');
    setTimeout(function () { toast.classList.remove('on'); }, 2000);
  }

  renderList();
</script>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>