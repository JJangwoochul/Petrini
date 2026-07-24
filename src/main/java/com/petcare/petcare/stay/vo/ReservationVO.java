package com.petcare.petcare.stay.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReservationVO {
    private Long    resvId;
    private String  resvNo;
    private String  resvType;       // HOSPITAL / STAY / GROOMING / STUDIO
    private Long    memberNo;
    private Long    petId;
    private String  targetId;
    private Long    roomId;
    private String  serviceName;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date    resvDate;
    private String  resvTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date    checkinDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date    checkoutDate;
    private Integer nightCnt;
    private String  symptoms;
    private String  requestMemo;
    private Long    totalAmount;
    private String  statusCd;       // PENDING / CONFIRMED / DONE / CANCEL / REJECTED
    private String  rejectReason;
    private Date    regDate;

    private String  memberName;
    private String  petName;
    private String  petSpecies;
    private String  petBreed;
    private Integer petAge;

    private String  stayName;
    private String  stayAddr;
    private String  roomName;    
}
