/**
 * 역할: 동물병원·예약 데이터 객체
 *
 * 필드 예시
 * - hospitalId, hospitalName, address, phone, rating
 *
 * 참고 테이블
 * - TB_HOSPITAL
 * - TB_RESERVATION
 *
 * DB 컬럼명은 팀 VO 규칙(camelCase)에 맞게 작성
 */

package com.petcare.petcare.hospital.vo;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class HospitalVO {
    private Long   hospitalId;     // HOSPITAL_ID
    private Long   bizNo;          // BIZ_NO
    private Long   memberNo;       // MEMBER_NO
    private String hospitalName;   // HOSPITAL_NAME
    private String phone;          // PHONE
    private String addr;           // ADDR
    private Double lat;            // LAT
    private Double lng;            // LNG
    private Double avgRating;      // AVG_RATING
    private Long   reviewCnt;      // REVIEW_CNT
    private String statusCd;       // STATUS_CD (PENDING/ACTIVE/INACTIVE)
    private Date   approveDate;    // APPROVE_DATE
    private String hoursJson;      // HOURS_JSON
    private String deptList;       // DEPT_LIST    
    private String thumbPath;        
}
