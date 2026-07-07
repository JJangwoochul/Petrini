/**
 * 역할: MemberAuthService 구현체 (@Service)
 *
 * 연결: MemberAuthMapper, PasswordEncoder
 */

package com.petcare.petcare.member.auth.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.petcare.petcare.member.auth.mapper.MemberAuthMapper;
import com.petcare.petcare.member.auth.vo.AdminAuthVO;
import com.petcare.petcare.member.auth.vo.EmailCheckResultVO;
import com.petcare.petcare.member.auth.vo.MemberAuthVO;
import com.petcare.petcare.member.auth.vo.MemberRegisterVO;
import com.petcare.petcare.member.vo.MemberVO;

@Service
public class MemberAuthServiceImpl implements MemberAuthService {

    private final MemberAuthMapper memberAuthMapper;
    private final PasswordEncoder passwordEncoder;

    public MemberAuthServiceImpl(MemberAuthMapper memberAuthMapper,
                                 PasswordEncoder passwordEncoder) {
        this.memberAuthMapper = memberAuthMapper;
        this.passwordEncoder = passwordEncoder;
    }

    // 2026/07/06 장우철 — login(로그인)

    // 2026/07/07 장우철 — 관리자 로그인 확장
    // 변경 이유:
    // - 관리자도 별도 /admin/login 이 아니라 유저 홈(/login)에서 동일하게 로그인.
    // - TB_MEMBER 에 없으면 TB_ADMIN 을 조회해서, 관리자면 세션 role=ADMIN 으로 반환.
    // - 관리자 여부는 "어느 테이블에서 조회됐는지"로 구분 (TB_ADMIN 유지, ADMIN_NO FK 보존).
    @Override
    public MemberVO login(String loginId, String rawPassword) {

        String id = loginId.trim();

        // [1] 먼저 일반 회원 조회 (이메일 = MEMBER_ID 또는 EMAIL)
        MemberAuthVO found = memberAuthMapper.selectMemberByLoginId(id);

        // [2] 회원이면 기존 회원 로그인 처리 (role=USER)
        if (found != null) {

            // [2-1] 정상 회원만 로그인 허용 (STATUS_CD = NORMAL)
            if (!"NORMAL".equals(found.getStatusCd())) {
                return null;
            }

            // [2-2] BCrypt 비밀번호 검증
            if (found.getMemberPwd() == null
                    || !passwordEncoder.matches(rawPassword, found.getMemberPwd())) {
                return null;
            }

            // [2-3] 로그인 성공 → 최종 로그인 일시 갱신
            memberAuthMapper.updateLastLoginDate(found.getMemberNo());

            // [2-4] 세션용 MemberVO 변환 (비밀번호는 세션에 넣지 않음)
            MemberVO sessionMember = new MemberVO();
            sessionMember.setMemberNo(found.getMemberNo());
            sessionMember.setMemberId(found.getMemberId());
            sessionMember.setEmail(found.getEmail());
            sessionMember.setMemberName(found.getMemberName());
            sessionMember.setNickname(found.getNickname());
            sessionMember.setRole("USER");
            return sessionMember;
        }

        // [3] 회원이 아니면 관리자(TB_ADMIN) 조회 (ADMIN_ID 는 이메일 형식 아님)
        AdminAuthVO admin = memberAuthMapper.selectAdminByLoginId(id);
        if (admin == null) {
            return null; // 회원도 관리자도 아님 → 로그인 실패
        }

        // [3-1] 정상 관리자만 로그인 허용 (STATUS_CD = NORMAL)
        if (!"NORMAL".equals(admin.getStatusCd())) {
            return null;
        }

        // [3-2] BCrypt 비밀번호 검증 (관리자도 회원과 동일한 PasswordEncoder 사용)
        if (admin.getAdminPwd() == null
                || !passwordEncoder.matches(rawPassword, admin.getAdminPwd())) {
            return null;
        }

        // [3-3] 세션용 MemberVO 변환 — 관리자 (role=ADMIN)
        MemberVO sessionAdmin = new MemberVO();
        sessionAdmin.setAdminNo(admin.getAdminNo());
        sessionAdmin.setMemberId(admin.getAdminId());
        sessionAdmin.setMemberName(admin.getAdminName());
        sessionAdmin.setRole("ADMIN");
        return sessionAdmin;
    }

