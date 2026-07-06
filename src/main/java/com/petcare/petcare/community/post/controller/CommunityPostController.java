/**
 * 역할: 커뮤니티 게시글 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: CommunityPostService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.community.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/*
 *  2026/07/06 장우철
 * id 파라미터 추가
 */

 @Controller("communityController")
@RequestMapping("/community")
public class CommunityPostController {

    @GetMapping({"", "/"})
    public String community() {
        return "community/list";
    }
    
    /* 상세 DB조회 -> defaultValue 값에는 상세보기 기능 구현시 id값 입력 / 현재-> 상세기능 x */
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id) {
        return "community/detail";
    }

    @GetMapping("/write")
    public String write() {
        return "community/write";
    }
}
