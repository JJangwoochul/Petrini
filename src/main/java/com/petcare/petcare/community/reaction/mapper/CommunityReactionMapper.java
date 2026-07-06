/**
 * 역할: 커뮤니티 반응 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/community/reaction/CommunityReactionMapper.xml
 * namespace: com.petcare.petcare.community.reaction.mapper.CommunityReactionMapper
 *
 * 쿼리 예시
 * - insertLike
 * - deleteLike
 * - insertReport
 * - countLikes
 *
 * 참고 테이블
 * - TB_COMMUNITY_LIKE
 * - TB_COMMUNITY_REPORT
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.community.reaction.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface CommunityReactionMapper {}
