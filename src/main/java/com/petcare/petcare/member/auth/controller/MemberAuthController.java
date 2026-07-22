/**
 * 역할: 회원 로그인·가입 URL 처리 → Service 호출 → JSP/리다이렉트 반환
 *
 * - 박유정 / 2026-07-22 — 정지 회원 로그인 후 /member/cs 리다이렉트, 탈퇴 로그인 메시지
 *
 * 연결
 * - Service: MemberAuthService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.member.auth.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.petcare.petcare.member.auth.exception.MemberLoginBlockedException;
import com.petcare.petcare.member.auth.service.EmailService;
import com.petcare.petcare.member.auth.service.KakaoOAuthService;
import com.petcare.petcare.member.auth.service.MemberAuthService;
import com.petcare.petcare.member.auth.vo.EmailCheckResultVO;
import com.petcare.petcare.member.auth.vo.KakaoUserVO;
import com.petcare.petcare.member.auth.vo.MemberRegisterVO;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("memberController")
public class MemberAuthController {

    //HYJ 26.07.15 카카오로그인
    @Autowired
    KakaoOAuthService kakaoOAuthService;

    //HYJ 26.07.15 이메일 인증
    @Autowired
    EmailService emailService;    

    private final MemberAuthService memberAuthService;

	//HYJ 26.07.15 카카오 로그인 추가
    public MemberAuthController(MemberAuthService memberAuthService,
                                KakaoOAuthService kakaoOAuthService) {
        this.memberAuthService = memberAuthService;
        this.kakaoOAuthService = kakaoOAuthService;
    }

    // 2026/07/06 장우철 — login(로그인)

    /** login — 화면 (GET /login) */
    @GetMapping("/login")
    public String login() {
        return "member/login";
    }

    /** login — 처리 (POST /login) */
    @PostMapping("/login")
    public String loginPost(
            @RequestParam(required = false) String loginId,
            @RequestParam(required = false) String loginPw,
            @RequestParam(required = false) String redirect,
            HttpSession session) {

        // [1] 필수값 검증 — 아이디·비밀번호 빈 값이면 로그인 페이지로 (error=empty)
        if (loginId == null || loginId.isBlank() || loginPw == null || loginPw.isBlank()) {
            return "redirect:/login?error=empty";
        }

        // [2] Service 호출 — TB_MEMBER 조회 + BCrypt 검증, 성공 시 세션용 MemberVO 반환
        try {
            MemberVO member = memberAuthService.login(loginId, loginPw);
            if (member == null) {
                // 회원 없음 / 비밀번호 틀림 → error=invalid
                return "redirect:/login?error=invalid";
            }

            // [3] 로그인 성공 — 세션에 회원 정보 저장 (header.jsp에서 memberInfo로 로그아웃 표시)
            session.setAttribute("memberInfo", member);

            // 2026-07-22 박유정 — 정지 회원은 고객센터로
            if("SUSPENDED".equals(member.getStatus())) {
                return "redirect:/member/cs";
            }

            // [4] 로그인 전 가려던 페이지가 있으면 해당 URL로 이동
            // "//" 로 시작하는 외부 URL 차단 (오픈 리다이렉트 방지)
            if (redirect != null && !redirect.isBlank() && redirect.startsWith("/") && !redirect.startsWith("//")) {
                return "redirect:" + redirect;
            }
            return "redirect:/";
        } catch (MemberLoginBlockedException e) {
            // 2026-07-22 박유정 — 정지·탈퇴 회원 전용 메시지
            return "redirect:/login?error=" + mapLoginBlockedError(e.getErrorCode());
        }

        /* ── [변경 전] 더미 로그인 ──
         * DB·비밀번호 검증 없이 입력한 이메일만으로 세션을 만들던 코드
         * 변경 이유: TB_MEMBER 실데이터 + BCrypt 검증으로 전환, 로직은 Service로 분리
         *
        String id = loginId.trim();

        MemberVO member = new MemberVO();
        member.setMemberId(id);
        member.setEmail(id);
        member.setMemberName(resolveDisplayName(id));
        member.setRole("USER");
        session.setAttribute("memberInfo", member);

        if (redirect != null && !redirect.isBlank() && redirect.startsWith("/") && !redirect.startsWith("//")) {
            return "redirect:" + redirect;
        }
        return "redirect:/";
         */
    }

    /* ── [변경 전] resolveDisplayName ──
     * 더미 로그인 때 이메일 @ 앞 문자열을 이름으로 쓰던 헬퍼
     * 변경 이유: DB에서 MEMBER_NAME, NICKNAME을 조회하므로 불필요
     *
    private String resolveDisplayName(String loginId) {
        int at = loginId.indexOf('@');
        if (at > 0) {
            return loginId.substring(0, at);
        }
        return loginId;
    }
     */

   // HYJ 26.07.15 — 카카오 로그인

    /**
     * 카카오 로그인 — 카카오 인가 페이지로 리다이렉트
     * login.jsp "카카오로 시작하기" 버튼 → 이 URL 호출
     */
    @GetMapping("/oauth/kakao")
    public String kakaoLogin() {
        return "redirect:" + kakaoOAuthService.buildAuthorizeUrl();
    }

    /**
     * 카카오 콜백 — 인가 코드 수신 → 토큰 교환 → 사용자 정보 → 로그인/연동
     * 카카오 디벨로퍼 > Redirect URI 에 등록한 주소
     */
    @GetMapping("/oauth/kakao/callback")
    public String kakaoCallback(
            @RequestParam(required = false) String code,
            @RequestParam(required = false) String error,
            HttpSession session) {

        // [1] 사용자가 카카오 로그인을 취소한 경우
        if (error != null || code == null || code.isBlank()) {
            return "redirect:/login?error=kakao_cancel";
        }

        // [2] 인가 코드 → 액세스 토큰 교환
        String accessToken = kakaoOAuthService.getAccessToken(code);
        if (accessToken == null) {
            return "redirect:/login?error=kakao_token";
        }

        // [3] 액세스 토큰 → 카카오 사용자 정보 조회
        KakaoUserVO kakaoUser = kakaoOAuthService.getUserInfo(accessToken);
        if (kakaoUser == null) {
            return "redirect:/login?error=kakao_user";
        }

        // [4] 기존 회원 조회 + 연동
        try {
            MemberVO member = memberAuthService.kakaoLogin(kakaoUser);

            // [5] 가입된 회원이 아니면 → 카카오 정보를 세션에 담고 회원가입 페이지로 이동
            if (member == null) {
                session.setAttribute("kakaoUserInfo", kakaoUser);
                return "redirect:/join";
            }
            session.setAttribute("memberInfo", member);
            
            // 2026-07-22 박유정 — 정지 회원은 고객센터로
            if("SUSPENDED".equals(member.getStatus())) {
                return "redirect:/member/cs";
            }
            return "redirect:/";
        } catch (MemberLoginBlockedException e) {
            // 2026-07-22 박유정 — 카카오 로그인 탈퇴 회원 차단
            return "redirect:/login?error=" + mapLoginBlockedError(e.getErrorCode());
        }
    }
    
    /** join — 화면 (GET /join) */
    @GetMapping("/join")
    public String join() {
        return "member/join";
    }

    // 2026/07/07 장우철 — join(회원가입)

    /**
     * join — 이메일 중복 확인 (GET /join/check-email)
     * join.jsp [중복 확인] Ajax → JSON { available, message }
     * SQL·검증은 Service, Controller 는 결과만 반환
     */
    @GetMapping("/join/check-email")
    @ResponseBody
    public EmailCheckResultVO checkEmail(@RequestParam String email) {
        return memberAuthService.checkEmail(email);
    }

    /**
     * join — 아이디 중복 확인 (GET /join/check-id)
     */
    @GetMapping("/join/check-id")
    @ResponseBody
    public EmailCheckResultVO checkMemberId(@RequestParam String memberId) {
        return memberAuthService.checkMemberId(memberId);
    }

       // 2026/07/15 — 이메일 인증

    /**
     * join — 인증번호 발송 (POST /join/send-code)
     * 이메일 중복 확인 통과 후 인증번호 메일 발송
     * 인증번호와 만료시간을 세션에 저장
     */
    @PostMapping("/join/send-code")
    @ResponseBody
    public EmailCheckResultVO sendCode(@RequestParam String email, HttpSession session) {

        // 이메일 형식 검증
        if (email == null || !email.trim().matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return new EmailCheckResultVO(false, "올바른 이메일 형식이 아닙니다.");
        }

        try {
            String code = emailService.generateCode();
            emailService.sendVerificationEmail(email.trim(), code);

            // 세션에 인증번호 + 만료시간(5분) 저장
            session.setAttribute("emailVerifyCode", code);
            session.setAttribute("emailVerifyEmail", email.trim());
            session.setAttribute("emailVerifyExpire", System.currentTimeMillis() + (5 * 60 * 1000));

            return new EmailCheckResultVO(true, "인증번호가 발송되었습니다.");
        } catch (Exception e) {
            System.out.println("오류" + e);
            return new EmailCheckResultVO(false, "메일 발송 실패: " + e.getMessage());
        }
    }

    /**
     * join — 인증번호 확인 (POST /join/verify-code)
     * 사용자가 입력한 인증번호와 세션 값 비교
     */
    @PostMapping("/join/verify-code")
    @ResponseBody
    public EmailCheckResultVO verifyCode(@RequestParam String email,
                                         @RequestParam String code,
                                         HttpSession session) {

        String savedCode  = (String) session.getAttribute("emailVerifyCode");
        String savedEmail = (String) session.getAttribute("emailVerifyEmail");
        Long   expireTime = (Long)   session.getAttribute("emailVerifyExpire");

        // 세션에 인증 정보가 없음
        if (savedCode == null || savedEmail == null || expireTime == null) {
            return new EmailCheckResultVO(false, "인증번호를 먼저 발송해 주세요.");
        }

        // 만료 확인
        if (System.currentTimeMillis() > expireTime) {
            session.removeAttribute("emailVerifyCode");
            session.removeAttribute("emailVerifyEmail");
            session.removeAttribute("emailVerifyExpire");
            return new EmailCheckResultVO(false, "인증번호가 만료되었습니다. 다시 발송해 주세요.");
        }

        // 이메일 일치 확인
        if (!savedEmail.equals(email.trim())) {
            return new EmailCheckResultVO(false, "인증 요청한 이메일과 다릅니다.");
        }

        // 인증번호 비교
        if (!savedCode.equals(code.trim())) {
            return new EmailCheckResultVO(false, "인증번호가 일치하지 않습니다.");
        }

        // 인증 성공 → 세션에 인증 완료 표시
        session.setAttribute("emailVerified", true);
        session.setAttribute("emailVerifiedAddr", email.trim());
        return new EmailCheckResultVO(true, "이메일 인증이 완료되었습니다.");
    }

    /**
     * join — 가입 처리 (POST /join)
     * join.jsp [가입 완료] FormData → MemberRegisterVO 자동 매핑
     * 성공: "OK" / 실패: "ERROR:코드" (join.jsp 에서 분기 — JSP 수정은 직접 적용)
     * HYJ 26.07.15 — 카카오 → 회원가입 흐름: 가입 성공 후 세션의 kakaoUserInfo 로 SOCIAL_ID 연동
     */
    @PostMapping("/join")
    @ResponseBody
    public String joinPost(MemberRegisterVO vo, HttpSession session) {

        // 카카오 → 회원가입 흐름이면 socialId 를 VO 에 담아서 register() 에서 함께 처리
        KakaoUserVO kakaoUser = (KakaoUserVO) session.getAttribute("kakaoUserInfo");
        if (kakaoUser != null) {
            vo.setSocialId(kakaoUser.getKakaoId());
        }

        String error = memberAuthService.register(vo);
        if (error != null) {
            return "ERROR:" + error;
        }

        // 세션 정리
        if (kakaoUser != null) {
            session.removeAttribute("kakaoUserInfo");
        }

        return "OK";
    }

    // 2026/07/06 장우철 — login(로그아웃)

    // ── 로그아웃 ──
    // 서버 세션만 제거 (브라우저 자동로그인용 sessionStorage는 login.jsp에서 별도 처리 예정)
    @GetMapping("/member/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // ── 아래 /test* URL: 개발용 빠른 로그인 (DB 없이 세션만 세팅) ──
    // 사업자·관리자 화면 개발 시 사용, 운영 전 제거 또는 비활성화 검토

    @GetMapping("/testUser")
    public String testLogin(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("user");
        member.setMemberName("테스트");
        member.setRole("USER");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testHospital")
    public String testHospital(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("hospital");
        member.setMemberName("수의사");
        member.setRole("BIZ");
        member.setBizType("HOSPITAL");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testStay")
    public String testStay(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("stay");
        member.setMemberName("숙박");
        member.setRole("BIZ");
        member.setBizType("STAY");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testRestaurant")
    public String testRestaurant(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("restaurant");
        member.setMemberName("요식업");
        member.setRole("BIZ");
        member.setBizType("RESTAURANT");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testGrooming")
    public String testGrooming(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("grooming");
        member.setMemberName("애견미용");
        member.setRole("BIZ");
        member.setBizType("GROOMING");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testStore")
    public String testStore(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("store");
        member.setMemberName("스토어");
        member.setRole("BIZ");
        member.setBizType("STORE");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testStudio")
    public String testStudio(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("studio");
        member.setMemberName("사진관");
        member.setRole("BIZ");
        member.setBizType("STUDIO");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    @GetMapping("/testAdmin")
    public String testAdmin(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("admin");
        member.setMemberName("관리자");
        member.setRole("ADMIN");
        session.setAttribute("memberInfo", member);
        return "redirect:/admin";
    }

    // 2026-07-22 박유정 — STATUS_CD → login.jsp error 파라미터
    private String mapLoginBlockedError(String statusCd) {
        if ("SUSPENDED".equals(statusCd)) {
            return "suspended";
        }
        if ("WITHDRAWN".equals(statusCd)) {
            return "withdrawn";
        }
        return "invalid";
    }
}
