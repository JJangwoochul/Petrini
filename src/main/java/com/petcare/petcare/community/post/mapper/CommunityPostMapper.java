/**
 * 역할: 커뮤니티 게시글 DB 접근 (MyBatis interface)
 *
 * - 박유정 / 2026-07-08
 * - give/report 의 GiveReportMapper 패턴 참고
 *
 * XML: resources/mybatis/mapper/community/post/CommunityPostMapper.xml
 * namespace: com.petcare.petcare.community.post.mapper.CommunityPostMapper
 *
 * 쿼리 (STEP 3 완료 / 4~ 예정)
 * - selectPostList      목록 (boardType 파라미터) ✅
 * - selectFileUrlsByPostId  사진 URL 목록 ✅
 * - insertPost          글 등록 (STEP 4)
 * - selectPostDetail    상세 1건 (STEP 5)
 * - insertFile          사진 TB_FILE (STEP 4)
 *
 * 참고 테이블
 * - TB_POST (BOARD_TYPE = TOWN / SHARE / LIFE)
 * - TB_FILE (REF_TYPE = 'POST')
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.community.post.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;

import com.petcare.petcare.community.post.vo.CommunityPostVO;
import com.petcare.petcare.give.report.vo.GiveReportFileVO;


@Mapper
public interface CommunityPostMapper {

    // STEP 4 — 글 등록
    int insertPost(CommunityPostVO vo);

    // STEP 3 — 목록 (boardType: 빈값=전체, TOWN/SHARE/LIFE=탭별)
    List<CommunityPostVO> selectPostList(String boardType);

    // STEP 5 — 상세 1건
    CommunityPostVO selectPostDetail(long postId);

    // STEP 4 — 로그인 회원 → MEMBER_NO (give/report 와 동일)
    Long selectMemberNoByMemberId(String memberId);
    Long selectMemberNoByEmail(String email);

    // STEP 4 — 사진 TB_FILE INSERT (GiveReportFileVO 재사용)
    int insertFile(GiveReportFileVO file);

    // STEP 3 — 게시글에 연결된 사진 URL 목록 (썸네일·상세용)
    List<String> selectFileUrlsByPostId(long postId);
}
