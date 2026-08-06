/**
 * 역할: 마이페이지 회원정보 데이터 객체
 *
 * - 2026-07-28 박유정 — 회원정보 수정 화면 DB 조회용
 *
 * 참고 테이블
 * - TB_MEMBER
 */

package com.petcare.petcare.mypage.account.vo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MypageAccountVO {

    private Long memberNo;      // MEMBER_NO — 회원번호
    private String memberId;    // MEMBER_ID — 아이디
    private String memberName;  // MEMBER_NAME — 이름
    private String nickname;    // NICKNAME — 닉네임
    private String email;       // EMAIL — 이메일
    private String phone;       // PHONE — 전화번호
    private String zipcode;     // ZIP_CODE — 우편번호
    private String addr1;       // ADDR1 — 기본 주소
    private String addr2;       // ADDR2 — 상세 주소
    private String birthDate;   // 2026-07-28 박유정 — TB_MEMBER.BIRTH_DATE
    private String gender;      // 2026-07-28 박유정 — TB_MEMBER.GENDER (M/F)
}
