<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 숙소" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_stay.jsp" %>

<%-- 7/2, 사업자(숙박) 대시보드 UI 구성 — 병원 대시보드와 동일한 공용 클래스(summary-grid, dash-card 등) 재사용 --%>
<main class="biz-main hospital-dashboard">
  <div class="dashboard-top">
    <div>
      <h1>안녕하세요, 포근한 숙소 사장님!</h1>
      <p>오늘의 숙소 현황을 한눈에 확인하세요.</p>
    </div>
    <div class="date-select">
      2026-06-30 (화) ▾
    </div>
  </div>

  <section class="summary-grid">
    <div class="summary-card">
      <div class="summary-icon green">📅</div>
      <div>
        <p>오늘 체크인</p>
        <strong>2 <span>건</span></strong>
        <small>어제 대비 ▲ 1건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon blue">🏠</div>
      <div>
        <p>객실 가동률</p>
        <strong>75 <span>%</span></strong>
        <small>어제 대비 ▲ 15%p</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon purple">🚪</div>
      <div>
        <p>오늘 체크아웃</p>
        <strong>1 <span>건</span></strong>
        <small>어제와 동일</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon orange">₩</div>
      <div>
        <p>이번 달 매출</p>
        <strong>5,200,000 <span>원</span></strong>
        <small>어제 대비 ▲ 180,000원</small>
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

            <polyline class="line-green" points="50,150 150,140 250,110 350,120 450,80 550,95 650,60" />
            <polyline class="line-blue"  points="50,190 150,175 250,150 350,160 450,120 550,135 650,100" />

            <circle cx="50" cy="150" r="5" class="dot-green"/>
            <circle cx="150" cy="140" r="5" class="dot-green"/>
            <circle cx="250" cy="110" r="5" class="dot-green"/>
            <circle cx="350" cy="120" r="5" class="dot-green"/>
            <circle cx="450" cy="80" r="5" class="dot-green"/>
            <circle cx="550" cy="95" r="5" class="dot-green"/>
            <circle cx="650" cy="60" r="5" class="dot-green"/>

            <circle cx="50" cy="190" r="5" class="dot-blue"/>
            <circle cx="150" cy="175" r="5" class="dot-blue"/>
            <circle cx="250" cy="150" r="5" class="dot-blue"/>
            <circle cx="350" cy="160" r="5" class="dot-blue"/>
            <circle cx="450" cy="120" r="5" class="dot-blue"/>
            <circle cx="550" cy="135" r="5" class="dot-blue"/>
            <circle cx="650" cy="100" r="5" class="dot-blue"/>
          </svg>
        </div>

        <div class="chart-days">
          <span>06-24</span><span>06-25</span><span>06-26</span><span>06-27</span>
          <span>06-28</span><span>06-29</span><span>06-30</span>
        </div>
      </div>
    </div>

    <div class="dash-card status-card">
      <div class="card-head">
        <h3>객실 상태 현황</h3>
      </div>

      <div class="donut-wrap">
        <div class="donut-chart">
          <div>
            <span>전체 객실</span>
            <strong>5실</strong>
          </div>
        </div>

        <ul class="status-list">
          <li><span class="box green-box"></span>입실중 <b>3실 (60%)</b></li>
          <li><span class="box blue-box"></span>예약확정 <b>1실 (20%)</b></li>
          <li><span class="box orange-box"></span>공실 <b>1실 (20%)</b></li>
          <li><span class="box gray-box"></span>정비중 <b>0실 (0%)</b></li>
        </ul>
      </div>
    </div>
  </section>

  <section class="bottom-grid">
    <div class="dash-card">
      <div class="card-head">
        <h3>오늘의 체크인·체크아웃</h3>
        <a href="${contextPath}/biz/stay/reserve" class="outline-btn">전체 예약 보기</a>
      </div>

      <table class="biz-table">
        <thead>
          <tr>
            <th>구분</th>
            <th>예약자</th>
            <th>반려동물</th>
            <th>객실</th>
            <th>상태</th>
            <th>관리</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>체크인</td>
            <td>이성민</td>
            <td>두부 (포메)</td>
            <td>A-01호</td>
            <td><span class="badge confirm">입실중</span></td>
            <td><button class="detail-btn">상세보기</button></td>
          </tr>
          <tr>
            <td>체크인</td>
            <td>정아린</td>
            <td>보리 (말티푸)</td>
            <td>B-02호</td>
            <td><span class="badge wait">예약 대기</span></td>
            <td><button class="detail-btn">상세보기</button></td>
          </tr>
          <tr>
            <td>체크아웃</td>
            <td>한지우</td>
            <td>달이 (사모예드)</td>
            <td>C-01호</td>
            <td><span class="badge confirm">예약 확정</span></td>
            <td><button class="detail-btn">상세보기</button></td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="dash-card review-card">
      <div class="card-head">
        <h3>최근 리뷰</h3>
        <a href="${contextPath}/biz/stay/reviews" class="outline-btn">전체 리뷰 보기</a>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>이성민 님</b> <span class="stars">★★★★★</span></p>
          <small>독채 풀빌라 이용했는데 마당이 넓어서 강아지가 정말 신나게 뛰어놀았어요.</small>
        </div>
        <em>2026-06-29</em>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>박소현 님</b> <span class="stars">★★★★☆</span></p>
          <small>전반적으로 만족스러웠는데 체크인 시간이 조금 늦어졌어요.</small>
        </div>
        <em>2026-06-26</em>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>한지우 님</b> <span class="stars">★★★★★</span></p>
          <small>체크아웃할 때까지 반려동물을 잘 챙겨주셔서 마음 편히 다녀왔어요.</small>
        </div>
        <em>2026-06-20</em>
      </div>
    </div>
  </section>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>