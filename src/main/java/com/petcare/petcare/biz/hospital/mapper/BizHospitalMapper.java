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

import com.petcare.petcare.hospital.vo.HospitalVO;
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
}
