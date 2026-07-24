/**
 * 역할: 사업자 쇼핑몰 URL 처리 → Service 호출 → JSP 반환
 *
 * 연결
 * - Service: BizStoreService
 * - 상속: BizBaseController (사업자 로그인 체크)
 *
 * SQL·비즈니스 로직은 넣지 말 것 → Service로 위임
 * return 경로는 담당 JSP와 동일하게 맞출 것
 */

package com.petcare.petcare.biz.store.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.biz.controller.BizBaseController;
import com.petcare.petcare.biz.store.service.BizStoreService;
import com.petcare.petcare.biz.store.vo.BizProductVO;
import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.store.vo.OptionVO;

import jakarta.servlet.http.HttpSession;

@Controller("bizStoreController")
@RequestMapping("/biz/store")
public class BizStoreController extends BizBaseController {

    //지윤 26.07.14 상품관리(BIZ-04) 서비스 주입
    @Autowired
    private BizStoreService bizStoreService;

    @GetMapping({"", "/"})
    public String storeDashboard(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/dashboard";
    }

    //지윤 26.07.14 수정: 상품목록 실데이터 연동 (검색/카테고리/상태 필터 + 페이지네이션, 페이지당 10개)
    @GetMapping("/products")
    public String storeProducts(@RequestParam(required = false) String keyword,
                                 @RequestParam(required = false) Long categoryId,
                                 @RequestParam(required = false) String statusCd,
                                 @RequestParam(defaultValue = "1") int page,
                                 HttpSession session, Model model) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";

