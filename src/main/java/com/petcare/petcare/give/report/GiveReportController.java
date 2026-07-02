package com.petcare.petcare.give.report;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.give.GiveController;

@Controller("giveReportController")
@RequestMapping("/give/report")
public class GiveReportController extends GiveController {
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
