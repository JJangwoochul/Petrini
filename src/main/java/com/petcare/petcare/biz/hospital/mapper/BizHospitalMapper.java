/**
 * 역할: 사업자 동물병원 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/biz/hospital/BizHospitalMapper.xml
 * namespace: com.petcare.petcare.biz.hospital.mapper.BizHospitalMapper
 *
 * 쿼리 예시
 * - selectReservationList
 * - updateReservationStatus
 * - selectTreatmentList
 * - selectPatientList
 * - selectMedicalRecords
 *
 * 참고 테이블
 * - TB_RESERVATION
 * - TB_TREATMENT
 * - TB_MEDICAL_RECORD
 * - TB_REVIEW
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.biz.hospital.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.MedicalRecordVO;
import com.petcare.petcare.hospital.vo.ReservationVO;


@Mapper
public interface BizHospitalMapper {
    HospitalVO selectHospitalByBizId(String bizId);

    int insertHospital(String bizId);

    int updateHospitalInfo(HospitalVO vo);

    // 2026-07-10 장우철 — 병원 예약 1차 (F4~F7) 사업자 측 Mapper
    List<ReservationVO> selectReservationList(@Param("hospitalId") Long hospitalId,
                                               @Param("tab") String tab) throws Exception;

    ReservationVO selectReservationDetail(@Param("resvId") Long resvId,
                                          @Param("hospitalId") Long hospitalId) throws Exception;

    int updateReservationStatus(@Param("resvId") Long resvId,
                                @Param("hospitalId") Long hospitalId,
                                @Param("statusCd") String statusCd,
                                @Param("rejectReason") String rejectReason) throws Exception;

    List<ReservationVO> selectReservationCalendarList(@Param("hospitalId") Long hospitalId,
                                                        @Param("fromDate") String fromDate,
                                                        @Param("toDate") String toDate) throws Exception;

    // 2026/07/11 장우철 — 사이드바 배지: PENDING(예약신청) 건수
    int countPendingReservations(@Param("hospitalId") Long hospitalId) throws Exception;

    // 2026/07/11 장우철 — 사이드바 캘린더 배지: 오늘 CONFIRMED 건수
    int countTodayConfirmedReservations(@Param("hospitalId") Long hospitalId) throws Exception;

    // 2026/07/11 장우철 — 알림 문구용 병원명
    String selectHospitalNameById(@Param("hospitalId") Long hospitalId) throws Exception;

    // 2026/07/13 장우철 — 리뷰 알림용 병원 소유 회원번호
    Long selectHospitalMemberNo(@Param("hospitalId") Long hospitalId) throws Exception;

    // 2026/07/13 장우철 — 진료기록 작성용: 확정이면서 기록 없는 예약
    List<ReservationVO> selectConfirmedWithoutRecord(@Param("hospitalId") Long hospitalId) throws Exception;

    // 2026/07/13 장우철 — 진료기록 INSERT
    int insertMedicalRecord(MedicalRecordVO record) throws Exception;

    // 2026/07/13 장우철 — 예약당 진료기록 존재 여부
    int countMedicalRecordByResvId(@Param("resvId") Long resvId) throws Exception;

    // 2026/07/13 장우철 — 진료기록 목록 (검색·기간 필터)
    List<MedicalRecordVO> selectMedicalRecords(@Param("hospitalId") Long hospitalId,
                                               @Param("keyword") String keyword,
                                               @Param("periodMonths") Integer periodMonths) throws Exception;

    // 2026/07/13 장우철 — 진료기록 단건
    MedicalRecordVO selectMedicalRecordDetail(@Param("hospitalId") Long hospitalId,
                                              @Param("recordId") Long recordId) throws Exception;

    // 2026/07/14 장우철 — 사업자 리뷰관리 목록
    List<HospitalReviewVO> selectBizHospitalReviews(@Param("hospitalId") Long hospitalId) throws Exception;

    // 2026/07/14 장우철 — 답글 작성/수정 (해당 병원 리뷰만)
    HospitalReviewVO selectBizHospitalReview(@Param("hospitalId") Long hospitalId,
                                             @Param("reviewId") Long reviewId) throws Exception;

    int updateReviewBizReply(@Param("hospitalId") Long hospitalId,
                             @Param("reviewId") Long reviewId,
                             @Param("bizReply") String bizReply) throws Exception;
}
