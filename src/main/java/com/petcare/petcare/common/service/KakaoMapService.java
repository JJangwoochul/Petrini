package com.petcare.petcare.common.service;

import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("kakaoMapService")
public class KakaoMapService {
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    @Value("${kakao.js-api-key}")
    private String kakaoJsApiKey;
    
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
