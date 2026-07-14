/**
 * 역할: 동물병원 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/hospital/HospitalMapper.xml
 * namespace: com.petcare.petcare.hospital.mapper.HospitalMapper
 *
 * 쿼리 예시
 * - selectHospitalList
 * - selectHospitalDetail
 * - insertReservation
 *
 * 참고 테이블
 * - TB_HOSPITAL
 * - TB_RESERVATION
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.hospital.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;


@Mapper
public interface HospitalMapper {
    //MyBatis가 @Mapper가 붙은 인터페이스를 보고 자동으로 구현체(XML)를 만들어줌
    List<HospitalVO> selectHospitalList() throws Exception;
    HospitalVO selectHospitalById(Long hospitalId) throws Exception;

    // 2026-07-10 장우철 — 병원 예약 1차 (F0~F3) 유저 측 Mapper
    List<HospitalPetVO> selectPetListByMemberNo(Long memberNo) throws Exception;
    int insertReservation(ReservationVO vo) throws Exception;
    ReservationVO selectReservationById(Long resvId) throws Exception;

    // 2026/07/13 장우철 — 병원 상세 리뷰 목록 (REVIEW_TYPE=HOSPITAL)
    List<HospitalReviewVO> selectHospitalReviews(Long hospitalId) throws Exception;
}
