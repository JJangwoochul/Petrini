/**
 * 역할: BizHospitalService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: BizHospitalService
 * - 사용: BizHospitalMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.biz.hospital.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.biz.hospital.mapper.BizHospitalMapper;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.hospital.vo.HospitalVO;
import com.petcare.petcare.hospital.vo.ReservationVO;

@Service
public class BizHospitalServiceImpl implements BizHospitalService {
    @Autowired
    private BizHospitalMapper bizHospitalMapper;
    @Autowired
    private KakaoMapService kakaoMapService;

    @Override
    @Transactional(readOnly = true)
    public HospitalVO getHospitalByBizId(String bizId) {
        return bizHospitalMapper.selectHospitalByBizId(bizId);
    }

    // 2026-07-10 장우철 — merge 전 승인 계정 등 TB_HOSPITAL 미생성 시 보정 INSERT
    @Override
    @Transactional
    public HospitalVO resolveHospitalByBizId(String bizId) {
        if (bizId == null || bizId.isBlank()) {
            return null;
        }
        HospitalVO hospital = bizHospitalMapper.selectHospitalByBizId(bizId);
        if (hospital == null) {
            bizHospitalMapper.insertHospital(bizId);
            hospital = bizHospitalMapper.selectHospitalByBizId(bizId);
        }
        return hospital;
    }

    @Override
    @Transactional
    public void updateHospitalInfo(HospitalVO vo) {
        // 주소가 있으면 좌표 변환
        if (vo.getAddr() != null && !vo.getAddr().isBlank()) {
            Map<String, Double> coords = kakaoMapService.geocodeAddress(vo.getAddr());
            if (coords != null) {
                vo.setLat(coords.get("lat"));
                vo.setLng(coords.get("lng"));
            }
        }
        
        bizHospitalMapper.updateHospitalInfo(vo);
    }

    // 2026-07-10 장우철 — 사업자 예약 목록 (F4)
    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getReservationList(Long hospitalId, String tab) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        String safeTab = (tab == null || "all".equals(tab)) ? null : tab;
        return bizHospitalMapper.selectReservationList(hospitalId, safeTab);
    }

    // 2026-07-10 장우철 — 사업자 예약 상세 모달 (F6)
    @Override
    @Transactional(readOnly = true)
    public ReservationVO getReservationDetail(Long hospitalId, Long resvId) throws Exception {
        return bizHospitalMapper.selectReservationDetail(resvId, hospitalId);
    }

    // 2026-07-10 장우철 — 사업자 예약 상태 변경 (F5)
    @Override
    @Transactional
    public void updateReservationStatus(Long hospitalId, Long resvId, String statusCd) throws Exception {
        if (hospitalId == null || resvId == null || statusCd == null || statusCd.isBlank()) {
            throw new IllegalArgumentException("예약 상태 변경 정보가 올바르지 않습니다.");
        }
        int updated = bizHospitalMapper.updateReservationStatus(resvId, hospitalId, statusCd);
        if (updated == 0) {
            throw new IllegalStateException("예약을 찾을 수 없거나 변경할 수 없습니다.");
        }
    }

    // 2026-07-10 장우철 — 사업자 예약 캘린더 (F7)
    @Override
    @Transactional(readOnly = true)
    public List<ReservationVO> getCalendarReservations(Long hospitalId, String fromDate, String toDate) throws Exception {
        if (hospitalId == null) {
            return List.of();
        }
        return bizHospitalMapper.selectReservationCalendarList(hospitalId, fromDate, toDate);
    }
}
