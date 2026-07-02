package com.petcare.petcare.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import jakarta.servlet.http.HttpServletRequest;

@RestControllerAdvice
public class ExHandler {
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleAjaxException(Exception e, HttpServletRequest request) {

        String uri = request.getRequestURI();
        // Chrome devtools 자동 요청은 무시
        if (uri.contains(".well-known")) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("not_found");
        }

        // 콘솔에 전체 스택트레이스 출력 → 어디서 터졌는지 바로 확인 가능
        System.out.println("===== 예외 발생 =====");
        System.out.println("요청 URL : " + request.getRequestURI());
        System.out.println("예외 메시지 : " + e.getMessage());
        StackTraceElement[] stackTrace = e.getStackTrace();

        for (StackTraceElement element : stackTrace) {
            if (element.getClassName().startsWith("com.example.bookmarket")) {
                System.out.println("오류 위치 : " + element.getClassName() 
                    + "." + element.getMethodName() 
                    + " (line " + element.getLineNumber() + ")");
                break;  // 첫 번째만 출력
            }
        }
        
        System.out.println("====================");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error");
    }    
}
