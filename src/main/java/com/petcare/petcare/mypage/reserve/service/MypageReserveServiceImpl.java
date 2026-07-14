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

import com.petcare.petcare.hospital.vo.HospitalReviewVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.mypage.reserve.mapper.MypageReserveMapper;
import com.petcare.petcare.mypage.reserve.vo.MypageReserveVO;

@Service
public class MypageReserveServiceImpl implements MypageReserveService {

    @Autowired
    private MypageReserveMapper mypageReserveMapper;
    @Autowired
    private MypageNotifyService mypageNotifyService;

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

    // 2026/07/13 장우철 — DONE + 미작성 예약만 병원 리뷰 INSERT 후 평점 갱신
    @Override
    @Transactional
    public void addHospitalReview(Long memberNo, Long resvId, Double rating, String content) {
        if (memberNo == null || resvId == null) {
            throw new IllegalArgumentException("리뷰 정보가 올바르지 않습니다.");
        }
        if (rating == null || rating < 1.0 || rating > 5.0) {
            throw new IllegalArgumentException("별점은 1~5점이어야 합니다.");
        }
        if (content == null || content.isBlank()) {
            throw new IllegalArgumentException("리뷰 내용을 입력해 주세요.");
        }

        MypageReserveVO detail = mypageReserveMapper.selectMyReservationDetail(memberNo, resvId);
        if (detail == null) {
            throw new IllegalStateException("예약을 찾을 수 없습니다.");
        }
        if (!"DONE".equalsIgnoreCase(detail.getStatusCd())) {
            throw new IllegalStateException("진료완료된 예약만 리뷰를 작성할 수 있습니다.");
        }
        if ("Y".equalsIgnoreCase(detail.getReviewedYn())
                || mypageReserveMapper.countHospitalReviewByResvId(resvId, memberNo) > 0) {
            throw new IllegalStateException("이미 리뷰를 작성한 예약입니다.");
        }
        if (detail.getTargetId() == null || detail.getTargetId().isBlank()) {
            throw new IllegalStateException("병원 정보가 없습니다.");
        }

        Long hospitalId = Long.parseLong(detail.getTargetId());
        HospitalReviewVO review = new HospitalReviewVO();
        review.setTargetId(hospitalId);
        review.setMemberNo(memberNo);
        review.setResvId(resvId);
        review.setRating(rating);
        review.setContent(content.trim());

        mypageReserveMapper.insertHospitalReview(review);
        mypageReserveMapper.updateHospitalRatingSummary(hospitalId);

        // 2026/07/13 장우철 — 사업자에게 리뷰 등록 알림
        Long bizMemberNo = mypageReserveMapper.selectHospitalMemberNo(hospitalId);
        String nickname = mypageReserveMapper.selectMemberNickname(memberNo);
        mypageNotifyService.sendHospitalReviewToBizNotification(
                bizMemberNo, detail.getHospitalName(), nickname, rating, resvId);
    }
}
