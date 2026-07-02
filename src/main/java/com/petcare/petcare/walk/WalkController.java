package com.petcare.petcare.walk;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("walkController")
@RequestMapping("/walk")
public class WalkController {

    @GetMapping({"", "/"})
    public String list() {
        return "walk/list";
    }
}
