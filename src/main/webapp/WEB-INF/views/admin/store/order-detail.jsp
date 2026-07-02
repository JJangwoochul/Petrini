<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="order-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
.order-detail-grid { display:grid; grid-template-columns:1fr 320px; gap:20px; }
.ods { background:#fff; border:1px solid #E4E6ED; border-radius:12px; padding:22px; margin-bottom:20px; }
.ods-title {
    font-size:14px; font-weight:800; color:#1A1A2E;
    margin:0 0 16px; padding-bottom:12px; border-bottom:1px solid #E4E6ED;
    display:flex; align-items:center; gap:8px;
}
.ods-title svg { width:16px; height:16px; stroke:#3B5BDB; fill:none; stroke-width:2; stroke-linecap:round; stroke-linejoin:round; }
.ods-row { display:flex; justify-content:space-between; align-items:center; padding:9px 0; border-bottom:1px solid #F5F5F5; font-size:14px; }
.ods-row:last-child { border-bottom:none; }
.ods-row label { color:#999; font-size:13px; }
.ods-row span  { color:#1A1A2E; font-weight:600; }

/* 주문 상품 */
.order-product-item { display:flex; gap:14px; align-items:center; padding:14px 0; border-bottom:1px solid #E4E6ED; }
.order-product-item:last-child { border-bottom:none; }
.op-thumb { width:64px; height:64px; border-radius:8px; object-fit:cover; flex-shrink:0; }
.op-info  { flex:1; min-width:0; }
.op-name  { font-size:14px; font-weight:600; color:#1A1A2E; margin-bottom:3px; }
.op-opt   { font-size:12px; color:#999; }
.op-price { font-size:15px; font-weight:800; color:#1A1A2E; flex-shrink:0; }

/* 진행 상태 타임라인 */
.order-timeline { display:flex; align-items:flex-start; position:relative; padding:8px 0; }
.order-timeline::before { content:''; position:absolute; top:20px; left:20px; right:20px; height:2px; background:#E4E6ED; z-index:0; }
.ot-step { flex:1; display:flex; flex-direction:column; align-items:center; gap:6px; position:relative; z-index:1; }
.ot-dot { width:40px; height:40px; border-radius:50%; border:2px solid #E4E6ED; background:#fff; display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:700; color:#999; }
.ot-dot svg { width:16px; height:16px; stroke:#fff; fill:none; stroke-width:2.5; stroke-linecap:round; stroke-linejoin:round; }
.ot-step.done .ot-dot  { background:#3B5BDB; border-color:#3B5BDB; color:#fff; }
.ot-step.active .ot-dot { background:#EEF2FF; border-color:#3B5BDB; color:#3B5BDB; }
.ot-label { font-size:11px; color:#999; font-weight:500; text-align:center; }
.ot-step.active .ot-label { color:#3B5BDB; font-weight:700; }
.ot-date  { font-size:10px; color:#bbb; }

/* 운송장 입력 */
.tracking-row { display:flex; gap:8px; margin-top:14px; }
.tracking-row select,
.tracking-row input { border:1px solid #E4E6ED; border-radius:8px; padding:9px 12px; font-size:14px; color:#1A1A2E; outline:none; font-family:inherit; }
.tracking-row select:focus,
.tracking-row input:focus { border-color:#3B5BDB; }
.tracking-row input  { flex:1; }

/* 교환/반품 탭 */
.claim-tab-bar { display:flex; gap:0; border-bottom:2px solid #E4E6ED; margin-bottom:18px; }
.claim-tab { padding:10px 18px; font-size:13px; font-weight:600; color:#999; border:none; background:none; cursor:pointer; border-bottom:2px solid transparent; margin-bottom:-2px; transition:all .15s; }
.claim-tab.on { color:#3B5BDB; border-bottom-color:#3B5BDB; }
.claim-card { border:1px solid #E4E6ED; border-radius:8px; padding:16px; margin-bottom:12px; }
.claim-card-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:10px; }
.claim-reason { font-size:13px; color:#555; line-height:1.6; margin-bottom:12px; }
.claim-actions { display:flex; gap:8px; justify-content:flex-end; }

/* 사이드 요약 */
.order-summary-side { position:sticky; top:20px; }
.summary-total-row { display:flex; justify-content:space-between; font-size:14px; color:#555; margin-bottom:10px; }
.summary-total-row.final { font-size:16px; font-weight:800; color:#1A1A2E; padding-top:12px; border-top:1px solid #E4E6ED; margin-top:4px; }
.summary-total-row.final span:last-child { color:#3B5BDB; }
.status-change-select { width:100%; border:1px solid #E4E6ED; border-radius:8px; padding:10px 12px; font-size:14px; color:#1A1A2E; outline:none; margin-bottom:10px; }
.status-change-select:focus { border-color:#3B5BDB; }
.btn-status-change { width:100%; padding:12px; border:none; border-radius:8px; background:#3B5BDB; color:#fff; font-size:14px; font-weight:700; cursor:pointer; transition:background .15s; }
.btn-status-change:hover { background:#2F4AC7; }
</style>

<main class="adm-main">
    <div style="display:flex;align-items:center;gap:8px;font-size:13px;color:#999;margin-bottom:20px">
        <a href="${contextPath}/admin/store/order-list" style="color:#999;text-decoration:none">주문 관리</a>
        <span>›</span>
        <span style="color:#1A1A2E;font-weight:600">#ORD-2025-0892 상세</span>
    </div>

    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
        <div>
            <h1 class="adm-page-title" style="margin-bottom:4px">주문 상세</h1>
            <p class="adm-page-desc">#ORD-2025-0892 · 2025.06.25 주문</p>
        </div>
        <span class="adm-badge shipping" style="font-size:14px;padding:6px 16px">배송중</span>
    </div>

    <div class="order-detail-grid">
        <div>
            <%-- 진행 상태 --%>
            <div class="ods" style="margin-bottom:20px">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
                    주문 진행 상태
                </div>
                <div class="order-timeline">
                    <div class="ot-step done">
                        <div class="ot-dot"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div>
                        <span class="ot-label">결제완료</span>
                        <span class="ot-date">06.25 10:42</span>
                    </div>
                    <div class="ot-step done">
                        <div class="ot-dot"><svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg></div>
                        <span class="ot-label">상품준비</span>
                        <span class="ot-date">06.25 14:00</span>
                    </div>
                    <div class="ot-step active">
                        <div class="ot-dot"><svg viewBox="0 0 24 24"><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg></div>
                        <span class="ot-label">배송중</span>
                        <span class="ot-date">06.25 16:30</span>
                    </div>
                    <div class="ot-step">
                        <div class="ot-dot">4</div>
                        <span class="ot-label">배송완료</span>
                        <span class="ot-date">—</span>
                    </div>
                </div>

                <%-- 운송장 입력 --%>
                <div style="margin-top:18px;padding-top:16px;border-top:1px solid #E4E6ED">
                    <div style="font-size:13px;font-weight:700;color:#1A1A2E;margin-bottom:10px">운송장 번호</div>
                    <div class="tracking-row">
                        <select style="width:140px;flex-shrink:0">
                            <option>CJ대한통운</option>
                            <option>한진택배</option>
                            <option>롯데택배</option>
                            <option>우체국</option>
                        </select>
                        <input type="text" placeholder="운송장 번호 입력" value="123-456-7890123">
                        <button class="adm-btn blue" onclick="alert('운송장이 등록되었습니다.\n구매자에게 이메일 알림이 발송됩니다.')">등록</button>
                    </div>
                </div>
            </div>

            <%-- 주문 상품 --%>
            <div class="ods">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/></svg>
                    주문 상품
                </div>
                <div class="order-product-item">
                    <img class="op-thumb" src="https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=128&q=70&auto=format&fit=crop" alt="사료" onerror="this.src='https://placehold.co/64x64/EAF7F2/2BAB82?text=IMG'">
                    <div class="op-info">
                        <div class="op-name">로얄캐닌 미디엄 어덜트 사료 4kg</div>
                        <div class="op-opt">옵션: 4kg · 수량: 1개</div>
                    </div>
                    <div class="op-price">48,900원</div>
                </div>
                <div class="order-product-item">
                    <img class="op-thumb" src="https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=128&q=70&auto=format&fit=crop" alt="장난감" onerror="this.src='https://placehold.co/64x64/EAF7F2/2BAB82?text=IMG'">
                    <div class="op-info">
                        <div class="op-name">노즈워크 매트 오렌지</div>
                        <div class="op-opt">단일 옵션 · 수량: 2개</div>
                    </div>
                    <div class="op-price">37,000원</div>
                </div>
            </div>

            <%-- 배송지 --%>
            <div class="ods">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    배송지 정보
                </div>
                <div class="ods-row"><label>받는 분</label><span>김민준</span></div>
                <div class="ods-row"><label>연락처</label><span>010-1234-5678</span></div>
                <div class="ods-row"><label>주소</label><span>서울 마포구 합정동 123-4 (우: 04001)</span></div>
                <div class="ods-row"><label>배송 요청사항</label><span>문 앞에 놓아주세요</span></div>
            </div>

            <%-- 교환 / 반품 처리 --%>
            <div class="ods">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></svg>
                    교환 / 반품 처리
                </div>
                <div class="claim-tab-bar">
                    <button class="claim-tab on" onclick="showClaim('exchange',this)">교환 신청 <span style="background:#EEF2FF;color:#3B5BDB;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">1건</span></button>
                    <button class="claim-tab" onclick="showClaim('return',this)">반품 신청 <span style="background:#FEE2E2;color:#DC2626;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">0건</span></button>
                </div>
                <div id="claim-exchange">
                    <div class="claim-card">
                        <div class="claim-card-head">
                            <div>
                                <strong style="font-size:14px;color:#1A1A2E">노즈워크 매트 오렌지</strong>
                                <span class="adm-badge wait" style="margin-left:8px;font-size:11px">검토중</span>
                            </div>
                            <span style="font-size:12px;color:#999">신청일: 2025.06.26</span>
                        </div>
                        <div class="claim-reason">
                            <strong style="color:#555">교환 사유:</strong> 사이즈가 생각보다 너무 작아요. 더 큰 사이즈로 교환하고 싶습니다.<br>
                            <strong style="color:#555">요청 사항:</strong> L 사이즈로 교환 원합니다.
                        </div>
                        <div class="claim-actions">
                            <button class="adm-btn gray" onclick="alert('교환 거절 처리되었습니다.')">거절</button>
                            <button class="adm-btn green" onclick="alert('교환 승인되었습니다.\n구매자에게 이메일 알림이 발송됩니다.')">승인</button>
                        </div>
                    </div>
                </div>
                <div id="claim-return" style="display:none">
                    <div class="adm-empty" style="padding:40px 0">
                        <div class="adm-empty-icon"><svg viewBox="0 0 24 24"><polyline points="1 4 1 10 7 10"/><path d="M3.51 15a9 9 0 102.13-9.36L1 10"/></svg></div>
                        <p>반품 신청 내역이 없습니다.</p>
                    </div>
                </div>
            </div>
        </div>

        <%-- 사이드 요약 --%>
        <div class="order-summary-side">
            <div class="ods">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    주문자 정보
                </div>
                <div class="ods-row"><label>이름</label><span>김민준</span></div>
                <div class="ods-row"><label>이메일</label><span>minjun@email.com</span></div>
                <div class="ods-row"><label>전화번호</label><span>010-1234-5678</span></div>
                <div style="margin-top:12px">
                    <a href="${contextPath}/admin/member/detail?id=12847" class="adm-btn blue" style="display:block;text-align:center;padding:8px">회원 상세 보기</a>
                </div>
            </div>

            <div class="ods">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/></svg>
                    결제 정보
                </div>
                <div class="summary-total-row"><span>상품 금액</span><span>85,900원</span></div>
                <div class="summary-total-row"><span>배송비</span><span style="color:#16A34A">무료</span></div>
                <div class="summary-total-row"><span>쿠폰 할인</span><span style="color:#DC2626">-11,000원</span></div>
                <div class="summary-total-row final"><span>총 결제금액</span><span>74,900원</span></div>
                <div style="margin-top:12px;padding-top:12px;border-top:1px solid #E4E6ED;font-size:13px;color:#555">
                    <div class="summary-total-row" style="margin-bottom:6px"><span>결제 수단</span><span>신용카드</span></div>
                    <div class="summary-total-row"><span>결제 일시</span><span>2025.06.25 10:42</span></div>
                </div>
            </div>

            <div class="ods">
                <div class="ods-title">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    주문 상태 변경
                </div>
                <select class="status-change-select">
                    <option>결제완료</option>
                    <option>상품준비중</option>
                    <option selected>배송중</option>
                    <option>배송완료</option>
                    <option>취소완료</option>
                </select>
                <button class="btn-status-change" onclick="alert('주문 상태가 변경되었습니다.\n구매자에게 이메일 알림이 발송됩니다.')">상태 변경 적용</button>
            </div>
        </div>
    </div>
</main>

<script>
function showClaim(tab, btn) {
    document.querySelectorAll('.claim-tab').forEach(t => t.classList.remove('on'));
    btn.classList.add('on');
    document.getElementById('claim-exchange').style.display = tab === 'exchange' ? 'block' : 'none';
    document.getElementById('claim-return').style.display   = tab === 'return'   ? 'block' : 'none';
}
</script>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
