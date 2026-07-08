/**
 * 역할: 커뮤니티 게시글 URL 처리 → Service 호출 → JSP 반환
 *
 * - 박유정 / 2026-07-08
 * - STEP 3: 목록 DB 연동 (탭별 boardType 필터)
 *
 * [목록 화면 흐름]
 * 1. 사용자가 /community 또는 /community?boardType=TOWN 등으로 접속
 * 2. boardType 파라미터 받음 (빈값=전체, TOWN/SHARE/LIFE=탭별)
 * 3. communityPostService.getPostList(boardType) 호출
 * 4. list, boardType 을 model 에 넣고 community/list.jsp 반환
 *
 * [탭 ↔ boardType]
 * - 전체     → "" (빈값)
 * - 집사생활 → TOWN
 * - 무료나눔 → SHARE
 * - 수의사 상담 → LIFE
 * - 재능나눔 → /community/talent/list (별도 Controller)
 *
 * 연결
 * - Service: CommunityPostService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.community.post.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/*
 *  2026/07/06 장우철
 * id 파라미터 추가
 */
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.community.post.service.CommunityPostService;

 @Controller("communityController")
@RequestMapping("/community")
public class CommunityPostController {

    private final CommunityPostService communityPostService;

    public CommunityPostController(CommunityPostService communityPostService) {
        this.communityPostService = communityPostService;
    }

    /** 게시글 목록 — boardType 으로 탭별 필터, list.jsp 에 ${list} 전달 */
    @GetMapping({"", "/"})
    public String list(
            @RequestParam(defaultValue = "") String boardType,
            Model model) {
        model.addAttribute("list", communityPostService.getPostList(boardType));
        model.addAttribute("boardType", boardType); // index.jsp 탭 .on 표시용
        return "community/list";
    }
    
    /* 상세 DB조회 -> defaultValue 값에는 상세보기 기능 구현시 id값 입력 / 현재-> 상세기능 x */
    /** 게시글 상세 — STEP 5 에서 DB 연동 예정 */
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id) {
        return "community/detail";
    }

    /** 게시글 작성 화면 — STEP 4 에서 POST 연동 예정 */
    @GetMapping("/write")
    public String write() {
        return "community/write";
    }
}
