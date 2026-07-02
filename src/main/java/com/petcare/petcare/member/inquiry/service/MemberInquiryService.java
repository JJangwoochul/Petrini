/**
 * 역할: 1:1 문의 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - member/cs-inquiry-list.jsp 문의 목록
 * - member/cs-inquiry-write.jsp 문의 작성
 * - member/cs-inquiry-detail.jsp 문의 상세
 *
 * 구현할 기능 예시
 * - 1:1 문의 목록·상세 조회
 * - 문의 등록
 *
 * 연결
 * - 구현: MemberInquiryServiceImpl
 * - 호출: MemberInquiryController
 * - DB: MemberInquiryMapper
 *
 * 참고 테이블
 * - TB_INQUIRY
 */

package com.petcare.petcare.member.inquiry.service;

import java.util.List;
import java.util.Optional;

import com.petcare.petcare.member.vo.InquiryVO;
import com.petcare.petcare.member.vo.MemberVO;

public interface MemberInquiryService {

    List<InquiryVO> getListForMember(String memberId);

    Optional<InquiryVO> findForMember(String memberId, long id);

    InquiryVO create(MemberVO member, String category, String title, String content);
}
