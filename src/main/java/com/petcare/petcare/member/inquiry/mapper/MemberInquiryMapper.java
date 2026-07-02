/**
 * 역할: 1:1 문의 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/member/inquiry/MemberInquiryMapper.xml
 * namespace: com.petcare.petcare.member.inquiry.mapper.MemberInquiryMapper
 *
 * 쿼리 예시
 * - selectInquiryList
 * - selectInquiryDetail
 * - insertInquiry
 *
 * 참고 테이블
 * - TB_INQUIRY
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.member.inquiry.mapper;

public interface MemberInquiryMapper {}
