package com.petcare.petcare.give.talent;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.petcare.petcare.give.GiveController;

@Controller("giveTalentController")
@RequestMapping("/give/talent")
public class GiveTalentController extends GiveController {
    @GetMapping("/list")   
    public String talentList() {
        return "give/talent/list";
    }
}
