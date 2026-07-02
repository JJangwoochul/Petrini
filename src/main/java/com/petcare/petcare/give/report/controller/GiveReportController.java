/**
 * 역할: 유기동물 제보 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: GiveReportService
 * - 상속: GiveBaseController
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.give.report.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.give.controller.GiveBaseController;

@Controller("giveReportController")
@RequestMapping("/give/report")
public class GiveReportController extends GiveBaseController {

    @GetMapping("/list")
    public String reportList() {
        return "give/report/list";
    }

    @GetMapping("/detail")
    public String reportDetail() {
        return "give/report/detail";
    }

    @GetMapping("/write")
    public String reportWrite() {
        return "give/report/write";
    }
}
