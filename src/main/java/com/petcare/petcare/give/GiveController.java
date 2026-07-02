package com.petcare.petcare.give;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fasterxml.jackson.databind.JsonNode;
import com.petcare.petcare.give.vo.AbandonmentVO;

@Controller("giveController")
@RequestMapping("/give")
public class GiveController {

    @Value("${abandonmentPublic-api-key}")
    public String serviceKey;

    public String baseUrl = "https://apis.data.go.kr/1543061/abandonmentPublicService_v2/abandonmentPublic_v2";
    public int    pageSize   = 20;

    @GetMapping({"", "/"})
    public String give() {
        return "redirect:/give/animal/list";
    }

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

    public AbandonmentVO parseItem(JsonNode item, DateTimeFormatter fmt) {
        AbandonmentVO vo = new AbandonmentVO();
        vo.setDesertionNo (item.path("desertionNo").asText(""));
        vo.setFilename    (item.path("filename").asText(""));
        vo.setPopfile1     (item.path("popfile1").asText(""));
        vo.setPopfile2     (item.path("popfile2").asText(""));
        vo.setHappenDt    (item.path("happenDt").asText(""));
        vo.setHappenPlace (item.path("happenPlace").asText(""));
        vo.setKindCd      (item.path("kindCd").asText(""));
        vo.setColorCd     (item.path("colorCd").asText(""));
        vo.setAge         (item.path("age").asText(""));
        vo.setWeight      (item.path("weight").asText(""));
        vo.setNoticeNo    (item.path("noticeNo").asText(""));
        vo.setNoticeSdt   (item.path("noticeSdt").asText(""));
        vo.setNoticeEdt   (item.path("noticeEdt").asText(""));
        vo.setProcessState(item.path("processState").asText(""));
        vo.setSexCd       (item.path("sexCd").asText(""));
        vo.setNeuterYn    (item.path("neuterYn").asText(""));
        vo.setSpecialMark (item.path("specialMark").asText(""));
        vo.setCareNm      (item.path("careNm").asText(""));
        vo.setCareTel     (item.path("careTel").asText(""));
        vo.setCareAddr    (item.path("careAddr").asText(""));
        vo.setOrgNm       (item.path("orgNm").asText(""));
        vo.setChargeNm    (item.path("chargeNm").asText(""));
        vo.setOfficetel   (item.path("officetel").asText(""));
        
        // D-day 계산
        String edt = vo.getNoticeEdt();
        if (edt != null && edt.length() == 8) {
            try {
                long days = ChronoUnit.DAYS.between(LocalDate.now(), LocalDate.parse(edt, fmt));
                vo.setDday((int) days);
            } catch (Exception ignore) {}
        }
        return vo;
    }
}
