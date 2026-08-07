/**
 * 역할: 숙소 전액 환불 취소 DB (사업자·관리자 공통)
 * 2026/07/31 장우철
 */
package com.petcare.petcare.stay.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.stay.vo.ReservationVO;

@Mapper
public interface StayCancelMapper {

    ReservationVO selectStayReservation(@Param("resvId") Long resvId,
                                        @Param("stayId") Long stayId);

    Map<String, Object> selectDonePaymentByResvId(@Param("resvId") Long resvId);

    int updatePaymentRefundByResvId(@Param("resvId") Long resvId,
                                    @Param("refundAmt") Long refundAmt);

    int updateStayFullCancel(@Param("resvId") Long resvId,
                             @Param("stayId") Long stayId,
                             @Param("rejectReason") String rejectReason,
                             @Param("cancelFeeAmt") Long cancelFeeAmt,
                             @Param("refundAmt") Long refundAmt,
                             @Param("allowDone") Boolean allowDone);

    // 2026/08/06 장우철 — 환불승인·보상숙박: 예약 상태 유지, 환불금액만 기록
    int updateStayRefundAmtKeepStatus(@Param("resvId") Long resvId,
                                      @Param("refundAmt") Long refundAmt);
}
