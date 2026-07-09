/**
 * 역할: 관리자 사업자 승인·재능나눔 승인 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - admin/biz/list.jsp      사업자 승인 목록
 * - admin/biz/detail.jsp    사업자 신청 상세
 */

package com.petcare.petcare.admin.biz.service;

import java.util.List;
import java.util.Map;

import com.petcare.petcare.admin.biz.vo.AdminBizVO;
import com.petcare.petcare.file.vo.FileVO;

public interface AdminBizService {

    // 2026-07-09 장우철 — 사업자 승인 목록·상세·처리 API
    List<AdminBizVO> getBizApplyList(String statusCd);

    AdminBizVO getBizApplyDetail(Long bizNo);

    Map<String, Integer> getBizStatusCounts();

    List<FileVO> getBizAuthFiles(Long bizNo);

    List<FileVO> getBizLicenseFiles(Long bizNo);

    void approveBiz(Long bizNo);

    void rejectBiz(Long bizNo, String rejectReason);
}
