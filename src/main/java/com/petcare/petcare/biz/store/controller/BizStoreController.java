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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.petcare.petcare.biz.controller.BizBaseController;
import com.petcare.petcare.biz.store.service.BizStoreService;
import com.petcare.petcare.biz.store.vo.BizProductVO;
import com.petcare.petcare.biz.store.vo.BizReviewVO;
import com.petcare.petcare.member.vo.MemberVO;
import com.petcare.petcare.store.vo.OptionVO;

import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller("bizStoreController")
@RequestMapping("/biz/store")
public class BizStoreController extends BizBaseController {

    //지윤 26.07.14 상품관리(BIZ-04) 서비스 주입
    @Autowired
    private BizStoreService bizStoreService;

    //지윤 26.07.20 추가: 리뷰관리 JSON 응답용
    @Autowired
    private ObjectMapper objectMapper;

    //지윤 26.07.24 추가: 택배사 API 연동용
    @Autowired
    private com.petcare.petcare.common.external.service.SmartTrackerService smartTrackerService;

    //지윤 26.07.21 추가: 사이드바 "주문관리" 뱃지 하드코딩(12) 제거 - 이 컨트롤러가 처리하는 모든 페이지(상품관리/주문관리/배송관리/리뷰관리 등) 렌더링 전에
    //자동으로 실행돼서 model에 paidOrderCount를 채워줌. 로그인 안 됐으면 0으로 조용히 넘어감 (개별 핸들러가 알아서 redirect:/login 처리하므로 여기선 막지 않음)
    @ModelAttribute
    public void addPaidOrderCount(HttpSession session, Model model) {
        MemberVO biz = getBizMember(session);
        if (biz == null) { model.addAttribute("paidOrderCount", 0); return; }
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        model.addAttribute("paidOrderCount", bizStoreService.getPaidOrderCount(bizNo));
    }

   //지윤 26.07.23 수정: 목업 -> 실데이터 연동 (매출 통계 라인차트/이번달매출은 패스, 나머지는 실데이터)
   @GetMapping({"", "/"})
   public String storeDashboard(HttpSession session, Model model) {
       MemberVO biz = getBizMember(session);
       if (biz == null) return "redirect:/login";
       Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

       model.addAttribute("todayNewOrderCount", bizStoreService.getTodayNewOrderCount(bizNo));
       model.addAttribute("statusCounts", bizStoreService.getOrderStatusCounts(bizNo));

       List<com.petcare.petcare.biz.store.vo.BizOrderVO> orders = bizStoreService.getOrderList(bizNo, null);
       model.addAttribute("recentOrders", orders.subList(0, Math.min(3, orders.size())));

       List<BizReviewVO> reviews = bizStoreService.getBizReviewList(bizNo);
       model.addAttribute("recentReviews", reviews.subList(0, Math.min(3, reviews.size())));

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
                                     @RequestParam(required = false) String courierCode,
                                     @RequestParam(required = false) String trackingNo,
                                     HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "LOGIN_REQUIRED";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        boolean ok = bizStoreService.updateOrderStatus(id, bizNo, orderStatus, courierName, courierCode, trackingNo);
        return ok ? "OK" : "FAILED";
    }

    //지윤 26.07.22 추가: 취소신청 승인
    @PostMapping("/orders/{id}/cancel/approve")
    @ResponseBody
    public String approveOrderCancel(@PathVariable Long id, HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "LOGIN_REQUIRED";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        String error = bizStoreService.approveOrderCancel(id, bizNo);
        return error == null ? "OK" : error;
    }