    /* ── [변경 전] login (2026/07/06) — TB_MEMBER 단독 조회, role=USER 고정 ──
     * 변경 이유: 관리자도 유저 홈(/login)에서 로그인할 수 있도록 TB_ADMIN 조회 분기 추가
     *
    @Override
    public MemberVO login(String loginId, String rawPassword) {

        // [1] DB에서 회원 조회 (이메일 = MEMBER_ID 또는 EMAIL)
        MemberAuthVO found = memberAuthMapper.selectMemberByLoginId(loginId.trim());
        if (found == null) {
            return null;
        }

        // [2] 정상 회원만 로그인 허용 (STATUS_CD = NORMAL)
        if (!"NORMAL".equals(found.getStatusCd())) {
            return null;
        }

        // [3] BCrypt 비밀번호 검증
        if (found.getMemberPwd() == null
                || !passwordEncoder.matches(rawPassword, found.getMemberPwd())) {
            return null;
        }

        // [4] 로그인 성공 → 최종 로그인 일시 갱신
        memberAuthMapper.updateLastLoginDate(found.getMemberNo());

        // [5] 세션용 MemberVO 변환 (비밀번호는 세션에 넣지 않음)
        MemberVO sessionMember = new MemberVO();
        sessionMember.setMemberNo(found.getMemberNo());
        sessionMember.setMemberId(found.getMemberId());
        sessionMember.setEmail(found.getEmail());
        sessionMember.setMemberName(found.getMemberName());
        sessionMember.setNickname(found.getNickname());
        sessionMember.setRole("USER");
        return sessionMember;
    }
     */

    // 2026/07/07 장우철 — join(회원가입)

    /** join.jsp 와 동일한 비밀번호 규칙: 8자 이상 + 영문 + 숫자 + 특수문자 */
    private static final String PASSWORD_PATTERN =
            "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{8,}$";

    private static final String EMAIL_PATTERN =
            "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";

    /** TB_MEMBER_AGREEMENT.TERMS_VER — 시드 더미와 동일 */
    private static final String TERMS_VERSION = "1.0";

    /**
     * join — checkEmail
     * 이메일 형식 검증 후 DB 중복 여부 반환 (Controller 는 JSON 그대로 전달)
     */
    @Override
    @Transactional(readOnly = true)
    public EmailCheckResultVO checkEmail(String email) {
        if (email == null || email.isBlank()) {
            return new EmailCheckResultVO(false, "이메일을 입력해 주세요.");
        }
        String trimmed = email.trim();
        if (!trimmed.matches(EMAIL_PATTERN)) {
            return new EmailCheckResultVO(false, "올바른 이메일 형식이 아닙니다.");
        }
        if (memberAuthMapper.countMemberByEmail(trimmed) > 0) {
            return new EmailCheckResultVO(false, "이미 사용 중인 이메일입니다.");
        }
        return new EmailCheckResultVO(true, "사용 가능한 이메일입니다.");
    }

