<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</style>
<div class="write-wrap">
  <h1 class="write-title">게시글 작성</h1>
  <div class="write-form-group">
    <label>게시판 선택</label>
    <select>
      <option value="">게시판을 선택하세요</option>
      <option>동네소식</option>
      <option>분실·보호</option>
      <option>무료나눔</option>
      <option>집사생활</option>
    </select>
  </div>
  <div class="write-form-group">
    <label>제목</label>
    <input type="text" placeholder="제목을 입력하세요">
  </div>
  <div class="write-form-group">
    <label>내용</label>
    <div class="write-editor">
      <div class="write-toolbar">
        <button class="toolbar-btn"><strong>B</strong></button>
        <button class="toolbar-btn"><em>I</em></button>
        <button class="toolbar-btn"><u>U</u></button>
        <button class="toolbar-btn">H1</button>
        <button class="toolbar-btn">H2</button>
        <button class="toolbar-btn">목록</button>
        <button class="toolbar-btn">링크</button>
      </div>
      <textarea class="write-textarea" placeholder="내용을 입력하세요..."></textarea>
    </div>
  </div>
  <div class="write-form-group">
    <label>이미지 첨부 (최대 5장)</label>
    <div class="write-img-upload">
      <svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
      <span>클릭하여 이미지 업로드</span>
      <small>JPG, PNG, GIF (개당 최대 10MB)</small>
    </div>
  </div>
  <div class="write-btn-row">
    <button class="btn-cancel-write" onclick="history.back()">취소</button>
    <button class="btn-submit-write" onclick="alert('게시글이 등록되었습니다.')">등록하기</button>
  </div>
</div>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
