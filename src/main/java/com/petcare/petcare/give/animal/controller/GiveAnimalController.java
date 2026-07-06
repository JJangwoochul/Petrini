/**
 * 역할: 유기동물 입양 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: GiveAnimalService
 * - 상속: GiveBaseController (공공 API 헬퍼)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.give.animal.controller;

import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.common.config.controller.CommonConfigController;
import com.petcare.petcare.common.util.controller.CommonUtilController;
import com.petcare.petcare.give.vo.AbandonmentVO;

@Controller("giveAnimalController")
@RequestMapping("/give/animal")
public class GiveAnimalController extends CommonConfigController {
    String baseUrl = "https://apis.data.go.kr/1543061/abandonmentPublicService_v2/abandonmentPublic_v2";

    @GetMapping("/list")
    public String animalList(
            @RequestParam(defaultValue = "")  String sido,
            @RequestParam(defaultValue = "")  String sigungu,
            @RequestParam(defaultValue = "")  String upkind,
            @RequestParam(defaultValue = "")  String state,
            @RequestParam(defaultValue = "1") int    pageNo,
            Model model) {

        try {

            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyyMMdd");
            String bgnde = LocalDate.now().minusDays(30).format(fmt);
            String endde = LocalDate.now().format(fmt);

            StringBuilder sb = new StringBuilder(baseUrl);
            sb.append("?serviceKey=").append(URLEncoder.encode(apiService.publicServiceApiKey, "UTF-8"));
            sb.append("&bgnde=").append(bgnde);
            sb.append("&endde=").append(endde);
            sb.append("&pageNo=").append(pageNo);
            sb.append("&numOfRows=").append(commonUtilController.pageSize);
            sb.append("&_type=json");
            if (!sido.isEmpty())    sb.append("&sidoLikeCd=").append(URLEncoder.encode(sido,    "UTF-8"));
            if (!sigungu.isEmpty()) sb.append("&sigunguLikeCd=").append(URLEncoder.encode(sigungu,"UTF-8"));
            if (!upkind.isEmpty())  sb.append("&upkind=").append(upkind);
            if (!state.isEmpty())   sb.append("&state=").append(state);

            String json   = apiService.callApi(sb.toString());
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(json);
            JsonNode body = root.path("response").path("body");
            int totalCount = body.path("totalCount").asInt(0);
            JsonNode items = body.path("items").path("item");

            List<AbandonmentVO> animals = new ArrayList<>();
            if (items.isArray()) {
                for (JsonNode item : items) animals.add(AbandonmentVO.parseItem(item, fmt));
            } else if (items.isObject() && !items.isEmpty()) {
                animals.add(AbandonmentVO.parseItem(items, fmt));
            }

            model.addAttribute("animals",    animals);
            model.addAttribute("totalCount", totalCount);
            model.addAttribute("pageNo",     pageNo);
            model.addAttribute("totalPages", (int) Math.ceil((double) totalCount / commonUtilController.pageSize));
            model.addAttribute("sido",       sido);
            model.addAttribute("upkind",     upkind);
            model.addAttribute("state",      state);
            model.addAttribute("apiError",   false);

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("animals",    new ArrayList<>());
            model.addAttribute("totalCount", 0);
            model.addAttribute("pageNo",     1);
            model.addAttribute("totalPages", 0);
            model.addAttribute("apiError",   true);
            model.addAttribute("errorMsg",   e.getMessage());
        }
        return "give/animal/list";
    }
    
    // ── 유기동물 상세 ─────────────────────────────────────
    @GetMapping("/detail")
    public String animalDetail(@RequestParam String desertionNo, Model model) {
        try {
            StringBuilder sb = new StringBuilder(baseUrl);
            sb.append("?serviceKey=").append(URLEncoder.encode(apiService.publicServiceApiKey, "UTF-8"));
            sb.append("&desertion_no=").append(URLEncoder.encode(desertionNo, "UTF-8"));
            sb.append("&_type=json");

            String json   = apiService.callApi(sb.toString());
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(json);
            JsonNode items = root.path("response").path("body").path("items").path("item");

            // 결과가 1건이면 객체로, 여러 건이면 배열로 내려오는 경우가 있어 둘 다 처리
            JsonNode item = items.isArray() ? items.get(0) : items;

            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyyMMdd");
            model.addAttribute("animal",   AbandonmentVO.parseItem(item, fmt));
            model.addAttribute("apiError", false);
        } 
        catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("animal",   null);
            model.addAttribute("apiError", true);
        }
        return "give/animal/detail";
    }
}