    /**
     * join — register
     * 흐름: 검증 → 중복재확인 → BCrypt → TB_MEMBER → TB_MEMBER_AGREEMENT → (선택) TB_PET
     * @Transactional : 중간 실패 시 INSERT 전부 롤백
     */
    @Override
    @Transactional
    public String register(MemberRegisterVO vo) {
        if (vo == null) {
            return "invalid";
        }

        // [1] 서버 측 유효성 검증 (join.jsp 우회 방지)
        String validateError = validateRegister(vo);
        if (validateError != null) {
            return validateError;
        }

        String email = vo.getEmail().trim();

        // [2] 이메일 중복 재확인 (Ajax 없이 POST 만 보내는 경우 차단)
        if (memberAuthMapper.countMemberByEmail(email) > 0) {
            return "duplicate";
        }

        // [3] 평문 비밀번호 → BCrypt 해시 (로그인 때와 동일 PasswordEncoder 사용)
        vo.setPassword(passwordEncoder.encode(vo.getPassword()));

        // [4] 마케팅 Y/N — TB_MEMBER.MARKETING_YN + 약관 행에 사용
        vo.setAgreeMarketing(toYn(vo.getAgreeMarketing()));

        // [5] TB_MEMBER INSERT — memberNo 는 XML selectKey 로 vo 에 세팅됨
        memberAuthMapper.insertMember(vo);
        Long memberNo = vo.getMemberNo();

        // [6] TB_MEMBER_AGREEMENT — 필수·선택 약관 각 1행 (AGREE_ID 는 전역 시퀀스)
        saveAgreement(memberNo, "SERVICE", vo.getAgreeService());
        saveAgreement(memberNo, "PRIVACY", vo.getAgreePrivacy());
        saveAgreement(memberNo, "LOCATION", vo.getAgreeLocation());
        saveAgreement(memberNo, "MARKETING", vo.getAgreeMarketing());

        // [7] TB_PET — petName 이 있을 때만 (없으면 Step3 스킵과 동일)
        if (hasPetInfo(vo)) {
            vo.setPetType(mapPetSpecies(vo.getPetType()));
            memberAuthMapper.insertPet(vo);
        }

        return null;
    }

    // ── 2026/07/07 장우철 — join(회원가입) private 헬퍼 ──

    /** 가입 폼 전체 검증 — 문제 있으면 오류 코드, 없으면 null */
    private String validateRegister(MemberRegisterVO vo) {
        if (vo.getMemberName() == null || vo.getMemberName().isBlank()) {
            return "name";
        }
        if (vo.getEmail() == null || !vo.getEmail().trim().matches(EMAIL_PATTERN)) {
            return "email";
        }
        if (vo.getPassword() == null || !vo.getPassword().matches(PASSWORD_PATTERN)) {
            return "password";
        }
        if (vo.getPasswordConfirm() == null
                || !vo.getPassword().equals(vo.getPasswordConfirm())) {
            return "password_mismatch";
        }
        if (vo.getPhone() == null || !vo.getPhone().matches("^01[0-9]-\\d{4}-\\d{4}$")) {
            return "phone";
        }
        if (!isAgreed(vo.getAgreeService()) || !isAgreed(vo.getAgreePrivacy())) {
            return "terms";
        }
        return null;
    }

    /** 체크박스 값이 동의인지 (Y / on / true) */
    private boolean isAgreed(String value) {
        if (value == null) {
            return false;
        }
        String v = value.trim();
        return "Y".equalsIgnoreCase(v)
                || "on".equalsIgnoreCase(v)
                || "true".equalsIgnoreCase(v);
    }

    /** 동의 여부를 DB용 Y/N 문자열로 */
    private String toYn(String value) {
        return isAgreed(value) ? "Y" : "N";
    }

    /** 약관 1건 INSERT — 동의 안 한 선택 약관도 N 으로 이력 남김 */
    private void saveAgreement(Long memberNo, String termsType, String agreeValue) {
        memberAuthMapper.insertMemberAgreement(
                memberNo, termsType, TERMS_VERSION, toYn(agreeValue));
    }

    /** petName 이 비어 있지 않으면 펫 등록 */
    private boolean hasPetInfo(MemberRegisterVO vo) {
        return vo.getPetName() != null && !vo.getPetName().isBlank();
    }

    /** join.jsp petType(dog/cat/etc) → TB_PET.SPECIES(DOG/CAT/ETC) */
    private String mapPetSpecies(String petType) {
        if (petType == null) {
            return "ETC";
        }
        return switch (petType.toLowerCase()) {
            case "dog" -> "DOG";
            case "cat" -> "CAT";
            default -> "ETC";
        };
    }
}
