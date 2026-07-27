package com.petcare.petcare.common.external.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class TossPaymentService {

    @Value("${toss.secret-key}")
    private String tossSecretKey;

    public String cancelPayment(String paymentKey, String cancelReason) {
        try {
            URL url = new URL("https://api.tosspayments.com/v1/payments/" + paymentKey + "/cancel");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");

            String encodedAuth = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String body = "{\"cancelReason\":\"" + cancelReason.replace("\"", "'") + "\"}";
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            InputStreamReader isr = new InputStreamReader(
                    status == 200 ? conn.getInputStream() : conn.getErrorStream(), StandardCharsets.UTF_8);
            BufferedReader br = new BufferedReader(isr);
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            br.close();

            if (status == 200) return null;

            JsonNode json = new ObjectMapper().readTree(sb.toString());
            return json.path("message").asText("토스 결제취소 요청이 거절되었습니다.");

        } catch (Exception e) {
            return "토스 API 호출 중 오류가 발생했습니다: " + e.getMessage();
        }
    }

    /**
     * 토스 결제승인 API 호출 (결제위젯에서 인증 성공 후 반드시 호출해야 실제 결제가 완료됨)
     * @param paymentKey 위젯이 돌려준 paymentKey
     * @param orderId    위젯이 돌려준 orderId (토스 쪽 주문 식별자)
     * @param amount     결제 금액 (위젯에 표시했던 금액과 정확히 일치해야 함)
     * @return null이면 성공, 실패면 에러 메시지 문자열 반환
     */
    public String confirmPayment(String paymentKey, String orderId, int amount) {
        try {
            URL url = new URL("https://api.tosspayments.com/v1/payments/confirm");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");

            String encodedAuth = Base64.getEncoder().encodeToString((tossSecretKey + ":").getBytes(StandardCharsets.UTF_8));
            conn.setRequestProperty("Authorization", "Basic " + encodedAuth);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String body = "{\"paymentKey\":\"" + paymentKey + "\",\"orderId\":\"" + orderId + "\",\"amount\":" + amount + "}";
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            InputStreamReader isr = new InputStreamReader(
                    status == 200 ? conn.getInputStream() : conn.getErrorStream(), StandardCharsets.UTF_8);
            BufferedReader br = new BufferedReader(isr);
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            br.close();

            if (status == 200) return null; // 승인 성공

            JsonNode json = new ObjectMapper().readTree(sb.toString());
            return json.path("message").asText("토스 결제승인 요청이 거절되었습니다.");

        } catch (Exception e) {
            return "토스 승인 API 호출 중 오류가 발생했습니다: " + e.getMessage();
        }
    }
}