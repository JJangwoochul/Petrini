/**
 * 역할: 관리자 회원 목록·상세 데이터 객체
 *
 * - 박유정 / 2026-07-16
 *
 * 참고 테이블
 * - TB_MEMBER
 * - TB_BUSINESS (역할=사업자 판별 JOIN)
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

    // ── 조회 전용 (JOIN·서브쿼리) ───────────────────────────
    private String roleType;         // (계산) — GENERAL(일반) / BIZ(사업자)
}
