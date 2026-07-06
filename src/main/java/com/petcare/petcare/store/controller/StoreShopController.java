/**
 * 역할: 쇼핑몰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: StoreShopService
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.store.controller;

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

//지윤 26.07.06 상품목록 조회용 Service 클래스 import
import com.petcare.petcare.store.service.StoreShopService;
import com.petcare.petcare.store.vo.CategoryVO;

@Controller("storeController")
@RequestMapping("/store")
public class StoreShopController {

    //HYJ 26.07.03 토스결제 api key
    @Value("${toss.client-key}")
    private String tossApiKey;

    //지윤 26.07.06 상품목록 조회용 Service 주입
    @Autowired
    private StoreShopService storeShopService;

    // ----- 수정 전 원본 -----
    // @GetMapping({"", "/"})
    // public String store(@RequestParam(required = false) String q) {
    //     if (q != null && !q.isBlank()) {
    //         return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);}
    //     return "store/list";}
    // ----- 수정 전 원본 -----
    //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터
    //지윤 26.07.06 카테고리 트리(species/category/age 3단계) 적용
    // 우선순위: age > category > species (더 세부적으로 고른 게 있으면 그걸로 필터링)
    @GetMapping({"", "/"})
    public String store(@RequestParam(required = false) String q,
                         @RequestParam(required = false, defaultValue = "5") Long species,
                         @RequestParam(required = false) Long category,
                         @RequestParam(required = false) Long age,
                         @RequestParam(required = false) String keyword,
                         @RequestParam(required = false, defaultValue = "popular") String sort,
                         @RequestParam(required = false, defaultValue = "1") int page,
                         Model model) {
        if (q != null && !q.isBlank()) {
            return "redirect:/search?q=" + java.net.URLEncoder.encode(q.trim(), java.nio.charset.StandardCharsets.UTF_8);
        }
        Long effectiveCategoryId = (age != null) ? age : (category != null ? category : species);

        model.addAttribute("productList", storeShopService.getProductList(effectiveCategoryId, keyword, sort, page));
        model.addAttribute("categoryTree", storeShopService.getCategoryTree());
        model.addAttribute("selectedSpecies", species);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedAge", age);
        model.addAttribute("selectedKeyword", keyword);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", storeShopService.getTotalPages(effectiveCategoryId, keyword));
        return "store/list";
    }

    
    @GetMapping("/detail")
    public String detail(@RequestParam(defaultValue = "1") String id, Model model) {
        model.addAttribute("id", id);
        return "store/detail";
    }

    @GetMapping("/cart")
    public String cart() {
        return "store/cart";
    }

    @GetMapping("/order")
    public String order() {
        return "store/order";
    }

    @GetMapping("/payment")
    public String payment(Model model) {
        //HYJ 26.07.03 결제 api key
        model.addAttribute("tossApiKey", tossApiKey);
        return "store/payment";
    }

    // HYJ 26.07.03 결제 요청 성공 시 여기로 돌아옴 (아직 승인 API는 호출 안 함)
    @GetMapping("/test/payment/success")
    @ResponseBody
    public String success(@RequestParam String orderId,
                            @RequestParam String amount,
                            @RequestParam String paymentKey) {
        return "결제 요청 성공! orderId=" + orderId + ", amount=" + amount + ", paymentKey=" + paymentKey;
    }

    @GetMapping("/test/payment/fail")
    @ResponseBody
    public String fail(@RequestParam(required = false) String code,
                        @RequestParam(required = false) String message) {
        return "결제 요청 실패: " + code + " - " + message;
    }
        
    @GetMapping("/order-complete")
    public String orderComplete() {
        return "store/order-complete";
    }
}
