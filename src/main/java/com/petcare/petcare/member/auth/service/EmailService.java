/**
 * 2026/07/15 — 회원가입 이메일 인증
 *
 * 역할: Google SMTP 로 인증번호 발송 (@Service)
 *
 * 흐름
 * 1. Controller 가 이메일 주소 전달
 * 2. 6자리 인증번호 생성 → 메일 발송
 * 3. 인증번호를 반환 → Controller 가 세션에 저장
 * 4. 사용자가 입력한 인증번호와 세션 값 비교 → 일치하면 인증 완료
 *
 * 연결
 * - 호출: MemberAuthController (POST /join/send-code, POST /join/verify-code)
 * - 설정: application.properties (spring.mail.*)
 */
package com.petcare.petcare.member.auth.service;

import java.util.Random;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    /**
     * 6자리 인증번호 생성
     */
    public String generateCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);  // 100000 ~ 999999
        return String.valueOf(code);
    }

    /**
     * 인증번호 메일 발송
     * @param toEmail 수신자 이메일
     * @param code    6자리 인증번호
     */
    public void sendVerificationEmail(String toEmail, String code) throws MessagingException {

        if (mailSender instanceof org.springframework.mail.javamail.JavaMailSenderImpl) {
            java.util.Properties props =
                    ((org.springframework.mail.javamail.JavaMailSenderImpl) mailSender)
                            .getJavaMailProperties();
            props.put("mail.smtp.localhost", "127.0.0.1");
        }
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
        helper.setFrom("j.yeah110@gmail.com");
        helper.setTo(toEmail);
        helper.setSubject("[PetCare] 이메일 인증번호 안내");

        String body = ""
                + "<div style='max-width:480px; margin:0 auto; padding:32px; "
                + "font-family:\"Pretendard\",\"Apple SD Gothic Neo\",sans-serif;'>"
                + "  <h2 style='color:#FD8B00; margin-bottom:8px;'>PetCare 이메일 인증</h2>"
                + "  <p style='color:#555; font-size:15px;'>아래 인증번호를 입력해 주세요.</p>"
                + "  <div style='background:#FFF8EE; border:2px solid #FD8B00; border-radius:12px; "
                + "  padding:24px; text-align:center; margin:24px 0;'>"
                + "    <span style='font-size:32px; font-weight:700; letter-spacing:8px; color:#333;'>"
                + code
                + "    </span>"
                + "  </div>"
                + "  <p style='color:#999; font-size:13px;'>인증번호는 5분간 유효합니다.</p>"
                + "</div>";

        helper.setText(body, true);  // true = HTML

        mailSender.send(message);
    }
}
