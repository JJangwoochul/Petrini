<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="community" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .comm-hero{background:linear-gradient(135deg,#0F766E 0%,#14B8A6 60%,#5EEAD4 100%);padding:40px 0;color:#fff;text-align:center}
  .comm-hero-inner{max-width:var(--inner-width);margin:0 auto;padding:0 20px}
  .comm-hero h1{font-size:28px;font-weight:800;margin:0 0 8px}
  .comm-hero p{font-size:14px;opacity:.85;margin:0}
  .comm-wrap{max-width:var(--inner-width);margin:32px auto 80px;padding:0 20px}
  .comm-tabs{display:flex;gap:0;border-bottom:2px solid var(--border);margin-bottom:24px}
  .comm-tab{padding:12px 24px;font-size:15px;font-weight:600;color:var(--text-muted);border:none;background:none;cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:var(--transition)}
  .comm-tab.on{color:var(--primary);border-bottom-color:var(--primary)}
  .comm-toolbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:18px}
  .comm-search{display:flex;gap:8px}
  .comm-search input{border:1px solid var(--border);border-radius:50px;padding:9px 18px;font-size:14px;outline:none;width:240px}
  .comm-search input:focus{border-color:var(--primary)}
  .comm-search button{padding:9px 18px;border:none;border-radius:50px;background:var(--primary);color:#fff;font-size:14px;font-weight:600;cursor:pointer}
  .btn-write{padding:9px 20px;border:none;border-radius:50px;background:var(--primary);color:#fff;font-size:14px;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:6px}
  .btn-write svg{width:14px;height:14px;stroke:#fff;fill:none;stroke-width:2.5;stroke-linecap:round;stroke-linejoin:round}
  .comm-card{display:flex;gap:16px;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:18px;margin-bottom:12px;transition:var(--transition);cursor:pointer}
  .comm-card:hover{box-shadow:var(--shadow-sm);transform:translateY(-1px)}
  .comm-thumb{width:96px;height:96px;border-radius:var(--radius-sm);object-fit:cover;flex-shrink:0}
  .comm-body{flex:1;min-width:0;display:flex;flex-direction:column;justify-content:space-between}
  .comm-category{font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px;display:inline-block;margin-bottom:6px}
  .cat-town{background:#FFF8E1;color:#F59E0B}
  .cat-lost{background:#FEE2E2;color:#DC2626}
  .cat-share{background:#DCFCE7;color:#16A34A}
  .cat-life{background:var(--primary-light);color:var(--primary-dark)}
  .comm-title{font-size:15px;font-weight:700;color:var(--text-main);margin-bottom:6px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .comm-preview{font-size:13px;color:var(--text-muted);margin-bottom:10px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
  .comm-meta{display:flex;align-items:center;gap:12px;font-size:12px;color:var(--text-muted)}
  .comm-meta-item{display:flex;align-items:center;gap:4px}
  .comm-meta-item svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
  .vet-tab{color:#0284C7 !important}
  .vet-tab.on{border-bottom-color:#0284C7 !important;color:#0284C7 !important}
  /* 수의사 상담 배너 */
  .vet-banner{background:linear-gradient(135deg,#EFF6FF,#DBEAFE);border:1px solid #BFDBFE;border-radius:var(--radius-md);padding:20px 24px;display:flex;align-items:center;gap:16px;margin-bottom:20px}
  .vet-banner-icon{width:48px;height:48px;border-radius:50%;background:#0284C7;display:flex;align-items:center;justify-content:center;flex-shrink:0}
  .vet-banner-icon svg{width:24px;height:24px;stroke:#fff}
  .vet-banner-title{font-size:16px;font-weight:800;color:#1E40AF;margin-bottom:2px}
  .vet-banner-desc{font-size:13px;color:#3B82F6}
  .vet-banner-desc strong{color:#1D4ED8}
  .btn-vet-ask{margin-left:auto;flex-shrink:0;padding:10px 18px;border:none;border-radius:50px;background:#0284C7;color:#fff;font-size:14px;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:6px;white-space:nowrap}
  .btn-vet-ask svg{width:14px;height:14px}
  .btn-vet-ask:hover{background:#0369A1}
  /* 글쓰기 폼 */
  .vet-ask-form{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;margin-bottom:20px}
  .vet-ask-title{font-size:16px;font-weight:800;color:var(--text-main);margin-bottom:20px;padding-bottom:14px;border-bottom:1px solid var(--border)}
  .vet-form-row{margin-bottom:14px}
  .vet-form-row label{display:block;font-size:13px;font-weight:600;color:var(--text-sub);margin-bottom:6px}
  .req{color:#FF6B6B}
  .vet-form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
  .vet-input{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 14px;font-size:14px;outline:none;font-family:inherit;box-sizing:border-box;transition:border-color .15s}
  .vet-input:focus{border-color:#0284C7}
  .vet-textarea{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:12px 14px;font-size:14px;outline:none;font-family:inherit;box-sizing:border-box;min-height:120px;resize:vertical;line-height:1.6}
  .vet-textarea:focus{border-color:#0284C7}
  .vet-radio-label{display:flex;align-items:center;gap:6px;font-size:14px;color:var(--text-sub);cursor:pointer;padding:8px 16px;border:1px solid var(--border);border-radius:50px}
  .vet-upload-box{border:2px dashed var(--border);border-radius:var(--radius-sm);padding:20px;text-align:center;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;color:var(--text-muted);font-size:13px}
  .vet-upload-box svg{width:20px;height:20px;stroke:currentColor;fill:none;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round}
  .vet-upload-box:hover{border-color:#0284C7;color:#0284C7}
  .vet-btn-cancel{padding:10px 24px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;color:var(--text-sub);font-size:14px;font-weight:600;cursor:pointer}
  .vet-btn-submit{padding:10px 24px;border:none;border-radius:var(--radius-sm);background:#0284C7;color:#fff;font-size:14px;font-weight:700;cursor:pointer}
  .vet-btn-submit:hover{background:#0369A1}
  /* 상담 카드 */
  .vet-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:20px;margin-bottom:12px;transition:var(--transition)}
  .vet-card:hover{box-shadow:var(--shadow-sm)}
  .vet-card-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px}
  .vet-card-badges{display:flex;gap:6px}
  .vet-badge{font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px}
  .vet-badge.dog{background:#FEF3C7;color:#D97706}
  .vet-badge.cat{background:#F3E8FF;color:#9333EA}
  .vet-badge.answered{background:#DCFCE7;color:#16A34A}
  .vet-badge.waiting{background:#FEE2E2;color:#DC2626}
  .vet-card-date{font-size:12px;color:var(--text-muted)}
  .vet-card-title{font-size:15px;font-weight:700;color:var(--text-main);margin-bottom:6px}
  .vet-card-preview{font-size:13px;color:var(--text-muted);margin-bottom:12px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
  /* 수의사 답변 박스 */
  .vet-answer{background:#EFF6FF;border:1px solid #BFDBFE;border-radius:var(--radius-sm);padding:14px 16px;margin-bottom:12px}
  .vet-answer-head{display:flex;align-items:center;gap:6px;font-size:12px;font-weight:700;color:#1D4ED8;margin-bottom:6px}
  .vet-answer-head svg{width:14px;height:14px;stroke:#1D4ED8}
  .vet-answer-date{color:#93C5FD;font-weight:400;margin-left:auto}
  .vet-answer-text{font-size:13px;color:#1E40AF;line-height:1.7}
  .vet-card-meta{display:flex;align-items:center;gap:12px;font-size:12px;color:var(--text-muted)}
  .vet-meta-item{display:flex;align-items:center;gap:4px}
  .vet-meta-item svg{width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
  .vet-meta-item.like svg{fill:var(--accent);stroke:none}
  .vet-select{border:1px solid var(--border);border-radius:50px;padding:8px 14px;font-size:13px;font-family:inherit;outline:none;cursor:pointer}
</style>

<div class="comm-hero">
  <div class="comm-hero-inner">
    <h1>우리애기 건강 고민, 수의사 선생님이 도와드려요!</h1>
    <p>강아지, 고양이와 함께하는 반려생활, 궁금한점 많으시죠?</p>
  </div>
</div>

<div class="comm-wrap">
  <div style="display:flex;justify-content:space-between;align-items:flex-end;margin-bottom:20px">
    <div>
      <h1 style="font-size:24px;font-weight:800;color:var(--text-main);margin-bottom:4px">커뮤니티</h1>
      <p style="font-size:14px;color:var(--text-muted)">반려동물 이야기를 나눠보세요</p>
    </div>
    <button class="btn-write" onclick="location.href='${contextPath}/community/write'"><svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>글쓰기</button>
  </div>
  <div class="comm-tabs">
    <button class="comm-tab on" onclick="selTab(this,'all')">전체</button>
    <button class="comm-tab" onclick="selTab(this,'life')">집사생활</button>
    <%-- <button class="comm-tab" onclick="selTab(this,'walk')">산책추천</button> --%>
    <button class="comm-tab" onclick="selTab(this,'share')">무료나눔</button>
    <button class="comm-tab vet-tab" onclick="selTab(this,'vet')">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:14px;height:14px;vertical-align:-2px;margin-right:4px"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
      수의사 상담
    </button>
  </div>
  <%-- ── 일반 게시판 영역 ─────────────────────────────── --%>
  <div id="normalBoard">
    <div class="comm-toolbar">
      <span style="font-size:14px;color:var(--text-sub)">총 <strong style="color:var(--text-main)">4,821</strong>개 게시글</span>
      <div class="comm-search">
        <input type="text" placeholder="게시글 검색...">
        <button>검색</button>
      </div>
    </div>

  <div class="comm-card" onclick="location.href='${contextPath}/community/detail?id=1'">
    <img class="comm-thumb" src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=192&q=70&auto=format&fit=crop" alt="강아지" onerror="this.src='https://placehold.co/96x96/EAF7F2/2BAB82?text=IMG'">
    <div class="comm-body">
      <div>
        <span class="comm-category cat-life">집사생활</span>
        <div class="comm-title">우리 강아지 훈련 방법 공유해요! 앉아·기다려 마스터!</div>
        <div class="comm-preview">6개월 된 비숑이 드디어 앉아·기다려를 배웠어요! 간식 클리커 훈련법으로 2주 만에 성공했답니다. 궁금하신 분들을 위해 자세한 방법을 공유해 드릴게요...</div>
      </div>
      <div class="comm-meta">
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>김민준</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.25</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>1,284</span>
        <span class="comm-meta-item like"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>148</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>32</span>
      </div>
    </div>
  </div>

  <div class="comm-card" onclick="location.href='${contextPath}/community/detail?id=2'">
    <img class="comm-thumb" src="https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=192&q=70&auto=format&fit=crop" alt="분실" onerror="this.src='https://placehold.co/96x96/FEE2E2/DC2626?text=분실'">
    <div class="comm-body">
      <div>
        <span class="comm-category cat-lost">분실·보호</span>
        <div class="comm-title">[분실] 강남구 역삼동 흰색 말티즈 찾습니다 — 6월 25일 오후 실종</div>
        <div class="comm-preview">이름은 코코, 3살 암컷 말티즈입니다. 어제 오후 6시쯤 역삼역 근처에서 목줄이 끊어져 실종됐어요. 파란 하트 모양 목걸이를 하고 있어요. 발견하시면 꼭 연락주세요...</div>
      </div>
      <div class="comm-meta">
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>이서연</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.25</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>892</span>
        <span class="comm-meta-item like"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>84</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>18</span>
      </div>
    </div>
  </div>

  <div class="comm-card" onclick="location.href='${contextPath}/community/detail?id=3'">
    <img class="comm-thumb" src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=192&q=70&auto=format&fit=crop" alt="나눔" onerror="this.src='https://placehold.co/96x96/DCFCE7/16A34A?text=나눔'">
    <div class="comm-body">
      <div>
        <span class="comm-category cat-share">무료나눔</span>
        <div class="comm-title">[나눔완료] 고양이 사료 나눔합니다 — 마포구 직거래</div>
        <div class="comm-preview">고양이가 갑자기 이 사료를 안 먹어서 나눔합니다. 로얄캐닌 인도어 2kg 미개봉 1개, 절반 사용 1개. 마포구 합정역 근처 직거래만 가능해요...</div>
      </div>
      <div class="comm-meta">
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>최유나</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.24</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>456</span>
        <span class="comm-meta-item like"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>31</span>
        <span class="comm-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>9</span>
      </div>
    </div>
  </div>

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
</div>
<script>
function selTab(btn, type) {
  document.querySelectorAll('.comm-tab').forEach(t => t.classList.remove('on'));
  btn.classList.add('on');
  var isVet = (type === 'vet');
  document.getElementById('normalBoard').style.display = isVet ? 'none' : 'block';
  document.getElementById('vetBoard').style.display   = isVet ? 'block' : 'none';
  if (!isVet) document.getElementById('askForm').style.display = 'none';
}
function toggleAskForm() {
  var f = document.getElementById('askForm');
  f.style.display = f.style.display === 'none' ? 'block' : 'none';
  if (f.style.display === 'block') f.scrollIntoView({behavior:'smooth', block:'start'});
}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
