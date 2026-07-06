package com.petcare.petcare.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 2026/07/06 장우철
 * BCrypt 비밀번호 처리용 설정
 * 비밀번호 보안을위해 사용
 */
@Configuration
public class PasswordEncoderConfig {

    /**
     * PasswordEncoder Bean 등록
     * → MemberAuthServiceImpl 생성자 주입으로 사용
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
