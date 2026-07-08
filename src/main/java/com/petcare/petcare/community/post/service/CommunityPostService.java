/**
 * 역할: 커뮤니티 게시글 비즈니스 로직 (interface)
 *
 * - 박유정 / 2026-07-08
 * - STEP 3: 목록 조회 (getPostList)
 * - STEP 4~: insertPost 등 추가 예정
 *
 * 담당 화면
 * - community/list.jsp        게시글 목록
 * - community/detail.jsp      게시글 상세
 * - community/write.jsp       게시글 작성
 *
 * 연결
 * - 구현: CommunityPostServiceImpl
 * - 호출: CommunityPostController
 * - DB: CommunityPostMapper
 *
 * 참고 테이블
 * - TB_POST (BOARD_TYPE = TOWN / SHARE / LIFE)
 * - TB_FILE (사진, REF_TYPE = 'POST')
 */

package com.petcare.petcare.community.post.service;

import java.util.List;
import com.petcare.petcare.community.post.vo.CommunityPostVO;

public interface CommunityPostService {

    // 게시글 목록 (boardType: TOWN/SHARE/LIFE, 빈값=전체)
    List<CommunityPostVO> getPostList(String boardType);
}
