/**
 * 2026/07/07 장우철 — join(회원가입)
 *
 * 역할
 * - join.jsp 가입 폼 → Controller(POST /join) → Service 로 넘기는 전용 객체
 * - 로그인용 MemberVO / MemberAuthVO 와 분리 (가입 시에만 쓰는 필드가 많음)
 *
 * 연결 테이블
 * - TB_MEMBER            (회원 기본 정보)
 * - TB_MEMBER_AGREEMENT  (약관 동의 이력)
 * - TB_PET               (Step3 반려동물 — 선택)
 */
package com.petcare.petcare.member.auth.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MemberRegisterVO {

    // ── 2026/07/07 장우철 — TB_MEMBER ──

    private Long memberNo;           // 회원번호 — SEQ_MEMBER, 가입할 때마다 1씩 증가 (TB_MEMBER.MEMBER_NO)
    private String memberName;       // 회원 실명 — join.jsp Step2 (TB_MEMBER.MEMBER_NAME)
    private String email;            // 이메일 — 로그인 ID 와 동일 저장 (TB_MEMBER.MEMBER_ID, EMAIL)
    private String password;         // 비밀번호 평문 — Service 에서 BCrypt 후 TB_MEMBER.MEMBER_PWD 저장
    private String passwordConfirm;  // 비밀번호 확인 — DB 저장 안 함, 일치 검증만
    private String phone;            // 휴대폰 — 010-0000-0000 (TB_MEMBER.PHONE)
    private String zipcode;          // 우편번호 (TB_MEMBER.ZIP_CODE)
    private String addr1;            // 기본 주소 (TB_MEMBER.ADDR1)
    private String addr2;            // 상세 주소 (TB_MEMBER.ADDR2)
    private String birthDate;        // 회원 생년월일 — TB_MEMBER 컬럼 없음, 1차 미저장
    private String gender;           // 회원 성별 — TB_MEMBER 컬럼 없음, 1차 미저장

    // ── 2026/07/07 장우철 — TB_MEMBER_AGREEMENT + MARKETING_YN ──

    private String agreeService;     // 서비스 이용약관 — 필수 (TERMS_TYPE=SERVICE)
    private String agreePrivacy;     // 개인정보 동의 — 필수 (TERMS_TYPE=PRIVACY)
    private String agreeLocation;    // 위치기반 서비스 — 선택 (TERMS_TYPE=LOCATION)
    private String agreeMarketing;   // 마케팅 수신 — 선택, Y 이면 TB_MEMBER.MARKETING_YN 도 Y

    // ── 2026/07/07 장우철 — TB_PET (Step3 선택) ──

    private String petType;          // 반려동물 종 — dog/cat/etc → DOG/CAT/ETC (TB_PET.SPECIES)
    private String petName;          // 반려동물 이름 — 비어 있으면 펫 등록 안 함 (TB_PET.PET_NAME)
    private String petBreed;         // 품종 (TB_PET.BREED)
    private Integer petAge;          // 나이(세) (TB_PET.AGE)
    private Double petWeight;        // 몸무게 kg (TB_PET.WEIGHT)
    private Long petId;              // 반려동물 ID — SEQ_PET 전역 증가 (TB_PET.PET_ID)
}
