/**
 * 역할: 펫맵 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: PetmapMapService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.petmap.controller;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.common.config.controller.CommonConfigController;
import com.petcare.petcare.common.external.service.KakaoMapService;
import com.petcare.petcare.petmap.vo.PetMapVO;

@Controller("petmapController")
@RequestMapping("/petmap")
public class PetmapMapController extends CommonConfigController {
    @Autowired
    private KakaoMapService kakaoMapService;
      
    String listUrl = "https://apis.data.go.kr/B551011/KorPetTourService2/areaBasedList2";
    String catUrl  = "https://apis.data.go.kr/B551011/KorPetTourService2/categoryCode2";
    
    @GetMapping({"", "/"})
    public String list(@RequestParam(defaultValue = "1") int pageNo,
                       @RequestParam(required = false) String contentTypeId,
                       @RequestParam(required = false) String areaCode,
                       @RequestParam(required = false) String cat1,
                       @RequestParam(required = false) String cat2,
                       Model model) {

        List<PetMapVO> places = new ArrayList<>();

        try {
            // ── 1) 메인 API 호출 URL 조립 ──
            StringBuilder sb = new StringBuilder(listUrl);
            sb.append("?serviceKey=").append(URLEncoder.encode(apiService.publicServiceApiKey, "UTF-8"));
            sb.append("&numOfRows=").append(commonUtilController.pageSize);
            sb.append("&pageNo=").append(pageNo);
            sb.append("&MobileOS=").append("WIN");
            sb.append("&MobileApp=").append("PetCare");
            sb.append("&_type=json");

            // 필터 파라미터 추가 (값이 있을 때만)
            if (contentTypeId != null && !contentTypeId.isEmpty()) {
                sb.append("&contentTypeId=").append(contentTypeId);
            }
            if (areaCode != null && !areaCode.isEmpty()) {
                sb.append("&areaCode=").append(areaCode);
            }
            if (cat1 != null && !cat1.isEmpty()) {
                sb.append("&cat1=").append(cat1);
            }
            if (cat2 != null && !cat2.isEmpty()) {
                sb.append("&cat2=").append(cat2);
            }

            // ── 2) API 호출 & 응답 파싱 ──
            String json   = apiService.callApi(sb.toString());
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(json);
            JsonNode body = root.path("response").path("body");
            int totalCount = body.path("totalCount").asInt(0);
            JsonNode items = body.path("items").path("item"); 
            
            if (items.isArray()) {
                for (JsonNode item : items) 
                    places.add(PetMapVO.parseItem(item));
            } 
            else if (items.isObject() && !items.isEmpty()) {
                places.add(PetMapVO.parseItem(items));
            }

            // ── 기존 (단일마커 메서드 사용) ──
            // if (!places.isEmpty()) {
            //     kakaoMapService.addMapAttributes(model,
            //         Double.parseDouble(places.get(0).getMapy()),
            //         Double.parseDouble(places.get(0).getMapx()),
            //         null);   // bizName 없음 → 단일마커 안 찍힘
            // } else {
            //     kakaoMapService.addMapAttributes(model, null, null, null);
            // }

            model.addAttribute("totalCount", totalCount);
            model.addAttribute("pageNo", pageNo);
            model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / commonUtilController.pageSize));
        } 
        catch (Exception e) {
            model.addAttribute("totalCount", 0);
            model.addAttribute("pageNo", 1);
            model.addAttribute("totalPages", 0);
            model.addAttribute("errorMsg", e.getMessage());
        }

        // ── 3) 하위 카테고리 목록 조회 ──
        //    contentTypeId가 선택되면 → cat1 목록 조회
        //    cat1까지 선택되면 → cat2 목록 조회
        if (contentTypeId != null && !contentTypeId.isEmpty()) {
            List<Map<String, String>> cat1List = getCategoryCodes(contentTypeId, null);
            model.addAttribute("cat1List", cat1List);
        }
        if (cat1 != null && !cat1.isEmpty()) {
            List<Map<String, String>> cat2List = getCategoryCodes(contentTypeId, cat1);
            model.addAttribute("cat2List", cat2List);
        }

         // ── 4) 지도 설정 ── 변경 후 (통합 메서드) ──
        kakaoMapService.addMapAttributes(model, places);
        model.addAttribute("skipAutoMarkers", "true");
        model.addAttribute("places", places);

        // ── 5) 현재 필터 상태를 JSP로 전달 ──
        model.addAttribute("contentTypeId", contentTypeId != null ? contentTypeId : "");
        model.addAttribute("areaCode", areaCode != null ? areaCode : "");
        model.addAttribute("cat1", cat1 != null ? cat1 : "");
        model.addAttribute("cat2", cat2 != null ? cat2 : "");

        return "petmap/list";
    }

    /*
     * TourAPI categoryCode2 호출 → [{code:"A01", name:"자연"}, ...] 형태로 반환
     * @param contentTypeId  관광타입 ID (필수)
     * @param parentCat1     cat1 값 (null이면 cat1 목록 조회, 값 있으면 cat2 목록 조회)
    */
    private List<Map<String, String>> getCategoryCodes(String contentTypeId, String parentCat1) {
        List<Map<String, String>> result = new ArrayList<>();
        try {
            String encodedKey = URLEncoder.encode(apiService.publicServiceApiKey, "UTF-8");
            
            StringBuilder sb = new StringBuilder(catUrl);
            sb.append("?serviceKey=").append(encodedKey);
            sb.append("&MobileOS=WIN");
            sb.append("&MobileApp=PetCare");
            sb.append("&_type=json");
            sb.append("&contentTypeId=").append(contentTypeId);
            
            if (parentCat1 != null) {
                sb.append("&cat1=").append(parentCat1);
            }

            String json = apiService.callApi(sb.toString());
            ObjectMapper mapper = new ObjectMapper();
            JsonNode items = mapper.readTree(json)
                    .path("response").path("body").path("items").path("item");

            if (items.isArray()) {
                for (int i = 0; i < items.size(); i++) {
                    JsonNode item = items.get(i);
                    Map<String, String> code = new HashMap<>();
                    code.put("code", item.path("code").asText(""));
                    code.put("name", item.path("name").asText(""));
                    result.add(code);
                }
            } else if (items.isObject() && !items.isEmpty()) {
                Map<String, String> code = new HashMap<>();
                code.put("code", items.path("code").asText(""));
                code.put("name", items.path("name").asText(""));
                result.add(code);
            }
        } catch (Exception e) {
            // 실패 시 빈 리스트 반환 → JSP에서 하위 카테고리 안 보임
        }
        return result;
    }
}
