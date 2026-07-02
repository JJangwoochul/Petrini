/**
 * 역할: 통합 검색 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/search/result/SearchResultMapper.xml
 * namespace: com.petcare.petcare.search.result.mapper.SearchResultMapper
 *
 * 쿼리 예시
 * - searchProducts
 * - searchHospitals
 * - searchPosts
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_HOSPITAL
 * - TB_COMMUNITY_POST
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.search.result.mapper;

public interface SearchResultMapper {}
