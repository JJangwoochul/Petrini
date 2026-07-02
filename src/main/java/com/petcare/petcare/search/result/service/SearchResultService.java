/**
 * 역할: 통합 검색 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - search/result.jsp         검색 결과
 *
 * 구현할 기능 예시
 * - 키워드 통합 검색 (상품·병원·커뮤니티 등)
 * - 영역별 결과 집계
 *
 * 연결
 * - 구현: SearchResultServiceImpl
 * - 호출: SearchResultController
 * - DB: SearchResultMapper
 *
 * 참고 테이블
 * - TB_PRODUCT
 * - TB_HOSPITAL
 * - TB_COMMUNITY_POST
 */

package com.petcare.petcare.search.result.service;

import java.util.List;

import com.petcare.petcare.search.SearchSection;

public interface SearchResultService {

    List<SearchSection> search(String keyword);

    int countResults(List<SearchSection> sections);
}
