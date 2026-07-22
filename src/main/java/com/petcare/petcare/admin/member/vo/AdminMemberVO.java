/**
 * 역할: 관리자 회원 목록·상세 데이터 객체
 *
 * - 박유정 / 2026-07-16 (기본정보), 2026-07-20 (STEP 8 활동현황 필드)
 *
 * 참고 테이블
 * - TB_MEMBER
 * - TB_BUSINESS (역할=사업자 판별 JOIN)
 * - TB_ORDER, TB_RESERVATION, TB_POST, TB_POST_REPORT (STEP 8 서브쿼리)
 * - TB_MEMBER_COUPON, TB_FAVORITE, TB_PET (STEP 8 서브쿼리)
 */

package com.petcare.petcare.admin.member.vo;

import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter

public class AdminMemberVO {

    
    // ── TB_MEMBER 컬럼 ──────────────────────────────────────

    private Long memberNo;           // MEMBER_NO — 회원 번호
    private String memberName;       // MEMBER_NAME — 이름
    private String email;            // EMAIL — 이메일
    private String phone;            // PHONE — 전화번호
    private String memberId;         // MEMBER_ID — 로그인 ID (이메일)
    private String zipCode;          // ZIP_CODE — 우편번호
    private String addr1;            // ADDR1 — 주소
    private String addr2;            // ADDR2 — 상세주소
    private String gradeCd;          // GRADE_CD — 등급 (BRONZE/SILVER/GOLD)
    private Integer pointBalance;    // POINT_BALANCE — 보유 포인트
    private String statusCd;         // STATUS_CD — 상태 (NORMAL/정지/탈퇴 코드)
    private LocalDateTime joinDate;  // JOIN_DATE — 가입일
    private LocalDateTime lastLoginDate; // LAST_LOGIN_DATE — 최근 로그인
    private LocalDateTime suspendEndDate; // SUSPEND_END_DATE — 2026-07-21 박유정 STEP ② 기간 정지 종료일 (NULL=영구)

    // ── 조회 전용 (JOIN·서브쿼리) ───────────────────────────
    private String roleType;         // (계산) — GENERAL(일반) / BIZ(사업자)
    
    // ── 관리자 상세 활동 현황 / 2026-07-20 STEP 8 ──
    private Integer orderCount;          // 총 주문 수
    private Long totalPayAmount;       // 총 결제 금액
    private Integer cancelCount;       // 취소/반품 건수
    private Integer hospitalResvCount; // 병원 예약 수
    private Integer postCount;         // 커뮤니티 게시글 수
    private Integer reportCount;       // 신고 받은 횟수 (내 글 기준)
    private Integer usedCouponCount;   // 사용 쿠폰 수
    private Integer favoriteCount;     // 관심 상품 수
    private Integer petCount;          // 등록 반려동물 수
    private String petNames;           // 반려동물 이름 (쉼표 구분)

    // ── 관리자 상세 포인트 요약 / 2026-07-21 STEP 10 ──
    private Integer totalEarnPoint;  // 총 적립 (TB_POINT EARN 합계)
    private Integer totalUsePoint;   // 총 사용 (TB_POINT USE 합계)
    
}
