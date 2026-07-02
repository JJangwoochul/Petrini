<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="community" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
.cdetail-wrap{max-width:780px;margin:32px auto 80px;padding:0 20px}
.cdetail-category{font-size:12px;font-weight:700;background:var(--primary-light);color:var(--primary-dark);padding:3px 10px;border-radius:20px;display:inline-block;margin-bottom:10px}
.cdetail-title{font-size:24px;font-weight:800;color:var(--text-main);margin-bottom:14px;line-height:1.3}
.cdetail-meta{display:flex;align-items:center;gap:14px;font-size:13px;color:var(--text-muted);margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid var(--border)}
.cdetail-meta svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.cdetail-author{display:flex;align-items:center;gap:6px;font-weight:700;color:var(--text-main)}
.cdetail-author img{width:28px;height:28px;border-radius:50%;object-fit:cover}
.cdetail-img{width:100%;border-radius:var(--radius-md);margin-bottom:20px;max-height:500px;object-fit:cover}
.cdetail-content{font-size:15px;color:var(--text-sub);line-height:1.8;margin-bottom:28px}
.cdetail-actions{display:flex;align-items:center;gap:12px;padding:16px 0;border-top:1px solid var(--border);border-bottom:1px solid var(--border);margin-bottom:28px}
.action-btn{display:flex;align-items:center;gap:6px;padding:8px 18px;border:1px solid var(--border);border-radius:50px;background:#fff;font-size:14px;font-weight:600;color:var(--text-sub);cursor:pointer;transition:var(--transition)}
.action-btn:hover{border-color:var(--primary);color:var(--primary)}
.action-btn.liked{border-color:var(--accent);color:var(--accent);background:#FFF5F5}
.action-btn svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
.action-btn.liked svg{fill:var(--accent);stroke:none}
/* 댓글 */
.comment-title{font-size:16px;font-weight:800;color:var(--text-main);margin-bottom:16px}
.comment-write{display:flex;gap:10px;margin-bottom:24px}
.comment-avatar{width:36px;height:36px;border-radius:50%;object-fit:cover;flex-shrink:0}
.comment-input-wrap{flex:1}
.comment-input{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit;box-sizing:border-box;resize:none;min-height:80px;line-height:1.6}
.comment-input:focus{border-color:var(--primary)}
.comment-submit{margin-top:8px;display:flex;justify-content:flex-end}
.comment-submit button{padding:8px 20px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:13px;font-weight:700;cursor:pointer}
.comment-item{display:flex;gap:12px;margin-bottom:18px}
.comment-body{flex:1}
.comment-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:6px}
.comment-name{font-size:14px;font-weight:700;color:var(--text-main)}
.comment-date{font-size:12px;color:var(--text-muted)}
.comment-text{font-size:14px;color:var(--text-sub);line-height:1.6;margin-bottom:6px}
.comment-actions{display:flex;gap:10px;font-size:12px;color:var(--text-muted)}
.comment-actions span{cursor:pointer} .comment-actions span:hover{color:var(--primary)}
.reply-item{display:flex;gap:12px;margin-top:12px;padding-left:20px;border-left:2px solid var(--border)}
</style>
<div class="cdetail-wrap">
  <span class="cdetail-category">집사생활</span>
  <h1 class="cdetail-title">우리 강아지 훈련 방법 공유해요! 앉아·기다려 마스터!</h1>
  <div class="cdetail-meta">
    <div class="cdetail-author">
      <img src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=56&q=70&auto=format&fit=crop" alt="작성자" onerror="this.src='https://placehold.co/28x28/EAF7F2/2BAB82?text=U'">
      김민준
    </div>
    <span>2025.06.25</span>
    <span style="display:flex;align-items:center;gap:4px"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>1,284</span>
    <span style="display:flex;align-items:center;gap:4px"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>32</span>
  </div>
  <img class="cdetail-img" src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=780&q=80&auto=format&fit=crop" alt="강아지" onerror="this.src='https://placehold.co/780x400/EAF7F2/2BAB82?text=게시글이미지'">
  <div class="cdetail-content">
    6개월 된 비숑이 드디어 앉아·기다려를 완벽하게 배웠어요!<br><br>
    <strong>사용한 방법: 클리커 + 간식 조합 훈련</strong><br><br>
    처음에는 클리커 소리와 간식을 연결시키는 것부터 시작했어요.
    강아지가 클리커 소리 = 좋은 일이 온다는 것을 인식하는 데 약 3일 정도 걸렸어요.<br><br>
    <strong>앉아 훈련 순서:</strong><br>
    1. 간식을 강아지 코 앞에 두고 뒤쪽으로 서서히 올립니다<br>
    2. 자연스럽게 앉는 동작이 나오면 즉시 클릭!<br>
    3. 간식 지급<br>
    4. 이걸 하루 10번씩 반복<br><br>
    일주일 정도 하니까 "앉아" 소리만 들어도 바로 앉더라고요!
    여러분의 강아지도 분명 할 수 있어요 :)
  </div>
  <div class="cdetail-actions">
    <button class="action-btn liked" onclick="this.classList.toggle('liked')">
      <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
      좋아요 148
    </button>
    <button class="action-btn"><svg viewBox="0 0 24 24"><path d="M4 12v8a2 2 0 002 2h12a2 2 0 002-2v-8"/><polyline points="16 6 12 2 8 6"/><line x1="12" y1="2" x2="12" y2="15"/></svg>공유</button>
    <button class="action-btn" style="margin-left:auto;color:var(--text-muted)"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/></svg>더보기</button>
  </div>

  <div class="comment-title">댓글 32개</div>
  <div class="comment-write">
    <img class="comment-avatar" src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=72&q=70&auto=format&fit=crop" alt="내 아바타" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=ME'">
    <div class="comment-input-wrap">
      <textarea class="comment-input" placeholder="댓글을 입력하세요..."></textarea>
      <div class="comment-submit"><button onclick="alert('댓글이 등록되었습니다.')">등록</button></div>
    </div>
  </div>

  <div class="comment-item">
    <img class="comment-avatar" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=72&q=70&auto=format&fit=crop" alt="댓글러" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=U'">
    <div class="comment-body">
      <div class="comment-head"><span class="comment-name">이서연</span><span class="comment-date">2025.06.25</span></div>
      <div class="comment-text">정말 도움이 됐어요! 저도 클리커 훈련 해봐야겠어요. 혹시 클리커는 어디서 구매하셨나요?</div>
      <div class="comment-actions"><span>좋아요 12</span><span>답글</span></div>
      <div class="reply-item">
        <img class="comment-avatar" src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=72&q=70&auto=format&fit=crop" alt="원글" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=U'">
        <div class="comment-body">
          <div class="comment-head"><span class="comment-name">김민준 <small style="color:var(--primary);font-size:11px">글쓴이</small></span><span class="comment-date">2025.06.25</span></div>
          <div class="comment-text">펫케어 쇼핑몰에서 구매했어요! "클리커 훈련"으로 검색하시면 나와요 :)</div>
          <div class="comment-actions"><span>좋아요 5</span></div>
        </div>
      </div>
    </div>
  </div>

  <div class="comment-item">
    <img class="comment-avatar" src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=72&q=70&auto=format&fit=crop" alt="댓글러2" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=U'">
    <div class="comment-body">
      <div class="comment-head"><span class="comment-name">박지호</span><span class="comment-date">2025.06.25</span></div>
      <div class="comment-text">우리 강아지도 도전해봐야겠어요! 혹시 훈련 전에 배가 고플 때 하는 게 효과적일까요?</div>
      <div class="comment-actions"><span>좋아요 8</span><span>답글</span></div>
    </div>
  </div>

  <div style="display:flex;justify-content:center;margin-top:20px">
    <button style="padding:10px 24px;border:1px solid var(--border);border-radius:50px;background:#fff;color:var(--text-sub);font-size:14px;cursor:pointer">댓글 더보기 (30개)</button>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
