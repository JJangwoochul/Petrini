<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="dashboard" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">대시보드</h1>
            <p class="adm-page-desc">PetCare 플랫폼 운영 현황을 한눈에 확인하세요.</p>
        </div>
        <div class="adm-page-actions">
            <span style="font-size:13px;color:#999">2025.06.26 기준</span>
        </div>
    </div>

    <%-- 통계 카드 4종 (ADMIN-01) --%>
    <div class="adm-stats">
        <div class="adm-stat-card">
            <div class="adm-stat-icon blue">
                <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg>
            </div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">오늘 신규 가입자</div>
                <div class="adm-stat-val">24<span class="adm-stat-unit">명</span></div>
                <div class="adm-stat-diff up">▲ 어제 대비 +8명</div>
            </div>
        </div>
        <div class="adm-stat-card">
            <div class="adm-stat-icon green">
                <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
            </div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">오늘 주문 수</div>
                <div class="adm-stat-val">138<span class="adm-stat-unit">건</span></div>
                <div class="adm-stat-diff up">▲ 어제 대비 +23건</div>
            </div>
        </div>
        <div class="adm-stat-card">
            <div class="adm-stat-icon orange">
                <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
            </div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">오늘 매출</div>
                <div class="adm-stat-val">4.2<span class="adm-stat-unit">백만원</span></div>
                <div class="adm-stat-diff up">▲ 어제 대비 +12%</div>
            </div>
        </div>
        <div class="adm-stat-card">
            <div class="adm-stat-icon red">
                <svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="16" y1="2" x2="16" y2="6"/></svg>
            </div>
            <div class="adm-stat-body">
                <div class="adm-stat-label">미처리 예약</div>
                <div class="adm-stat-val">17<span class="adm-stat-unit">건</span></div>
                <div class="adm-stat-diff down">▼ 처리 필요</div>
            </div>
        </div>
    </div>

    <div class="adm-grid-2">
        <%-- 매출 차트 --%>
        <div class="adm-card">
            <div class="adm-card-head">
                <span class="adm-card-head-title">주간 매출 현황</span>
                <div style="display:flex;gap:8px">
                    <button class="adm-btn blue" style="font-size:11px;padding:3px 10px">주간</button>
                    <button class="adm-btn gray" style="font-size:11px;padding:3px 10px">월간</button>
                </div>
            </div>
            <div class="adm-card-body">
                <canvas id="salesChart" height="200"></canvas>
            </div>
        </div>

        <%-- 회원 현황 도넛 차트 --%>
        <div class="adm-card">
            <div class="adm-card-head">
                <span class="adm-card-head-title">회원 현황</span>
                <span class="adm-card-head-sub">총 12,847명</span>
            </div>
            <div class="adm-card-body" style="display:flex;align-items:center;gap:24px">
                <canvas id="memberChart" width="160" height="160" style="flex-shrink:0"></canvas>
                <div style="flex:1">
                    <div style="display:flex;flex-direction:column;gap:10px">
                        <div style="display:flex;align-items:center;gap:10px;font-size:13px">
                            <span style="width:12px;height:12px;border-radius:3px;background:#3B5BDB;flex-shrink:0"></span>
                            <span style="flex:1;color:#555">일반회원</span>
                            <span style="font-weight:700;color:#1A1A2E">11,240명</span>
                            <span style="color:#999">87.5%</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;font-size:13px">
                            <span style="width:12px;height:12px;border-radius:3px;background:#2BAB82;flex-shrink:0"></span>
                            <span style="flex:1;color:#555">사업자</span>
                            <span style="font-weight:700;color:#1A1A2E">1,482명</span>
                            <span style="color:#999">11.5%</span>
                        </div>
                        <div style="display:flex;align-items:center;gap:10px;font-size:13px">
                            <span style="width:12px;height:12px;border-radius:3px;background:#E4E6ED;flex-shrink:0"></span>
                            <span style="flex:1;color:#555">탈퇴</span>
                            <span style="font-weight:700;color:#1A1A2E">125명</span>
                            <span style="color:#999">1.0%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="adm-grid-2">
        <%-- 최근 주문 목록 --%>
        <div class="adm-card">
            <div class="adm-card-head">
                <span class="adm-card-head-title">최근 주문</span>
                <a href="${contextPath}/admin/store/order-list" class="adm-btn gray" style="font-size:12px">전체보기</a>
            </div>
            <div class="adm-table-wrap">
                <table class="adm-table">
                    <thead><tr><th>주문번호</th><th>회원</th><th>금액</th><th>상태</th></tr></thead>
                    <tbody>
                        <tr><td>#ORD-2025-0892</td><td>김민준</td><td>74,900원</td><td><span class="adm-badge shipping">배송중</span></td></tr>
                        <tr><td>#ORD-2025-0891</td><td>이서연</td><td>18,500원</td><td><span class="adm-badge done">배송완료</span></td></tr>
                        <tr><td>#ORD-2025-0890</td><td>박지호</td><td>22,000원</td><td><span class="adm-badge done">배송완료</span></td></tr>
                        <tr><td>#ORD-2025-0889</td><td>최유나</td><td>26,000원</td><td><span class="adm-badge wait">결제완료</span></td></tr>
                        <tr><td>#ORD-2025-0888</td><td>정태양</td><td>55,800원</td><td><span class="adm-badge cancel">취소</span></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <%-- 사업자 승인 대기 --%>
        <div class="adm-card">
            <div class="adm-card-head">
                <span class="adm-card-head-title">사업자 승인 대기
                    <span style="margin-left:8px;background:#EEF2FF;color:#3B5BDB;font-size:11px;font-weight:700;padding:2px 8px;border-radius:20px">3건</span>
                </span>
                <a href="${contextPath}/admin/biz/list" class="adm-btn blue" style="font-size:12px">승인 관리</a>
            </div>
            <div class="adm-table-wrap">
                <table class="adm-table">
                    <thead><tr><th>업체명</th><th>업종</th><th>신청일</th><th>처리</th></tr></thead>
                    <tbody>
                        <tr>
                            <td><strong>행복 동물병원</strong></td>
                            <td>동물병원</td>
                            <td>06.25</td>
                            <td><a href="${contextPath}/admin/biz/list" class="adm-btn blue">검토</a></td>
                        </tr>
                        <tr>
                            <td><strong>강아지숲 펫호텔</strong></td>
                            <td>반려동물 숙소</td>
                            <td>06.24</td>
                            <td><a href="${contextPath}/admin/biz/list" class="adm-btn blue">검토</a></td>
                        </tr>
                        <tr>
                            <td><strong>냥냥 그루밍샵</strong></td>
                            <td>애견미용실</td>
                            <td>06.23</td>
                            <td><a href="${contextPath}/admin/biz/list" class="adm-btn blue">검토</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
<script>
/* 매출 차트 */
new Chart(document.getElementById('salesChart'), {
    type: 'bar',
    data: {
        labels: ['월', '화', '수', '목', '금', '토', '일'],
        datasets: [{
            label: '매출 (만원)',
            data: [320, 410, 380, 490, 520, 680, 420],
            backgroundColor: 'rgba(59,91,219,.18)',
            borderColor: '#3B5BDB',
            borderWidth: 2,
            borderRadius: 6
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: {
            y: { beginAtZero: true, grid: { color: '#F1F3F7' } },
            x: { grid: { display: false } }
        }
    }
});

/* 회원 도넛 차트 */
new Chart(document.getElementById('memberChart'), {
    type: 'doughnut',
    data: {
        labels: ['일반회원', '사업자', '탈퇴'],
        datasets: [{
            data: [11240, 1482, 125],
            backgroundColor: ['#3B5BDB', '#2BAB82', '#E4E6ED'],
            borderWidth: 0
        }]
    },
    options: {
        responsive: false,
        plugins: { legend: { display: false } },
        cutout: '70%'
    }
});
</script>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
