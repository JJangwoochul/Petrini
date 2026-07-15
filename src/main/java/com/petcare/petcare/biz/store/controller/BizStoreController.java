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

    @GetMapping("/orders")
    public String storeOrders(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/orders";
    }

    @GetMapping("/delivery")
    public String storeDelivery(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/delivery";
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


