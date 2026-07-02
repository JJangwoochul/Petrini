/**
 * 역할: 카카오맵 API 연동 서비스 (@Service)
 *
 * 구현 내용
 * - 주소 → 좌표 변환 (Kakao Local API)
 * - Model에 mapLat, mapLng, kakaoJsKey 속성 추가
 *
 * 연결
 * - 호출: HospitalHospitalController, StayStayController 등
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.common.external.service;

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
                    url, HttpMethod.GET, new HttpEntity<>(headers), String.class, address);

            JsonNode documents = new ObjectMapper().readTree(response.getBody()).path("documents");

            if (documents.isArray() && documents.size() > 0) {
                model.addAttribute("mapLat", documents.get(0).path("y").asText());
                model.addAttribute("mapLng", documents.get(0).path("x").asText());
            } else {
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
