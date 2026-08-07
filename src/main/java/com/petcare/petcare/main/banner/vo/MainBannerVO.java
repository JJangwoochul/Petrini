package com.petcare.petcare.main.banner.vo;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import lombok.Getter;
import lombok.Setter;

/**
 * 역할: TB_BANNER 배너 VO
 *
 * 2026-08-06 박유정
 * - HOLD(노출예정) 상태, effectiveStatusLabel, displayScheduleNote 추가
 * - 관리자·사업자 화면 라벨 / 노출 페이지 안내
 */
@Getter @Setter
public class MainBannerVO {
    // TB_BANNER
    private Long bannerId;
    private Long bizNo;
    private String title;
    private String positionCd;
    private Long fileId;
    private String linkUrl;
    // 2026/08/03 장우철 — 로컬 DDL START/END_DATE = DATE (VARCHAR2 아님). INSERT는 Mapper TO_DATE 사용
    private String startDate;
    private String endDate;
    private String statusCd;        // PENDING / HOLD / ACTIVE / REJECTED / EXPIRED — 2026-08-06 박유정 HOLD 추가
    private String rejectReason;    // 반려·대기 사유 공용 — 2026-08-06 박유정
    private java.util.Date regDate;

    // 조인 필드
    private String bizName;         // TB_BUSINESS.BIZ_NAME
    private String bizType;         // TB_BUSINESS.BIZ_TYPE (알림 링크용)
    private String imageUrl;        // TB_FILE.FILE_URL (배너 이미지)

    // 2026-08-06 박유정 — 위치 코드 → 한글 라벨 (STORE=쇼핑)
    public String getPositionLabel() {
        if (positionCd == null) return "";
        switch (positionCd) {
            case "MAIN_HERO": return "메인 히어로";
            case "MAIN_MID":  return "메인 중간";
            case "STORE":     return "쇼핑";
            case "HOSPITAL":  return "병원";
            case "STAY":      return "숙소";
            case "GROOMING":  return "미용";
            default:          return positionCd;
        }
    }

    // 상태 코드 → 한글 라벨 (JSP 표시용)
    public String getStatusLabel() {
        if (statusCd == null) return "";
        switch (statusCd) {
            case "PENDING":  return "심사중";
            case "HOLD":     return "노출예정";
            case "ACTIVE":   return "노출중";
            case "REJECTED": return "반려";
            case "EXPIRED":  return "미노출";
            default:         return statusCd;
        }
    }

    // 2026-08-06 박유정 — ACTIVE 시 기간 기준 실제 노출 라벨 (노출중/노출 예정/미노출)
    public String getEffectiveStatusLabel() {
        if (statusCd == null) return "";
        if (!"ACTIVE".equals(statusCd)) {
            return getStatusLabel();
        }
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        if (endDate != null && endDate.compareTo(today) < 0) {
            return "미노출";
        }
        if (startDate != null && startDate.compareTo(today) > 0) {
            return "노출 예정";
        }
        return "노출중";
    }

    // 2026-08-06 박유정 — 관리자 상세 노출 안내 문구
    public String getDisplayScheduleNote() {
        if (!"ACTIVE".equals(statusCd)) {
            return "";
        }
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        if (startDate != null && startDate.compareTo(today) > 0) {
            return startDate + "부터 " + getDisplayPageLabel() + "에 자동 노출됩니다.";
        }
        if (endDate != null && endDate.compareTo(today) < 0) {
            return "종료일이 지났습니다. 기간을 수정하면 다시 노출할 수 있습니다.";
        }
        return getDisplayPageLabel() + "에 현재 노출 중입니다.";
    }

    // 2026-08-06 박유정 — 노출 위치 → 실제 페이지 경로 안내
    public String getDisplayPageLabel() {
        if (positionCd == null) return "";
        switch (positionCd) {
            case "MAIN_HERO": return "메인 페이지 (/)";
            case "MAIN_MID":  return "메인 페이지 중간";
            case "STORE":     return "쇼핑 목록 (/store)";
            case "HOSPITAL":  return "병원 목록 (/hospital)";
            case "STAY":      return "숙소 목록 (/stay)";
            case "GROOMING":  return "미용 목록 (/grooming)";
            default:          return positionCd;
        }
    }
}
