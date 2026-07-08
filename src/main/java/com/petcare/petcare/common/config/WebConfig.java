/**
 * 역할: 정적 리소스 + 로컬 업로드 파일 URL 매핑
 *
 * - 박유정 / 2026-07-07
 * - /upload/** → file.upload-dir (C:/upload/) — give/report 사진 서빙용
 */

package com.petcare.petcare.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    // mypage/biz 등 다른 패키지에서 webConfig.uploadDir 로 접근 → public 유지
    @Value("${file.upload-dir}")
    public String uploadDir;

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
}
