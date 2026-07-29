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



import org.slf4j.Logger;

import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;



import com.petcare.petcare.admin.review.mapper.AdminReviewMapper;

import com.petcare.petcare.admin.review.vo.AdminReviewDeleteRequestVO;



@Service

public class AdminReviewServiceImpl implements AdminReviewService {



    private static final Logger log = LoggerFactory.getLogger(AdminReviewServiceImpl.class);



    private final AdminReviewMapper adminReviewMapper;

    private final AdminReviewApproveTxService approveTxService;

    private final AdminReviewSideEffectService sideEffectService;

    private static final int PAGE_SIZE = 10;



    public AdminReviewServiceImpl(AdminReviewMapper adminReviewMapper,

                                  AdminReviewApproveTxService approveTxService,

                                  AdminReviewSideEffectService sideEffectService) {

        this.adminReviewMapper = adminReviewMapper;

        this.approveTxService = approveTxService;

        this.sideEffectService = sideEffectService;

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



    // 2026-07-28 박유정 — 삭제 승인: DELETE+상태변경(짧은 TX) → 평점·알림(별도 TX)

    @Override

    public void approveReviewDeleteRequest(long requestId, long adminNo) {

        log.info("리뷰 삭제 승인 시작 requestId={}, adminNo={}", requestId, adminNo);

        AdminReviewDeleteRequestVO req = approveTxService.approve(requestId, adminNo);

        sideEffectService.afterApprove(req);

        log.info("리뷰 삭제 승인 완료 requestId={}", requestId);

    }



    // 2026-07-24 박유정 — 삭제 요청 반려 (반려 사유 저장 + 사업자 알림)

    @Override

    @Transactional(timeout = 15)

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



        sideEffectService.afterReject(req, reason);

    }

}


