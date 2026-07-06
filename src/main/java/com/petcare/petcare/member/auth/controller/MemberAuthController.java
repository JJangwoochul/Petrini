/**
 * 역할: 회원 로그인·가입 URL 처리 → Service 호출 → JSP/리다이렉트 반환
 *
 * 연결
 * - Service: MemberAuthService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.member.auth.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.petcare.petcare.member.auth.service.MemberAuthService;
import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

/* 2026/07/06 장우철 */

@Controller("memberController")
public class MemberAuthController {

    // ── 의존성 주입 ──
    // Controller는 URL·세션만 담당, 로그인 검증(BCrypt·DB)은 MemberAuthService에 위임
    private final MemberAuthService memberAuthService;

    public MemberAuthController(MemberAuthService memberAuthService) {
        this.memberAuthService = memberAuthService;
    }

    // ── 로그인 화면 (GET) ──
    // login.jsp 표시만, DB 조회 없음
    @GetMapping("/login")
    public String login() {
        return "member/login";
    }

    // ── 로그인 처리 (POST) ──
    // login.jsp 폼 → loginId, loginPw 수신
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
        MemberVO member = memberAuthService.login(loginId, loginPw);
        if (member == null) {
            // 회원 없음 / 비밀번호 틀림 / 정지·탈퇴 회원 → error=invalid (login.jsp 메시지는 추후 추가)
            return "redirect:/login?error=invalid";
        }

        // [3] 로그인 성공 — 세션에 회원 정보 저장 (header.jsp에서 memberInfo로 로그아웃 표시)
        session.setAttribute("memberInfo", member);

        // [4] 로그인 전 가려던 페이지가 있으면 해당 URL로 이동
        // "//" 로 시작하는 외부 URL 차단 (오픈 리다이렉트 방지)
        if (redirect != null && !redirect.isBlank() && redirect.startsWith("/") && !redirect.startsWith("//")) {
            return "redirect:" + redirect;
        }
        return "redirect:/";

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

    // ── 회원가입 화면 ──
    @GetMapping("/join")
    public String join() {
        return "member/join";
    }

    @GetMapping("/member/join")
    public String joinAlias() {
        return "redirect:/join";
    }

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
}
