/**
 * 역할: MypageAccountService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: MypageAccountService
 * - 사용: MypageAccountMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.mypage.account.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.mypage.account.mapper.MypageAccountMapper;

@Service
public class MypageAccountServiceImpl implements MypageAccountService {

    private static final Logger log = LoggerFactory.getLogger(MypageAccountServiceImpl.class);

    private final MypageAccountMapper mypageAccountMapper;
    private final BCryptPasswordEncoder passwordEncoder;

    public MypageAccountServiceImpl(MypageAccountMapper mypageAccountMapper,
                                     BCryptPasswordEncoder passwordEncoder) {
        this.mypageAccountMapper = mypageAccountMapper;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * HYJ 26.07.29 회원 탈퇴
     * [1] DB 에서 암호화된 비밀번호 조회
     * [2] 입력된 비밀번호와 비교
     * [3] 일치하면 STATUS_CD = 'WITHDRAWN'
     * [4] INSERT INTO TB_MEMBER_WITHDRAW
     */
    @Override
    @Transactional
    public String withdraw(Long memberNo, String password) {

        String storedPwd = mypageAccountMapper.selectPasswordByMemberNo(memberNo);
        if (storedPwd == null) {
            return "회원 정보를 찾을 수 없습니다.";
        }

        if (!passwordEncoder.matches(password, storedPwd)) {
            return "비밀번호가 일치하지 않습니다.";
        }

        mypageAccountMapper.updateStatusToWithdrawn(memberNo);
        mypageAccountMapper.insertMemberWithdraw(memberNo);
        return null;
    }

    /**
     * HYJ 26.07.29 7일 경과 탈퇴 회원 개인정보 삭제
     *
     * 삭제 범위:
     * - TB_MEMBER: 개인정보 익명화 (이름, 이메일, 전화번호 등 → NULL)
     * - TB_MEMBER_SOCIAL: 소셜 연동 삭제
     * - TB_PET: 반려동물 정보 삭제
     * - TB_MEMBER_AGREEMENT: 약관 동의 기록 삭제
     * - TB_MEMBER_WITHDRAW: 탈퇴회원 관리(맨마지막)
     */
    @Override
    @Transactional
    public int purgeExpiredWithdrawnMembers() {

        List<Long> memberNos = mypageAccountMapper.selectExpiredWithdrawnMemberNos();

        if (memberNos.isEmpty()) {
            return 0;
        }

        for (Long memberNo : memberNos) {
            // 관련 테이블 먼저 삭제 (FK 순서)
            mypageAccountMapper.deleteSocialByMemberNo(memberNo);
            mypageAccountMapper.deletePetsByMemberNo(memberNo);
            mypageAccountMapper.deleteAgreementsByMemberNo(memberNo);
            // TB_MEMBER 익명화 (삭제가 아닌 NULL 처리)
            mypageAccountMapper.anonymizeMember(memberNo);

            //HYJ 26.07.29 TB_MEMBER FK참조하는 테이블 확인 후 추가 필요
            //....

            // TB_MEMBER_WITHDRAW (탈퇴회원관리테이블 삭제)
            mypageAccountMapper.deleteMemberWithdrawByMemberNo(memberNo);

            log.info("탈퇴 회원 개인정보 삭제 완료: MEMBER_NO={}", memberNo);
        }

        log.info("총 {}명의 탈퇴 회원 개인정보 삭제 완료", memberNos.size());
        return memberNos.size();
    }
}
