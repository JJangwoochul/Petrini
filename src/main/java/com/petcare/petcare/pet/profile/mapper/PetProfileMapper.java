/**
 * 역할: 반려동물 프로필 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/pet/profile/PetProfileMapper.xml
 * namespace: com.petcare.petcare.pet.profile.mapper.PetProfileMapper
 *
 * 쿼리 예시
 * - selectPetList
 * - selectPetDetail
 * - insertPet
 * - updatePet
 * - deletePet
 *
 * 참고 테이블
 * - TB_PET
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.pet.profile.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface PetProfileMapper {}
