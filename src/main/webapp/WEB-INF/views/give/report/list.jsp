<%-- give/report/_list.jsp — 분실/보호 게시판 탭 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="give" />
<c:set var="giveTab"     value="report" />

<%@ include file="/WEB-INF/views/give/index.jsp" %>

<style>
  .report-toolbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;flex-wrap:wrap;gap:12px}
  .report-filters{display:flex;gap:8px;flex-wrap:wrap}
  .report-chip{padding:7px 16px;border:1px solid var(--border);border-radius:50px;font-size:13px;color:var(--text-sub);background:#fff;cursor:pointer;transition:var(--transition)}
  .report-chip:hover,.report-chip.on{border-color:var(--primary);background:var(--primary-light);color:var(--primary-dark);font-weight:600}
  .btn-report-write{padding:9px 20px;border:none;border-radius:50px;background:var(--primary);color:#fff;font-size:14px;font-weight:700;cursor:pointer;display:flex;align-items:center;gap:6px}
  .btn-report-write svg{width:14px;height:14px;stroke:#fff;fill:none;stroke-width:2.5;stroke-linecap:round;stroke-linejoin:round}

  .report-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;margin-bottom:32px}
  .report-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden;transition:var(--transition);cursor:pointer}
  .report-card:hover{box-shadow:var(--shadow-md);transform:translateY(-2px)}
  .report-thumb-wrap{position:relative}
  .report-thumb{width:100%;height:200px;object-fit:cover;display:block}
  .report-status{position:absolute;top:10px;left:10px;font-size:11px;font-weight:700;padding:3px 9px;border-radius:20px}
  .rs-finding{background:#FFF8E1;color:#F59E0B}
  .rs-rescued{background:#DCFCE7;color:#16A34A}
  .rs-returned{background:#EEF2FF;color:#3B5BDB}
  .report-map-pin{position:absolute;bottom:10px;right:10px;background:rgba(0,0,0,.55);color:#fff;font-size:11px;font-weight:600;padding:4px 10px;border-radius:20px;display:flex;align-items:center;gap:4px}
  .report-map-pin svg{width:11px;height:11px;stroke:#fff;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .report-body{padding:14px}
  .report-tags{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:8px}
  .report-tag{font-size:11px;font-weight:700;padding:2px 9px;border-radius:20px;background:var(--primary-light);color:var(--primary-dark)}
  .report-title{font-size:14px;font-weight:700;color:var(--text-main);margin-bottom:5px;line-height:1.4;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .report-desc{font-size:12px;color:var(--text-muted);line-height:1.6;margin-bottom:10px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
  .report-meta{display:flex;justify-content:space-between;font-size:12px;color:var(--text-muted)}
  .report-meta-left{display:flex;align-items:center;gap:10px}
  .report-meta-item{display:flex;align-items:center;gap:4px}
  .report-meta-item svg{width:12px;height:12px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
</style>

<div class="give-content">
  <div class="report-toolbar">
    <div class="report-filters">
      <span class="report-chip on" onclick="selChip(this)">전체</span>
      <span class="report-chip" onclick="selChip(this)">분실</span>
      <span class="report-chip" onclick="selChip(this)">임시보호중</span>
      <span class="report-chip" onclick="selChip(this)">발견</span>
      <%-- <span class="report-chip" onclick="selChip(this)">강아지</span>
      <span class="report-chip" onclick="selChip(this)">고양이</span> --%>
    </div>
    <button class="btn-report-write" onclick="location.href='${contextPath}/give/report/write'">
      <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      발견 신고하기
    </button>
  </div>

  <div style="font-size:14px;color:var(--text-sub);margin-bottom:16px">
    총 <strong style="color:var(--text-main)">328</strong>건의 발견 신고가 있습니다
  </div>

  <div class="report-grid">
    <div class="report-card" onclick="location.href='${contextPath}/give/report/detail?id=1'">
      <div class="report-thumb-wrap">
        <img class="report-thumb" src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400&q=70&auto=format&fit=crop" alt="신고1" onerror="this.src='https://placehold.co/400x200/EAF7F2/2BAB82?text=발견사진'">
        <span class="report-status rs-finding">찾는 중</span>
        <div class="report-map-pin"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 마포구</div>
      </div>
      <div class="report-body">
        <div class="report-tags"><span class="report-tag">강아지</span><span class="report-tag">중형</span><span class="report-tag">황갈색</span></div>
        <div class="report-title">합정역 근처 목줄 없는 강아지 발견</div>
        <div class="report-desc">합정역 2번 출구 앞에서 목줄 없이 배회하는 강아지를 발견했습니다. 골든 리트리버로 보이며 약 20kg 정도 됩니다. 겁을 많이 먹은 상태입니다.</div>
        <div class="report-meta">
          <div class="report-meta-left">
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>김민준</span>
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.25</span>
          </div>
          <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>12</span>
        </div>
      </div>
    </div>

    <div class="report-card" onclick="location.href='${contextPath}/give/report/detail?id=2'">
      <div class="report-thumb-wrap">
        <img class="report-thumb" src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400&q=70&auto=format&fit=crop" alt="신고2" onerror="this.src='https://placehold.co/400x200/F3E8FF/9333EA?text=발견사진'">
        <span class="report-status rs-rescued">구조 완료</span>
        <div class="report-map-pin"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 강남구</div>
      </div>
      <div class="report-body">
        <div class="report-tags"><span class="report-tag">고양이</span><span class="report-tag">소형</span><span class="report-tag">검은색</span></div>
        <div class="report-title">[구조완료] 삼성동 아파트 단지 고양이 발견</div>
        <div class="report-desc">삼성동 아파트 주차장에서 다리를 절고 있는 고양이를 발견했습니다. 임시 보호 후 보호소 연계 완료되었습니다.</div>
        <div class="report-meta">
          <div class="report-meta-left">
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>이서연</span>
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.24</span>
          </div>
          <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>8</span>
        </div>
      </div>
    </div>

    <div class="report-card" onclick="location.href='${contextPath}/give/report/detail?id=3'">
      <div class="report-thumb-wrap">
        <img class="report-thumb" src="https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&q=70&auto=format&fit=crop" alt="신고3" onerror="this.src='https://placehold.co/400x200/EAF7F2/2BAB82?text=발견사진'">
        <span class="report-status rs-returned">주인 찾음</span>
        <div class="report-map-pin"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>경기 고양시</div>
      </div>
      <div class="report-body">
        <div class="report-tags"><span class="report-tag">강아지</span><span class="report-tag">소형</span><span class="report-tag">흰색</span></div>
        <div class="report-title">[주인찾음] 일산 호수공원 흰색 푸들 발견</div>
        <div class="report-desc">일산 호수공원 벤치 근처에서 혼자 앉아있는 푸들을 발견했습니다. 목걸이에 연락처가 있어 주인에게 연락이 닿았습니다.</div>
        <div class="report-meta">
          <div class="report-meta-left">
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>박지호</span>
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.23</span>
          </div>
          <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>5</span>
        </div>
      </div>
    </div>

    <div class="report-card" onclick="location.href='${contextPath}/give/report/detail?id=4'">
      <div class="report-thumb-wrap">
        <img class="report-thumb" src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=400&q=70&auto=format&fit=crop" alt="신고4" onerror="this.src='https://placehold.co/400x200/EAF7F2/2BAB82?text=발견사진'">
        <span class="report-status rs-finding">찾는 중</span>
        <div class="report-map-pin"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>서울 노원구</div>
      </div>
      <div class="report-body">
        <div class="report-tags"><span class="report-tag">강아지</span><span class="report-tag">중형</span><span class="report-tag">오렌지</span></div>
        <div class="report-title">노원역 인근 시바이누로 보이는 강아지 목격</div>
        <div class="report-desc">노원역 근처 골목에서 시바이누처럼 생긴 강아지가 배회하고 있습니다. 경계심이 강해 접근이 어렵습니다. 주변 분들의 제보 부탁드립니다.</div>
        <div class="report-meta">
          <div class="report-meta-left">
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>최유나</span>
            <span class="report-meta-item"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>2025.06.22</span>
          </div>
          <span class="report-meta-item"><svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>21</span>
        </div>
      </div>
    </div>
  </div>

  <div style="display:flex;justify-content:center;gap:5px">
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">‹</button>
    <button style="width:36px;height:36px;border:1px solid var(--primary);border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-weight:700;cursor:pointer">1</button>
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">2</button>
    <button style="width:36px;height:36px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;cursor:pointer">›</button>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
function selChip(el) {
  document.querySelectorAll('.report-chip').forEach(c => c.classList.remove('on'));
  el.classList.add('on');
}
</script>
