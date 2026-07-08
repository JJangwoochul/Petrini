/**
 * 역할: MypageBizService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: MypageBizService
 * - 사용: MypageBizMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.mypage.biz.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.file.mapper.FileMapper;
import com.petcare.petcare.file.vo.FileVO;
import com.petcare.petcare.mypage.biz.mapper.MypageBizMapper;
import com.petcare.petcare.mypage.biz.vo.MypageBizVO;

@Service
public class MypageBizServiceImpl implements MypageBizService {
    @Autowired
    private MypageBizMapper mypageBizMapper;

    @Autowired
    private FileMapper fileMapper;
    
    @Override
    @Transactional
    public void applyBusiness(MypageBizVO vo, List<FileVO> fileList) throws Exception {
        // 1) TB_BUSINESS INSERT (bizNo가 selectKey로 채번됨)
        // TB_BUSINESS INSERT (사업자 기본정보)
        mypageBizMapper.insertBusiness(vo);

        // 2) TB_BUSINESS_AUTH INSERT (위에서 채번된 bizNo 사용)
        //TB_BUSINESS_AUTH INSERT (승인요청, STATUS_CD = 'PENDING')
        mypageBizMapper.insertBusinessAuth(vo);

        // 3) TB_FILE INSERT (파일이 있을 때만)
        for (FileVO fv : fileList) {
            fv.setRefId(vo.getBizNo());
            fileMapper.insertFile(fv);
        }
    }

    @Override
    public MypageBizVO getBizAuthStatus(String bizId) throws Exception {
        return mypageBizMapper.selectBizAuthStatus(bizId);
    }
}
