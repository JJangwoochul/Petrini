/**
 * 역할: MemberAuthService 구현체 (@Service)
 *
 * 로그인 처리 흐름
 * 1. TB_MEMBER 조회 (Mapper)
 * 2. 회원 상태·비밀번호 검증 (BCrypt)
 * 3. 최종 로그인 일시 UPDATE
 * 4. 세션용 MemberVO로 변환 후 반환
 *
 * 연결
 * - MemberAuthMapper, PasswordEncoder
 */

package com.petcare.petcare.member.auth.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.petcare.petcare.member.auth.mapper.MemberAuthMapper;
import com.petcare.petcare.member.auth.vo.MemberAuthVO;
import com.petcare.petcare.member.vo.MemberVO;
/* 2026/07/06 장우철 */
@Service
public class MemberAuthServiceImpl implements MemberAuthService {

    private final MemberAuthMapper memberAuthMapper;
    private final PasswordEncoder passwordEncoder;

    /** Mapper(DB), PasswordEncoder(BCrypt) 생성자 주입 */
    public MemberAuthServiceImpl(MemberAuthMapper memberAuthMapper,
                                 PasswordEncoder passwordEncoder) {
        this.memberAuthMapper = memberAuthMapper;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public MemberVO login(String loginId, String rawPassword) {

        // ── 1. DB에서 회원 조회 (이메일 = MEMBER_ID 또는 EMAIL) ──
        MemberAuthVO found = memberAuthMapper.selectMemberByLoginId(loginId.trim());
        if (found == null) {
            return null;    // 존재하지 않는 아이디
        }

        // ── 2. 정상 회원만 로그인 허용 (정지·탈퇴 차단) ──
        if (!"NORMAL".equals(found.getStatusCd())) {
            return null;
        }

        // ── 3. BCrypt 비밀번호 검증 (평문 vs DB 해시) ──
        if (found.getMemberPwd() == null
                || !passwordEncoder.matches(rawPassword, found.getMemberPwd())) {
            return null;    // 비밀번호 불일치
        }

        // ── 4. 로그인 성공 → 최종 로그인 일시 갱신 ──
        memberAuthMapper.updateLastLoginDate(found.getMemberNo());

        // ── 5. 세션용 MemberVO 변환 (비밀번호는 세션에 넣지 않음) ──
        MemberVO sessionMember = new MemberVO();
        sessionMember.setMemberNo(found.getMemberNo());
        sessionMember.setMemberId(found.getMemberId());
        sessionMember.setEmail(found.getEmail());
        sessionMember.setMemberName(found.getMemberName());
        sessionMember.setNickname(found.getNickname());
        sessionMember.setRole("USER");   // 일반 회원 세션 역할 (header·마이페이지 등에서 사용)
        return sessionMember;
    }
}
