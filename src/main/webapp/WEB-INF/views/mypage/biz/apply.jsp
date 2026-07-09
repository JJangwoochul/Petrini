<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="pageId" value="mypage" />
<c:set var="sec" value="biz/apply" />

<style>
    /* 힌트·에러 텍스트 */
    .field-hint  { font-size: 12px; color: var(--text-muted); margin-top: 5px; margin-left: 5px;}
    .field-ok    { font-size: 12px; color: var(--primary); margin-top: 5px; margin-left: 5px; display: none; }
    .field-error { font-size: 12px; color: #EF4444; margin-top: 5px; margin-left: 5px; display: none; }
    .field-ok.show    { display: block; }
    .field-error.show { display: block; }
</style>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css">

<div class="mypage-wrap">
    <%@ include file="/WEB-INF/views/mypage/sidebar.jsp" %>

        <div class="mypage-content">
        <%-- 2026-07-09 장우철 — 재신청 모드 안내 / 오류 메시지 --%>
        <c:if test="${reapply}">
            <div style="background:#FEF2F2;border:1px solid #FECACA;color:#991B1B;padding:14px 18px;border-radius:8px;margin-bottom:16px;font-size:14px;line-height:1.6">
                <strong>재신청</strong> — 아래 내용을 보완하여 다시 제출해 주세요.
                <c:if test="${not empty rejectReason}">
                    <br><span style="color:#7F1D1D;margin-top:6px;display:inline-block">반려 사유: ${rejectReason}</span>
                </c:if>
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:8px;margin-bottom:16px;font-size:14px">${errorMsg}</div>
        </c:if>
        <%-- ── 사업자 등록 신청 ── --%>
        <div class="mp-section active">
            <h2 class="mp-title">사업자 등록 신청</h2>
            <p class="mp-desc">PetCare 파트너가 되어 더 많은 반려인에게 서비스를 알리세요.</p>
            <div class="biz-hero">
                <img class="biz-hero-img"
                    src="https://images.unsplash.com/photo-1601758124510-52d02ddb7cbd?w=900&q=80&auto=format&fit=crop"
                    alt="사업자 배너"
                    onerror="this.src='https://placehold.co/900x180/1F8464/ffffff?text=PetCare+Partner'">
                <div class="biz-hero-text">
                    <h3>PetCare 파트너 신청</h3>
                    <p>수의사·펫샵·숙소·미용실 등 모든 반려동물 사업자 환영합니다</p>
                </div>
            </div>
            <div class="biz-benefit-grid">
                <div class="biz-benefit-card">
                    <img class="biz-benefit-img"
                        src="https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b?w=400&q=70&auto=format&fit=crop"
                        alt="고객노출"
                        onerror="this.src='https://placehold.co/400x120/EAF7F2/2BAB82?text=노출'">
                    <div class="biz-benefit-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/>
                        </svg>
                    </div>
                    <strong>더 많은 고객 노출</strong>
                    <span>수십만 반려인에게 내 업체를 알리세요.</span>
                </div>
                <div class="biz-benefit-card">
                    <img class="biz-benefit-img"
                         src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400&q=70&auto=format&fit=crop"
                         alt="예약관리"
                         onerror="this.src='https://placehold.co/400x120/EAF7F2/2BAB82?text=예약관리'">
                    <div class="biz-benefit-icon">
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                    </div>
                    <strong>예약 통합 관리</strong>
                    <span>실시간 예약 현황을 한눈에 확인하세요.</span>
                </div>
                <div class="biz-benefit-card">
                    <img class="biz-benefit-img"
                         src="https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=400&q=70&auto=format&fit=crop"
                         alt="정산"
                         onerror="this.src='https://placehold.co/400x120/EAF7F2/2BAB82?text=정산'">
                    <div class="biz-benefit-icon">
                        <svg viewBox="0 0 24 24">
                            <line x1="12" y1="1" x2="12" y2="23"/>
                            <path d="M17 5H9.5a3.5 3.5 0 000 7h5a3.5 3.5 0 010 7H6"/>
                        </svg>
                    </div>
                    <strong>투명한 정산</strong>
                    <span>매출·수수료·지급일을 명확하게 확인하세요.</span>
                </div>
            </div>
            <div class="biz-steps">
                <div class="biz-step done">
                    <div class="biz-step-num">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <span class="biz-step-label">로그인</span>
                </div>
                <div class="biz-step active">
                    <div class="biz-step-num">2</div>
                    <span class="biz-step-label">신청서 작성</span>
                </div>
                <div class="biz-step">
                    <div class="biz-step-num">3</div>
                    <span class="biz-step-label">서류 제출</span>
                </div>
                <div class="biz-step">
                    <div class="biz-step-num">4</div>
                    <span class="biz-step-label">관리자 심사</span>
                </div>
                <div class="biz-step">
                    <div class="biz-step-num">5</div>
                    <span class="biz-step-label">승인 완료</span>
                </div>
            </div>

            <form name="bizApplyForm" method="post" action="${contextPath}/mypage/biz/apply" enctype="multipart/form-data">
                <div class="biz-form-section">
                    <div class="biz-form-title">
                        <svg viewBox="0 0 24 24">
                            <rect x="2" y="7" width="20" height="14" rx="2"/>
                            <path d="M16 7V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v2"/>
                        </svg>사업자 기본 정보
                    </div>
                    <div class="biz-grid">
                        <div class="biz-group">
                            <label>업체명 <span class="req">*</span></label>
                            <input type="text" name="bizName" placeholder="예) 행복 펫 병원" value="행복펫병원">
                        </div>
                        <div class="biz-group">
                            <label>업종 <span class="req">*</span></label>
                            <select name="bizType">
                                <option value="">업종을 선택하세요</option>
                                <option value="HOSPITAL" selected>동물병원</option>
                                <option value="GROOMING">반려동물 미용</option>
                                <option value="STAY">펫 호텔·유치원</option>
                                <option value="STORE">반려동물 용품점</option>
                                <option value="STUDIO">스튜디오</option>
                            </select>
                        </div>
                        <div class="biz-group full">
                            <label>사업자 등록번호 <span class="req">*</span></label>
                            <div class="biz-input-row">
                                <input type="text" name="bizRegNo" placeholder="000-00-00000" maxlength="12" value="012-34-56789">
                                <button class="btn-verify" id="btnCheckBizNo" type="button">국세청 인증</button>
                            </div>
                            <p style="font-size: 12px; color: var(--text-muted); margin-top: 5px; margin-left: 5px;" id="checkResult"></p>
                        </div>
                        <div class="biz-group">
                            <label>대표자명 <span class="req">*</span></label>
                            <input type="text" name="ceoName" placeholder="홍길동" value="홍길동">
                        </div>
                        <div class="biz-group">
                            <label>사업장 전화번호 <span class="req">*</span></label>
                            <input type="tel" name="phone" placeholder="02-0000-0000" value="02-123-4567">
                        </div>
                        <div class="biz-group full">
                            <label>사업장 주소 <span class="req">*</span></label>
                            <div class="biz-input-row">
                                <input type="text" name="bizZipcode" placeholder="우편번호" style="max-width:120px">
                                <button class="btn-verify" id="btnAddr" type="button">주소 검색</button>
                            </div>
                            <input type="text" name="bizAddr1" placeholder="기본 주소" style="margin-top:8px" value="판교역로 166">
                            <input type="text" name="bizAddr2" placeholder="상세 주소" style="margin-top:8px">
                        </div>
                    </div>
                </div>
                <div class="biz-form-section">
                    <div class="biz-form-title">
                        <svg viewBox="0 0 24 24">
                            <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="12" y1="18" x2="12" y2="12"/>
                            <line x1="9" y1="15" x2="15" y2="15"/>
                        </svg>서류 업로드
                    </div>
                    <div class="biz-grid">
                        <div class="biz-group">
                            <label>사업자등록증 <span class="req">*</span></label>
                            <div class="biz-upload-box">
                                <svg viewBox="0 0 24 24">
                                    <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
                                    <polyline points="17 8 12 3 7 8"/>
                                    <line x1="12" y1="3" x2="12" y2="15"/>
                                </svg>
                                <p>클릭하여 업로드</p>
                                <small>JPG, PNG, PDF · 최대 10MB</small>
                                <input type="file" id="docFile" name="docFile" accept=".jpg,.jpeg,.png,.pdf"
                                    style="display:none" onchange="document.getElementById('docFileName').textContent = this.files[0].name">
                            </div>
                        </div>
                        <div class="biz-group">
                            <label>영업신고증 <small style="color:var(--text-muted);font-weight:400">(해당 시)</small></label>
                            <div class="biz-upload-box">
                                <svg viewBox="0 0 24 24">
                                    <path d="M21 15v4a2 2 0 01-2 2H5a2 2 0 01-2-2v-4"/>
                                    <polyline points="17 8 12 3 7 8"/>
                                    <line x1="12" y1="3" x2="12" y2="15"/>
                                </svg>
                                <p>클릭하여 업로드</p>
                                <small>JPG, PNG, PDF · 최대 10MB</small>
                                <input type="file" id="licenseFile" name="licenseFile" accept=".jpg,.jpeg,.png,.pdf"
                                    style="display:none" onchange="document.getElementById('licenseFileName').textContent = this.files[0].name">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="biz-form-section">
                    <div class="biz-form-title">
                        <svg viewBox="0 0 24 24">
                            <path d="M9 11l3 3L22 4"/>
                            <path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>
                        </svg>약관 동의
                    </div>
                    <div class="biz-agree-list">
                        <label class="biz-agree-item"><input type="checkbox" id="agreeAll"><span>[전체 동의] 아래 약관에 모두 동의합니다.</span></label>
                        <label class="biz-agree-item"><input type="checkbox" name="agreeRequired" value="terms"><span>[필수] <a href="#">PetCare 파트너 서비스 이용약관</a></span></label>
                        <label class="biz-agree-item"><input type="checkbox" name="agreeRequired" value="privacy"><span>[필수] <a href="#">개인정보 수집·이용 동의</a></span></label>
                        <label class="biz-agree-item"><input type="checkbox" id="agreeMarketing" value="terms"><span>[선택] 마케팅 정보 수신 동의</span></label>
                    </div>
                </div>
                <div class="biz-submit-area">
                    <button class="biz-submit-btn" id="btnApply" type="button">사업자 등록 신청하기</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    let bizVerified = false;
    $("#btnCheckBizNo").click(function() {
        let bizRegNo = $("[name='bizRegNo']").val().replace(/-/g,"");
        if(bizRegNo.length != 10){
            alert("사업자등록번호를 입력하세요.");
            return;
        }

        //테스트시 주석
        // $.ajax({
        //     url : "/mypage/biz/checkBizNo",
        //     type : "POST",
        //     data : {
        //         bizRegNo : bizRegNo
        //     },
        //     success : function(res){
        //         if(res.success){
        //             bizVerified = true;
        //             $("#checkResult")
        //                 .css("color","blue")
        //                 .text("사업자 인증 완료");
        //         }
        //         else{
        //             bizVerified = false;
        //             $("#checkResult")
        //                 .css("color","red")
        //                 .text(res.message);
        //         }
        //     },
        //     error : function(){
        //         alert("서버 오류");
        //     }
        // });
        $("#checkResult").css("color","blue").text("사업자 인증 완료");
        bizVerified = true;
    });

    $(".biz-upload-box").click(function(e){
        if (e.target.tagName !== 'INPUT') {
            $(this).find("input[type='file']").click();
        }
    });

    // 전체동의 클릭
    $("#agreeAll").change(function () {
        let checked = $(this).prop("checked");
        $(".biz-agree-list input[type='checkbox']").prop("checked", checked);
    });

    // 개별 체크 시 전체동의 자동 변경
    $(".biz-agree-list input[type='checkbox']").not("#agreeAll").change(function(){
        let total = $(".biz-agree-list input[type='checkbox']").not("#agreeAll").length;
        let checked = $(".biz-agree-list input[type='checkbox']:checked").not("#agreeAll").length;
        $("#agreeAll").prop("checked", total == checked);
    });

    $("#btnApply").click(function(){
        // 업체명
        if (!$("input[name='bizName']").val().trim()) {
            alert("업체명을 입력하세요.");
            $("input[name='bizName']").focus();
            return;
        }
    
        // 업종
        if (!$("select[name='bizType']").val()) {
            alert("업종을 선택하세요.");
            $("select[name='bizType']").focus();
            return;
        }

        if(!bizVerified){
            alert("국세청 인증을 먼저 진행해주세요.");
            return;
        }

        // 주소
        if (!$("input[name='bizZipcode']").val().trim()) {
            alert("주소를 입력하세요.");
            $("input[name='bizName']").focus();
            return;
        }

        if ($("input[name='docFile']")[0].files.length == 0) {
            alert("사업자등록증을 첨부해주세요.");
            return;
        }

        // 필수 체크 여부 확인
        let requiredCnt = $("input[name='agreeRequired']").length;
        let checkedCnt = $("input[name='agreeRequired']:checked").length;
        if (requiredCnt != checkedCnt) {
            alert("필수 약관에 모두 동의해주세요.");
            return;
        }
        
        document.forms["bizApplyForm"].submit();
    });

    //daum 주소
    $("#btnAddr").click(function(){
        new daum.Postcode({
            oncomplete:function(data){
                let addr = "";
                let extraAddr = "";
                if(data.userSelectedType === 'R'){
                    addr = data.roadAddress;
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr ? ", " : "") + data.buildingName;
                    }
                    if(extraAddr !== ''){
                        extraAddr = " (" + extraAddr + ")";
                    }

                }
                else{
                    addr = data.jibunAddress;
                }

                $("input[name='bizZipcode']").val(data.zonecode);
                $("input[name='bizAddr1']").val(addr + extraAddr);
                $("input[name='bizAddr2']").focus();
            }
        }).open();
    });
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
