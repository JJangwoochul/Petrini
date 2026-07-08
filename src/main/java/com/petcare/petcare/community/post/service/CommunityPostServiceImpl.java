/**
 * 역할: CommunityPostService 구현체 (@Service)
 *
 * - 박유정 / 2026-07-08
 * - give/report 의 getReportList() 패턴 참고
 *
 * [getPostList — 목록]
 * 1. Mapper.selectPostList(boardType) → TB_POST 목록 조회
 * 2. 각 글마다 Mapper.selectFileUrlsByPostId() → TB_FILE 첫 사진
 * 3. 첫 사진 URL → item.thumbUrl (list.jsp 썸네일용)
 * 4. list 반환
 *
 * 연결
 * - implements: CommunityPostService
 * - 사용: CommunityPostMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.community.post.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.petcare.petcare.community.post.mapper.CommunityPostMapper;
import com.petcare.petcare.community.post.vo.CommunityPostVO;

@Service
public class CommunityPostServiceImpl implements CommunityPostService {

    private final CommunityPostMapper communityPostMapper;

    // 생성자 주입 — Spring이 Mapper 넣어 줌
    public CommunityPostServiceImpl(CommunityPostMapper communityPostMapper) {
        this.communityPostMapper = communityPostMapper;
    }

    @Override
    public List<CommunityPostVO> getPostList(String boardType) {
        // 1) DB에서 글 목록 (boardType 빈값이면 TOWN+LIFE+SHARE 전체)
        List<CommunityPostVO> list = communityPostMapper.selectPostList(boardType);

        // 2) 각 글마다 TB_FILE 첫 사진 → thumbUrl
        for (CommunityPostVO item : list) {
            List<String> urls = communityPostMapper.selectFileUrlsByPostId(item.getPostId());
            if (urls != null && !urls.isEmpty()) {
                item.setThumbUrl(urls.get(0));
            }
        }
        return list;
    }
}
