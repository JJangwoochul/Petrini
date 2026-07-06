/**
 * 역할: 커뮤니티 댓글 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/community/comment/CommunityCommentMapper.xml
 * namespace: com.petcare.petcare.community.comment.mapper.CommunityCommentMapper
 *
 * 쿼리 예시
 * - selectCommentList
 * - insertComment
 * - updateComment
 * - deleteComment
 *
 * 참고 테이블
 * - TB_COMMUNITY_COMMENT
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.community.comment.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface CommunityCommentMapper {}
