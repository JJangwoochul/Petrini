/**
 * 역할: 커뮤니티 게시글 DB 접근 (MyBatis interface)
 *
 * - 박유정 / 2026-07-08~10
 * - give/report 의 GiveReportMapper 패턴 참고
 *
 * XML: resources/mybatis/mapper/community/post/CommunityPostMapper.xml
 *
 * 쿼리
 * - selectPostList / selectPostCount   목록·페이징·검색
 * - selectPostDetail                   상세 1건
 * - insertPost / insertFile            글·사진 등록
 * - selectFileUrlsByPostId             사진 URL 목록
 * - increaseViewCount                  조회수 +1
 * - increaseLikeCnt / decreaseLikeCnt  좋아요 수 증감
 * - selectMemberNoByMemberId/Email     로그인 → MEMBER_NO
 * - updatePostTags                     TAGS 변경 (LIFE WAITING→ANSWERED, 2026-07-10)
 *
 * 참고 테이블
 * - TB_POST (BOARD_TYPE = TOWN / SHARE / LIFE)
 * - TB_FILE (REF_TYPE = 'POST')
 *
 * SQL은 XML에만 작성
 */

package com.petcare.petcare.community.post.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.petcare.petcare.community.post.vo.CommunityPostVO;
import com.petcare.petcare.give.report.vo.GiveReportFileVO;


@Mapper
public interface CommunityPostMapper {

    // 글 등록 (SEQ_TB_POST)
    int insertPost(CommunityPostVO vo);

    // 목록 (boardType: 빈값=전체, TOWN/SHARE/LIFE=탭별, 페이징·검색·LIFE 필터)
    List<CommunityPostVO> selectPostList(
            @Param("boardType") String boardType,
            @Param("keyword") String keyword,
            @Param("petSpecies") String petSpecies,
            @Param("vetStatus") String vetStatus,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize);

    int selectPostCount(
            @Param("boardType") String boardType,
            @Param("keyword") String keyword,
            @Param("petSpecies") String petSpecies,
            @Param("vetStatus") String vetStatus);

    // 상세 1건
    CommunityPostVO selectPostDetail(long postId);

    // 로그인 회원 → MEMBER_NO (give/report 와 동일)
    Long selectMemberNoByMemberId(String memberId);
    Long selectMemberNoByEmail(String email);

    // 사진 TB_FILE INSERT (GiveReportFileVO 재사용)
    int insertFile(GiveReportFileVO file);

    // 게시글에 연결된 사진 URL 목록 (썸네일·상세용)
    List<String> selectFileUrlsByPostId(long postId);

    // 조회수 +1 (시퀀스 없음, UPDATE)
    int increaseViewCount(long postId);

    // 좋아요 수 증감 (TB_POST.LIKE_CNT)
    int increaseLikeCnt(long postId);

    int decreaseLikeCnt(long postId);

     // LIFE 답변완료 등 — TAGS 컬럼 UPDATE
     int updatePostTags(@Param("postId") long postId, @Param("tags") String tags);

    // 2026-07-23 HYJ — 게시글 수정 (본인 글)
    int updatePost(CommunityPostVO vo);

    // 2026-07-23 HYJ — LIFE 게시글 소프트 삭제 (IS_DELETED='Y')
    int softDeletePost(@Param("postId") long postId, @Param("memberNo") long memberNo);

    // 2026-07-23 HYJ — TOWN/SHARE 게시글 물리 삭제
    int hardDeletePost(@Param("postId") long postId, @Param("memberNo") long memberNo);

    // 2026-07-23 HYJ — 게시글 연결 파일 삭제 (물리 삭제 시 함께)
    int deleteFilesByPostId(long postId);

    // 2026-07-23 HYJ — 7일 경과 소프트 삭제 게시글 ID 목록 (스케줄러용)
    List<Long> selectExpiredSoftDeletedPostIds(@Param("days") int days);

    // 2026-07-23 HYJ — 소프트 삭제 게시글 물리 삭제 (스케줄러용)
    int hardDeleteExpiredPost(long postId);
}
