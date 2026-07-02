package com.petcare.petcare.search;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SearchController {

    private final SearchService searchService;

    public SearchController(SearchService searchService) {
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
