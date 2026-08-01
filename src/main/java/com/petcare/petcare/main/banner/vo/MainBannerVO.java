package com.petcare.petcare.main.banner.vo;

import lombok.Getter;
import lombok.Setter;
import java.util.Date;

@Getter @Setter
public class MainBannerVO {
    // TB_BANNER
    private Long bannerId;
    private Long bizNo;
    private String title;
    private String positionCd;
    private Long fileId;
    private String linkUrl;
    // 2026/08/01 장우철 — DDL START_DATE/END_DATE = VARCHAR2(YYYY-MM-DD)
    private String startDate;
    private String endDate;
    private String statusCd;        // PENDING / ACTIVE / REJECTED / EXPIRED
    private String rejectReason;
    private Date   regDate;

    // 조인 필드
    private String bizName;         // TB_BUSINESS.BIZ_NAME
    private String imageUrl;        // TB_FILE.FILE_URL (배너 이미지)

    // 위치 코드 → 한글 라벨 (JSP 표시용)
    public String getPositionLabel() {
        if (positionCd == null) return "";
        switch (positionCd) {
            case "MAIN_HERO": return "메인 히어로";
            case "MAIN_MID":  return "메인 중간";
            case "STORE":     return "쇼핑몰";
            case "HOSPITAL":  return "병원";
            case "STAY":      return "숙소";
            case "GROOMING":  return "미용";
            default:          return positionCd;
        }
    }
}
