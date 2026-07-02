package com.petcare.petcare.member;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.petcare.petcare.member.vo.MemberVO;

import jakarta.servlet.http.HttpSession;

@Controller("memberController")
public class MemberController {
    @GetMapping("/login")
    public String login() {
        return "member/login";
    }

    @GetMapping("/join")
    public String join() {
        return "member/join";
    }   

    //http://localhost:8080/
    @GetMapping("/")
    public String main() {
        return "main/main";
    }

    //http://localhost:8080/testUser
    @GetMapping("/testUser")
    public String testLogin(HttpSession session) {
        MemberVO member = new MemberVO();
        member.setMemberId("user");
        member.setMemberName("테스트");
        member.setRole("USER");
        session.setAttribute("memberInfo", member);
        return "redirect:/";
    }

    //http://localhost:8080/testHospital
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

    //http://localhost:8080/testStay
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

    //http://localhost:8080/testRestaurant
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

    //http://localhost:8080/testGrooming
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

    //http://localhost:8080/testStore
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

    //http://localhost:8080/testStudio
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

    //http://localhost:8080/testAdmin
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
