package com.petcare.petcare.community;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("communityController")
@RequestMapping("/community")
public class CommunityController {

    @GetMapping({"", "/"})
    public String community() {
        return "community/list";
    }
}
