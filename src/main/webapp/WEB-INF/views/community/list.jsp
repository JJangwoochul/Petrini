<%-- community/list.jsp — 커뮤니티 게시판 목록 --%>
<%--
  - 박유정 / 2026-07-08
  - STEP 3: 목록 DB 연동 (가짜 카드 → ${list})

  [목록 화면 흐름]
  1. GET /community?boardType=... → CommunityPostController.list()
  2. Service → TB_POST 조회 + thumbUrl(첫 사진)
  3. 아래 <c:forEach items="${list}"> 로 카드 표시
  4. 탭 클릭은 index.jsp 의 <a href> 로 URL 이동 (JS 필터 X)

  [탭 ↔ boardType]
  - 전체 /community
  - 집사생활 ?boardType=TOWN
  - 무료나눔 ?boardType=SHARE
  - 수의사 상담 ?boardType=LIFE
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="community" />
<c:set var="commTab" value="all" />
<%@ include file="/WEB-INF/views/community/index.jsp" %>
  <%-- ── 일반 게시판 영역 ─────────────────────────────── --%>
  <div id="normalBoard">
    <div class="comm-toolbar">
      <span style="font-size:14px;color:var(--text-sub)">총 <strong style="color:var(--text-main)">4,821</strong>개 게시글</span>
      <div class="comm-search">
        <input type="text" placeholder="게시글 검색...">
        <button>검색</button>
      </div>
    </div>

    <%-- DB 글 목록 (Controller 가 넘긴 ${list}) --%>
    <c:forEach var="item" items="${list}">
      <div class="comm-card" onclick="location.href='${contextPath}/community/detail?id=${item.postId}'">
        <img class="comm-thumb"
             src="${not empty item.thumbUrl ? contextPath.concat(item.thumbUrl) : 'https://placehold.co/96x96/EAF7F2/2BAB82?text=IMG'}"
             alt="썸네일"
             onerror="this.src='https://placehold.co/96x96/EAF7F2/2BAB82?text=IMG'">
        <div class="comm-body">
          <div>
            <c:choose>
              <c:when test="${item.boardType eq 'TOWN'}">
                <span class="comm-category cat-town">집사생활</span>
              </c:when>
              <c:when test="${item.boardType eq 'SHARE'}">
                <span class="comm-category cat-share">무료나눔</span>
              </c:when>
              <c:when test="${item.boardType eq 'LIFE'}">
                <span class="comm-category cat-life">수의사 상담</span>
              </c:when>
            </c:choose>
            <div class="comm-title">${item.title}</div>
            <div class="comm-preview">${item.body}</div>
          </div>
          <div class="comm-meta">
            <span class="comm-meta-item">${item.regDate}</span>
            <span class="comm-meta-item">조회 ${item.viewCount}</span>
            <span class="comm-meta-item">♥ ${item.likeCnt}</span>
          </div>
        </div>
      </div>
    </c:forEach>

<c:if test="${empty list}">
  <p style="text-align:center;color:var(--text-muted);padding:40px 0">
    등록된 게시글이 없습니다.
  </p>
