/**
 * 역할: 관리자 사업자 관리 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/admin/biz/AdminBizMapper.xml
 * namespace: com.petcare.petcare.admin.biz.mapper.AdminBizMapper
 *
 * 쿼리 예시
 * - selectBizApplyList    사업자 신청 목록
 * - selectBizApplyDetail  사업자 신청 상세
 * - updateBizStatus       승인/반려 상태 변경
 * - selectTalentApplyList 재능나눔 승인 목록
 * - updateTalentStatus    재능나눔 승인/반려
 *
 * 참고 테이블
 * - TB_BUSINESS
 * - (재능나눔) 관련 테이블
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.admin.biz.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface AdminBizMapper {}
