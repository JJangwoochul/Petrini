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
}
