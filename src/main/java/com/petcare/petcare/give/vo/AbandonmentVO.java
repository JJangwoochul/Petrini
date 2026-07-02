package com.petcare.petcare.give.vo;

import org.springframework.stereotype.Component;

import lombok.Getter;
import lombok.Setter;

/*
 * 농림축산식품부 유기동물 공공API 응답 VO
 * API: https://apis.data.go.kr/1543061/abandonmentPublicService_v2/abandonmentPublic_v2
 */

@Component("abandonmentVO")
@Getter @Setter
public class AbandonmentVO {

    private String desertionNo;    // 유기번호 (공고번호)
    private String filename;       // 이미지 URL
    private String happenDt;       // 접수일 (YYYYMMDD)
    private String happenPlace;    // 발견 장소
    private String kindCd;         // 품종 (ex: "[개] 골든 리트리버")
    private String colorCd;        // 색상
    private String age;            // 나이 (ex: "2023(년생)")
    private String weight;         // 체중 (ex: "8.0(Kg)")
    private String noticeNo;       // 공고번호
    private String noticeSdt;      // 공고 시작일
    private String noticeEdt;      // 공고 종료일
    private String popfile1;        // 썸네일 이미지 URL
    private String popfile2;        // 썸네일 이미지 URL
    private String processState;   // 상태 (보호중, 공고중 등)
    private String sexCd;          // 성별 (M:수컷 F:암컷 Q:미상)
    private String neuterYn;       // 중성화 (Y/N/U)
    private String specialMark;    // 특징
    private String careNm;         // 보호소 이름
    private String careTel;        // 보호소 전화번호
    private String careAddr;       // 보호소 주소
    private String orgNm;          // 관할기관 (시도군)
    private String chargeNm;       // 담당자
    private String officetel;      // 담당자 전화
    private int    dday;           // D-day 계산 (컨트롤러에서 세팅)

    /** 성별 한글 변환 */
    public String getSexLabel() {
        if ("M".equals(sexCd)) return "수컷";
        if ("F".equals(sexCd)) return "암컷";
        return "미상";
    }

    /** 중성화 한글 변환 */
    public String getNeuterLabel() {
        if ("Y".equals(neuterYn)) return "완료";
        if ("N".equals(neuterYn)) return "미완료";
        return "미상";
    }

    /** 품종에서 동물 종류만 추출: "[개] 골든 리트리버" → "개" */
    public String getSpecies() {
        if (kindCd == null) return "";
        if (kindCd.contains("[개]"))    return "개";
        if (kindCd.contains("[고양이]")) return "고양이";
        return "기타";
    }

    /** 품종명만 추출: "[개] 골든 리트리버" → "골든 리트리버" */
    public String getBreedName() {
        if (kindCd == null) return "";
        int idx = kindCd.indexOf(']');
        return idx >= 0 ? kindCd.substring(idx + 1).trim() : kindCd;
    }

    /** 공고 종료일 포맷 변환: "20250629" → "2025.06.29" */
    public String getNoticeEdtFormatted() {
        if (noticeEdt == null || noticeEdt.length() < 8) return noticeEdt;
        return noticeEdt.substring(0,4) + "." + noticeEdt.substring(4,6) + "." + noticeEdt.substring(6,8);
    }
}
