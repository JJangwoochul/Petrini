/**
 * 2026/07/11 장우철 — 마이페이지 반려동물 프로필 VO
 *
 * 참고 테이블: TB_PET
 */

package com.petcare.petcare.pet.profile.vo;

import java.time.LocalDate;
import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PetProfileVO {

    private Long petId;
    private Long memberNo;
    private String petName;
    private String species;      // DOG / CAT / ETC
    private String breed;
    private String gender;       // M / F
    private LocalDate birthDate;
    private Integer age;
    private Double weight;
    private String furColor;   // 2026-07-28 박유정 — 털 색상 (TB_PET.FUR_COLOR)
    private String neuterYn;   // 2026-07-28 박유정 — 중성화 Y/N/U (TB_PET.NEUTER_YN)
    private String traits;     // 2026-07-28 박유정 — 성격/특징, 쉼표 구분 (TB_PET.TRAITS)
    private String memo;       // 2026-07-28 박유정 — 메모 (TB_PET.MEMO)
    private String isRepresent;  // Y / N
    private String photoUrl;
    private String delYn;        // 2026/07/11 장우철 — Y=삭제(소프트), N=정상
    private LocalDateTime regDate;

    // 화면용 (dog/cat/etc) — 폼 바인딩, DB 저장 전 DOG/CAT/ETC 로 변환
    private String kind;
}
