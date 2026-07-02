<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="give" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .rd-wrap{max-width:860px;margin:32px auto 80px;padding:0 20px;display:grid;grid-template-columns:1fr 280px;gap:24px;align-items:flex-start}
  .rd-back{display:inline-flex;align-items:center;gap:6px;font-size:13px;color:var(--text-muted);text-decoration:none;margin-bottom:18px;transition:var(--transition)}
  .rd-back:hover{color:var(--primary)}
  .rd-back svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .rd-photos{display:grid;grid-template-columns:2fr 1fr;gap:6px;border-radius:var(--radius-md);overflow:hidden;margin-bottom:20px}
  .rd-photos img{width:100%;object-fit:cover;display:block}
  .rd-photos img:first-child{height:260px;grid-row:span 2}
  .rd-photos img:not(:first-child){height:127px}
  .rd-status-row{display:flex;align-items:center;gap:10px;margin-bottom:10px}
  .rd-status{font-size:13px;font-weight:700;padding:4px 14px;border-radius:20px}
  .rds-finding{background:#FFF8E1;color:#F59E0B}
  .rds-rescued{background:#DCFCE7;color:#16A34A}
  .rd-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:14px;line-height:1.3}
  .rd-tags{display:flex;gap:7px;flex-wrap:wrap;margin-bottom:16px}
  .rd-tag{font-size:12px;font-weight:700;padding:4px 12px;border-radius:20px;background:var(--primary-light);color:var(--primary-dark)}
  .rd-info-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:20px}
  .rd-info-row{background:var(--bg-page);border-radius:var(--radius-sm);padding:12px 14px}
  .rd-info-row label{font-size:11px;color:var(--text-muted);font-weight:600;display:block;margin-bottom:3px}
  .rd-info-row span{font-size:14px;font-weight:600;color:var(--text-main)}
  .rd-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:18px;margin-bottom:16px}
  .rd-section h3{font-size:14px;font-weight:800;color:var(--text-main);margin:0 0 12px}
  .rd-desc{font-size:14px;color:var(--text-sub);line-height:1.8;margin:0;border-left:3px solid var(--primary);padding-left:14px}
  .rd-map{border-radius:var(--radius-sm);overflow:hidden;height:180px}
  .rd-map img{width:100%;height:100%;object-fit:cover;display:block}
  .comment-area{}
  .comment-input-wrap{display:flex;gap:10px;margin-bottom:18px}
  .comment-avatar{width:36px;height:36px;border-radius:50%;object-fit:cover;flex-shrink:0}
  .comment-flex{flex:1}
  .comment-input{width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 13px;font-size:14px;color:var(--text-main);outline:none;font-family:inherit;resize:none;min-height:70px;line-height:1.6;box-sizing:border-box}
  .comment-input:focus{border-color:var(--primary)}
  .comment-submit-row{display:flex;justify-content:flex-end;margin-top:8px}
  .comment-submit-row button{padding:7px 18px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:13px;font-weight:700;cursor:pointer}
  .comment-item{display:flex;gap:12px;margin-bottom:14px}
  .comment-body-box{flex:1}
  .comment-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:5px}
  .comment-name{font-size:14px;font-weight:700;color:var(--text-main)}
  .comment-date{font-size:12px;color:var(--text-muted)}
  .comment-text{font-size:14px;color:var(--text-sub);line-height:1.6}
  
  /* 사이드 카드 */
  .rd-side-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:20px;position:sticky;top:20px;margin-bottom:16px}
  .rd-side-card h3{font-size:14px;font-weight:800;color:var(--text-main);margin:0 0 14px;padding-bottom:12px;border-bottom:1px solid var(--border)}
  .side-row{display:flex;justify-content:space-between;font-size:13px;color:var(--text-sub);margin-bottom:10px}
  .side-row:last-child{margin-bottom:0}
  .side-row span:last-child{font-weight:700;color:var(--text-main)}
  .btn-status-change{width:100%;padding:11px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:14px;font-weight:700;cursor:pointer;margin-top:14px;transition:var(--transition)}
  .btn-status-change:hover{background:var(--primary-dark)}
  .btn-shelter-link{width:100%;padding:10px;border:2px solid var(--primary);border-radius:var(--radius-sm);background:#fff;color:var(--primary);font-size:13px;font-weight:700;cursor:pointer;margin-top:8px}
</style>

<div class="rd-wrap">
  <div>
    <a href="${contextPath}/give?tab=report" class="rd-back">
      <svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>
      발견 신고 목록으로
    </a>
    <div class="rd-photos">
      <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=600&q=80&auto=format&fit=crop" alt="발견사진 메인" onerror="this.src='https://placehold.co/600x260/EAF7F2/2BAB82?text=발견사진'">
      <img src="https://images.unsplash.com/photo-1552053831-71594a27632d?w=300&q=70&auto=format&fit=crop" alt="발견사진2" onerror="this.src='https://placehold.co/300x127/EAF7F2/2BAB82?text=사진'">
      <img src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=300&q=70&auto=format&fit=crop" alt="발견사진3" onerror="this.src='https://placehold.co/300x127/EAF7F2/2BAB82?text=사진'">
    </div>

    <div class="rd-status-row">
      <span class="rd-status rds-finding">찾는 중</span>
      <span style="font-size:12px;color:var(--text-muted)">신고번호: #RPT-2025-0892</span>
    </div>
    <div class="rd-title">합정역 근처 목줄 없는 강아지 발견</div>
    <div class="rd-tags">
      <span class="rd-tag">강아지</span>
      <span class="rd-tag">중형</span>
      <span class="rd-tag">황갈색</span>
      <span class="rd-tag">목줄 없음</span>
      <span class="rd-tag">겁을 많이 먹음</span>
    </div>

    <div class="rd-info-grid">
      <div class="rd-info-row"><label>발견 일시</label><span>2025.06.25 15:32</span></div>
      <div class="rd-info-row"><label>발견 장소</label><span>서울 마포구 합정역 2번 출구</span></div>
      <div class="rd-info-row"><label>추정 크기</label><span>중형 (약 20kg)</span></div>
      <div class="rd-info-row"><label>털 색상</label><span>황갈색</span></div>
      <div class="rd-info-row"><label>현재 상황</label><span>제보 후 자리 떠남 — 인근 목격 중</span></div>
      <div class="rd-info-row"><label>신고자</label><span>김민준</span></div>
    </div>

    <div class="rd-section">
      <h3>상세 설명</h3>
      <p class="rd-desc">합정역 2번 출구 앞에서 목줄 없이 배회하는 강아지를 발견했습니다. 골든 리트리버로 보이며 약 20kg 정도 됩니다. 겁을 많이 먹은 상태로 접근하면 피합니다. 인근 편의점 앞을 왔다 갔다 하고 있어요. 잃어버리신 분이나 주변에서 목격하신 분은 댓글 달아주세요!</p>
    </div>

    <div class="rd-section">
      <h3>발견 위치</h3>
      <div class="rd-map">
        <img src="https://images.unsplash.com/photo-1524661135-423995f22d0b?w=860&q=70&auto=format&fit=crop" alt="지도" onerror="this.src='https://placehold.co/860x180/EAF7F2/2BAB82?text=카카오맵+위치'">
      </div>
    </div>

    <div class="rd-section">
      <h3>댓글 (12)</h3>
      <div class="comment-input-wrap">
        <img class="comment-avatar" src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=72&q=70&auto=format&fit=crop" alt="me" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=ME'">
        <div class="comment-flex">
          <textarea class="comment-input" placeholder="제보, 목격 정보, 응원 댓글을 남겨주세요."></textarea>
          <div class="comment-submit-row"><button onclick="alert('댓글이 등록되었습니다.')">등록</button></div>
        </div>
      </div>
      <div class="comment-item">
        <img class="comment-avatar" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=72&q=70&auto=format&fit=crop" alt="댓글러" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=U'">
        <div class="comment-body-box">
          <div class="comment-head"><span class="comment-name">이서연</span><span class="comment-date">2025.06.25 16:15</span></div>
          <div class="comment-text">방금 저도 합정 카페거리 쪽에서 비슷한 강아지 봤어요! 골든 리트리버 맞는 것 같고 남쪽으로 이동했습니다.</div>
        </div>
      </div>
      <div class="comment-item">
        <img class="comment-avatar" src="https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=72&q=70&auto=format&fit=crop" alt="댓글러2" onerror="this.src='https://placehold.co/36x36/EAF7F2/2BAB82?text=U'">
        <div class="comment-body-box">
          <div class="comment-head"><span class="comment-name">박지호</span><span class="comment-date">2025.06.25 17:02</span></div>
          <div class="comment-text">마포구청 동물보호소(02-1234-5678)에 신고하시면 포획 인력 나옵니다. 빠른 해결 바랍니다.</div>
        </div>
      </div>
    </div>
  </div>

  <div>
    <div class="rd-side-card">
      <h3>신고 현황</h3>
      <div class="side-row"><span>상태</span><span style="color:#F59E0B;font-weight:800">찾는 중</span></div>
      <div class="side-row"><span>신고일</span><span>2025.06.25</span></div>
      <div class="side-row"><span>조회 수</span><span>284</span></div>
      <div class="side-row"><span>댓글</span><span>12</span></div>
      <select style="width:100%;border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;font-size:14px;color:var(--text-main);outline:none;margin-top:12px">
        <option>찾는 중</option>
        <option>구조 완료</option>
        <option>주인 찾음</option>
      </select>
      <button class="btn-status-change" onclick="alert('상태가 변경되었습니다.')">상태 변경</button>
    </div>
    <div class="rd-side-card">
      <h3>보호소 연계</h3>
      <p style="font-size:13px;color:var(--text-muted);margin:0 0 12px;line-height:1.6">직접 보호가 어려우시면 보호소 연계를 신청해 주세요.</p>
      <button class="btn-shelter-link" onclick="alert('마포구 동물보호소에 연계 신청이 접수되었습니다.\n담당자가 연락드립니다.')">보호소 연계 신청</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
