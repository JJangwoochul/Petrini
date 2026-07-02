/**
 * 역할: 마이페이지 포인트 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/mypage/point/MypagePointMapper.xml
 * namespace: com.petcare.petcare.mypage.point.mapper.MypagePointMapper
 *
 * 쿼리 예시
 * - selectPointBalance
 * - selectPointHistory
 *
 * 참고 테이블
 * - TB_POINT
 * - TB_POINT_HISTORY
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.mypage.point.mapper;

public interface MypagePointMapper {}
