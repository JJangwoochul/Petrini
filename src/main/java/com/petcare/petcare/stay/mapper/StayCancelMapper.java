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
}
