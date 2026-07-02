/**
 * 역할: 재능나눔 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: GiveTalentService
 * - 상속: GiveBaseController
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.give.talent.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.give.controller.GiveBaseController;

@Controller("giveTalentController")
@RequestMapping("/give/talent")
public class GiveTalentController extends GiveBaseController {

    @GetMapping("/list")
    public String talentList() {
        return "give/talent/list";
    }

    @GetMapping("/detail")
    public String talentDetail() {
        return "give/talent/detail";
    }
}
