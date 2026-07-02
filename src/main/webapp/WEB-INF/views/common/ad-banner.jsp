<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- ===================================================================
     광고 배너 (입점/제휴사 배너광고 노출 영역)
     - 다른 JSP에서 <%@ include file="/WEB-INF/views/common/ad-banner.jsp" %> 로 삽입
     - 광고가 여러 건이면 자동 슬라이드 + 점 네비게이션으로 순환 노출
     - 추후 관리자 CMS(배너 관리)에서 등록한 데이터를 모델로 받으면
       아래 하드코딩된 .adv-slide 블록을 <c:forEach>로 교체하면 됨
==================================================================== --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<style>
  .adv-wrap{max-width:var(--inner-width);margin:24px auto 40px;padding:0 20px}
  .adv-banner{position:relative;border-radius:var(--radius-md);overflow:hidden;height:140px;box-shadow:var(--shadow-sm)}
  .adv-track{display:flex;height:100%;transition:transform .5s ease}
  .adv-slide{min-width:100%;height:100%;position:relative;display:flex;align-items:center;text-decoration:none}
  .adv-slide img{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;z-index:0}
  .adv-slide-overlay{position:relative;z-index:1;padding:0 36px;color:#fff;max-width:60%}
  .adv-eyebrow{font-size:11px;font-weight:700;opacity:.85;letter-spacing:.3px;margin-bottom:6px;display:block}
  .adv-headline{font-size:19px;font-weight:800;line-height:1.4;margin:0;text-shadow:0 1px 6px rgba(0,0,0,.25)}
  .adv-label{position:absolute;top:10px;right:12px;z-index:2;font-size:10px;font-weight:700;color:rgba(255,255,255,.92);background:rgba(0,0,0,.38);padding:3px 9px;border-radius:20px;letter-spacing:.4px}
  .adv-sponsor{position:absolute;bottom:10px;right:14px;z-index:2;font-size:11px;color:rgba(255,255,255,.8)}
  .adv-dots{position:absolute;bottom:10px;left:36px;z-index:2;display:flex;gap:5px}
  .adv-dot{width:6px;height:6px;border-radius:50%;background:rgba(255,255,255,.45);cursor:pointer;transition:var(--transition)}
  .adv-dot.active{width:16px;border-radius:4px;background:#fff}
  .adv-nav{position:absolute;top:50%;transform:translateY(-50%);z-index:2;width:28px;height:28px;border-radius:50%;border:none;background:rgba(0,0,0,.28);color:#fff;font-size:14px;cursor:pointer;display:flex;align-items:center;justify-content:center;opacity:0;transition:opacity .2s}
  .adv-banner:hover .adv-nav{opacity:1}
  .adv-nav:hover{background:rgba(0,0,0,.5)}
  .adv-nav.prev{left:10px}
  .adv-nav.next{right:10px}
  @media (max-width:640px){
    .adv-banner{height:108px}
    .adv-slide-overlay{padding:0 20px;max-width:75%}
    .adv-headline{font-size:15px}
    .adv-dots{left:20px}
  }
</style>

<div class="adv-wrap">
  <div class="adv-banner" id="advBanner">
    <span class="adv-label">광고</span>
    <div class="adv-track" id="advTrack">

      <a class="adv-slide" href="https://www.royalcanin.com" target="_blank" rel="noopener sponsored" style="background:linear-gradient(120deg,#0F2C4C 0%,rgba(15,44,76,.35) 55%,rgba(15,44,76,0) 100%)">
        <img src="https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=1000&q=70&auto=format&fit=crop" alt="로얄캐닌 광고" onerror="this.src='https://placehold.co/1000x280/0F2C4C/ffffff?text=AD'">
        <div class="adv-slide-overlay">
          <span class="adv-eyebrow">로얄캐닌 공식 파트너</span>
          <p class="adv-headline">우리 아이 맞춤 사료,<br>지금 PetCare 단독 15% 할인</p>
        </div>
        <span class="adv-sponsor">제공 · 로얄캐닌코리아</span>
      </a>

      <a class="adv-slide" href="https://www.example-petinsurance.com" target="_blank" rel="noopener sponsored" style="background:linear-gradient(120deg,#1F8464 0%,rgba(31,132,100,.35) 55%,rgba(31,132,100,0) 100%)">
        <img src="https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=1000&q=70&auto=format&fit=crop" alt="펫보험 광고" onerror="this.src='https://placehold.co/1000x280/1F8464/ffffff?text=AD'">
        <div class="adv-slide-overlay">
          <span class="adv-eyebrow">하나펫 보험</span>
          <p class="adv-headline">월 9,900원부터,<br>우리 아이 의료비 걱정 끝</p>
        </div>
        <span class="adv-sponsor">제공 · 하나손해보험</span>
      </a>

      <a class="adv-slide" href="https://www.example-petairline.com" target="_blank" rel="noopener sponsored" style="background:linear-gradient(120deg,#831843 0%,rgba(131,24,67,.35) 55%,rgba(131,24,67,0) 100%)">
        <img src="https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=1000&q=70&auto=format&fit=crop" alt="펫동반 항공권 광고" onerror="this.src='https://placehold.co/1000x280/831843/ffffff?text=AD'">
        <div class="adv-slide-overlay">
          <span class="adv-eyebrow">펫프렌들리 항공권</span>
          <p class="adv-headline">반려동물과 떠나는 여행,<br>동반 항공권 최대 20% 할인</p>
        </div>
        <span class="adv-sponsor">제공 · 트래블펫</span>
      </a>

    </div>

    <button class="adv-nav prev" id="advPrev" aria-label="이전 광고">&#8249;</button>
    <button class="adv-nav next" id="advNext" aria-label="다음 광고">&#8250;</button>
    <div class="adv-dots" id="advDots">
      <span class="adv-dot active" data-i="0"></span>
      <span class="adv-dot" data-i="1"></span>
      <span class="adv-dot" data-i="2"></span>
    </div>
  </div>
</div>

<script>
(function(){
  var track = document.getElementById('advTrack');
  var dots  = document.querySelectorAll('#advDots .adv-dot');
  var total = dots.length;
  var idx = 0, timer;

  function go(n){
    idx = (n + total) % total;
    track.style.transform = 'translateX(-' + (idx * 100) + '%)';
    dots.forEach(function(d,i){ d.classList.toggle('active', i === idx); });
  }
  function next(){ go(idx + 1); }
  function startAuto(){ timer = setInterval(next, 5000); }
  function stopAuto(){ clearInterval(timer); }

  document.getElementById('advPrev').addEventListener('click', function(){ go(idx - 1); stopAuto(); startAuto(); });
  document.getElementById('advNext').addEventListener('click', function(){ go(idx + 1); stopAuto(); startAuto(); });
  dots.forEach(function(d){ d.addEventListener('click', function(){ go(parseInt(d.dataset.i,10)); stopAuto(); startAuto(); }); });

  var banner = document.getElementById('advBanner');
  banner.addEventListener('mouseenter', stopAuto);
  banner.addEventListener('mouseleave', startAuto);

  if (total > 1) startAuto();
})();
</script>
