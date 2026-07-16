/**
 * 역할: 재능나눔 비즈니스 로직 (interface)
 *
 * - 박유정 / 2026-07-13~14
 *
 * 담당 화면
 * - give/talent/list.jsp        사용자 재능나눔 목록 (APPROVED)
 * - give/talent/detail.jsp      사용자 재능나눔 상세
 * - admin/biz/talent.jsp        관리자 승인·반려
 * - biz/hospital/talent.jsp     사업자 재능나눔 신청 (병원만 DB 연동)
 *
 * 연결
 * - 구현: GiveTalentServiceImpl
 * - DB: GiveTalentMapper
 *
 * 참고 테이블
 * - TB_TALENT (STATUS: PENDING / APPROVED / REJECTED / DONE)
 */

package com.petcare.petcare.give.talent.service;

import java.util.List;
import java.util.Map;

import com.petcare.petcare.give.talent.vo.GiveTalentVO;

public interface GiveTalentService {

    // ── 사용자 목록·상세 (2026-07-13) ─────────────────────────────

    List<GiveTalentVO> getApprovedTalentList(String talentType);

    GiveTalentVO getTalentDetail(long talentId);

    // ── 관리자 승인 화면 (2026-07-13) ─────────────────────────────

    List<GiveTalentVO> getTalentListByStatus(String statusCd);

    Map<String, Integer> getTalentStatusCounts();

    void approveTalent(long talentId, long adminNo);

    void rejectTalent(long talentId, String rejectReason, long adminNo);

    void completeTalent(long talentId, long adminNo);

    // ── 사업자 신청 (2026-07-14 STEP 4 — 병원) ───────────────────

    /** 사업자 재능나눔 신청 — TB_TALENT INSERT (STATUS_CD=PENDING) */
    void applyTalent(String bizId, GiveTalentVO vo);

    /** 사업자 본인 재능나눔 이력 — biz/hospital/talent.jsp 하단 테이블 */
    List<GiveTalentVO> getTalentListByBizId(String bizId);
}
