/**
 * 역할: 사업자 펫호텔 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/biz/stay/BizStayMapper.xml
 * namespace: com.petcare.petcare.biz.stay.mapper.BizStayMapper
 *
 * 쿼리 예시
 * - selectReservationList
 * - updateReservationStatus
 * - selectRoomList
 * - insertRoom
 * - updateRoom
 *
 * 참고 테이블
 * - TB_STAY_ROOM
 * - TB_RESERVATION
 * - TB_REVIEW
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.biz.stay.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.stay.vo.StayVO;


@Mapper
public interface BizStayMapper {
    StayVO selectStayByBizId(String bizId);

    int insertStay(String bizId);

    int updateStayInfo(StayVO vo);

    // 2026-07-10 장우철 — 병원 예약 1차 (F4~F7) 사업자 측 Mapper
    List<ReservationVO> selectReservationList(@Param("stayId") Long stayId,
                                               @Param("tab") String tab) throws Exception;

    ReservationVO selectReservationDetail(@Param("resvId") Long resvId,
                                          @Param("hospitalId") Long hospitalId) throws Exception;

    int updateReservationStatus(@Param("resvId") Long resvId,
                                @Param("stayId") Long stayId,
                                @Param("statusCd") String statusCd,
                                @Param("rejectReason") String rejectReason) throws Exception;

    List<ReservationVO> selectReservationCalendarList(@Param("stayId") Long stayId,
                                                        @Param("fromDate") String fromDate,
                                                        @Param("toDate") String toDate) throws Exception;

    int countPendingReservations(@Param("stayId") Long stayId) throws Exception;

    int countTodayConfirmedReservations(@Param("stayId") Long stayId) throws Exception;

    String selectStayNameById(@Param("stayId") Long stayId) throws Exception;

    void updateStayProfile(StayVO vo);     
}
