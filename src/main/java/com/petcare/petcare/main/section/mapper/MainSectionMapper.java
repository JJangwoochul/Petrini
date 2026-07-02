/**
 * 역할: 메인 섹션 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/main/section/MainSectionMapper.xml
 * namespace: com.petcare.petcare.main.section.mapper.MainSectionMapper
 *
 * 쿼리 예시
 * - selectPopularProducts
 * - selectCommunityPreview
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_COMMUNITY_POST
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.main.section.mapper;

public interface MainSectionMapper {}
