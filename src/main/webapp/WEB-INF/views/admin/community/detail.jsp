<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage"   value="community-list" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

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
            <p class="adm-page-desc">신고 내역을 확인하고 게시글을 처리하세요.</p>
        </div>
        <div class="adm-page-actions" style="display:flex;gap:8px">
            <button class="adm-btn gray" onclick="if(confirm('이 게시글을 숨김 처리하시겠습니까?'))alert('숨김 처리되었습니다.')">숨김</button>
            <button class="adm-btn red" onclick="if(confirm('이 게시글을 삭제하시겠습니까?'))location.href='${contextPath}/admin/community/list'">삭제</button>
        </div>
    </div>

    <div class="comm-detail-grid">
        <div class="comm-post-card">
            <div class="comm-post-head">
                <span class="comm-post-board">집사생활</span>
                <span class="adm-badge wait" style="margin-left:8px">신고 대기</span>
                <h2 class="comm-post-title">우리 강아지 훈련 방법 공유해요!</h2>
                <div class="comm-post-meta">
                    <span>작성자 <strong>김민준</strong></span>
                    <span>작성일 2025.06.25 14:32</span>
                    <span>조회 1,284</span>
                    <span>댓글 24</span>
                    <span style="color:#DC2626;font-weight:700">신고 3건</span>
                </div>
            </div>
            <div class="comm-post-body">
                <img src="https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=800&q=80&auto=format&fit=crop"
                     class="comm-post-img" alt="게시글 이미지"
                     onerror="this.style.display='none'">
                <p>안녕하세요! 1살 말티즈 키우는 집사입니다.</p>
                <p>최근에 산책 훈련과 기본 명령어(앉아, 기다려)를 가르치는 방법을 정리해 봤어요.
                긍정 강화 방식으로 하루 10분씩 반복하니 일주일 만에 눈에 띄게 좋아졌습니다.</p>
                <p>궁금한 점 있으시면 댓글로 물어봐 주세요!</p>
            </div>
        </div>

        <div>
            <div class="comm-side-card">
                <h3 class="comm-side-title">작성자 정보</h3>
                <div class="comm-report-item"><span>이름</span><strong>김민준</strong></div>
                <div class="comm-report-item"><span>이메일</span><strong>minjun@email.com</strong></div>
                <div class="comm-report-item"><span>가입일</span><strong>2025.06.25</strong></div>
                <div class="comm-report-item"><span>누적 신고</span><strong style="color:#DC2626">1건</strong></div>
                <a href="${contextPath}/admin/member/detail?id=12847" class="adm-btn blue" style="display:block;text-align:center;margin-top:14px;padding:9px">회원 상세 보기</a>
            </div>

            <div class="comm-side-card">
                <h3 class="comm-side-title">신고 내역 (3건)</h3>
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

            <div class="comm-side-card">
                <h3 class="comm-side-title">처리</h3>
                <div class="comm-action-btns">
                    <button class="adm-btn green" onclick="if(confirm('신고를 기각하고 게시글을 유지하시겠습니까?'))alert('신고 기각 처리되었습니다.')">신고 기각 (유지)</button>
                    <button class="adm-btn gray" onclick="if(confirm('게시글을 숨김 처리하시겠습니까?'))alert('숨김 처리되었습니다.')">숨김 처리</button>
                    <button class="adm-btn red" onclick="if(confirm('게시글을 삭제하시겠습니까?'))location.href='${contextPath}/admin/community/list'">삭제</button>
                    <a href="${contextPath}/admin/community/list" class="adm-btn gray" style="text-align:center;padding:9px;text-decoration:none">목록으로</a>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
