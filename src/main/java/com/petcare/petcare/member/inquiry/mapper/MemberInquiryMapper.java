/**
 * 역할: TB_INQUIRY MyBatis
 * 2026/07/31 장우철
 */
package com.petcare.petcare.member.inquiry.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.member.inquiry.vo.MemberInquiryVO;

@Mapper
public interface MemberInquiryMapper {

    List<MemberInquiryVO> selectByMemberNo(@Param("memberNo") Long memberNo);

    MemberInquiryVO selectByIdAndMemberNo(@Param("inquiryId") Long inquiryId,
                                          @Param("memberNo") Long memberNo);

    int insertInquiry(MemberInquiryVO vo);

    int countOpenStayRefund(@Param("memberNo") Long memberNo, @Param("resvId") Long resvId);

    // 관리자 — 숙소 환불(1:1) 목록
    List<MemberInquiryVO> selectStayRefundList(@Param("statusCd") String statusCd);

    MemberInquiryVO selectStayRefundDetail(@Param("inquiryId") Long inquiryId);

    int updateInquiryAnswer(@Param("inquiryId") Long inquiryId,
                            @Param("statusCd") String statusCd,
                            @Param("answer") String answer,
                            @Param("adminNo") Long adminNo);
}
