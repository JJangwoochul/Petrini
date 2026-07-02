<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId"      value="give" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .tld-wrap{max-width:900px;margin:32px auto 80px;padding:0 20px;display:grid;grid-template-columns:1fr 300px;gap:28px;align-items:flex-start}
  .tld-back{display:inline-flex;align-items:center;gap:6px;font-size:13px;color:var(--text-muted);text-decoration:none;margin-bottom:20px;transition:var(--transition)}
  .tld-back:hover{color:var(--primary)}
  .tld-back svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .tld-header{display:flex;gap:18px;align-items:flex-start;margin-bottom:22px}
  .tld-icon{width:72px;height:72px;border-radius:var(--radius-md);display:flex;align-items:center;justify-content:center;flex-shrink:0;background:#FDF2F8}
  .tld-icon svg{width:34px;height:34px;stroke:#DB2777;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
  .tld-header-info{}
  .tld-tags{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:8px}
  .tld-tag{font-size:12px;font-weight:700;padding:3px 10px;border-radius:20px}
  .tlt-grooming{background:#FDF2F8;color:#DB2777}
  .tlt-biz{background:var(--primary-light);color:var(--primary-dark)}
  .tld-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:6px;line-height:1.3}
  .tld-provider{font-size:14px;color:var(--text-muted)}
  .tld-provider strong{color:var(--text-main)}
  .tld-section{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:20px;margin-bottom:16px}
  .tld-section h3{font-size:15px;font-weight:800;color:var(--text-main);margin:0 0 14px;display:flex;align-items:center;gap:8px}
  .tld-section h3 svg{width:16px;height:16px;stroke:var(--primary);fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
  .tld-info-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:16px}
  .tld-info-row{background:var(--bg-page);border-radius:var(--radius-sm);padding:12px 14px}
  .tld-info-row label{font-size:11px;color:var(--text-muted);font-weight:600;display:block;margin-bottom:4px}
  .tld-info-row span{font-size:14px;font-weight:600;color:var(--text-main)}
  .tld-desc{font-size:14px;color:var(--text-sub);line-height:1.8;margin:0}
  /* 신청 카드 */
  .talent-apply-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);padding:24px;position:sticky;top:20px}
  .talent-apply-card h3{font-size:16px;font-weight:800;color:var(--text-main);margin:0 0 16px}
  .tac-provider-box{background:var(--primary-light);border-radius:var(--radius-sm);padding:14px;margin-bottom:18px;display:flex;align-items:center;gap:12px}
  .tac-provider-box img{width:44px;height:44px;border-radius:50%;object-fit:cover;flex-shrink:0}
  .tac-prov-name{font-size:14px;font-weight:700;color:var(--text-main)}
  .tac-prov-type{font-size:12px;color:var(--text-muted)}
  .tac-badge{display:inline-flex;align-items:center;gap:4px;font-size:11px;font-weight:700;background:var(--primary);color:#fff;padding:2px 8px;border-radius:20px;margin-top:3px}
  .tac-badge svg{width:10px;height:10px;stroke:#fff;fill:none;stroke-width:2.5;stroke-linecap:round;stroke-linejoin:round}
  .tac-info-row{display:flex;justify-content:space-between;font-size:14px;color:var(--text-sub);margin-bottom:10px}
  .tac-info-row span:last-child{font-weight:700;color:var(--text-main)}
  .tac-divider{height:1px;background:var(--border);margin:14px 0}
  .tac-form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:14px}
  .tac-form-group label{font-size:13px;font-weight:600;color:var(--text-sub)}
  .tac-form-group input,.tac-form-group textarea,.tac-form-group select{border:1px solid var(--border);border-radius:var(--radius-sm);padding:10px 12px;font-size:14px;color:var(--text-main);outline:none;font-family:inherit;width:100%;box-sizing:border-box}
  .tac-form-group input:focus,.tac-form-group textarea:focus,.tac-form-group select:focus{border-color:var(--primary)}
  .tac-form-group textarea{min-height:80px;resize:vertical;line-height:1.6}
  .btn-talent-submit{width:100%;padding:14px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:16px;font-weight:800;cursor:pointer;transition:var(--transition)}
  .btn-talent-submit:hover{background:var(--primary-dark)}
</style>
<div class="tld-wrap">
  <div>
    <a href="${contextPath}/give?tab=talent" class="tld-back"><svg viewBox="0 0 24 24"><path d="M19 12H5"/><polyline points="12 19 5 12 12 5"/></svg>재능나눔 목록으로</a>
    <div class="tld-header">
      <div class="tld-icon"><svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg></div>
      <div class="tld-header-info">
        <div class="tld-tags"><span class="tld-tag tlt-grooming">애견미용</span><span class="tld-tag tlt-biz">사업자 파트너 제공</span></div>
        <div class="tld-title">유기견 무료 미용 서비스<br>— 입양 전 그루밍 지원</div>
        <div class="tld-provider">제공: <strong>냥냥 그루밍샵</strong> · 애견미용실 사업자 파트너</div>
      </div>
    </div>
    <div class="tld-section">
      <h3><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>기본 정보</h3>
      <div class="tld-info-grid">
        <div class="tld-info-row"><label>서비스 유형</label><span>애견 무료 미용 (그루밍)</span></div>
        <div class="tld-info-row"><label>진행 일정</label><span>매월 마지막 일요일</span></div>
        <div class="tld-info-row"><label>장소</label><span>냥냥 그루밍샵 (서울 강남구)</span></div>
        <div class="tld-info-row"><label>소요시간</label><span>마리당 1~2시간</span></div>
        <div class="tld-info-row"><label>대상</label><span>보호소 유기견 (소·중형)</span></div>
        <div class="tld-info-row"><label>이번 달 잔여</label><span style="color:var(--primary-dark);font-weight:800">3마리</span></div>
      </div>
    </div>
    <div class="tld-section">
      <h3><svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>서비스 상세</h3>
      <p class="tld-desc">냥냥 그루밍샵은 매월 유기견 10마리에게 무료 미용 서비스를 제공합니다.<br><br>
      <strong>포함 서비스:</strong><br>
      · 전체 미용 (컷, 드라이, 발톱 정리, 귀 청소)<br>
      · 목욕 + 드라이<br>· 기본 건강상태 체크<br><br>
      <strong>신청 안내:</strong><br>
      · 보호소 봉사자 또는 임시 보호자가 직접 동반 방문<br>
      · 신청 후 일정 확인 연락 드립니다 (1~2 영업일 이내)<br>
      · 당일 취소 시 다음 달로 이월됩니다</p>
    </div>
  </div>
  <div class="talent-apply-card">
    <h3>제공자 정보</h3>
    <div class="tac-provider-box">
      <img src="https://images.unsplash.com/photo-1560743641-3914f2c45636?w=88&q=70&auto=format&fit=crop" alt="미용샵" onerror="this.src='https://placehold.co/44x44/FDF2F8/DB2777?text=샵'">
      <div>
        <div class="tac-prov-name">냥냥 그루밍샵</div>
        <div class="tac-prov-type">애견미용실 · 강남구 청담동</div>
        <span class="tac-badge"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>인증 파트너</span>
      </div>
    </div>
    <div class="tac-info-row"><span>이번 달 진행일</span><span>2025.06.29 (일)</span></div>
    <div class="tac-info-row"><span>잔여 자리</span><span style="color:var(--primary-dark);font-weight:800">3마리</span></div>
    <div class="tac-info-row"><span>진행 장소</span><span>냥냥 그루밍샵</span></div>
    <div class="tac-divider"></div>
    <div style="font-size:13px;color:var(--text-muted);margin-bottom:12px;line-height:1.6">
      참여를 원하시면 아래 연락처로 직접 문의해 주세요.
    </div>
    <div class="tac-info-row"><span>문의 전화</span><span style="color:var(--primary);font-weight:800">02-1234-5678</span></div>
    <div class="tac-info-row"><span>문의 이메일</span><span>nyang@grooming.com</span></div>
    <div style="font-size:12px;color:var(--text-muted);margin-top:14px;line-height:1.6">
      · 무료 서비스이며, 추가 비용이 발생하지 않습니다.<br>
      · 운영 시간: 평일 10:00 ~ 19:00
    </div>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
