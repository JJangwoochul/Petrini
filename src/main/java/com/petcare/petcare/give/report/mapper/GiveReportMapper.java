/**
 * 역할: 유기동물 제보 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/give/report/GiveReportMapper.xml
 * namespace: com.petcare.petcare.give.report.mapper.GiveReportMapper
 *
 * 쿼리 예시
 * - selectReportList
 * - selectReportDetail
 * - insertReport
 * - updateReport
 *
 * 참고 테이블
 * - TB_ANIMAL_REPORT
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.give.report.mapper;

public interface GiveReportMapper {}
