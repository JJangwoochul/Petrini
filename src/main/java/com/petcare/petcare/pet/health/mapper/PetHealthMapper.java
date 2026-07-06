/**
 * 역할: 반려동물 건강 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/pet/health/PetHealthMapper.xml
 * namespace: com.petcare.petcare.pet.health.mapper.PetHealthMapper
 *
 * 쿼리 예시
 * - selectHealthList
 * - insertHealthRecord
 * - updateHealthRecord
 *
 * 참고 테이블
 * - TB_PET_HEALTH
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.pet.health.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface PetHealthMapper {}
