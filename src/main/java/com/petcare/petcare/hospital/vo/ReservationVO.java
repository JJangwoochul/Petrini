/**
 * 역할: 병원 예약 데이터 객체 (TB_RESERVATION + 조회용 JOIN 필드)
 *
 * 참고 테이블: TB_RESERVATION, TB_MEMBER, TB_PET, TB_HOSPITAL
 */

package com.petcare.petcare.hospital.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReservationVO {

    // 2026-07-10 장우철 — TB_RESERVATION 컬럼 (DATABASE_TABLE.sql 기준)
    private Long    resvId;
    private String  resvNo;
    private String  resvType;       // HOSPITAL / STAY / GROOMING / STUDIO
    private Long    memberNo;
    private Long    petId;
    private String  targetId;       // 병원 예약 시 HOSPITAL_ID (VARCHAR2)
    private Long    roomId;
    private String  serviceName;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private Date    resvDate;
    private String  resvTime;
    private Date    checkinDate;
    private Date    checkoutDate;
    private Integer nightCnt;
    private String  symptoms;
    private String  requestMemo;
    private Long    totalAmount;
    private String  statusCd;       // PENDING / CONFIRMED / DONE / CANCEL / REJECTED
    private String  rejectReason;
    private Date    regDate;

    // 2026-07-10 장우철 — 목록·상세·완료 화면 JOIN 표시용
    private String  memberName;
    private String  petName;
    private String  petSpecies;
    private String  petBreed;
    private Integer petAge;
    private String  hospitalName;
}
