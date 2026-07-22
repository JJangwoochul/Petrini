/**
 * 역할: 정적 리소스 + 로컬 업로드 파일 URL 매핑, Interceptor 등록
 *
 * - 박유정 / 2026-07-07 — /upload/** → file.upload-dir (give/report 사진 서빙)
 * - 박유정 / 2026-07-22 — SuspendedMemberInterceptor 등록 (정지 회원 고객센터 외 차단)
 */

package com.petcare.petcare.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import com.petcare.petcare.common.interceptor.SuspendedMemberInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // mypage/biz 등 다른 패키지에서 webConfig.uploadDir 로 접근 → public 유지
    @Value("${file.upload-dir}")
    public String uploadDir;

    @Autowired
    private SuspendedMemberInterceptor suspendedMemberInterceptor; // 2026-07-22 박유정 — 정지 회원 Interceptor

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/")
                .setCachePeriod(0);

        // 로컬 업로드 파일 서빙: /upload/** → file.upload-dir (C:/upload/)
        String location = uploadDir.endsWith("/") ? uploadDir : uploadDir + "/";
        registry.addResourceHandler("/upload/**")
                .addResourceLocations("file:" + location)
                .setCachePeriod(0);
    }

    // 2026-07-22 박유정 — 정지 회원 고객센터 외 접근 차단
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(suspendedMemberInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/login", "/join", "/join/**",
                        "/oauth/**",
                        "/admin/**",
                        "/resources/**",
                        "/upload/**",
                        "/favicon.ico"
                );
    }
}
