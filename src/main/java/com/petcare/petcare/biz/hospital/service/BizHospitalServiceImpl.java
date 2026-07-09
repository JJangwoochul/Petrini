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

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.biz.hospital.mapper.BizHospitalMapper;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.hospital.vo.HospitalVO;

@Service
public class BizHospitalServiceImpl implements BizHospitalService {
    @Autowired
    private BizHospitalMapper bizHospitalMapper;
    @Autowired
    private KakaoMapService kakaoMapService;

    public HospitalVO getHospitalByBizId(String bizId) throws Exception {
        return bizHospitalMapper.selectHospitalByBizId(bizId);
    } 

    @Transactional
    public void updateHospitalInfo(HospitalVO vo) throws Exception {
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
}
