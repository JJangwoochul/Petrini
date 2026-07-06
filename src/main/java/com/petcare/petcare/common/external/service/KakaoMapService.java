/**
 * 역할: 카카오맵 API 연동 서비스 (@Service)
 *
 * 구현 내용
 * - 주소 → 좌표 변환 (Kakao Local API)
 * - Model에 mapLat, mapLng, kakaoJsApiKey 속성 추가
 *
 * 연결
 * - 호출: HospitalHospitalController, StayStayController 등
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.common.external.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.hospital.vo.HospitalVO;

@Service
public class KakaoMapService {
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;

    @Value("${kakao.js-api-key}")
    private String kakaoJsApiKey; 
    
    // Controller에서 한 줄로 호출하면 model에 지도 관련 속성 전부 세팅
    //상세페이지 단일마커용
    public void addMapAttributes(Model model, Double lat, Double lng, String bizName) {
        model.addAttribute("kakaoJsApiKey", kakaoJsApiKey);
        model.addAttribute("bizName", bizName);
        
        //주소 -> 위경도 변환
        // try {
        //     model.addAttribute("mapAddress", address);
        //     String url = "https://dapi.kakao.com/v2/local/search/address.json?analyze_type=similar&page=1&size=10&query={query}";

        //     HttpHeaders headers = new HttpHeaders();
        //     headers.set("Authorization", "KakaoAK " + kakaoRestApiKey);

        //     RestTemplate restTemplate = new RestTemplate();
        //     ResponseEntity<String> response = restTemplate.exchange(
        //         url, HttpMethod.GET, new HttpEntity<>(headers), String.class, address
        //     );

        //     JsonNode documents = new ObjectMapper().readTree(response.getBody()).path("documents");

        //     if (documents.isArray() && documents.size() > 0) {
        //         model.addAttribute("mapLat", documents.get(0).path("y").asText());
        //         model.addAttribute("mapLng", documents.get(0).path("x").asText());
        //     } 
        //     else {
        //         setFallback(model);
        //     }
        // } catch (Exception e) {
        //     setFallback(model);
        // }

        if (lat != null && lng != null) {
            model.addAttribute("mapLat", lat);
            model.addAttribute("mapLng", lng);
        } else {
            setFallback(model);
        }
    }

    //리스트 다중마커용
    public void addMapAttributes(Model model, List<HospitalVO> hospitalList) {
        model.addAttribute("kakaoJsApiKey", kakaoJsApiKey);

        ObjectMapper mapper = new ObjectMapper();
        List<Map<String, Object>> markers = new ArrayList<>();

        //위치정보 있는 병원만 JSON 변환
        for (HospitalVO hospital : hospitalList) {
            if (hospital.getLat() != null && hospital.getLng() != null) {
                Map<String, Object> marker = new HashMap<>();
                marker.put("id", hospital.getHospitalId());
                marker.put("name", hospital.getHospitalName());
                marker.put("lat", hospital.getLat());
                marker.put("lng", hospital.getLng());
                markers.add(marker);
            }
        }

        try {
            //Java 객체(List, Map)를 JSON문자열로 변환
            // [{"id":1,"name":"서울동물병원","lat":37.55,"lng":126.97}]
            String strJson = mapper.writeValueAsString(markers);
            //Controller -> JSP 전달
            //${markerJson}
            model.addAttribute("markersJson", strJson);
        } 
        catch (Exception e) {
            model.addAttribute("markersJson", "[]");
        }

        boolean found = false;
        for (HospitalVO hospital : hospitalList) {
            if (hospital.getLat() != null && hospital.getLng() != null) {
                model.addAttribute("mapLat", hospital.getLat());
                model.addAttribute("mapLng", hospital.getLng());
                found = true;
                break;
            }
        }

        if (!found) {
            setFallback(model);
        }
    }
    
    //위경도값 없을시
    private void setFallback(Model model) {
        model.addAttribute("mapLat", "37.5665");
        model.addAttribute("mapLng", "126.9780");
    }
}
