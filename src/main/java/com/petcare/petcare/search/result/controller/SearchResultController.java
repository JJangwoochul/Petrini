/**
 * 역할: 통합 검색 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: SearchResultService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.search.result.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.search.SearchSection;
import com.petcare.petcare.search.result.service.SearchResultService;

@Controller
public class SearchResultController {

    private final SearchResultService searchService;

    public SearchResultController(SearchResultService searchService) {
        this.searchService = searchService;
    }

    @GetMapping("/search")
    public String search(@RequestParam(required = false, defaultValue = "") String q, Model model) {
        String keyword = q == null ? "" : q.trim();
        List<SearchSection> sections = searchService.search(keyword);

        model.addAttribute("keyword", keyword);
        model.addAttribute("sections", sections);
        model.addAttribute("totalCount", searchService.countResults(sections));
        return "search/result";
    }
}
