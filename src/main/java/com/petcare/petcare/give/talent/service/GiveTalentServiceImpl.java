/**
 * 역할: GiveTalentService 구현체 (@Service)
 *
 * - 박유정 / 2026-07-13~14
 *
 * 연결
 * - DB: GiveTalentMapper
 */

package com.petcare.petcare.give.talent.service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.petcare.petcare.give.talent.mapper.GiveTalentMapper;
import com.petcare.petcare.give.talent.vo.GiveTalentVO;

@Service
public class GiveTalentServiceImpl implements GiveTalentService {

    private final GiveTalentMapper giveTalentMapper;

    public GiveTalentServiceImpl(GiveTalentMapper giveTalentMapper) {
        this.giveTalentMapper = giveTalentMapper;
    }

    // ── 사용자 목록·상세 (2026-07-13) ─────────────────────────────

    @Override
    public List<GiveTalentVO> getApprovedTalentList(String talentType) {
        return giveTalentMapper.selectApprovedTalentList(talentType);
    }

    @Override
    public GiveTalentVO getTalentDetail(long talentId) {
        return giveTalentMapper.selectTalentDetail(talentId);
    }

    // ── 관리자 승인 화면 (2026-07-13) ─────────────────────────────

    @Override
    public List<GiveTalentVO> getTalentListByStatus(String statusCd) {
        return giveTalentMapper.selectTalentListByStatus(statusCd);
    }

    @Override
    public Map<String, Integer> getTalentStatusCounts() {
        Map<String, Integer> counts = new LinkedHashMap<>();
        counts.put("PENDING", giveTalentMapper.countTalentByStatus("PENDING"));
        counts.put("APPROVED", giveTalentMapper.countTalentByStatus("APPROVED"));
        counts.put("REJECTED", giveTalentMapper.countTalentByStatus("REJECTED"));
        counts.put("DONE", giveTalentMapper.countTalentByStatus("DONE"));
        return counts;
    }

    @Override
    public void approveTalent(long talentId, long adminNo) {
        updateStatus(talentId, "APPROVED", null, adminNo);
    }

    @Override
    public void rejectTalent(long talentId, String rejectReason, long adminNo) {
        updateStatus(talentId, "REJECTED", rejectReason, adminNo);
    }

    @Override
    public void completeTalent(long talentId, long adminNo) {
        updateStatus(talentId, "DONE", null, adminNo);
    }

    private void updateStatus(long talentId, String statusCd, String rejectReason, long adminNo) {
        GiveTalentVO vo = new GiveTalentVO();
        vo.setTalentId(talentId);
        vo.setStatusCd(statusCd);
        vo.setRejectReason(rejectReason);
        vo.setAdminNo(adminNo);
        giveTalentMapper.updateTalentStatus(vo);
    }

    // ── 사업자 신청 (2026-07-14 STEP 4 — 병원) ───────────────────

    @Override
    public List<GiveTalentVO> getTalentListByBizId(String bizId) {
        return giveTalentMapper.selectTalentListByBizId(bizId);
    }

    // 2026-07-14 박유정 — 사업자 재능나눔 신청
    // 이유: biz/hospital/talent.jsp POST → TB_TALENT PENDING 저장 → admin/biz/talent 승인 대기 노출
    @Override
    public void applyTalent(String bizId, GiveTalentVO vo) {
        // [1] TB_BUSINESS STATUS_CD=APPROVED 인 사업자만 신청 가능
        if (!"APPROVED".equals(giveTalentMapper.selectBusinessStatusByBizId(bizId))) {
            throw new IllegalStateException("BIZ_NOT_APPROVED");
        }

        // [2] 로그인 bizId(=MEMBER_ID) → BIZ_NO FK 조회
        Long bizNo = giveTalentMapper.selectBizNoByBizId(bizId);
        if (bizNo == null) {
            throw new IllegalStateException("BIZ_NOT_FOUND");
        }

        // [3] PENDING 으로 INSERT (관리자 승인 후 APPROVED → /give/talent/list 노출)
        vo.setBizNo(bizNo);
        vo.setStatusCd("PENDING");
        vo.setCurrentCnt(0);
        giveTalentMapper.insertTalent(vo);
    }
}
