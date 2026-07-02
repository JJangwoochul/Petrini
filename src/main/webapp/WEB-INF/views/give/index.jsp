<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="/WEB-INF/views/common/header.jsp" %>

<style>
    .give-hero{background:linear-gradient(135deg,#1F8464 0%,#2BAB82 60%,#5BC8A8 100%);padding:52px 0 0;text-align:center;color:#fff}
    .give-hero-inner{max-width:var(--inner-width);margin:0 auto;padding:0 20px}
    .give-hero-badge{display:inline-block;font-size:13px;font-weight:700;background:rgba(255,255,255,.2);padding:5px 16px;border-radius:50px;margin-bottom:16px}
    .give-hero h1{font-size:36px;font-weight:800;margin:0 0 12px;line-height:1.25}
    .give-hero p{font-size:16px;opacity:.85;margin:0 0 32px}
    .give-hero-stats{display:flex;justify-content:center;gap:48px;padding:24px 0;border-top:1px solid rgba(255,255,255,.2);margin-top:8px}
    .ghs{text-align:center}
    .ghs .num{font-size:28px;font-weight:800}
    .ghs .label{font-size:13px;opacity:.8;margin-top:2px}
    .give-tab-wrap{background:#fff;border-bottom:1px solid var(--border);position:sticky;top:0;z-index:10;box-shadow:0 2px 8px rgba(0,0,0,.05)}
    .give-tabs{max-width:var(--inner-width);margin:0 auto;padding:0 20px;display:flex;gap:0}
    .give-tab{display:flex;align-items:center;gap:8px;padding:16px 28px;font-size:15px;font-weight:600;color:var(--text-muted);border:none;background:none;cursor:pointer;border-bottom:3px solid transparent;margin-bottom:-1px;transition:var(--transition);text-decoration:none}
    .give-tab:hover{color:var(--primary)}
    .give-tab.active{color:var(--primary);border-bottom-color:var(--primary)}
    .give-tab svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round}
    .give-tab .tab-count{background:var(--primary-light);color:var(--primary-dark);font-size:11px;font-weight:700;padding:2px 7px;border-radius:20px}
    .give-tab.active .tab-count{background:var(--primary);color:#fff}
    .give-content{max-width:var(--inner-width);margin:36px auto 80px;padding:0 20px}
</style>

<%-- 히어로 배너 --%>
<div class="give-hero">
  <div class="give-hero-inner">
    <span class="give-hero-badge">PetCare 나눔</span>
    <h1>따뜻한 마음이<br>세상을 바꿔요</h1>
    <p>유기동물 조회부터 봉사·재능나눔까지,<br>함께하는 작은 실천이 큰 변화를 만듭니다.</p>
    <div class="give-hero-stats">
      <div class="ghs"><div class="num">4,821</div><div class="label">보호 중인 동물</div></div>
      <%-- <div class="ghs"><div class="num">328</div><div class="label">봉사 신청</div></div> --%>
      <div class="ghs"><div class="num">64</div><div class="label">재능나눔 참여</div></div>
    </div>
  </div>
</div>

<%-- 탭바 --%>
<div class="give-tab-wrap">
    <div class="give-tabs">
        <a href="${contextPath}/give/animal/list"
           class="give-tab ${giveTab eq 'animal' ? 'active' : ''}">
          <svg viewBox="0 0 24 24"><circle cx="4.5" cy="9.5" r="2"/><circle cx="9" cy="5.5" r="2"/><circle cx="15" cy="5.5" r="2"/><circle cx="19.5" cy="9.5" r="2"/><path d="M12 13c-3.87 0-7 1.79-7 4v1h14v-1c0-2.21-3.13-4-7-4z"/></svg>
          유기동물 조회
          <span class="tab-count">실시간</span>
        </a>
        <a href="${contextPath}/give/report/list"
           class="give-tab ${giveTab eq 'report' ? 'active' : ''}">
          <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
          분실·보호
          <span class="tab-count">328</span>
        </a>
        <%-- <a href="${contextPath}/give/volunteer/list"
           class="give-tab ${giveTab eq 'volunteer' ? 'active' : ''}">
          <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg>
          봉사 모집
          <span class="tab-count">28</span>
        </a> --%>
        <a href="${contextPath}/give/talent/list"
           class="give-tab ${giveTab eq 'talent' ? 'active' : ''}">
          <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
          재능나눔
          <span class="tab-count">16</span>
        </a>
    </div>
</div>
