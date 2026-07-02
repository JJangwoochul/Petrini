/**
 * 역할: SearchResultService 구현체 (@Service)
 *
 * 구현 내용
 * - 키워드 통합 검색 처리
 * - 영역별 Mapper 호출 및 결과 집계
 *
 * 연결
 * - 호출: SearchResultController
 * - 사용: SearchResultMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.search.result.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.petcare.petcare.search.SearchSection;

@Service
public class SearchResultServiceImpl implements SearchResultService {

    @Override
    public List<SearchSection> search(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return List.of();
        }
        // TODO: DB 연동 후 각 영역 Mapper에서 keyword로 조회
        return List.of();
    }

    @Override
    public int countResults(List<SearchSection> sections) {
        return sections.stream().mapToInt(section -> section.getItems().size()).sum();
    }
}