    //지윤 26.07.22 추가: 취소신청 반려
    @PostMapping("/orders/{id}/cancel/reject")
    @ResponseBody
    public String rejectOrderCancel(@PathVariable Long id, HttpSession session) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "LOGIN_REQUIRED";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        boolean ok = bizStoreService.rejectOrderCancel(id, bizNo);
        return ok ? "OK" : "FAILED";
    }
    
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

    //지윤 26.07.24 추가: 택배사 전체목록 조회 (드롭다운 채우기용, AJAX)
    @GetMapping("/delivery/companies")
    @ResponseBody
    public java.util.List<java.util.Map<String, String>> getCompanyList(HttpSession session) {
        if (getBizMember(session) == null) return java.util.List.of();
        return smartTrackerService.getCompanyList();
    }

    //지윤 26.07.24 추가: 실시간 배송조회 (AJAX, 원본 JSON 그대로 화면에 넘김)
    @GetMapping("/delivery/track")
    @ResponseBody
    public String trackDelivery(@RequestParam String courierCode, @RequestParam String trackingNo, HttpSession session) {
        if (getBizMember(session) == null) return "{\"status\":false,\"msg\":\"로그인이 필요합니다.\"}";
        return smartTrackerService.getTrackingInfo(courierCode, trackingNo);
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

    //지윤 26.07.20 수정: 목업 -> 실데이터 연동. 리뷰 목록 조회해서 JS에서 쓸 JSON으로 변환
    @GetMapping("/reviews")
    public String storeReviews(HttpSession session, Model model) throws Exception {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        List<BizReviewVO> reviewList = bizStoreService.getBizReviewList(bizNo);
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
        List<java.util.Map<String, Object>> rows = new ArrayList<>();
        for (BizReviewVO r : reviewList) {
            java.util.Map<String, Object> row = new java.util.LinkedHashMap<>();
            row.put("id", r.getReviewId());
            row.put("author", (r.getNickname() != null && !r.getNickname().isBlank()) ? r.getNickname() : "회원");
            row.put("date", r.getRegDate() != null ? df.format(r.getRegDate()) : "");
            row.put("rating", r.getRating() != null ? r.getRating() : 0);
            row.put("product", r.getProductName());
            row.put("thumbnail", r.getThumbnailUrl()); //지윤 26.07.22 추가: 상품 썸네일
            //지윤 26.07.22 복원: 실제 구매 옵션 (색상/사이즈)
            String optText = "";
            if (r.getOptionSize() != null && !r.getOptionSize().isBlank()) {
                optText = (r.getOptionColor() != null && !r.getOptionColor().isBlank() && !"기본".equals(r.getOptionColor()))
                        ? r.getOptionColor() + " / " + r.getOptionSize() : r.getOptionSize();
            }
            row.put("option", optText);
            row.put("content", r.getContent() != null ? r.getContent() : "");
            row.put("reply", r.getBizReply());
            row.put("deleteRequested", "PENDING".equals(r.getReportStatus())); //지윤 26.07.20 추가: 삭제요청 대기중이면 true
            //지윤 26.07.22 추가: 리뷰가 남아있는데 요청상태가 DONE이면 = 반려된 것 (승인됐으면 리뷰 자체가 삭제돼서 여기 조회조차 안 됨)
            row.put("deleteRejected", "DONE".equals(r.getReportStatus()));
            row.put("reportCount", r.getReportCount() != null ? r.getReportCount() : 0); //지윤 26.07.21 추가: 유저 신고 건수
            row.put("reporterNames", r.getReporterNames());                              //지윤 26.07.21 추가: 신고자 닉네임 목록
            rows.add(row);
        }
        model.addAttribute("reviewListJson", objectMapper.writeValueAsString(rows));
        return "biz/store/reviews";
    }

    //지윤 26.07.20 추가: 리뷰 답글 작성/수정 (TB_REVIEW.BIZ_REPLY)
    @PostMapping("/reviews/reply")
    public String saveReviewReply(@RequestParam("reviewId") Long reviewId,
                                   @RequestParam("bizReply") String bizReply,
                                   HttpSession session, RedirectAttributes rttr) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        boolean ok = bizStoreService.saveReviewBizReply(bizNo, reviewId, bizReply);
        rttr.addFlashAttribute(ok ? "msg" : "errorMsg", ok ? "답글이 저장되었습니다." : "본인 상품의 리뷰가 아닙니다.");
        return "redirect:/biz/store/reviews";
    }

    //지윤 26.07.20 추가: 리뷰 삭제요청 - 즉시 삭제 X, TB_REVIEW_REPORT에 PENDING 등록만 (관리자 승인 후 실제 삭제됨)
    @PostMapping("/reviews/delete-request")
    public String requestReviewDelete(@RequestParam("reviewId") Long reviewId,
                                       @RequestParam(value = "reason", required = false) String reason,
                                       HttpSession session, RedirectAttributes rttr) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        try {
            bizStoreService.requestReviewDelete(bizNo, reviewId, reason);
            rttr.addFlashAttribute("msg", "삭제 요청이 접수되었습니다. 관리자 승인 후 삭제됩니다.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            rttr.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/biz/store/reviews";
    }

    //지윤 26.07.21 추가: Q&A관리 목록 (미답변 우선 정렬)
    @GetMapping("/qna")
    public String storeQna(HttpSession session, Model model) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        model.addAttribute("qnaList", bizStoreService.getBizQnaList(bizNo));
        return "biz/store/qna";
    }

    //지윤 26.07.21 추가: Q&A 답변 작성/수정
    @PostMapping("/qna/answer")
    public String saveQnaAnswer(@RequestParam("qnaId") Long qnaId,
                                 @RequestParam("answer") String answer,
                                 HttpSession session, RedirectAttributes rttr) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());
        boolean ok = bizStoreService.saveQnaAnswer(bizNo, qnaId, answer);
        rttr.addFlashAttribute(ok ? "msg" : "errorMsg", ok ? "답변이 등록되었습니다." : "본인 상품의 문의가 아닙니다.");
        return "redirect:/biz/store/qna";
    }

    @GetMapping("/settlement")
    public String storeSettlement(HttpSession session) {
        if (getBizMember(session) == null)
            return "redirect:/login";
        return "biz/store/settlement";
    }

    //지윤 26.07.23 수정: 목업 -> 실데이터 연동
    @GetMapping("/info")
    public String storeInfo(HttpSession session, Model model) {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        model.addAttribute("info", bizStoreService.getBusinessInfo(bizNo));
        return "biz/store/info";
    }

    //지윤 26.07.23 추가: 사업자 정보 저장
    @PostMapping("/info")
    public String saveInfo(@RequestParam String shopName, @RequestParam String ceoName, @RequestParam String bizRegNo,
                            @RequestParam String addr,
                            @RequestParam(required = false) String addrDetail, @RequestParam String phone,
                            @RequestParam(required = false) MultipartFile certFile,
                            HttpSession session, RedirectAttributes rttr) throws Exception {
        MemberVO biz = getBizMember(session);
        if (biz == null) return "redirect:/login";
        Long bizNo = bizStoreService.getBizNo(biz.getMemberId());

        com.petcare.petcare.biz.store.vo.BizInfoVO existing = bizStoreService.getBusinessInfo(bizNo);

        com.petcare.petcare.biz.store.vo.BizInfoVO info = new com.petcare.petcare.biz.store.vo.BizInfoVO();
        info.setShopName(shopName);
        info.setCeoName(ceoName);
        info.setBizRegNo(bizRegNo);
        info.setBizType(existing.getBizType());
        info.setAddr(addr);
        info.setAddrDetail(addrDetail);
        info.setPhone(phone);

        bizStoreService.updateBusinessInfo(bizNo, info, certFile);
        rttr.addFlashAttribute("msg", "사업자 정보가 저장되었습니다.");
        return "redirect:/biz/store/info";
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
                                   @RequestParam(required = false) String tags,
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
        product.setTags(tags);

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
                                       @RequestParam(required = false) String tags,
                                       @RequestParam(required = false) Long[] optionId,
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
        product.setTags(tags);

        bizStoreService.updateProduct(product, buildOptions(optionId, optionColor, optionSize, addPrice, stockQty), image);
        return "redirect:/biz/store/products";
    }

    //지윤 26.07.15 폼 배열(옵션당 1줄씩)을 OptionVO 리스트로 변환
    //지윤 26.07.15 수정: 배열 길이가 서로 안 맞아도(브라우저 재전송 등) 에러 안 나게 방어 코드 추가
    //지윤 26.07.24 수정: optionId 오버로드 추가 (수정화면에서 어느 옵션인지 정확히 구분하기 위함)
    private List<OptionVO> buildOptions(String[] optionColor, String[] optionSize, Integer[] addPrice, Integer[] stockQty) {
        return buildOptions(null, optionColor, optionSize, addPrice, stockQty);
    }

    private List<OptionVO> buildOptions(Long[] optionId, String[] optionColor, String[] optionSize, Integer[] addPrice, Integer[] stockQty) {
        List<OptionVO> options = new ArrayList<>();
        if (optionSize == null) return options;
        for (int i = 0; i < optionSize.length; i++) {
            OptionVO opt = new OptionVO();
            opt.setOptionId(optionId != null && optionId.length > i ? optionId[i] : null);
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