        //로그인 세션엔 bizNo가 없어서, 로그인 ID로 되짚어 조회
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        model.addAttribute("productList", bizStoreService.getProductList(bizNo, keyword, categoryId, statusCd, page));
        model.addAttribute("totalPages", bizStoreService.getTotalPages(bizNo, keyword, categoryId, statusCd));
        model.addAttribute("totalCount", bizStoreService.getTotalCount(bizNo, keyword, categoryId, statusCd));
        model.addAttribute("currentPage", page);
        model.addAttribute("categoryList", bizStoreService.getLeafCategories());
        model.addAttribute("selectedKeyword", keyword);
        model.addAttribute("selectedCategoryId", categoryId);
        model.addAttribute("selectedStatusCd", statusCd);
        return "biz/store/products";
    }

    //지윤 26.07.20 수정: 목업 -> 실데이터 연동 (상태 탭 필터)
    @GetMapping("/orders")
    public String storeOrders(@RequestParam(required = false) String statusCd, HttpSession session, Model model) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        model.addAttribute("orderList", bizStoreService.getOrderList(bizNo, statusCd));
        model.addAttribute("statusCounts", bizStoreService.getOrderStatusCounts(bizNo));
        model.addAttribute("selectedStatusCd", statusCd);
        return "biz/store/orders";
    }

    //지윤 26.07.20 추가: 주문 상세 조회 (모달/상세영역 프리필용 AJAX)
    @GetMapping("/orders/{id}")
    @ResponseBody
    public com.petcare.petcare.biz.store.vo.BizOrderVO getOrderDetailJson(@PathVariable Long id, HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return null;
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        return bizStoreService.getOrderDetail(id, bizNo);
    }

    //지윤 26.07.20 추가: 주문 상태 변경 (택배사/송장번호 같이 저장)
    @PostMapping("/orders/{id}/status")
    @ResponseBody
    public String updateOrderStatus(@PathVariable Long id,
                                     @RequestParam String orderStatus,
                                     @RequestParam(required = false) String courierName,
                                     @RequestParam(required = false) String trackingNo,
                                     HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "LOGIN_REQUIRED";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        boolean ok = bizStoreService.updateOrderStatus(id, bizNo, orderStatus, courierName, trackingNo);
        return ok ? "OK" : "FAILED";
    }
    
    //지윤 26.07.20 수정: 목업 -> 실데이터 연동 (택배사/상태/키워드 필터)
    @GetMapping("/delivery")
    public String storeDelivery(@RequestParam(required = false) String carrier,
                                 @RequestParam(required = false) String statusCd,
                                 @RequestParam(required = false) String keyword,
                                 HttpSession session, Model model) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        model.addAttribute("deliveryList", bizStoreService.getDeliveryList(bizNo, carrier, statusCd, keyword));
        model.addAttribute("summary", bizStoreService.getDeliverySummary(bizNo));
        model.addAttribute("selectedCarrier", carrier);
        model.addAttribute("selectedStatusCd", statusCd);
        model.addAttribute("selectedKeyword", keyword);
        return "biz/store/delivery";
    }

    //지윤 26.07.20 추가: 송장 일괄등록 (텍스트 여러 줄 파싱)
    @PostMapping("/delivery/bulk")
    @ResponseBody
    public java.util.Map<String, Object> bulkDelivery(@RequestParam String bulkText, HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return java.util.Map.of("error", "LOGIN_REQUIRED");
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        return bizStoreService.bulkRegisterDelivery(bizNo, bulkText);
    }

    @GetMapping("/reviews")
    public String storeReviews(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/reviews";
    }

    @GetMapping("/settlement")
    public String storeSettlement(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/settlement";
    }

    @GetMapping("/info")
    public String storeInfo(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/info";
    }

    //지윤 26.07.15 상품 등록 모달 제출 처리 (옵션 여러 개 + 이미지 1장)
    @PostMapping("/products")
    public String registerProduct(@RequestParam String productName,
                                   @RequestParam Long categoryId,
                                   @RequestParam Integer price,
                                   @RequestParam Integer salePrice,
                                   @RequestParam(required = false) String brandName,
                                   @RequestParam(required = false) String description,
                                   @RequestParam String statusCd,
                                   @RequestParam(required = false) String[] optionColor,
                                   @RequestParam String[] optionSize,
                                   @RequestParam Integer[] addPrice,
                                   @RequestParam Integer[] stockQty,
                                   @RequestParam(required = false) MultipartFile image,
                                   HttpSession session) throws Exception {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        BizProductVO product = new BizProductVO();
        product.setProductName(productName);
        product.setBizNo(bizNo);
        product.setCategoryId(categoryId);
        product.setPrice(price);
        product.setSalePrice(salePrice);
        product.setBrandName(brandName);
        product.setDescription(description);
        product.setStatusCd(statusCd);

        bizStoreService.addProduct(product, buildOptions(optionColor, optionSize, addPrice, stockQty), image);
        return "redirect:/biz/store/products";
    }

    //지윤 26.07.15 수정 모달 프리필용 - 상품 1건 + 옵션 리스트 JSON 반환
    @GetMapping("/products/{id}")
    @ResponseBody
    public BizProductVO getProductJson(@PathVariable Long id, HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return null;
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        return bizStoreService.getProductDetail(id, bizNo);
    }

    //지윤 26.07.15 상품 수정 모달 제출 처리
    @PostMapping("/products/{id}")
    public String updateProductSubmit(@PathVariable Long id,
                                       @RequestParam String productName,
                                       @RequestParam Long categoryId,
                                       @RequestParam Integer price,
                                       @RequestParam Integer salePrice,
                                       @RequestParam(required = false) String brandName,
                                       @RequestParam(required = false) String description,
                                       @RequestParam String statusCd,
                                       @RequestParam(required = false) String[] optionColor,
                                       @RequestParam String[] optionSize,
                                       @RequestParam Integer[] addPrice,
                                       @RequestParam Integer[] stockQty,
                                       @RequestParam(required = false) MultipartFile image,
                                       HttpSession session) throws Exception {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        BizProductVO product = new BizProductVO();
        product.setProductId(id);
        product.setBizNo(bizNo);
        product.setProductName(productName);
        product.setCategoryId(categoryId);
        product.setPrice(price);
        product.setSalePrice(salePrice);
        product.setBrandName(brandName);
        product.setDescription(description);
        product.setStatusCd(statusCd);

        bizStoreService.updateProduct(product, buildOptions(optionColor, optionSize, addPrice, stockQty), image);
        return "redirect:/biz/store/products";
    }

    //지윤 26.07.15 폼 배열(옵션당 1줄씩)을 OptionVO 리스트로 변환
    //지윤 26.07.15 수정: 배열 길이가 서로 안 맞아도(브라우저 재전송 등) 에러 안 나게 방어 코드 추가
    private List<OptionVO> buildOptions(String[] optionColor, String[] optionSize, Integer[] addPrice, Integer[] stockQty) {
        List<OptionVO> options = new ArrayList<>();
        if (optionSize == null) return options;
        for (int i = 0; i < optionSize.length; i++) {
            OptionVO opt = new OptionVO();
            opt.setOptionColor(optionColor != null && optionColor.length > i ? optionColor[i] : null);
            opt.setOptionSize(optionSize[i]);
            opt.setAddPrice(addPrice != null && addPrice.length > i ? addPrice[i] : 0);
            opt.setStockQty(stockQty != null && stockQty.length > i ? stockQty[i] : 0);
            options.add(opt);
        }
        return options;
    }

    /*사업자(샵) 계약관리*/
    @GetMapping("/contract")
    public String storeContract(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/contract";
    }
}


