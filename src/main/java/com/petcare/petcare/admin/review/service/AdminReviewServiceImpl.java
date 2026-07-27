/**
 * 역할: AdminReviewService 구현체 (@Service)
 *
 * - 박유정 / 2026-07-24
 *
 * 연결
 * - implements: AdminReviewService
 * - 사용: AdminReviewMapper, MypageReserveMapper, MypageNotifyService
 */

package com.petcare.petcare.admin.review.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.admin.review.mapper.AdminReviewMapper;
import com.petcare.petcare.admin.review.vo.AdminReviewDeleteRequestVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;
import com.petcare.petcare.mypage.reserve.mapper.MypageReserveMapper;

@Service
public class AdminReviewServiceImpl implements AdminReviewService {

    private final AdminReviewMapper adminReviewMapper;
    private final MypageReserveMapper mypageReserveMapper;
    private final MypageNotifyService mypageNotifyService;
    private static final int PAGE_SIZE = 10;

    public AdminReviewServiceImpl(AdminReviewMapper adminReviewMapper,
                                  MypageReserveMapper mypageReserveMapper,
                                  MypageNotifyService mypageNotifyService) {
        this.adminReviewMapper = adminReviewMapper;
        this.mypageReserveMapper = mypageReserveMapper;
        this.mypageNotifyService = mypageNotifyService;
    }

    // 2026-07-24 박유정 — 삭제 요청 목록 (검색·필터·페이징)
    @Override
    public List<AdminReviewDeleteRequestVO> getReviewDeleteRequestList(
            String keyword, String statusCd, int page) {
        int safePage = page < 1 ? 1 : page;
        int offset = (safePage - 1) * PAGE_SIZE;
        return adminReviewMapper.selectAdminReviewDeleteRequestList(
                keyword, statusCd, offset, PAGE_SIZE);
    }

    @Override
    public int getReviewDeleteRequestCount(String keyword, String statusCd) {
        return adminReviewMapper.selectAdminReviewDeleteRequestCount(keyword, statusCd);
    }

    @Override
    public int getPendingReviewDeleteCount() {
        return adminReviewMapper.countPendingReviewDeleteRequest();
    }

    // 2026-07-24 박유정 — 삭제 요청 승인 (리뷰 DELETE + 평점 재계산)
    @Override
    @Transactional
    public void approveReviewDeleteRequest(long requestId, long adminNo) {
        AdminReviewDeleteRequestVO req =
                adminReviewMapper.selectAdminReviewDeleteRequestDetail(requestId);
        if (req == null) {
            throw new IllegalArgumentException("REQUEST_NOT_FOUND");
        }
        if (!"PENDING".equals(req.getStatusCd())) {
            throw new IllegalStateException("REQUEST_NOT_PENDING");
        }

        int deleted = adminReviewMapper.deleteReviewById(req.getReviewId());
        if (deleted == 0) {
            throw new IllegalStateException("REVIEW_NOT_FOUND");
        }

        mypageReserveMapper.updateHospitalRatingSummary(req.getTargetId());

        int updated = adminReviewMapper.updateReviewDeleteRequestApproved(requestId, adminNo);
        if (updated == 0) {
            throw new IllegalStateException("REQUEST_NOT_PENDING");
        }

        Long bizMemberNo = adminReviewMapper.selectBizMemberNoByBizNo(req.getBizNo());
        if (bizMemberNo != null) {
            mypageNotifyService.sendReviewDeleteApproveNotification(
                    bizMemberNo, req.getHospitalName(), req.getReviewId());
        }
    }

    // 2026-07-24 박유정 — 삭제 요청 반려 (반려 사유 저장 + 사업자 알림)
    @Override
    @Transactional
    public void rejectReviewDeleteRequest(long requestId, String rejectReason, long adminNo) {
        if (rejectReason == null || rejectReason.isBlank()) {
            throw new IllegalArgumentException("REJECT_REASON_REQUIRED");
        }

        AdminReviewDeleteRequestVO req =
                adminReviewMapper.selectAdminReviewDeleteRequestDetail(requestId);
        if (req == null) {
            throw new IllegalArgumentException("REQUEST_NOT_FOUND");
        }
        if (!"PENDING".equals(req.getStatusCd())) {
            throw new IllegalStateException("REQUEST_NOT_PENDING");
        }

        String reason = rejectReason.trim();
        int updated = adminReviewMapper.updateReviewDeleteRequestRejected(
                requestId, adminNo, reason);
        if (updated == 0) {
            throw new IllegalStateException("REQUEST_NOT_PENDING");
        }

        Long bizMemberNo = adminReviewMapper.selectBizMemberNoByBizNo(req.getBizNo());
        if (bizMemberNo != null) {
            mypageNotifyService.sendReviewDeleteRejectNotification(
                    bizMemberNo, req.getHospitalName(), reason);
        }
    }
}