</c:if>

  <div style="display:flex;justify-content:center;margin-top:24px;gap:5px">
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">‹</button>
    <button style="width:36px;height:36px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-weight:700;cursor:pointer">1</button>
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">2</button>
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">3</button>
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">›</button>
  </div>
  </div><%-- end #normalBoard --%>

  <%-- ── 수의사 상담 탭 영역 ──────────────────────────── --%>
  <div id="vetBoard" style="display:none">
    <%-- 안내 배너 --%>
    <div class="vet-banner">
      <div class="vet-banner-icon">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
      </div>
      <div>
        <div class="vet-banner-title">펫케어 수의사 상담</div>
        <div class="vet-banner-desc">등록된 수의사 선생님이 직접 답변해드립니다. 평균 답변 시간 <strong>4시간</strong> 이내</div>
      </div>
      <button class="btn-vet-ask" onclick="toggleAskForm()">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        상담 글쓰기
      </button>
    </div>

    <%-- 상담 글쓰기 폼 (토글) --%>
    <div class="vet-ask-form" id="askForm" style="display:none">
      <div class="vet-ask-title">상담 내용 작성</div>
      <div class="vet-form-row">
        <label>반려동물 종류 <span class="req">*</span></label>
        <div style="display:flex;gap:8px;flex-wrap:wrap">
          <label class="vet-radio-label"><input type="radio" name="petType" value="dog" checked> 강아지</label>
          <label class="vet-radio-label"><input type="radio" name="petType" value="cat"> 고양이</label>
          <label class="vet-radio-label"><input type="radio" name="petType" value="other"> 기타</label>
        </div>
      </div>
      <div class="vet-form-grid">
        <div class="vet-form-row">
          <label>품종 <span class="req">*</span></label>
          <input type="text" class="vet-input" placeholder="예) 말티즈, 페르시안">
        </div>
        <div class="vet-form-row">
          <label>나이</label>
          <input type="text" class="vet-input" placeholder="예) 2세, 생후 6개월">
        </div>
      </div>
      <div class="vet-form-row">
        <label>상담 제목 <span class="req">*</span></label>
        <input type="text" class="vet-input" placeholder="상담하실 내용을 간략하게 적어주세요">
      </div>
      <div class="vet-form-row">
        <label>증상 및 상담 내용 <span class="req">*</span></label>
        <textarea class="vet-textarea" placeholder="언제부터 증상이 시작됐는지, 어떤 행동을 보이는지 최대한 자세히 적어주세요.&#10;&#10;예) 3일 전부터 밥을 잘 안 먹고, 물은 평소보다 많이 마셔요. 구토는 없지만 기운이 없어 보여요."></textarea>
      </div>
      <div class="vet-form-row">
        <label>관련 사진 첨부 <span style="font-size:12px;color:var(--text-muted);font-weight:400">(선택, 최대 3장)</span></label>
        <div class="vet-upload-box" onclick="alert('이미지 업로드')">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
          <span>클릭하여 사진 업로드</span>
        </div>
      </div>
      <div style="display:flex;gap:10px;justify-content:flex-end">
        <button class="vet-btn-cancel" onclick="toggleAskForm()">취소</button>
        <button class="vet-btn-submit" onclick="if(confirm('상담 글을 등록하시겠습니까?'))alert('상담 글이 등록되었습니다.\n수의사 선생님의 답변을 기다려주세요!')">등록하기</button>
      </div>
    </div>

    <%-- 필터 --%>
    <div class="comm-toolbar" style="margin-bottom:16px">
      <span style="font-size:14px;color:var(--text-sub)">총 <strong style="color:var(--text-main)">1,248</strong>개 상담</span>
      <div style="display:flex;gap:8px">
        <select class="vet-select"><option>전체 동물</option><option>강아지</option><option>고양이</option><option>기타</option></select>
        <select class="vet-select"><option>전체 상태</option><option>답변 완료</option><option>답변 대기</option></select>
        <div class="comm-search">
          <input type="text" placeholder="증상, 키워드 검색...">
          <button>검색</button>
        </div>
      </div>
    </div>

    <%-- 상담 카드 목록 --%>
    <div class="vet-card">
      <div class="vet-card-head">
        <div class="vet-card-badges">
          <span class="vet-badge dog">강아지</span>
          <span class="vet-badge answered">답변완료</span>
        </div>
        <span class="vet-card-date">2025.06.25</span>
      </div>
      <div class="vet-card-title">말티즈 3살인데 갑자기 물을 너무 많이 마셔요</div>
      <div class="vet-card-preview">3일 전부터 밥을 잘 안 먹고 물은 평소 2배 이상 마시고 있어요. 소변도 자주 보고...</div>
      <div class="vet-answer">
        <div class="vet-answer-head">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
          수의사 김○○ 답변
          <span class="vet-answer-date">2025.06.25</span>
        </div>
        <div class="vet-answer-text">다뇨·다음(물을 많이 마시고 소변을 자주 보는 증상)이 함께 나타나는 경우 당뇨, 신장 질환, 쿠싱증후군 등을 의심할 수 있습니다. 이런 증상이 3일 이상 지속된다면 혈액검사와 소변검사를 권장합니다. 가능한 빠른 시일 내에 내원해 주세요.</div>
      </div>
      <div class="vet-card-meta">
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>이민지</span>
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>1,042</span>
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>24</span>
        <span class="vet-meta-item like"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>89</span>
      </div>
    </div>

    <div class="vet-card">
      <div class="vet-card-head">
        <div class="vet-card-badges">
          <span class="vet-badge cat">고양이</span>
          <span class="vet-badge answered">답변완료</span>
        </div>
        <span class="vet-card-date">2025.06.24</span>
      </div>
      <div class="vet-card-title">고양이가 갑자기 구토를 반복해요 — 하루에 4번 이상</div>
      <div class="vet-card-preview">평소에 헤어볼 토는 가끔 있었는데 어제부터 노란 액체를 계속 토해요. 밥도 안 먹고 구석에만 있어요...</div>
      <div class="vet-answer">
        <div class="vet-answer-head">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
          수의사 박○○ 답변
          <span class="vet-answer-date">2025.06.24</span>
        </div>
        <div class="vet-answer-text">노란 액체를 반복적으로 구토하는 것은 담즙이 역류하는 것으로 공복 시간이 너무 길거나 위염, 이물질 섭취 등이 원인일 수 있습니다. 식욕 부진과 무기력이 동반된다면 즉시 내원을 권장합니다. 24시간 이상 증상이 지속되면 탈수 위험이 있으니 지체하지 마세요.</div>
      </div>
      <div class="vet-card-meta">
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>한소희</span>
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>876</span>
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>17</span>
        <span class="vet-meta-item like"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>67</span>
      </div>
    </div>

    <div class="vet-card">
      <div class="vet-card-head">
        <div class="vet-card-badges">
          <span class="vet-badge dog">강아지</span>
          <span class="vet-badge waiting">답변대기</span>
        </div>
        <span class="vet-card-date">2025.06.26</span>
      </div>
      <div class="vet-card-title">골든 리트리버 5살, 뒷다리를 절뚝거려요</div>
      <div class="vet-card-preview">산책 후에 갑자기 왼쪽 뒷다리를 들고 다니기 시작했어요. 만지면 아파하진 않는데 체중을 잘 싣지 못하는 것 같아요...</div>
      <div class="vet-card-meta" style="margin-top:12px">
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>정우찬</span>
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>342</span>
        <span class="vet-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>6</span>
        <span class="vet-meta-item like"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>28</span>
      </div>
    </div>

    <div style="display:flex;justify-content:center;margin-top:24px;gap:5px">
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">‹</button>
      <button style="width:36px;height:36px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-weight:700;cursor:pointer">1</button>
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">2</button>
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">3</button>
      <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">›</button>
    </div>
  </div><%-- end #vetBoard --%>
  </div><%-- end .comm-content --%>
