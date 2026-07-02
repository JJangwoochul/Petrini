/**
 * 역할: 유기동물 입양 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - give/animal/list.jsp      유기동물 목록
 * - give/animal/detail.jsp    유기동물 상세
 *
 * 구현할 기능 예시
 * - 공공 API 유기동물 목록 조회 (지역·품종·상태 필터)
 * - 유기동물 상세 조회
 * - 입양 관심 등록
 *
 * 연결
 * - 구현: GiveAnimalServiceImpl
 * - 호출: GiveAnimalController
 * - DB: GiveAnimalMapper
 *
 * 참고 테이블
 * - TB_ADOPTION_INTEREST
 */

package com.petcare.petcare.give.animal.service;

public interface GiveAnimalService {}
