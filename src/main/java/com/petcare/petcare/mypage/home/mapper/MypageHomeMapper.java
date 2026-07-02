/**
 * 역할: 마이페이지 홈 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/mypage/home/MypageHomeMapper.xml
 * namespace: com.petcare.petcare.mypage.home.mapper.MypageHomeMapper
 *
 * 쿼리 예시
 * - selectMypageSummary
 * - selectPetList
 * - selectHealthSummary
 *
 * 참고 테이블
 * - TB_MEMBER
 * - TB_PET
 * - TB_PET_HEALTH
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.mypage.home.mapper;

public interface MypageHomeMapper {}
