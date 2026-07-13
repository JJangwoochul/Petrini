/**
 * 역할: 마이페이지 예약 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/mypage/reserve/MypageReserveMapper.xml
 */

package com.petcare.petcare.mypage.reserve.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;

@Mapper
public interface MypageReserveMapper {

    // 2026/07/11 장우철 — 회원 예약 목록 (병원 중심, 2차)
    List<MypageReserveVO> selectMyReservationList(@Param("memberNo") Long memberNo,
                                                    @Param("statusFilter") String statusFilter);

    // 2026/07/11 장우철 — 회원 예약 상세 (본인 건만)
    MypageReserveVO selectMyReservationDetail(@Param("memberNo") Long memberNo,
                                              @Param("resvId") Long resvId);
}
