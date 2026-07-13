/**
 * 역할: MypageReserveService 구현체 (@Service)
 *
 * 2026/07/11 장우철 — 마이페이지 예약 목록·상세 (2차)
 */

package com.petcare.petcare.mypage.reserve.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.mypage.reserve.mapper.MypageReserveMapper;
import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;

@Service
public class MypageReserveServiceImpl implements MypageReserveService {

    @Autowired
    private MypageReserveMapper mypageReserveMapper;

    @Override
    @Transactional(readOnly = true)
    public List<MypageReserveVO> getMyReservationList(Long memberNo, String statusFilter) {
        if (memberNo == null) {
            return Collections.emptyList();
        }
        String filter = (statusFilter == null || statusFilter.isBlank() || "all".equalsIgnoreCase(statusFilter))
                ? null : statusFilter.trim().toLowerCase();
        return mypageReserveMapper.selectMyReservationList(memberNo, filter);
    }

    @Override
    @Transactional(readOnly = true)
    public MypageReserveVO getMyReservationDetail(Long memberNo, Long resvId) {
        if (memberNo == null || resvId == null) {
            return null;
        }
        return mypageReserveMapper.selectMyReservationDetail(memberNo, resvId);
    }
}
