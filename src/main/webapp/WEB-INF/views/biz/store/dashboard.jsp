<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<c:set var="bizTypeLabel" value="반려동물 쇼핑몰" />
<c:set var="bizPage"      value="dashboard" />

<%@ include file="/WEB-INF/views/biz/common/header.jsp" %>
<%@ include file="/WEB-INF/views/biz/common/sidebar_store.jsp" %>

<%-- 7/3, 사업자(쇼핑몰) 대시보드 UI 구성 — 병원/숙박 대시보드와 동일한 공용 클래스(summary-grid, dash-card 등) 재사용 --%>
<main class="biz-main hospital-dashboard">
  <div class="dashboard-top">
    <div>
      <h1>안녕하세요, 푸짐한 펫샵 사장님!</h1>
      <p>오늘의 쇼핑몰 현황을 한눈에 확인하세요.</p>
    </div>
    <div class="date-select">
      2026-07-03 (금) ▾
    </div>
  </div>

  <section class="summary-grid">
    <div class="summary-card">
      <div class="summary-icon green">📦</div>
      <div>
        <p>신규 주문</p>
        <strong>12 <span>건</span></strong>
        <small>어제 대비 ▲ 3건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon blue">🚚</div>
      <div>
        <p>배송중</p>
        <strong>8 <span>건</span></strong>
        <small>어제 대비 ▲ 1건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon purple">✅</div>
      <div>
        <p>배송완료</p>
        <strong>24 <span>건</span></strong>
        <small>어제 대비 ▲ 5건</small>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon orange">₩</div>
      <div>
        <p>이번 달 매출</p>
        <strong>12,600,000 <span>원</span></strong>
        <small>어제 대비 ▲ 480,000원</small>
      </div>
    </div>
  </section>

  <section class="dashboard-grid">
    <div class="dash-card chart-card">
      <div class="card-head">
        <h3>주문 / 매출 통계</h3>
        <div class="tab-btns">
          <button class="active">일간</button>
          <button>주간</button>
          <button>월간</button>
          <button>연간</button>
        </div>
      </div>

      <div class="line-chart">
        <div class="chart-legend">
          <span class="green-dot"></span> 주문 건수(건)
          <span class="blue-dot"></span> 매출(원)
        </div>

        <div class="fake-line-chart">
          <svg viewBox="0 0 700 260" preserveAspectRatio="none">
            <line x1="40" y1="30" x2="660" y2="30" />
            <line x1="40" y1="80" x2="660" y2="80" />
            <line x1="40" y1="130" x2="660" y2="130" />
            <line x1="40" y1="180" x2="660" y2="180" />
            <line x1="40" y1="230" x2="660" y2="230" />

            <polyline class="line-green" points="50,160 150,140 250,150 350,100 450,110 550,70 650,90" />
            <polyline class="line-blue"  points="50,190 150,175 250,180 350,140 450,150 550,105 650,120" />

            <circle cx="50" cy="160" r="5" class="dot-green"/>
            <circle cx="150" cy="140" r="5" class="dot-green"/>
            <circle cx="250" cy="150" r="5" class="dot-green"/>
            <circle cx="350" cy="100" r="5" class="dot-green"/>
            <circle cx="450" cy="110" r="5" class="dot-green"/>
            <circle cx="550" cy="70" r="5" class="dot-green"/>
            <circle cx="650" cy="90" r="5" class="dot-green"/>

            <circle cx="50" cy="190" r="5" class="dot-blue"/>
            <circle cx="150" cy="175" r="5" class="dot-blue"/>
            <circle cx="250" cy="180" r="5" class="dot-blue"/>
            <circle cx="350" cy="140" r="5" class="dot-blue"/>
            <circle cx="450" cy="150" r="5" class="dot-blue"/>
            <circle cx="550" cy="105" r="5" class="dot-blue"/>
            <circle cx="650" cy="120" r="5" class="dot-blue"/>
          </svg>
        </div>

        <div class="chart-days">
          <span>06-27</span><span>06-28</span><span>06-29</span><span>06-30</span>
          <span>07-01</span><span>07-02</span><span>07-03</span>
        </div>
      </div>
    </div>

    <div class="dash-card status-card">
      <div class="card-head">
        <h3>주문 상태 현황</h3>
      </div>

      <div class="donut-wrap">
        <div class="donut-chart">
          <div>
            <span>총 주문</span>
            <strong>44건</strong>
          </div>
        </div>

        <ul class="status-list">
          <li><span class="box green-box"></span>배송완료 <b>24건 (55%)</b></li>
          <li><span class="box blue-box"></span>배송중 <b>8건 (18%)</b></li>
          <li><span class="box orange-box"></span>배송준비 <b>7건 (16%)</b></li>
          <li><span class="box gray-box"></span>결제완료 <b>5건 (11%)</b></li>
        </ul>
      </div>
    </div>
  </section>

  <section class="bottom-grid">
    <div class="dash-card">
      <div class="card-head">
        <h3>최근 주문 현황</h3>
        <a href="${contextPath}/biz/store/orders" class="outline-btn">전체 주문 보기</a>
      </div>

      <table class="biz-table">
        <thead>
          <tr>
            <th>주문번호</th>
            <th>주문자</th>
            <th>상품명</th>
            <th>금액</th>
            <th>상태</th>
            <th>처리</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>#ORD-2026-0892</td>
            <td>김민준</td>
            <td>로얄캐닌 사료 4kg 외 1건</td>
            <td>74,900원</td>
            <td><span class="badge wait">결제완료</span></td>
            <td><button class="detail-btn">출고처리</button></td>
          </tr>
          <tr>
            <td>#ORD-2026-0891</td>
            <td>이서연</td>
            <td>노즈워크 매트 오렌지</td>
            <td>18,500원</td>
            <td><span class="badge wait">결제완료</span></td>
            <td><button class="detail-btn">출고처리</button></td>
          </tr>
          <tr>
            <td>#ORD-2026-0890</td>
            <td>박지호</td>
            <td>H형 하네스 M 블루</td>
            <td>22,000원</td>
            <td><span class="badge confirm">배송중</span></td>
            <td>—</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="dash-card review-card">
      <div class="card-head">
        <h3>최근 리뷰</h3>
        <a href="${contextPath}/biz/store/reviews" class="outline-btn">전체 리뷰 보기</a>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>김민준 님</b> <span class="stars">★★★★★</span></p>
          <small>사료 배송이 빠르고 포장도 꼼꼼했어요.</small>
        </div>
        <em>2026-07-02</em>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>이서연 님</b> <span class="stars">★★★★☆</span></p>
          <small>매트 재질이 생각보다 도톰해서 만족스러워요.</small>
        </div>
        <em>2026-07-01</em>
      </div>

      <div class="review-item">
        <div class="avatar"></div>
        <div>
          <p><b>박지호 님</b> <span class="stars">★★★★★</span></p>
          <small>하네스 사이즈가 딱 맞고 착용감이 좋습니다.</small>
        </div>
        <em>2026-06-30</em>
      </div>
    </div>
  </section>
</main>

<%@ include file="/WEB-INF/views/biz/common/footer.jsp" %>