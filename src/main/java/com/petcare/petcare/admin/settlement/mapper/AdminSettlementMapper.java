/**
 * 역할: 관리자 정산 DB 접근 (MyBatis) — 사업자 StaySettlementMapper 와 분리
 * 2026/07/30 장우철 — 숙소 정산 구현순서 3-1 ~ 3-5 / 4-3
 *
 * XML: resources/mybatis/mapper/admin/settlement/AdminSettlementMapper.xml
 */
package com.petcare.petcare.admin.settlement.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.admin.settlement.vo.AdminStayRequestVO;
import com.petcare.petcare.admin.settlement.vo.AdminStaySettlementVO;
import com.petcare.petcare.settlement.vo.StaySettlementItemVO;

@Mapper
public interface AdminSettlementMapper {

    int ping();

    int countStaySettlements(@Param("bizNo") Long bizNo);

    List<AdminStaySettlementVO> selectStaySettlementList(@Param("statusCd") String statusCd);

    List<StaySettlementItemVO> selectStaySettlementItems(@Param("settleId") Long settleId);

    /** 지급 알림용 단건 */
    AdminStaySettlementVO selectStaySettlementById(@Param("settleId") Long settleId);

    int updateStaySettlementPaid(@Param("settleId") Long settleId);

    int updateStaySettlementPaidBatch(@Param("settleIds") List<Long> settleIds);

    /** 4-3 중간정산 요청 대기 건수 (사이드바 배지) */
    int countStayRequestsRequested();

    /**
     * 중간정산 요청 목록
     * @param statusCd requested|approved|rejected|all(null)
     */
    List<AdminStayRequestVO> selectStayRequestList(@Param("statusCd") String statusCd);
}
