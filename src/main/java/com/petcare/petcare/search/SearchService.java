package com.petcare.petcare.search;

import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class SearchService {

    public List<SearchSection> search(String keyword) {
        if (keyword == null || keyword.isBlank()) {
            return List.of();
        }

        // TODO: DB 연동 후 각 영역 Mapper에서 keyword로 조회
        return List.of();
    }

    public int countResults(List<SearchSection> sections) {
        return sections.stream().mapToInt(section -> section.getItems().size()).sum();
    }
}
