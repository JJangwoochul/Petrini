<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="biz-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<style>
.biz-apply-card {
    background:#fff; border:1px solid #E4E6ED; border-radius:12px;
    margin-bottom:14px; overflow:hidden; transition:box-shadow .2s;
}
.biz-apply-card:hover { box-shadow:0 4px 16px rgba(0,0,0,.08); }
.biz-apply-head {
    display:flex; align-items:center; gap:14px;
    padding:16px 20px; border-bottom:1px solid #E4E6ED; background:#FAFBFC;
}
.biz-apply-type {
    width:42px; height:42px; border-radius:10px;
    display:flex; align-items:center; justify-content:center; flex-shrink:0;
}
.biz-apply-type svg { width:22px; height:22px; fill:none; stroke-width:1.8; stroke-linecap:round; stroke-linejoin:round; }
.biz-apply-type.hospital   { background:#E0F2FE; } .biz-apply-type.hospital svg   { stroke:#0284C7; }
.biz-apply-type.stay       { background:#F3E8FF; } .biz-apply-type.stay svg       { stroke:#9333EA; }
.biz-apply-type.grooming   { background:#FDF2F8; } .biz-apply-type.grooming svg   { stroke:#DB2777; }
.biz-apply-name   { font-size:15px; font-weight:700; color:#1A1A2E; }
.biz-apply-meta   { font-size:12px; color:#999; margin-top:2px; }
.biz-apply-date   { margin-left:auto; font-size:12px; color:#999; }
.biz-apply-body {
    display:grid; grid-template-columns:repeat(4,1fr);
    padding:0; border-bottom:1px solid #E4E6ED;
}
.biz-apply-field { padding:14px 20px; border-right:1px solid #E4E6ED; }
.biz-apply-field:last-child { border-right:none; }
.biz-apply-field label { font-size:11px; color:#999; font-weight:600; display:block; margin-bottom:4px; }
.biz-apply-field span  { font-size:13px; color:#1A1A2E; }
.biz-apply-foot {
    display:flex; justify-content:space-between; align-items:center;
    padding:12px 20px;
}
.biz-doc-link { font-size:12px; color:#3B5BDB; text-decoration:underline; cursor:pointer; }
.biz-action-area { display:flex; gap:8px; align-items:center; }
.biz-reject-input {
    border:1px solid #E4E6ED; border-radius:6px;
    padding:6px 12px; font-size:12px; color:#333;
    outline:none; width:220px; display:none;
}
</style>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">사업자 승인 관리</h1>
            <p class="adm-page-desc">사업자 등록 신청을 검토하고 승인·반려 처리하세요.</p>
        </div>
    </div>

    <%-- 2026-07-09 장우철 — 처리 결과 메시지 (승인/반려 redirect 후) --%>
    <c:if test="${not empty successMsg}">
        <div style="background:#ECFDF5;border:1px solid #BBF7D0;color:#166534;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
    </c:if>

    <%-- 2026-07-09 장우철 — [변경 후] 상태 탭 (DB 건수 연동)
         이유: PENDING/APPROVED/REJECTED 별 TB_BUSINESS 목록 필터 --%>
    <div style="display:flex;gap:0;border-bottom:2px solid #E4E6ED;margin-bottom:20px">
        <a href="${contextPath}/admin/biz/list?status=PENDING"
           style="padding:10px 20px;font-size:14px;font-weight:${status eq 'PENDING' ? '700' : '600'};color:${status eq 'PENDING' ? '#3B5BDB' : '#999'};text-decoration:none;border:none;background:none;border-bottom:2px solid ${status eq 'PENDING' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
            대기 <span style="background:#EEF2FF;color:#3B5BDB;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.PENDING}</span>
        </a>
        <a href="${contextPath}/admin/biz/list?status=APPROVED"
           style="padding:10px 20px;font-size:14px;font-weight:${status eq 'APPROVED' ? '700' : '600'};color:${status eq 'APPROVED' ? '#3B5BDB' : '#999'};text-decoration:none;border:none;background:none;border-bottom:2px solid ${status eq 'APPROVED' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
            승인완료 <span style="background:#F0FDF4;color:#16A34A;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.APPROVED}</span>
        </a>
        <a href="${contextPath}/admin/biz/list?status=REJECTED"
           style="padding:10px 20px;font-size:14px;font-weight:${status eq 'REJECTED' ? '700' : '600'};color:${status eq 'REJECTED' ? '#3B5BDB' : '#999'};text-decoration:none;border:none;background:none;border-bottom:2px solid ${status eq 'REJECTED' ? '#3B5BDB' : 'transparent'};margin-bottom:-2px">
            반려 <span style="background:#FEF2F2;color:#DC2626;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">${statusCounts.REJECTED}</span>
        </a>
    </div>

    <%-- 2026-07-09 장우철 — [변경 후] 신청 목록 실데이터 반복 --%>
    <c:choose>
    <c:when test="${empty list}">
        <p style="text-align:center;color:#999;padding:48px 0">해당 상태의 사업자 신청이 없습니다.</p>
    </c:when>
    <c:otherwise>
    <c:forEach var="item" items="${list}">
    <div class="biz-apply-card">
        <div class="biz-apply-head">
            <c:set var="typeClass" value="hospital"/>
            <c:if test="${item.bizType eq 'STAY'}"><c:set var="typeClass" value="stay"/></c:if>
            <c:if test="${item.bizType eq 'GROOMING'}"><c:set var="typeClass" value="grooming"/></c:if>
            <div class="biz-apply-type ${typeClass}">
                <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
            </div>
            <div>
                <div class="biz-apply-name">${item.bizName}</div>
                <div class="biz-apply-meta">
                    ${item.bizType} · 대표자: ${item.ceoName} · ${item.phone}
                </div>
            </div>
            <c:choose>
                <c:when test="${item.statusCd eq 'PENDING'}"><span class="adm-badge wait" style="margin-left:12px">승인 대기</span></c:when>
                <c:when test="${item.statusCd eq 'APPROVED'}"><span class="adm-badge active" style="margin-left:12px">승인 완료</span></c:when>
                <c:otherwise><span class="adm-badge" style="margin-left:12px;background:#FEE2E2;color:#DC2626">반려</span></c:otherwise>
            </c:choose>
            <span class="biz-apply-date">신청일: ${item.applyDate}</span>
        </div>
        <div class="biz-apply-body">
            <div class="biz-apply-field"><label>사업자 등록번호</label><span>${item.bizRegNo}</span></div>
            <div class="biz-apply-field"><label>신청 계정</label><span>${item.bizId}</span></div>
            <div class="biz-apply-field"><label>업종</label><span>${item.bizType}</span></div>
            <div class="biz-apply-field"><label>연락처</label><span>${item.phone}</span></div>
        </div>
        <div class="biz-apply-foot">
            <div>
                <span class="biz-doc-link">서류는 상세에서 확인</span>
            </div>
            <div class="biz-action-area">
                <a href="${contextPath}/admin/biz/detail?bizNo=${item.bizNo}" class="adm-btn blue">상세 검토</a>
                <c:if test="${item.statusCd eq 'PENDING'}">
                <form method="post" action="${contextPath}/admin/biz/approve" style="display:inline"
                      onsubmit="return confirm('${item.bizName} 신청을 승인하시겠습니까?')">
                    <input type="hidden" name="bizNo" value="${item.bizNo}">
                    <button type="submit" class="adm-btn green">승인</button>
                </form>
                </c:if>
            </div>
        </div>
    </div>
    </c:forEach>
    </c:otherwise>
    </c:choose>

    <%-- ========== [변경 전] 2026-07-09 장우철 — 더미 카드 3건 (목업) 보존
         이유: 기존 UI 목업을 삭제하지 않고 참고용으로 남김 ==========
    <div style="display:flex;gap:0;border-bottom:2px solid #E4E6ED;margin-bottom:20px">
        <button style="padding:10px 20px;font-size:14px;font-weight:700;color:#3B5BDB;border:none;background:none;border-bottom:2px solid #3B5BDB;margin-bottom:-2px;cursor:pointer">대기 <span style="background:#EEF2FF;color:#3B5BDB;font-size:11px;padding:1px 7px;border-radius:20px;margin-left:4px">3</span></button>
        <button style="padding:10px 20px;font-size:14px;font-weight:600;color:#999;border:none;background:none;cursor:pointer">승인완료</button>
        <button style="padding:10px 20px;font-size:14px;font-weight:600;color:#999;border:none;background:none;cursor:pointer">반려</button>
    </div>
    <div class="biz-apply-card">
        <div class="biz-apply-head">
            <div class="biz-apply-type hospital">
                <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><rect x="9" y="10" width="6" height="11" rx="1"/><line x1="12" y1="13" x2="12" y2="17"/><line x1="10" y1="15" x2="14" y2="15"/></svg>
            </div>
            <div>
                <div class="biz-apply-name">행복 동물병원</div>
                <div class="biz-apply-meta">동물병원 · 대표자: 김철수 · 010-1234-5678</div>
            </div>
            <span class="adm-badge wait" style="margin-left:12px">승인 대기</span>
            <span class="biz-apply-date">신청일: 2025.06.25</span>
        </div>
        <div class="biz-apply-body">
            <div class="biz-apply-field"><label>사업자 등록번호</label><span>123-45-67890 ✓ 인증됨</span></div>
            <div class="biz-apply-field"><label>사업장 주소</label><span>서울 마포구 합정동 123-4</span></div>
            <div class="biz-apply-field"><label>이메일</label><span>happy@hospital.com</span></div>
            <div class="biz-apply-field"><label>연락처</label><span>02-1234-5678</span></div>
        </div>
        <div class="biz-apply-foot">
            <div>
                <span class="biz-doc-link" onclick="alert('서류 미리보기')">사업자등록증 보기</span>
                <span class="biz-doc-link" style="margin-left:14px" onclick="alert('서류 미리보기')">영업신고증 보기</span>
            </div>
            <div class="biz-action-area">
                <a href="${contextPath}/admin/biz/detail?id=1" class="adm-btn blue">상세 검토</a>
                <input type="text" class="biz-reject-input" id="reject1" placeholder="반려 사유를 입력하세요">
                <button class="adm-btn gray" onclick="var el=document.getElementById('reject1');el.style.display=el.style.display==='none'?'block':'none'">반려</button>
                <button class="adm-btn green" onclick="if(confirm('행복 동물병원을 승인하시겠습니까?\n승인 시 사업자 권한이 부여되고 이메일이 발송됩니다.'))alert('승인 처리되었습니다.')">승인</button>
            </div>
        </div>
    </div>
    <div class="biz-apply-card">
        <div class="biz-apply-head">
            <div class="biz-apply-type stay">
                <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><path d="M9 22V12h6v10"/></svg>
            </div>
            <div>
                <div class="biz-apply-name">강아지숲 펫호텔</div>
                <div class="biz-apply-meta">반려동물 숙소 · 대표자: 이영희 · 010-2345-6789</div>
            </div>
            <span class="adm-badge wait" style="margin-left:12px">승인 대기</span>
            <span class="biz-apply-date">신청일: 2025.06.24</span>
        </div>
        <div class="biz-apply-body">
            <div class="biz-apply-field"><label>사업자 등록번호</label><span>234-56-78901 ✓ 인증됨</span></div>
            <div class="biz-apply-field"><label>사업장 주소</label><span>경기 고양시 일산동구 456-7</span></div>
            <div class="biz-apply-field"><label>이메일</label><span>dogforest@hotel.com</span></div>
            <div class="biz-apply-field"><label>연락처</label><span>031-2345-6789</span></div>
        </div>
        <div class="biz-apply-foot">
            <div>
                <span class="biz-doc-link" onclick="alert('서류 미리보기')">사업자등록증 보기</span>
            </div>
            <div class="biz-action-area">
                <a href="${contextPath}/admin/biz/detail?id=2" class="adm-btn blue">상세 검토</a>
                <input type="text" class="biz-reject-input" id="reject2" placeholder="반려 사유를 입력하세요">
                <button class="adm-btn gray" onclick="var el=document.getElementById('reject2');el.style.display=el.style.display==='none'?'block':'none'">반려</button>
                <button class="adm-btn green" onclick="if(confirm('강아지숲 펫호텔을 승인하시겠습니까?'))alert('승인 처리되었습니다.')">승인</button>
            </div>
        </div>
    </div>
    <div class="biz-apply-card">
        <div class="biz-apply-head">
            <div class="biz-apply-type grooming">
                <svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78L12 21.23l8.84-8.84a5.5 5.5 0 000-7.78z"/></svg>
            </div>
            <div>
                <div class="biz-apply-name">냥냥 그루밍샵</div>
                <div class="biz-apply-meta">애견미용실 · 대표자: 박수진 · 010-3456-7890</div>
            </div>
            <span class="adm-badge wait" style="margin-left:12px">승인 대기</span>
            <span class="biz-apply-date">신청일: 2025.06.23</span>
        </div>
        <div class="biz-apply-body">
            <div class="biz-apply-field"><label>사업자 등록번호</label><span>345-67-89012 ✓ 인증됨</span></div>
            <div class="biz-apply-field"><label>사업장 주소</label><span>서울 강남구 역삼동 789-1</span></div>
            <div class="biz-apply-field"><label>이메일</label><span>nyang@grooming.com</span></div>
            <div class="biz-apply-field"><label>연락처</label><span>02-3456-7890</span></div>
        </div>
        <div class="biz-apply-foot">
            <div>
                <span class="biz-doc-link" onclick="alert('서류 미리보기')">사업자등록증 보기</span>
                <span class="biz-doc-link" style="margin-left:14px" onclick="alert('서류 미리보기')">영업신고증 보기</span>
            </div>
            <div class="biz-action-area">
                <a href="${contextPath}/admin/biz/detail?id=3" class="adm-btn blue">상세 검토</a>
                <input type="text" class="biz-reject-input" id="reject3" placeholder="반려 사유를 입력하세요">
                <button class="adm-btn gray" onclick="var el=document.getElementById('reject3');el.style.display=el.style.display==='none'?'block':'none'">반려</button>
                <button class="adm-btn green" onclick="if(confirm('냥냥 그루밍샵을 승인하시겠습니까?'))alert('승인 처리되었습니다.')">승인</button>
            </div>
        </div>
    </div>
    ========== [변경 전] 끝 ========== --%>

</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
