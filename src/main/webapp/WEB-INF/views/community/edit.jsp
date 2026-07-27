<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  - HYJ / 2026-07-23
  - 커뮤니티 게시글 수정 화면

  [수정 화면 흐름]
  1. GET /community/edit?id=번호 → CommunityPostController.editForm()
  2. 본인 글 확인 후 ${post} 로 기존 데이터 표시
  3. POST /community/edit → updatePost() → 상세 redirect + successMessage
  4. 실패 → ?error=save / ?error=forbidden

  [model]
  - post (기존 게시글 데이터)
--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="community" />
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
  .write-wrap{max-width:780px;margin:32px auto 80px;padding:0 20px}
  .write-title{font-size:22px;font-weight:800;color:var(--text-main);margin-bottom:24px}
  .write-form-group{display:flex;flex-direction:column;gap:6px;margin-bottom:16px}
  .write-form-group label{font-size:13px;font-weight:700;color:var(--text-sub)}
  .write-form-group select,.write-form-group input{border:1px solid var(--border);border-radius:var(--radius-sm);padding:11px 14px;font-size:14px;color:var(--text-main);outline:none;transition:border-color .2s;font-family:inherit}
  .write-form-group select:focus,.write-form-group input:focus{border-color:var(--primary)}
  .write-editor{border:1px solid var(--border);border-radius:var(--radius-sm);overflow:hidden}
  .write-toolbar{background:var(--bg-page);border-bottom:1px solid var(--border);padding:10px 14px;display:flex;gap:6px;flex-wrap:wrap}
  .toolbar-btn{padding:5px 10px;border:1px solid var(--border);border-radius:4px;background:#fff;font-size:12px;cursor:pointer;font-weight:600;color:var(--text-sub);transition:var(--transition)}
  .toolbar-btn:hover{border-color:var(--primary);color:var(--primary)}
  .write-textarea{width:100%;min-height:300px;border:none;padding:16px;font-size:14px;color:var(--text-main);outline:none;resize:vertical;font-family:inherit;line-height:1.7;box-sizing:border-box}
  .write-btn-row{display:flex;justify-content:flex-end;gap:12px;margin-top:20px}
  .btn-cancel-write{padding:12px 28px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;color:var(--text-sub);font-size:15px;font-weight:700;cursor:pointer}
  .btn-submit-write{padding:12px 32px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:15px;font-weight:700;cursor:pointer;transition:var(--transition)}
  .btn-submit-write:hover{background:var(--primary-dark)}
  .write-error{background:#FEE2E2;border:1px solid #FCA5A5;border-radius:var(--radius-sm);padding:14px 16px;margin-bottom:20px;font-size:14px;color:#B91C1C;line-height:1.6}
  .edit-board-badge{display:inline-block;font-size:12px;font-weight:700;background:var(--primary-light);color:var(--primary-dark);padding:3px 10px;border-radius:20px;margin-bottom:10px}
</style>

<form method="post" action="${contextPath}/community/edit">
  <input type="hidden" name="postId" value="${post.postId}">
<div class="write-wrap">
  <h1 class="write-title">게시글 수정</h1>

  <c:if test="${param.error eq 'save'}">
    <div class="write-error">수정에 실패했습니다. 잠시 후 다시 시도해 주세요.</div>
  </c:if>
  <c:if test="${param.error eq 'forbidden'}">
    <div class="write-error">본인이 작성한 글만 수정할 수 있습니다.</div>
  </c:if>

  <div class="write-form-group">
    <label>게시판</label>
    <c:choose>
      <c:when test="${post.boardType eq 'TOWN'}"><span class="edit-board-badge">집사생활</span></c:when>
      <c:when test="${post.boardType eq 'SHARE'}"><span class="edit-board-badge">무료나눔</span></c:when>
      <c:when test="${post.boardType eq 'LIFE'}"><span class="edit-board-badge">수의사 상담</span></c:when>
    </c:choose>
  </div>

  <div class="write-form-group">
    <label>제목</label>
    <input type="text" name="title" value="<c:out value='${post.title}'/>" placeholder="제목을 입력하세요" required>
  </div>
  <div class="write-form-group">
    <label>내용</label>
    <div class="write-editor">
      <div class="write-toolbar">
        <button type="button" class="toolbar-btn"><strong>B</strong></button>
        <button type="button" class="toolbar-btn"><em>I</em></button>
        <button type="button" class="toolbar-btn"><u>U</u></button>
        <button type="button" class="toolbar-btn">H1</button>
        <button type="button" class="toolbar-btn">H2</button>
        <button type="button" class="toolbar-btn">목록</button>
        <button type="button" class="toolbar-btn">링크</button>
      </div>
      <textarea class="write-textarea" name="body" placeholder="내용을 입력하세요..." required><c:out value="${post.body}"/></textarea>
    </div>
  </div>

  <div class="write-btn-row">
    <button type="button" class="btn-cancel-write" onclick="history.back()">취소</button>
    <button type="submit" class="btn-submit-write">수정하기</button>
  </div>
</div>
</form>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
