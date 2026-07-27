/**
 * 역할: AdminStoreService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: AdminStoreService
 * - 사용: AdminStoreMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.admin.store.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.admin.store.mapper.AdminStoreMapper;
import com.petcare.petcare.admin.store.vo.AdminReviewReportVO;

//지윤 26.07.21 수정: @Service 어노테이션이 원래 빠져있어서 스프링 빈으로 등록조차 안 되던 상태였음 - 추가함
@Service
public class AdminStoreServiceImpl implements AdminStoreService {

    @Autowired
    private AdminStoreMapper adminStoreMapper;

    //지윤 26.07.21 추가: 대기중인 리뷰 삭제요청 목록
    @Override
    public List<AdminReviewReportVO> getPendingReviewReports() {
        return adminStoreMapper.selectPendingReviewReports();
    }

    //지윤 26.07.21 수정: FK(TB_REVIEW_REPORT.REVIEW_ID) 참조 때문에 리뷰를 먼저 지우면 ORA-02292 남
    //-> 순서 반드시 "참조 끊기(updateReportApproved) -> 리뷰 삭제(deleteReview)"
    @Override
    @Transactional
    public void approveReviewReport(Long reportId, Long reviewId, Long adminNo) {
        adminStoreMapper.updateReportApproved(reportId, adminNo);
        //지윤 26.07.22 추가: 같은 리뷰에 다른 신고(예: 유저신고 여러 건)가 더 걸려있으면 그것들의 REVIEW_ID도 마저 비워야
        //TB_REVIEW 삭제할 때 ORA-02292(자식 레코드 발견) 안 남
        adminStoreMapper.clearAllReportRefsByReviewId(reviewId);
        adminStoreMapper.deleteReview(reviewId);
    }

    //지윤 26.07.21 추가: 반려 - 리뷰는 그대로 두고 요청만 DONE 처리
    @Override
    public void rejectReviewReport(Long reportId, Long adminNo) {
        adminStoreMapper.updateReportDone(reportId, adminNo);
    }
}
