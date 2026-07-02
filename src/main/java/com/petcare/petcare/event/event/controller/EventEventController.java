/**
 * 역할: 이벤트 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: EventEventService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.event.event.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("eventController")
@RequestMapping("/event")
public class EventEventController {

    @GetMapping({"", "/"})
    public String list() {
        return "event/list";
    }
}
