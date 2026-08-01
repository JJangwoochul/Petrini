/**
 * 역할: AdminCMSService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: AdminCMSService
 * - 사용: AdminCMSMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.admin.cms.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.admin.cms.mapper.AdminCMSMapper;
import com.petcare.petcare.main.banner.vo.MainBannerVO;

@Service
public class AdminCMSServiceImpl implements AdminCMSService {
    @Autowired
    private AdminCMSMapper adminCMSMapper;
    
    // ── 관리자: 전체 배너 목록 ──
    @Override
    public List<MainBannerVO> getAllBannerList() {
        return adminCMSMapper.selectAllBannerList();
    }

    // ── 관리자: PENDING 건수 (사이드바 배지용) ──
    @Override
    public int getPendingBannerCount() {
        return adminCMSMapper.selectPendingBannerCount();
    }

    // ── 관리자: 배너 승인 ──
    @Override
    @Transactional
    public void approveBanner(Long bannerId) {
        MainBannerVO vo = new MainBannerVO();
        vo.setBannerId(bannerId);
        vo.setStatusCd("ACTIVE");
        adminCMSMapper.updateBannerStatus(vo);
    }

    // ── 관리자: 배너 반려 ──
    @Override
    @Transactional
    public void rejectBanner(Long bannerId, String rejectReason) {
        MainBannerVO vo = new MainBannerVO();
        vo.setBannerId(bannerId);
        vo.setStatusCd("REJECTED");
        vo.setRejectReason(rejectReason);
        adminCMSMapper.updateBannerStatus(vo);
    }
}
