/**
 * 역할: 관리자 커뮤니티 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/admin/community/AdminCommunityMapper.xml
 * namespace: com.petcare.petcare.admin.community.mapper.AdminCommunityMapper
 *
 * 쿼리 예시
 * - selectPostList
 * - selectPostDetail
 * - updatePostStatus
 * - deletePost
 *
 * 참고 테이블
 * - TB_COMMUNITY_POST
 * - TB_COMMUNITY_REPORT
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.admin.community.mapper;

public interface AdminCommunityMapper {}
