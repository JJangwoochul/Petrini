<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage" value="cms-faq" />
<c:set var="isEdit" value="${param.mode eq 'edit'}" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>
<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">${isEdit ? 'FAQ 수정' : 'FAQ 등록'}</h1>
            <p class="adm-page-desc">고객센터 FAQ를 등록합니다.</p>
        </div>
    </div>
    <div class="adm-card">
        <div class="adm-card-body" style="padding:24px">
            <div style="display:flex;flex-direction:column;gap:16px">
                <div style="display:flex;flex-direction:column;gap:6px">
                    <label style="font-size:13px;font-weight:600">카테고리</label>
                    <select style="border:1px solid #E4E6ED;border-radius:8px;padding:10px 14px;font-size:14px">
                        <option>서비스</option>
                        <option selected>주문/배송</option>
                        <option>회원</option>
                        <option>예약</option>
                    </select>
                </div>
                <div style="display:flex;flex-direction:column;gap:6px">
                    <label style="font-size:13px;font-weight:600">질문</label>
                    <input type="text" value="${isEdit ? '배송은 얼마나 걸리나요?' : ''}" style="border:1px solid #E4E6ED;border-radius:8px;padding:10px 14px;font-size:14px">
                </div>
                <div style="display:flex;flex-direction:column;gap:6px">
                    <label style="font-size:13px;font-weight:600">답변</label>
                    <textarea style="min-height:200px;border:1px solid #E4E6ED;border-radius:8px;padding:14px;font-size:14px;line-height:1.7;font-family:inherit">결제 완료 후 영업일 기준 2~3일 내 출고되며, 지역에 따라 배송은 1~2일 추가 소요됩니다.</textarea>
                </div>
                <div style="display:flex;align-items:center;gap:8px;font-size:14px">
                    <input type="checkbox" id="faqVisible" checked>
                    <label for="faqVisible">노출</label>
                </div>
            </div>
            <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:24px">
                <a href="${contextPath}/admin/cms/faq" class="adm-btn gray" style="text-decoration:none">취소</a>
                <button type="button" class="adm-btn blue" onclick="alert('저장되었습니다.');location.href='${contextPath}/admin/cms/faq'">${isEdit ? '수정' : '등록'}</button>
            </div>
        </div>
    </div>
</main>
<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>
