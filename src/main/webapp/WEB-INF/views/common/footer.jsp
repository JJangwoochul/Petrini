<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<footer class="pc-footer">
    <div class="footer-inner">
        <div class="footer-left">
            <a href="${contextPath}/" class="footer-logo">
                <svg width="26" height="26" viewBox="0 0 32 32" fill="none">
                    <ellipse cx="16" cy="20" rx="9" ry="8" fill="#2BAB82"/>
                    <ellipse cx="8"  cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="13" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="19" cy="9.5" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <ellipse cx="24" cy="12" rx="3.2" ry="3.8" fill="#2BAB82"/>
                    <path d="M14.5 20.5 C14.5 19 16 18 16 18 C16 18 17.5 19 17.5 20.5 C17.5 22 16 23 16 23 C16 23 14.5 22 14.5 20.5Z" fill="white" opacity="0.85"/>
                </svg>
                <span>펫린이</span>
            </a>
            <p class="footer-copy">© 2024 펫린이. All rights reserved.</p>
        </div>

        <div class="footer-right">
            <div class="footer-info">
                <p><span class="footer-info-label">대표이사</span> 장우철, 하예주, 곽지윤, 박유정</p>
                <p><span class="footer-info-label">사업자번호</span> 000-00000-00</p>
                <p><span class="footer-info-label">주소</span> 대전광역시 서구 대덕대로 182 오라클빌딩 3층, 10층</p>
                <p><span class="footer-info-label">이메일</span> <a class="footer-info-value" href="mailto:asdfg@gmail.com">asdfg@gmail.com</a></p>
                <p><span class="footer-info-label">고객센터</span> 1588-0000</p>
            </div>
        </div>
    </div>
</footer>
<script>window.__CONTEXT_PATH__ = '${contextPath}';</script>
<script src="${contextPath}/resources/js/search.js?v=20260705"></script>
