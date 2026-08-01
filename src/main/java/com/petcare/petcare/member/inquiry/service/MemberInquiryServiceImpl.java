/**
 * 역할: 1:1 문의 Service
 * 2026/07/31 장우철 — TB_INQUIRY 연동 + 숙소 환불신청
 */
package com.petcare.petcare.member.inquiry.service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.member.inquiry.mapper.MemberInquiryMapper;
import com.petcare.petcare.member.inquiry.vo.MemberInquiryVO;
import com.petcare.petcare.member.vo.InquiryVO;
import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.mypage.reserve.mapper.MypageReserveMapper;
import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;

@Service
public class MemberInquiryServiceImpl implements MemberInquiryService {

    @Autowired
    private MemberInquiryMapper memberInquiryMapper;
    @Autowired
    private MypageReserveMapper mypageReserveMapper;

    @Override
    @Transactional(readOnly = true)
    public List<InquiryVO> getListForMember(String memberId) {
        // memberId 문자열 대신 컨트롤러에서 memberNo 쓰도록 오버로드 추가 예정 — 호환용 빈 목록
        return List.of();
    }

    @Transactional(readOnly = true)
    public List<InquiryVO> getListForMemberNo(Long memberNo) {
        if (memberNo == null) {
            return List.of();
        }
        List<MemberInquiryVO> rows = memberInquiryMapper.selectByMemberNo(memberNo);
        List<InquiryVO> list = new ArrayList<>();
        for (MemberInquiryVO row : rows) {
            list.add(toInquiryVO(row));
        }
        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<InquiryVO> findForMember(String memberId, long id) {
        return Optional.empty();
    }

    @Transactional(readOnly = true)
    public Optional<InquiryVO> findForMemberNo(Long memberNo, long id) {
        if (memberNo == null) {
            return Optional.empty();
        }
        MemberInquiryVO row = memberInquiryMapper.selectByIdAndMemberNo(id, memberNo);
        return row == null ? Optional.empty() : Optional.of(toInquiryVO(row));
    }

    @Override
    @Transactional
    public InquiryVO create(MemberVO member, String category, String title, String content) {
        return create(member, category, title, content, null, null);
    }

    @Transactional
    public InquiryVO create(MemberVO member, String category, String title, String content,
                            String refType, Long refId) {
        if (member == null || member.getMemberNo() == null) {
            return null;
        }
        MemberInquiryVO vo = new MemberInquiryVO();
        vo.setInquiryType(mapCategoryToType(category));
        vo.setMemberNo(member.getMemberNo());
        vo.setTitle(title.trim());
        vo.setBody(content.trim());
        vo.setRefType(refType);
        vo.setRefId(refId);
        vo.setStatusCd("WAIT");
        memberInquiryMapper.insertInquiry(vo);
        return toInquiryVO(vo);
    }

    /**
     * 숙소 체크인 상태 환불신청 → 1:1 문의 INSERT
     * 2026/08/01 장우철 — 체크아웃 이후 환불 신청 불가 (CHECKIN만)
     */
    @Transactional
    public InquiryVO createStayRefundInquiry(MemberVO member, Long resvId, String content) {
        if (member == null || member.getMemberNo() == null || resvId == null) {
            throw new IllegalArgumentException("환불 신청 정보가 올바르지 않습니다.");
        }
        MypageReserveVO detail = mypageReserveMapper.selectMyReservationDetail(member.getMemberNo(), resvId);
        if (detail == null || !"STAY".equalsIgnoreCase(detail.getResvType())) {
            throw new IllegalStateException("숙소 예약을 찾을 수 없습니다.");
        }
        String st = detail.getStatusCd() != null ? detail.getStatusCd().toUpperCase() : "";
        if (!"CHECKIN".equals(st)) {
            throw new IllegalStateException("체크인 상태에서만 환불 신청할 수 있습니다.");
        }
        if (memberInquiryMapper.countOpenStayRefund(member.getMemberNo(), resvId) > 0) {
            throw new IllegalStateException("이미 처리 중인 환불 신청이 있습니다.");
        }
        String body = (content == null || content.isBlank())
                ? "숙소 이용 중 환불을 신청합니다."
                : content.trim();
        String title = "숙소 환불신청 #" + (detail.getResvNo() != null ? detail.getResvNo() : resvId);
        return create(member, "예약", title, body, "RESV", resvId);
    }

    private String mapCategoryToType(String category) {
        if (category == null) {
            return "ETC";
        }
        String c = category.trim();
        if (c.contains("예약") || c.contains("환불")) {
            return "RESERVE";
        }
        if (c.contains("주문") || c.contains("배송")) {
            return "ORDER";
        }
        if (c.contains("수의사") || c.contains("진료")) {
            return "VET";
        }
        if (c.contains("제휴")) {
            return "PARTNER";
        }
        return "ETC";
    }

    private InquiryVO toInquiryVO(MemberInquiryVO row) {
        InquiryVO vo = new InquiryVO();
        vo.setId(row.getInquiryId() != null ? row.getInquiryId() : 0L);
        vo.setMemberId(row.getMemberNo() != null ? String.valueOf(row.getMemberNo()) : null);
        vo.setCategory(row.getInquiryType());
        vo.setTitle(row.getTitle());
        vo.setContent(row.getBody());
        if ("WAIT".equalsIgnoreCase(row.getStatusCd())) {
            vo.setStatus("WAIT");
        } else {
            vo.setStatus("ANSWERED");
        }
        vo.setAnswer(row.getAnswer());
        vo.setCreatedAt(toLocalDateTime(row.getRegDate() != null ? row.getRegDate() : row.getApplyDate()));
        vo.setAnsweredAt(toLocalDateTime(row.getAnswerDate()));
        return vo;
    }

    private LocalDateTime toLocalDateTime(Date date) {
        if (date == null) {
            return null;
        }
        if (date instanceof java.sql.Timestamp) {
            return ((java.sql.Timestamp) date).toLocalDateTime();
        }
        if (date instanceof java.sql.Date) {
            return ((java.sql.Date) date).toLocalDate().atStartOfDay();
        }
        return date.toInstant().atZone(ZoneId.of("Asia/Seoul")).toLocalDateTime();
    }
}
