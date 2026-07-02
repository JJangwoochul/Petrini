package com.petcare.petcare.petmap;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller("petmapController")
@RequestMapping("/petmap")
public class PetmapController {

    @GetMapping({"", "/"})
    public String list(Model model) {
        model.addAttribute("lat", 37.5665);
        model.addAttribute("lng", 126.9780);
        return "petmap/list";
    }
}
