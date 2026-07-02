/**
 * 역할: /stay → /hotel URL 리다이렉트 처리
 *
 * 연결
 * - 리다이렉트: StayStayController (/hotel)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */
package com.petcare.petcare.stay.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/stay")
public class StayRedirectController {

    @GetMapping({"", "/", "/detail", "/reserve", "/complete"})
    public String redirectRoot(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String suffix = uri.substring(uri.indexOf("/stay") + "/stay".length());
        String query = request.getQueryString();
        String target = "/hotel" + suffix;
        if (query != null && !query.isBlank()) {
            target += "?" + query;
        }
        return "redirect:" + target;
    }
}