</div><%-- end .comm-wrap --%>
<script>
function selTab(btn, type) {
  document.querySelectorAll('.comm-tab').forEach(function(t) {
    if (t.tagName === 'BUTTON') t.classList.remove('on');
  });
  btn.classList.add('on');

  var isVet = (type === 'vet');
  document.getElementById('normalBoard').style.display = isVet ? 'none' : 'block';
  document.getElementById('vetBoard').style.display   = isVet ? 'block' : 'none';
  if (!isVet) document.getElementById('askForm').style.display = 'none';

  if (isVet) return;

  // 전체 / 집사생활 / 무료나눔 — 카드 필터 (DB 연동 전 UI용)
  document.querySelectorAll('#normalBoard .comm-card').forEach(function(card) {
    var bt = card.getAttribute('data-board-type');
    var show = false;
    if (type === 'all')   show = true;
    if (type === 'life')  show = (bt === 'LIFE');
    if (type === 'share') show = (bt === 'SHARE');
    card.style.display = show ? 'flex' : 'none';
  });
}
function toggleAskForm() {
  var f = document.getElementById('askForm');
  f.style.display = f.style.display === 'none' ? 'block' : 'none';
  if (f.style.display === 'block') f.scrollIntoView({behavior:'smooth', block:'start'});
}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
