<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="동물병원" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_hospital.jsp" %>

<%--7/1, 곽지윤, 사업자(병원)대시보드 ui구성변경(before)--%>
<%--<main class="biz-main">
  <div class="biz-page-head">
    <h1 class="biz-page-title">병원 대시보드</h1>
    <p class="biz-page-desc">오늘 진료 현황과 주요 지표를 확인하세요.</p>
  </div>
  <div class="biz-stats">
    <div class="biz-stat-card">
      <div class="bsc-icon appt"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">오늘 예약</span><span class="bsc-val">5<span class="bsc-unit">건</span></span></div>
    </div>
    <div class="biz-stat-card">
      <div class="bsc-icon done"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">진료 완료</span><span class="bsc-val">3<span class="bsc-unit">건</span></span></div>
    </div>
    <div class="biz-stat-card">
      <div class="bsc-icon revenue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">이번 달 매출</span><span class="bsc-val">3.8<span class="bsc-unit">백만원</span></span></div>
    </div>
    <div class="biz-stat-card">
      <div class="bsc-icon review"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg></div>
      <div class="bsc-body"><span class="bsc-label">평균 리뷰</span><span class="bsc-val">4.9<span class="bsc-unit">/ 5.0</span></span></div>
    </div>
  </div>
  <div class="biz-card">
    <div class="biz-card-head"><span>오늘 예약 현황</span><small>2025.06.26 기준</small></div>
    <table class="biz-table">
      <thead><tr><th>시간</th><th>보호자</th><th>환자(동물)</th><th>진료 목적</th><th>상태</th><th>처리</th></tr></thead>
      <tbody>
        <tr><td>09:30</td><td>김민준</td><td>초코 (말티즈 / 3세)</td><td>예방접종</td><td><span class="bs-badge bs-done">완료</span></td><td>—</td></tr>
        <tr><td>10:00</td><td>이서연</td><td>나비 (페르시안 / 2세)</td><td>정기검진</td><td><span class="bs-badge bs-done">완료</span></td><td>—</td></tr>
        <tr><td>11:30</td><td>박지호</td><td>몽이 (골든 / 4세)</td><td>피부 트러블</td><td><span class="bs-badge bs-done">완료</span></td><td>—</td></tr>
        <tr><td>14:00</td><td>최유나</td><td>루비 (푸들 / 1세)</td><td>중성화 수술</td><td><span class="bs-badge bs-wait">대기</span></td><td><button class="biz-btn">진료 시작</button></td></tr>
        <tr><td>15:30</td><td>정태양</td><td>별이 (샴 / 5세)</td><td>치석 제거</td><td><span class="bs-badge bs-wait">대기</span></td><td><button class="biz-btn">진료 시작</button></td></tr>
      </tbody>
    </table>
  </div>
</main>--%>

