<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="event" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .ev-hero{background:linear-gradient(135deg,#92400E 0%,#F59E0B 60%,#FCD34D 100%);padding:48px 0;color:#fff;text-align:center}
  .ev-hero-inner{max-width:var(--inner-width);margin:0 auto;padding:0 20px}
  .ev-hero-badge{display:inline-block;font-size:13px;font-weight:700;background:rgba(255,255,255,.22);padding:5px 16px;border-radius:50px;margin-bottom:14px}
  .ev-hero h1{font-size:30px;font-weight:800;margin:0 0 8px}
  .ev-hero p{font-size:14px;opacity:.9;margin:0}

  .ev-wrap{max-width:var(--inner-width);margin:32px auto 80px;padding:0 20px}
  .ev-tabs{display:flex;gap:0;border-bottom:2px solid var(--border);margin-bottom:24px}
  .ev-tab{padding:12px 24px;font-size:15px;font-weight:600;color:var(--text-muted);border:none;background:none;cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;transition:var(--transition)}
  .ev-tab.on{color:#D97706;border-bottom-color:#D97706}

  /* 이벤트 카드 */
  .ev-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:18px;margin-bottom:48px}
  .ev-card{background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);overflow:hidden;cursor:pointer;transition:var(--transition)}
  .ev-card:hover{box-shadow:var(--shadow-md);transform:translateY(-2px)}
  .ev-card-img{height:160px;position:relative}
  .ev-card-img img{width:100%;height:100%;object-fit:cover;display:block}
  .ev-card-badge{position:absolute;top:12px;left:12px;font-size:11px;font-weight:700;padding:3px 10px;border-radius:20px}
  .ev-card-badge.live{background:#DCFCE7;color:#16A34A}
  .ev-card-badge.soon{background:#FEE2E2;color:#DC2626}
  .ev-card-badge.end{background:#F5F5F5;color:#999}
  .ev-card-body{padding:16px}
  .ev-card-title{font-size:15px;font-weight:800;color:var(--text-main);margin-bottom:6px;line-height:1.4}
  .ev-card-period{font-size:12px;color:var(--text-muted)}

  /* 혜택/쿠폰 띠 배너 */
  .ev-section-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
  .ev-section-head h2{font-size:18px;font-weight:800;color:var(--text-main);margin:0}
  .ev-section-more{font-size:13px;color:#D97706;font-weight:700;text-decoration:none}
  .ev-coupon-strip{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
  .ev-coupon-mini{background:linear-gradient(135deg,#FFFBEB 0%,#FEF3C7 100%);border:1px solid #FDE68A;border-radius:var(--radius-md);padding:18px;display:flex;flex-direction:column;gap:6px}
  .ev-coupon-mini .pct{font-size:24px;font-weight:800;color:#B45309}
  .ev-coupon-mini .desc{font-size:13px;color:var(--text-sub);font-weight:600}
  .ev-coupon-mini .cond{font-size:11px;color:var(--text-muted)}
  .ev-coupon-mini-btn{margin-top:8px;padding:8px;border:none;border-radius:var(--radius-sm);background:#F59E0B;color:#fff;font-size:12px;font-weight:700;cursor:pointer}
  .ev-coupon-mini-btn:hover{background:#D97706}
</style>

<div class="ev-hero">
  <div class="ev-hero-inner">
    <span class="ev-hero-badge">PetCare 이벤트</span>
    <h1>지금 놓치면 아쉬운 혜택</h1>
    <p>신규 가입 쿠폰부터 시즌 프로모션까지, 한 곳에서 모두 확인하세요</p>
  </div>
</div>

<div class="ev-wrap">
  <div class="ev-tabs">
    <button class="ev-tab on" onclick="filterEv(this,'all')">전체</button>
    <button class="ev-tab" onclick="filterEv(this,'live')">진행중</button>
    <button class="ev-tab" onclick="filterEv(this,'soon')">오픈예정</button>
    <button class="ev-tab" onclick="filterEv(this,'end')">종료</button>
  </div>

  <div class="ev-grid">
    <div class="ev-card" data-status="live" onclick="alert('이벤트 상세 페이지로 이동합니다.')">
      <div class="ev-card-img">
        <span class="ev-card-badge live">진행중</span>
        <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=500&q=70&auto=format&fit=crop" alt="신규회원 이벤트" onerror="this.src='https://placehold.co/500x320/FEF3C7/D97706?text=이벤트'">
      </div>
      <div class="ev-card-body">
        <div class="ev-card-title">신규 회원 첫 구매 10% 할인 쿠폰</div>
        <div class="ev-card-period">2025.07.01 ~ 2025.07.31</div>
      </div>
    </div>

    <div class="ev-card" data-status="live" onclick="alert('이벤트 상세 페이지로 이동합니다.')">
      <div class="ev-card-img">
        <span class="ev-card-badge live">진행중</span>
        <img src="https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=500&q=70&auto=format&fit=crop" alt="여름맞이 그루밍 프로모션" onerror="this.src='https://placehold.co/500x320/FEF3C7/D97706?text=이벤트'">
      </div>
      <div class="ev-card-body">
        <div class="ev-card-title">여름맞이 미용·목욕 패키지 20% 할인</div>
        <div class="ev-card-period">2025.06.20 ~ 2025.08.10</div>
      </div>
    </div>

    <div class="ev-card" data-status="soon" onclick="alert('이벤트 상세 페이지로 이동합니다.')">
      <div class="ev-card-img">
        <span class="ev-card-badge soon">오픈예정</span>
        <img src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500&q=70&auto=format&fit=crop" alt="가족사진 촬영 이벤트" onerror="this.src='https://placehold.co/500x320/FEF3C7/D97706?text=이벤트'">
      </div>
      <div class="ev-card-body">
        <div class="ev-card-title">반려동물 프로필 촬영 무료 체험단 모집</div>
        <div class="ev-card-period">2025.08.01 ~ 2025.08.15</div>
      </div>
    </div>

    <div class="ev-card" data-status="end" onclick="alert('이벤트 상세 페이지로 이동합니다.')" style="opacity:.6">
      <div class="ev-card-img">
        <span class="ev-card-badge end">종료</span>
        <img src="https://images.unsplash.com/photo-1589924691995-400dc9a04a86?w=500&q=70&auto=format&fit=crop" alt="봄맞이 사료 할인전" onerror="this.src='https://placehold.co/500x320/F5F5F5/999999?text=종료된+이벤트'">
      </div>
      <div class="ev-card-body">
        <div class="ev-card-title">봄맞이 사료·간식 최대 30% 할인전</div>
        <div class="ev-card-period">2025.04.01 ~ 2025.04.30</div>
      </div>
    </div>
  </div>

  <div class="ev-section-head">
    <h2>지금 받을 수 있는 쿠폰</h2>
    <a href="${contextPath}/event/coupon" class="ev-section-more">쿠폰함 전체보기 →</a>
  </div>
  <div class="ev-coupon-strip">
    <div class="ev-coupon-mini">
      <span class="pct">10% 할인</span>
      <span class="desc">신규 회원 첫 구매 쿠폰</span>
      <span class="cond">5만원 이상 구매 시 · 7/31까지</span>
      <button class="ev-coupon-mini-btn" onclick="alert('쿠폰이 발급되었습니다!')">쿠폰 받기</button>
    </div>
    <div class="ev-coupon-mini">
      <span class="pct">3,000원 할인</span>
      <span class="desc">병원 예약 첫 이용 쿠폰</span>
      <span class="cond">전 진료과 사용 가능 · 8/31까지</span>
      <button class="ev-coupon-mini-btn" onclick="alert('쿠폰이 발급되었습니다!')">쿠폰 받기</button>
    </div>
    <div class="ev-coupon-mini">
      <span class="pct">20% 할인</span>
      <span class="desc">미용·목욕 패키지 쿠폰</span>
      <span class="cond">그루밍 전 업체 사용 가능 · 8/10까지</span>
      <button class="ev-coupon-mini-btn" onclick="alert('쿠폰이 발급되었습니다!')">쿠폰 받기</button>
    </div>
  </div>
</div>

<script>
function filterEv(el, status){
  document.querySelectorAll('.ev-tab').forEach(t=>t.classList.remove('on'));
  el.classList.add('on');
  document.querySelectorAll('.ev-card').forEach(c=>{
    c.style.display = (status==='all' || c.dataset.status===status) ? '' : 'none';
  });
}
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
