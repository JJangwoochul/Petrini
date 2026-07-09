/**
 * 역할: AdminBizService 구현체 (@Service)
 *
 * 연결
 * - implements: AdminBizService
 * - 사용: AdminBizMapper, FileMapper
 */

package com.petcare.petcare.admin.biz.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.admin.biz.mapper.AdminBizMapper;
import com.petcare.petcare.admin.biz.vo.AdminBizVO;
import com.petcare.petcare.file.mapper.FileMapper;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;

@Service
public class AdminBizServiceImpl implements AdminBizService {

    @Autowired
    private AdminBizMapper adminBizMapper;

    // 2026-07-09 장우철 — 신청 서류 조회용 (MypageBiz apply 시 REF_TYPE=BIZ_AUTH / BIZ_LICENSE)
    // 이유: 상세 화면에서 TB_FILE 메타를 그대로 재사용 (FK 없이 refType+refId 패턴)
    @Autowired
    private FileMapper fileMapper;

    // 2026-07-09 장우철 — 반려 알림 발송 (TB_NOTIFICATION)
    // 이유: rejectBiz 트랜잭션 안에서 해당 유저에게만 알림 INSERT
    @Autowired
    private MypageNotifyService mypageNotifyService;

    @Override
    public List<AdminBizVO> getBizApplyList(String statusCd) {
        return adminBizMapper.selectBizApplyList(statusCd);
    }

    @Override
    public AdminBizVO getBizApplyDetail(Long bizNo) {
        return adminBizMapper.selectBizApplyDetail(bizNo);
    }

    @Override
    public Map<String, Integer> getBizStatusCounts() {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("PENDING", adminBizMapper.countBizApplyByStatus("PENDING"));
        counts.put("APPROVED", adminBizMapper.countBizApplyByStatus("APPROVED"));
        counts.put("REJECTED", adminBizMapper.countBizApplyByStatus("REJECTED"));
        return counts;
    }

    @Override
    public List<FileVO> getBizAuthFiles(Long bizNo) {
        return selectFilesByRef("BIZ_AUTH", bizNo);
    }

    @Override
    public List<FileVO> getBizLicenseFiles(Long bizNo) {
        return selectFilesByRef("BIZ_LICENSE", bizNo);
    }

    private List<FileVO> selectFilesByRef(String refType, Long bizNo) {
        try {
            FileVO query = new FileVO();
            query.setRefType(refType);
            query.setRefId(bizNo);
            return fileMapper.selectFileList(query);
        } catch (Exception e) {
            throw new IllegalStateException("FILE_LIST_FAILED", e);
        }
    }

    // 2026-07-09 장우철 — 승인 처리 (TB_BUSINESS + TB_BUSINESS_AUTH 동시 갱신)
    // 이유: USER 신청(applyBusiness)이 두 테이블에 PENDING 으로 넣으므로 승인도 쌍으로 맞춤
    // 후속: 로그인 시 TB_BUSINESS APPROVED 이면 세션 role=BIZ 세팅은 MemberAuth 쪽 별도 작업
    @Override
    @Transactional
    public void approveBiz(Long bizNo) {
        AdminBizVO biz = requirePendingBiz(bizNo);
        adminBizMapper.updateBusinessStatus(biz.getBizNo(), "APPROVED");
        adminBizMapper.updateBusinessAuthStatus(biz.getBizNo(), "APPROVED");
    }

    // 2026-07-09 장우철 — [변경 후] 반려 처리 + 사유 저장 + 유저 알림
    // 이유: DATABASE_TABLE.sql TB_BUSINESS_AUTH.REJECT_REASON / TB_NOTIFICATION 활용
    @Override
    @Transactional
    public void rejectBiz(Long bizNo, String rejectReason) {
        if (rejectReason == null || rejectReason.isBlank()) {
            throw new IllegalArgumentException("REJECT_REASON_REQUIRED");
        }
        AdminBizVO biz = requirePendingBiz(bizNo);
        String reason = rejectReason.trim();

        adminBizMapper.updateBusinessStatus(biz.getBizNo(), "REJECTED");
        adminBizMapper.updateBusinessAuthReject(biz.getBizNo(), "REJECTED", reason);

        Long memberNo = adminBizMapper.selectMemberNoByBizId(biz.getBizId());
        if (memberNo != null) {
            mypageNotifyService.sendBizRejectNotification(memberNo, biz.getBizName(), reason);
        }

        /* [변경 전] 2026-07-09 장우철 — STATUS 만 REJECTED, 사유·알림 없음
        adminBizMapper.updateBusinessStatus(biz.getBizNo(), "REJECTED");
        adminBizMapper.updateBusinessAuthStatus(biz.getBizNo(), "REJECTED");
        */
    }

    private AdminBizVO requirePendingBiz(Long bizNo) {
        if (bizNo == null) {
            throw new IllegalArgumentException("BIZ_NO_REQUIRED");
        }
        AdminBizVO biz = adminBizMapper.selectBizApplyDetail(bizNo);
        if (biz == null) {
            throw new IllegalArgumentException("BIZ_NOT_FOUND");
        }
        if (!"PENDING".equals(biz.getStatusCd())) {
            throw new IllegalStateException("BIZ_NOT_PENDING");
        }
        return biz;
    }
}
