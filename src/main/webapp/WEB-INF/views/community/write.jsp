<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  - 박유정 / 2026-07-09
  - 게시글 작성 화면

  [작성 화면 흐름]
  1. GET /community/write → 로그인 확인 후 이 JSP 표시
  2. form POST /community/write (multipart/form-data)
  3. 성공 → /community/detail?id=... redirect + successMessage
  4. 실패 → ?error=member / ?error=save

  [form 필드]
  - boardType : TOWN / SHARE / LIFE
  - title, body, photos(최대 5장)
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
  .write-img-upload{border:2px dashed var(--border);border-radius:var(--radius-sm);padding:24px;text-align:center;cursor:pointer;transition:var(--transition);display:flex;flex-direction:column;align-items:center;gap:8px;color:var(--text-muted)}
  .write-img-upload:hover{border-color:var(--primary);background:var(--primary-light);color:var(--primary-dark)}
  .write-img-upload svg{width:28px;height:28px;stroke:currentColor;fill:none;stroke-width:1.6;stroke-linecap:round;stroke-linejoin:round}
  .write-btn-row{display:flex;justify-content:flex-end;gap:12px;margin-top:20px}
  .btn-cancel-write{padding:12px 28px;border:1px solid var(--border);border-radius:var(--radius-sm);background:#fff;color:var(--text-sub);font-size:15px;font-weight:700;cursor:pointer}
  .btn-submit-write{padding:12px 32px;border:none;border-radius:var(--radius-sm);background:var(--primary);color:#fff;font-size:15px;font-weight:700;cursor:pointer;transition:var(--transition)}
  .btn-submit-write:hover{background:var(--primary-dark)}
  .write-error{background:#FEE2E2;border:1px solid #FCA5A5;border-radius:var(--radius-sm);padding:14px 16px;margin-bottom:20px;font-size:14px;color:#B91C1C;line-height:1.6}
</style>

<form method="post"
      action="${contextPath}/community/write"
      enctype="multipart/form-data">
<div class="write-wrap">
  <h1 class="write-title">게시글 작성</h1>
  <c:if test="${param.error eq 'member'}">
    <div class="write-error">로그인은 되어 있지만 <strong>DB에 회원 정보가 없습니다.</strong> 테스트 계정이 아닌, <strong>회원가입으로 만든 계정</strong>으로 로그인했는지 확인해 주세요.</div>
  </c:if>
  <c:if test="${param.error eq 'save'}">
    <div class="write-error">등록에 실패했습니다. 잠시 후 다시 시도해 주세요. (이미지 용량·로그인 계정도 확인해 주세요)</div>
  </c:if>
  <div class="write-form-group">
    <label>게시판 선택</label>
    <select name="boardType" required>
  <option value="">게시판을 선택하세요</option>
  <option value="TOWN">집사생활</option>
  <option value="SHARE">무료나눔</option>
  <option value="LIFE">수의사 상담</option>
</select>
  </div>
  <div class="write-form-group">
    <label>제목</label>
    <input type="text" name="title" placeholder="제목을 입력하세요" required>
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
      <textarea class="write-textarea" name="body" placeholder="내용을 입력하세요..." required></textarea>
    </div>
  </div>
  <div class="write-form-group">
    <label>이미지 첨부 (최대 5장)</label>
    <label class="write-img-upload" style="cursor:pointer">
  <input type="file" name="photos" accept="image/*" multiple style="display:none"
         onchange="this.closest('.write-form-group').querySelector('.upload-label').textContent =
         this.files.length ? this.files.length + '장 선택됨' : '클릭하여 이미지 업로드'">
  <svg viewBox="0 0 24 24">...</svg>
  <span class="upload-label">클릭하여 이미지 업로드</span>
  <small>JPG, PNG, GIF (최대 5장)</small>
    </label>
  </div>
  <div class="write-btn-row">
    <button type="button" class="btn-cancel-write" onclick="history.back()">취소</button>
    <button type="submit" class="btn-submit-write">등록하기</button>
  </div>
</div>
</form>
 
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
