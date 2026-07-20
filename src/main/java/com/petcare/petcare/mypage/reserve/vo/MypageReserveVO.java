/**
 * 역할: 마이페이지 예약 데이터 객체
 *
 * 참고 테이블: TB_RESERVATION, TB_HOSPITAL, TB_PET
 */

package com.petcare.petcare.mypage.reserve.vo;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MypageReserveVO {

    private Long resvId;
    private String resvNo;
    private String resvType;      // HOSPITAL / STAY ...
    private Long memberNo;
    private Long petId;
    private String targetId;
    private Date resvDate;
    private String resvTime;
    private String symptoms;
    private String requestMemo;
    private String statusCd;
    private String rejectReason;  // 취소 사유 (TB_RESERVATION.REJECT_REASON)
    private Date regDate;

    private String petName;
    private String petSpecies;
    private String petBreed;
    private String hospitalName;
    private String hospitalAddr;

    // 2026/07/20 장우철 — 병원 예약 고도화 표시용
    private Long    doctorId;
    private Long    treatTypeId;
    private Integer durationMin;
    private String  endTime;
    private String  doctorName;
    private String  treatTypeName;

    // 2026/07/13 장우철 — DONE 예약 리뷰 작성 여부 (Y/N)
    private String reviewedYn;

    // 숙소 예약용
    private Date   checkinDate;
    private Date   checkoutDate;
    private Integer nightCnt;
    private Long   totalAmount;
    private String stayName;
    private String stayAddr;
    private Long   roomId;
    private String roomName;
}
