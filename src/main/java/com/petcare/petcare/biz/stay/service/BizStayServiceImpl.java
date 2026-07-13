/**
 * 역할: BizStayService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: BizStayService
 * - 사용: BizStayMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.biz.stay.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petcare.petcare.biz.stay.mapper.BizStayMapper;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.stay.vo.StayVO;

@Service
public class BizStayServiceImpl implements BizStayService {
    @Autowired
    private BizStayMapper bizStayMapper;
    @Autowired
    private KakaoMapService kakaoMapService;
    @Autowired
    private MypageNotifyService mypageNotifyService;
    
    @Override
    public StayVO getHospitalByBizId(String bizId) {
        return bizStayMapper.selectStayByBizId(bizId);
    }
    @Override
    public StayVO resolveStayByBizId(String bizId) {
        if (bizId == null || bizId.isBlank()) {
            return null;
        }
        StayVO stay = bizStayMapper.selectStayByBizId(bizId);
        if (stay == null) {
            bizStayMapper.insertStay(bizId);
            stay = bizStayMapper.selectStayByBizId(bizId);
        }
        return stay;
    }
    @Override
    public void updateStayInfo(StayVO vo) {
        // 2026-07-10 장우철 — 주소 있으면 좌표 변환 (유저 목록 '상세보기'는 LAT 필수)
        if (vo.getAddr() != null && !vo.getAddr().isBlank()) {
            Map<String, Double> coords = kakaoMapService.geocodeAddress(vo.getAddr());
            if (coords != null) {
                vo.setLat(coords.get("lat"));
                vo.setLng(coords.get("lng"));
            }
        }

        bizStayMapper.updateStayInfo(vo);
    }

    @Override
    public void updateStayProfile(StayVO vo) {
        if (vo.getAddr() != null && !vo.getAddr().isBlank()) {
            Map<String, Double> coords = kakaoMapService.geocodeAddress(vo.getAddr());
            if (coords != null) {
                vo.setLat(coords.get("lat"));
                vo.setLng(coords.get("lng"));
            }
        }
        
        bizStayMapper.updateStayProfile(vo);
    }
}
