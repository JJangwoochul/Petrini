package com.petcare.petcare.stay;

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