<%--7/1, 곽지윤, 사업자(병원)대시보드 ui구성변경(after)--%>
<main class="biz-main hospital-dashboard">
  <div class="dashboard-top">
    <div>
      <h1>안녕하세요, 펫사랑 동물병원 원장님!</h1>
      <p>오늘의 병원 현황을 한눈에 확인하세요.</p>
    </div>

    <div class="date-select">
      2024-06-01 (토) ▾
    </div>
  </div>

  <section class="summary-grid">
    <div class="summary-card">
      <div class="summary-icon green">📅</div>
      <div>
        <p>오늘 예약</p>
        <strong>12 <span>건</span></strong>
        <small>어제 대비 ▲ 2건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon purple">🩺</div>
      <div>
        <p>진료 대기</p>
        <strong>4 <span>건</span></strong>
        <small>어제 대비 ▼ 1건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon blue">📋</div>
      <div>
        <p>진료 완료</p>
        <strong>8 <span>건</span></strong>
        <small>어제 대비 ▲ 3건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon orange">₩</div>
      <div>
        <p>이번 달 매출</p>
        <strong>1,000,000 <span>원</span></strong>
        <small>어제 대비 ▲ 120,000원</small>
      </div>
    </div>
  </section>

  <section class="dashboard-grid">
    <div class="dash-card chart-card">
      <div class="card-head">
        <h3>예약 / 매출 통계</h3>
        <div class="tab-btns">
          <button class="active">일간</button>
          <button>주간</button>
          <button>월간</button>
          <button>연간</button>
        </div>
      </div>

      <div class="line-chart">
        <div class="chart-legend">
          <span class="green-dot"></span> 예약 건수(건)
          <span class="blue-dot"></span> 매출(원)
        </div>

        <div class="fake-line-chart">
          <svg viewBox="0 0 700 260" preserveAspectRatio="none">
            <line x1="40" y1="30" x2="660" y2="30" />
            <line x1="40" y1="80" x2="660" y2="80" />
            <line x1="40" y1="130" x2="660" y2="130" />
            <line x1="40" y1="180" x2="660" y2="180" />
            <line x1="40" y1="230" x2="660" y2="230" />

            <polyline class="line-green" points="50,120 150,160 250,125 350,115 450,65 550,120 650,155" />
            <polyline class="line-blue" points="50,170 150,145 250,170 350,150 450,95 550,150 650,190" />

            <circle cx="50" cy="120" r="5" class="dot-green"/>
            <circle cx="150" cy="160" r="5" class="dot-green"/>
            <circle cx="250" cy="125" r="5" class="dot-green"/>
            <circle cx="350" cy="115" r="5" class="dot-green"/>
            <circle cx="450" cy="65" r="5" class="dot-green"/>
            <circle cx="550" cy="120" r="5" class="dot-green"/>
            <circle cx="650" cy="155" r="5" class="dot-green"/>

            <circle cx="50" cy="170" r="5" class="dot-blue"/>
            <circle cx="150" cy="145" r="5" class="dot-blue"/>
            <circle cx="250" cy="170" r="5" class="dot-blue"/>
            <circle cx="350" cy="150" r="5" class="dot-blue"/>
            <circle cx="450" cy="95" r="5" class="dot-blue"/>
            <circle cx="550" cy="150" r="5" class="dot-blue"/>
            <circle cx="650" cy="190" r="5" class="dot-blue"/>
          </svg>
        </div>

        <div class="chart-days">
          <span>05-26</span><span>05-27</span><span>05-28</span><span>05-29</span>
          <span>05-30</span><span>05-31</span><span>06-01</span>
        </div>
      </div>
    </div>

    <div class="dash-card status-card">
      <div class="card-head">
        <h3>예약 상태 현황</h3>
      </div>

      <div class="donut-wrap">
        <div class="donut-chart">
          <div>
            <span>총 예약</span>
            <strong>152건</strong>
          </div>
        </div>

        <ul class="status-list">
          <li><span class="box green-box"></span>예약 확정 <b>84건 (55%)</b></li>
          <li><span class="box blue-box"></span>예약 대기 <b>40건 (26%)</b></li>
          <li><span class="box orange-box"></span>진료 완료 <b>20건 (13%)</b></li>
          <li><span class="box gray-box"></span>예약 취소 <b>8건 (6%)</b></li>
        </ul>
      </div>
    </div>
  </section>

  <section class="bottom-grid">
    <div class="dash-card">
      <div class="card-head">
        <h3>오늘의 예약 목록</h3>
  <a href="${contextPath}/biz/hospital/reserve" class="outline-btn">전체 예약 보기</a>
      </div>

      <table class="biz-table">
        <thead>
          <tr>
            <th>예약 시간</th>
            <th>예약자</th>
            <th>반려동물</th>
            <th>담당 수의사</th>
            <th>진료 항목</th>
            <th>상태</th>
            <th>관리</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>10:00</td>
            <td>김민지</td>
            <td>코코 (강아지)</td>
            <td>김수의</td>
            <td>종합검진</td>
            <td><span class="badge confirm">예약 확정</span></td>
            <td><button class="detail-btn">상세보기</button></td>
          </tr>
          <tr>
            <td>11:30</td>
            <td>이서현</td>
            <td>나비 (고양이)</td>
            <td>박수의</td>
            <td>예방접종</td>
            <td><span class="badge wait">예약 대기</span></td>
            <td><button class="detail-btn">상세보기</button></td>
          </tr>
          <tr>
            <td>14:00</td>
            <td>박영수</td>
            <td>초코 (강아지)</td>
            <td>김수의</td>
            <td>피부 치료</td>
            <td><span class="badge confirm">예약 확정</span></td>
            <td><button class="detail-btn">상세보기</button></td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="dash-card review-card">
      <div class="card-head">
        <h3>최근 리뷰</h3>
<a href="${contextPath}/biz/hospital/reviews" class="outline-btn">전체 리뷰 보기</a> 
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>김민지 님</b> <span class="stars">★★★★★</span></p>
          <small>원장님이 친절하게 잘 설명해주셨어요!</small>
        </div>
        <em>2024-05-31</em>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>이서현 님</b> <span class="stars">★★★★★</span></p>
          <small>고양이도 편안해하고 진료도 꼼꼼했어요.</small>
        </div>
        <em>2024-05-30</em>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>박영수 님</b> <span class="stars">★★★★☆</span></p>
          <small>대기시간이 조금 길었지만 전반적으로 만족합니다.</small>
        </div>
        <em>2024-05-29</em>
      </div>
    </div>
  </section>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>
