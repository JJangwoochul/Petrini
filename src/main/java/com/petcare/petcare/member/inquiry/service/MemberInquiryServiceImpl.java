/**
 * 역할: MemberInquiryService 구현체 (@Service)
 *
 * 구현 내용
 * - 1:1 문의 목록·상세 조회
 * - 문의 등록 처리
 *
 * 연결
 * - implements: MemberInquiryService
 * - 사용: MemberInquiryMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.member.inquiry.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.petcare.petcare.member.vo.InquiryVO;
import com.petcare.petcare.member.vo.MemberVO;

@Service
public class MemberInquiryServiceImpl implements MemberInquiryService {

    @Override
    public List<InquiryVO> getListForMember(String memberId) {
        // TODO: DB 연동 후 MemberInquiryMapper.selectByMemberId(memberId)
        return List.of();
    }

    @Override
    public Optional<InquiryVO> findForMember(String memberId, long id) {
        // TODO: DB 연동 후 MemberInquiryMapper.selectByIdAndMemberId(id, memberId)
        return Optional.empty();
    }

    @Override
    public InquiryVO create(MemberVO member, String category, String title, String content) {
        // TODO: DB 연동 후 MemberInquiryMapper.insert(...)
        return null;
    }
}
