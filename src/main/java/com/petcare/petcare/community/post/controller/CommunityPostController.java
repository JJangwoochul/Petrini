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

@Controller("communityController")
@RequestMapping("/community")
public class CommunityPostController {

    @GetMapping({"", "/"})
    public String community() {
        return "community/list";
    }

    @GetMapping("/detail")
    public String detail() {
        return "community/detail";
    }

    @GetMapping("/write")
    public String write() {
        return "community/write";
    }
}
