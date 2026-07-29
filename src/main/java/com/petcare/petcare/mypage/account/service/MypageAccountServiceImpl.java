/**
 * 역할: MypageAccountService 구현체 (@Service)
 */

package com.petcare.petcare.mypage.account.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.mypage.account.mapper.MypageAccountMapper;
import com.petcare.petcare.mypage.account.vo.MypageAccountVO;

@Service
public class MypageAccountServiceImpl implements MypageAccountService {

    @Autowired
    private MypageAccountMapper mypageAccountMapper;

    // 2026-07-28 박유정 — 회원정보 수정 화면용 프로필 조회
    @Override
    @Transactional(readOnly = true)
    public MypageAccountVO getMemberProfile(Long memberNo) {
        if (memberNo == null) {
            return null;
        }
        return mypageAccountMapper.selectMemberProfile(memberNo);
    }
}
