package com.petcare.petcare.member.vo;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Component;

@Getter @Setter
@Component("memberVO")
public class MemberVO {

    private String memberId;        // PK
    private String email;           // 로그인 ID (unique)
    private String password;        // BCrypt 암호화
    private String memberName;      // 이름
    private String phone;           // 전화번호
    private String zipcode;         // 우편번호
    private String addr1;           // 기본 주소
    private String addr2;           // 상세 주소
    private LocalDate birthDate; // 생년월일
    private String gender;          // M / F / null
    private String role;            // ROLE_USER / ROLE_BUSINESS / ROLE_ADMIN
    private String bizType;         // HOSPITAL / STAY / RESTAURANT / GROOMING / STORE / STUDIO
    private String status;          // ACTIVE / INACTIVE / BANNED

    // 약관 동의 (요구사항: 서비스(필수)·개인정보(필수)·마케팅(선택))
    private String agreeService;    // Y/N
    private String agreePrivacy;    // Y/N
    private String agreeLocation;   // Y/N (선택)
    private String agreeMarketing;  // Y/N (선택)

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
