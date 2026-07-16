<%--
  - 박유정 / 2026-07-15
  - GET /admin/community/detail?id= → ${post}
  - POST 숨김·삭제·복구 (상태별 버튼 분기)
  - 신고 내역: UI 유지, DB 연동은 팀 회의 후
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="community-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<%-- 2026-07-15 박유정 — 상세 레이아웃·처리 버튼 너비 통일 --%>
<style>
.comm-detail-breadcrumb{font-size:13px;color:#999;margin-bottom:20px;display:flex;align-items:center;gap:8px}
.comm-detail-breadcrumb a{color:#999;text-decoration:none}
.comm-detail-breadcrumb a:hover{color:#3B5BDB}
.comm-detail-grid{display:grid;grid-template-columns:1fr 320px;gap:20px;align-items:flex-start}
.comm-post-card{background:#fff;border:1px solid #E4E6ED;border-radius:12px;overflow:hidden}
.comm-post-head{padding:22px 24px;border-bottom:1px solid #E4E6ED}
.comm-post-board{font-size:11px;font-weight:700;padding:3px 10px;border-radius:20px;background:#EEF2FF;color:#3B5BDB;display:inline-block;margin-bottom:10px}
.comm-post-title{font-size:20px;font-weight:800;color:#1A1A2E;margin:0 0 12px;line-height:1.4}
.comm-post-meta{display:flex;flex-wrap:wrap;gap:16px;font-size:13px;color:#999}
.comm-post-meta strong{color:#555}
.comm-post-body{padding:24px;font-size:15px;color:#444;line-height:1.85}
.comm-post-img{width:100%;max-height:360px;object-fit:cover;border-radius:8px;margin-bottom:20px}
.comm-side-card{background:#fff;border:1px solid #E4E6ED;border-radius:12px;padding:20px;margin-bottom:16px}
.comm-side-title{font-size:14px;font-weight:800;color:#1A1A2E;margin:0 0 14px;padding-bottom:12px;border-bottom:1px solid #E4E6ED}
.comm-report-item{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid #F5F5F5;font-size:13px}
.comm-report-item:last-child{border-bottom:none}
.comm-action-btns{display:flex;flex-direction:column;gap:8px}
.comm-action-btns form{display:block;width:100%}
.comm-action-btns .adm-btn,
.comm-action-btns a.adm-btn{width:100%;box-sizing:border-box;text-align:center}
.adm-page-actions{display:flex;gap:8px;align-items:center;flex-shrink:0}
.adm-page-actions form{display:inline;margin:0}
.adm-page-actions .adm-btn{min-width:80px;padding:9px 20px}
@media(max-width:900px){.comm-detail-grid{grid-template-columns:1fr}}
</style>

<main class="adm-main">
    <div class="comm-detail-breadcrumb">
        <a href="${contextPath}/admin/community/list">커뮤니티 관리</a>
        <span>›</span>
        <span style="color:#1A1A2E;font-weight:600">게시글 상세</span>
    </div>

    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">게시글 상세</h1>
            <p class="adm-page-desc">게시글을 확인하세요. 신고 처리·패널티는 팀 회의 후 연동 예정입니다.</p>
        </div>
        <%-- 2026-07-15 박유정 — 상단 처리 버튼 (상태별 분기) --%>
        <div class="adm-page-actions">
            <c:choose>
                <c:when test="${post.statusCd eq 'HIDDEN'}">
                    <form method="post" action="${contextPath}/admin/community/restore"
                          onsubmit="return confirm('다시 게시하시겠습니까?')">
                        <input type="hidden" name="postId" value="${post.postId}">
                        <button type="submit" class="adm-btn green">복구</button>
                    </form>
                    <form method="post" action="${contextPath}/admin/community/delete"
                          onsubmit="return confirm('삭제하시겠습니까?')">
                        <input type="hidden" name="postId" value="${post.postId}">
                        <button type="submit" class="adm-btn red">삭제</button>
                    </form>
                </c:when>
                <c:when test="${post.statusCd eq 'DELETED'}">
                    <form method="post" action="${contextPath}/admin/community/restore"
                          onsubmit="return confirm('다시 게시하시겠습니까?')">
                        <input type="hidden" name="postId" value="${post.postId}">
                        <button type="submit" class="adm-btn green">복구</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <form method="post" action="${contextPath}/admin/community/hide"
                          onsubmit="return confirm('숨김 처리하시겠습니까?')">
                        <input type="hidden" name="postId" value="${post.postId}">
                        <button type="submit" class="adm-btn gray">숨김</button>
                    </form>
                    <form method="post" action="${contextPath}/admin/community/delete"
                          onsubmit="return confirm('삭제하시겠습니까?')">
                        <input type="hidden" name="postId" value="${post.postId}">
                        <button type="submit" class="adm-btn red">삭제</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <c:if test="${not empty successMsg}">
        <div style="background:#ECFDF5;border:1px solid #BBF7D0;color:#166534;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
    </c:if>

    <div class="comm-detail-grid">
        <div class="comm-post-card">
            <div class="comm-post-head">
                <span class="comm-post-board">
                    <c:choose>
                        <c:when test="${post.boardType eq 'TOWN'}">집사생활</c:when>
                        <c:when test="${post.boardType eq 'SHARE'}">무료나눔</c:when>
                        <c:when test="${post.boardType eq 'LIFE'}">수의사 상담</c:when>
                    </c:choose>
                </span>
                <%-- 회의 후 pendingReportCount 연동 --%>
                <c:if test="${post.pendingReportCount != null && post.pendingReportCount > 0}">
                    <span class="adm-badge wait" style="margin-left:8px">신고 대기</span>
                </c:if>
                <h2 class="comm-post-title">${post.title}</h2>
                <div class="comm-post-meta">
                    <span>작성자 <strong>${post.authorName}</strong></span>
                    <span>작성일 ${post.regDate.year}.${post.regDate.monthValue}.${post.regDate.dayOfMonth}</span>
                    <span>조회 ${post.viewCount}</span>
                    <span>댓글 ${post.commentCount}</span>
                    <%-- 회의 후 reportCount XML 연동 --%>
                    <span style="color:#DC2626;font-weight:700">신고 ${post.reportCount != null ? post.reportCount : 0}건</span>
                </div>
            </div>
            <div class="comm-post-body">
                <c:forEach var="url" items="${post.photoUrls}">
                    <img src="${url}" class="comm-post-img" alt=""
                         onerror="this.style.display='none'">
                </c:forEach>
                <p style="white-space:pre-wrap">${post.body}</p>
            </div>
        </div>

                <div>
            <div class="comm-side-card">
                <h3 class="comm-side-title">작성자 정보</h3>
                <div class="comm-report-item"><span>이름</span><strong>${post.authorMemberName}</strong></div>
                <div class="comm-report-item"><span>닉네임</span><strong>${post.authorName}</strong></div>
                <div class="comm-report-item"><span>이메일</span><strong>${post.authorEmail}</strong></div>
            </div>

            <%-- ⑤ 신고 UI (회의 후 DB 연동) --%>
            <div class="comm-side-card">
                <h3 class="comm-side-title">신고 내역 (회의 후 연동)</h3>
                <p style="font-size:12px;color:#999;margin:0 0 12px">아래는 UI 샘플입니다. 실제 데이터는 추후 연동합니다.</p>
                <div class="comm-report-item">
                    <div>
                        <div style="font-weight:600;color:#1A1A2E">스팸/광고</div>
                        <div style="font-size:12px;color:#999;margin-top:2px">신고자: user*** · 06.25</div>
                    </div>
                </div>
                <div class="comm-report-item">
                    <div>
                        <div style="font-weight:600;color:#1A1A2E">욕설/비방</div>
                        <div style="font-size:12px;color:#999;margin-top:2px">신고자: pet*** · 06.25</div>
                    </div>
                </div>
                <div class="comm-report-item">
                    <div>
                        <div style="font-weight:600;color:#1A1A2E">기타</div>
                        <div style="font-size:12px;color:#999;margin-top:2px">신고자: dog*** · 06.26</div>
                    </div>
                </div>
            </div>

            <%-- ⑥ 처리 버튼 — 2026-07-15 박유정 상태별 숨김/삭제/복구 POST --%>
            <div class="comm-side-card">
                <h3 class="comm-side-title">처리</h3>
                <div class="comm-action-btns">
                    <button type="button" class="adm-btn green"
                            onclick="alert('신고 기각은 팀 회의 후 연동 예정입니다.')">신고 기각 (유지)</button>
                    <c:choose>
                        <c:when test="${post.statusCd eq 'HIDDEN'}">
                            <form method="post" action="${contextPath}/admin/community/restore"
                                  onsubmit="return confirm('다시 게시하시겠습니까?')">
                                <input type="hidden" name="postId" value="${post.postId}">
                                <button type="submit" class="adm-btn green">복구</button>
                            </form>
                            <form method="post" action="${contextPath}/admin/community/delete"
                                  onsubmit="return confirm('삭제하시겠습니까?')">
                                <input type="hidden" name="postId" value="${post.postId}">
                                <button type="submit" class="adm-btn red">삭제</button>
                            </form>
                        </c:when>
                        <c:when test="${post.statusCd eq 'DELETED'}">
                            <form method="post" action="${contextPath}/admin/community/restore"
                                  onsubmit="return confirm('다시 게시하시겠습니까?')">
                                <input type="hidden" name="postId" value="${post.postId}">
                                <button type="submit" class="adm-btn green">복구</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="${contextPath}/admin/community/hide"
                                  onsubmit="return confirm('숨김 처리하시겠습니까?')">
                                <input type="hidden" name="postId" value="${post.postId}">
                                <button type="submit" class="adm-btn gray">숨김 처리</button>
                            </form>
                            <form method="post" action="${contextPath}/admin/community/delete"
                                  onsubmit="return confirm('삭제하시겠습니까?')">
                                <input type="hidden" name="postId" value="${post.postId}">
                                <button type="submit" class="adm-btn red">삭제</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                    <a href="${contextPath}/admin/community/list" class="adm-btn gray"
                       style="text-align:center;padding:9px;text-decoration:none">목록으로</a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
