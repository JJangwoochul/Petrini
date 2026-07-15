/**
 * 역할: HospitalHospitalService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: HospitalHospitalService
 * - 사용: HospitalHospitalMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.hospital.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.hospital.mapper.HospitalMapper;
import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;

@Service
public class HospitalServiceImpl implements HospitalService {

    @Autowired
    private HospitalMapper hospitalMapper;

    @Override
    public List<HospitalVO> getHospitalList() throws Exception {
        return hospitalMapper.selectHospitalList();
    }

    @Override
    public List<HospitalVO> getHospitalListBySearch(HospitalVO searchVO) throws Exception {
        return hospitalMapper.selectHospitalListBySearch(searchVO);
    }
    
    @Override
    public HospitalVO getHospitalById(Long hospitalId) throws Exception {
        return hospitalMapper.selectHospitalById(hospitalId);
    }

    // 2026-07-10 장우철 — 예약 폼 펫 목록 (F2)
    @Override
    @Transactional(readOnly = true)
    public List<HospitalPetVO> getPetListForReserve(Long memberNo) throws Exception {
        return hospitalMapper.selectPetListByMemberNo(memberNo);
    }

    // 2026-07-10 장우철 — 병원 예약 저장 (F2)
    @Override
    @Transactional
    public Long createHospitalReservation(ReservationVO vo) throws Exception {
        vo.setResvType("HOSPITAL");
        vo.setStatusCd("PENDING");
        if (vo.getResvNo() == null || vo.getResvNo().isBlank()) {
            vo.setResvNo(buildResvNo());
        }
        hospitalMapper.insertReservation(vo);
        return vo.getResvId();
    }

    // 2026-07-10 장우철 — 예약 완료 화면 (F3)
    @Override
    @Transactional(readOnly = true)
    public ReservationVO getReservationById(Long resvId) throws Exception {
        return hospitalMapper.selectReservationById(resvId);
    }

    // 2026/07/13 장우철 — 병원 상세 리뷰
    @Override
    @Transactional(readOnly = true)
    public List<HospitalReviewVO> getHospitalReviews(Long hospitalId) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return hospitalMapper.selectHospitalReviews(hospitalId);
    }

    /** 2026-07-10 장우철 — 예약번호 생성 (TOTAL_DATA 패턴: RyyyyMMdd + 일련) */
    private String buildResvNo() {
        String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        long suffix = System.currentTimeMillis() % 10000;
        return "R" + datePart + String.format("%04d", suffix);
    }
}
