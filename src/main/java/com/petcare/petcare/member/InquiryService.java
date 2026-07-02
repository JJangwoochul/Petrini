package com.petcare.petcare.member;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.petcare.petcare.member.vo.InquiryVO;
import com.petcare.petcare.member.vo.MemberVO;

@Service
public class InquiryService {

    public List<InquiryVO> getListForMember(String memberId) {
        // TODO: DB 연동 후 inquiryMapper.selectByMemberId(memberId)
        return List.of();
    }

    public Optional<InquiryVO> findForMember(String memberId, long id) {
        // TODO: DB 연동 후 inquiryMapper.selectByIdAndMemberId(id, memberId)
        return Optional.empty();
    }

    public InquiryVO create(MemberVO member, String category, String title, String content) {
        // TODO: DB 연동 후 inquiryMapper.insert(...)
        return null;
    }
}
