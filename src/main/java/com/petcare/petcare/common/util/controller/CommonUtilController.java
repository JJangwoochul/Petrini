/**
 * 역할: 공통 유틸 API 처리 → Service 호출
 *
 * 연결
 * - Service: CommonUtilService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.common.util.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller("commonUtilController")
public class CommonUtilController {
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    @Value("${kakao.js-api-key}")
    private String kakaoJsApiKey;

    @Value("${abandonmentPublic-api-key}")
    public String serviceKey;    

    public int pageSize   = 20;

    public String callApi(String apiUrl) throws Exception {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(10000);
        conn.setRequestProperty("Accept", "application/json");
        if (conn.getResponseCode() != 200)
            throw new RuntimeException("API 오류: HTTP " + conn.getResponseCode());
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return sb.toString();
        }
    }
    
    // Controller에서 한 줄로 호출하면 model에 지도 관련 속성 전부 세팅
    public void addMapAttributes(Model model, String address, String bizName) {
        model.addAttribute("kakaoJsKey", kakaoJsApiKey);
        model.addAttribute("mapAddress", address);
        model.addAttribute("bizName", bizName);

        try {
            String url = "https://dapi.kakao.com/v2/local/search/address.json?analyze_type=similar&page=1&size=10&query={query}";

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK " + kakaoRestApiKey);

            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.exchange(
                url, HttpMethod.GET, new HttpEntity<>(headers), String.class, address
            );

            JsonNode documents = new ObjectMapper().readTree(response.getBody()).path("documents");

            if (documents.isArray() && documents.size() > 0) {
                model.addAttribute("mapLat", documents.get(0).path("y").asText());
                model.addAttribute("mapLng", documents.get(0).path("x").asText());
            } 
            else {
                setFallback(model);
            }
        } catch (Exception e) {
            setFallback(model);
        }
    }  
    
    private void setFallback(Model model) {
        model.addAttribute("mapLat", "37.5665");
        model.addAttribute("mapLng", "126.9780");
    }
}
