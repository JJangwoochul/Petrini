<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage" value="cms-notice" />
<c:set var="isEdit" value="${param.mode eq 'edit'}" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>
<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">${isEdit ? '공지 수정' : '공지 등록'}</h1>
            <p class="adm-page-desc">고객센터에 노출될 공지사항을 작성합니다.</p>
        </div>
    </div>
    <div class="adm-card">
        <div class="adm-card-body" style="padding:24px">
            <div style="display:flex;flex-direction:column;gap:16px">
                <div style="display:flex;flex-direction:column;gap:6px">
                    <label style="font-size:13px;font-weight:600">제목</label>
                    <input type="text" value="${isEdit ? '7월 여름맞이 최대 30% 할인 이벤트 안내' : ''}" style="border:1px solid #E4E6ED;border-radius:8px;padding:10px 14px;font-size:14px">
                </div>
                <div style="display:flex;align-items:center;gap:8px;font-size:14px">
                    <input type="checkbox" id="pinNotice" ${isEdit ? 'checked' : ''}>
                    <label for="pinNotice">상단 고정</label>
                </div>
                <div style="display:flex;flex-direction:column;gap:6px">
                    <label style="font-size:13px;font-weight:600">내용</label>
                    <textarea style="min-height:280px;border:1px solid #E4E6ED;border-radius:8px;padding:14px;font-size:14px;line-height:1.7;font-family:inherit">7월 한 달간 전 상품 최대 30% 할인 이벤트를 진행합니다. 자세한 내용은 이벤트 페이지를 확인해 주세요.</textarea>
                </div>
            </div>
            <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:24px">
                <a href="${contextPath}/admin/cms/notice" class="adm-btn gray" style="text-decoration:none">취소</a>
                <button type="button" class="adm-btn blue" onclick="alert('저장되었습니다.');location.href='${contextPath}/admin/cms/notice'">${isEdit ? '수정' : '등록'}</button>
            </div>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
