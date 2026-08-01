<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="adminPage" value="cms-banner" />
<%@ include file="/WEB-INF/views/admin/common/header.jsp" %>
<%@ include file="/WEB-INF/views/admin/common/sidebar.jsp" %>

<main class="adm-main">
    <div class="adm-page-head">
        <div class="adm-page-head-left">
            <h1 class="adm-page-title">배너 관리</h1>
            <p class="adm-page-desc">사업자가 신청한 배너를 승인·반려하세요. 승인된 배너는 선택한 위치에 노출됩니다.</p>
        </div>
    </div>

    <div class="adm-card">
        <div class="adm-card-head">
            <span class="adm-card-head-title">배너 신청 목록</span>
            <span class="adm-card-head-sub">총 ${bannerList.size()}건</span>
        </div>

        <c:choose>
            <c:when test="${not empty bannerList}">
                <div class="adm-table-wrap">
                    <table class="adm-table">
                        <thead>
                            <tr>
                                <th>미리보기</th>
                                <th>제목</th>
                                <th>사업자</th>
                                <th>노출 위치</th>
                                <th>노출 기간</th>
                                <th>순서</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="banner" items="${bannerList}">
                                <tr id="row-${banner.bannerId}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty banner.imageUrl}">
                                                <img src="/upload/${banner.imageUrl}" alt=""
                                                     style="width:120px;height:50px;object-fit:cover;border-radius:6px"
                                                     onerror="this.src='https://placehold.co/120x50/EAF7F2/2BAB82?text=배너'">
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#999;font-size:12px">이미지 없음</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${banner.title}</strong></td>
                                    <td>${banner.bizName}</td>
                                    <td>
                                        <span class="adm-badge">${banner.positionLabel}</span>
                                    </td>
                                    <td>
                                        ${banner.startDate} ~ ${banner.endDate}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${banner.statusCd eq 'PENDING'}">
                                                <span class="adm-badge warning">대기</span>
                                            </c:when>
                                            <c:when test="${banner.statusCd eq 'ACTIVE'}">
                                                <span class="adm-badge active">노출</span>
                                            </c:when>
                                            <c:when test="${banner.statusCd eq 'REJECTED'}">
                                                <span class="adm-badge danger">반려</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="adm-badge">${banner.statusCd}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${banner.statusCd eq 'PENDING'}">
                                            <button class="adm-btn blue btn-approve"
                                                    data-id="${banner.bannerId}">승인</button>
                                            <button class="adm-btn red btn-reject"
                                                    data-id="${banner.bannerId}">반려</button>
                                        </c:if>
                                        <c:if test="${banner.statusCd eq 'REJECTED' and not empty banner.rejectReason}">
                                            <span style="color:#e74c3c;font-size:12px">사유: ${banner.rejectReason}</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div style="padding:60px 20px;text-align:center;color:#999">
                    신청된 배너가 없습니다.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%-- 반려 사유 모달 --%>
<div id="rejectModal" style="display:none;position:fixed;inset:0;background:rgba(0,0,0,.4);z-index:1000;align-items:center;justify-content:center">
    <div style="background:#fff;border-radius:12px;padding:24px;width:400px;max-width:90vw">
        <h3 style="margin:0 0 16px;font-size:16px">배너 반려</h3>
        <textarea id="rejectReason" rows="3" placeholder="반려 사유를 입력하세요"
                  style="width:100%;border:1px solid #E4E6ED;border-radius:8px;padding:10px;font-size:14px;resize:vertical;box-sizing:border-box"></textarea>
        <div style="display:flex;justify-content:flex-end;gap:8px;margin-top:16px">
            <button id="rejectCancel" class="adm-btn" style="background:#f5f5f5;color:#555">취소</button>
            <button id="rejectConfirm" class="adm-btn red">반려 확인</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/admin/common/footer.jsp" %>

<script>
var currentBannerId = null;

// 승인
document.querySelectorAll('.btn-approve').forEach(function(btn) {
    btn.addEventListener('click', function() {
        var bannerId = this.getAttribute('data-id');

        var xhr = new XMLHttpRequest();
        xhr.open('POST', '${contextPath}/admin/cms/banner/approve');
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onload = function() {
            if (xhr.responseText === 'OK') {
                alert('승인되었습니다.');
                location.reload();
            } else {
                alert('처리 실패: ' + xhr.responseText);
            }
        };
        xhr.send('bannerId=' + bannerId);
    });
});

// 반려 → 모달
document.querySelectorAll('.btn-reject').forEach(function(btn) {
    btn.addEventListener('click', function() {
        currentBannerId = this.getAttribute('data-id');
        document.getElementById('rejectReason').value = '';
        document.getElementById('rejectModal').style.display = 'flex';
    });
});

document.getElementById('rejectCancel').addEventListener('click', function() {
    document.getElementById('rejectModal').style.display = 'none';
    currentBannerId = null;
});

document.getElementById('rejectConfirm').addEventListener('click', function() {
    var reason = document.getElementById('rejectReason').value.trim();
    if (!reason) { alert('반려 사유를 입력하세요.'); return; }

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '${contextPath}/admin/cms/banner/reject');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function() {
        if (xhr.responseText === 'OK') {
            alert('반려되었습니다.');
            location.reload();
        } else {
            alert('처리 실패: ' + xhr.responseText);
        }
    };
    xhr.send('bannerId=' + currentBannerId + '&rejectReason=' + encodeURIComponent(reason));
});
</script>
