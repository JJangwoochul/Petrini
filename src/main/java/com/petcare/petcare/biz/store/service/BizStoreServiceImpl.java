/**
 * 역할: BizStoreService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: BizStoreService
 * - 사용: BizStoreMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.biz.store.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.biz.store.mapper.BizStoreMapper;
import com.petcare.petcare.biz.store.vo.BizDeliveryVO;
import com.petcare.petcare.biz.store.vo.BizOrderVO;
import com.petcare.petcare.biz.store.vo.BizProductVO;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.OptionVO;
import com.petcare.petcare.biz.store.vo.BizOrderVO;
import com.petcare.petcare.biz.store.vo.BizDeliveryVO;
import com.petcare.petcare.common.external.service.TossPaymentService;

@Service
public class BizStoreServiceImpl implements BizStoreService {

    @Autowired
    private BizStoreMapper bizStoreMapper;

    @Autowired
    private FileService fileService;

    //지윤 26.07.22 추가: 주문취소 승인 시 토스 결제취소 API 호출용
    @Autowired
    private TossPaymentService tossPaymentService;

    //지윤 26.07.22 추가: 취소승인 DB반영 트랜잭션 전용 (self-invocation 문제로 별도 빈 분리)
    @Autowired
    private OrderCancelTxService orderCancelTxService;

    //지윤 26.07.14 페이지당 상품 개수 (요청대로 10개)
    private static final int PAGE_SIZE = 10;

    //지윤 26.07.14 로그인 ID로 BIZ_NO 조회 (컨트롤러가 세션에서 로그인 ID만 갖고 있어서 매 요청마다 이걸로 실제 사업자번호를 알아냄)
    @Override
    public Long getBizNo(String bizId) {
        return bizStoreMapper.selectBizNoByBizId(bizId);
    }

    //지윤 26.07.15 수정: 상품목록 조회 + 할인율 계산 + 상품마다 옵션 목록도 같이 채워넣음 (옵션별 재고 표시용)
    @Override
    public List<BizProductVO> getProductList(Long bizNo, String keyword, Long categoryId, String statusCd, int pageNo) {
        int offset = (pageNo - 1) * PAGE_SIZE;
        List<BizProductVO> list = bizStoreMapper.selectProductList(bizNo, keyword, categoryId, statusCd, offset, PAGE_SIZE);
        for (BizProductVO p : list) {
            //정가 대비 판매가 할인율 계산 (store 모듈과 동일 로직)
            if (p.getPrice() != null && p.getSalePrice() != null && p.getPrice() > 0) {
                int rate = (int) Math.round((p.getPrice() - p.getSalePrice()) * 100.0 / p.getPrice());
                p.setDiscountRate(rate);
            } else {
                p.setDiscountRate(0);
            }
            //옵션 있는 상품은 옵션별 재고를 화면에서 나눠서 보여줘야 해서 같이 채워넣음
            p.setOptionList(bizStoreMapper.selectProductOptions(p.getProductId()));
        }
        return list;
    }

    //지윤 26.07.14 상품목록 총 페이지 수 (페이지네이션 버튼 개수 계산용)
    @Override
    public int getTotalPages(Long bizNo, String keyword, Long categoryId, String statusCd) {
        int totalCount = bizStoreMapper.selectProductCount(bizNo, keyword, categoryId, statusCd);
        return (int) Math.ceil(totalCount / (double) PAGE_SIZE);
    }

   //지윤 26.07.15 수정: 옵션 재고 합계로 STOCK_QTY 자동 계산, 합계 0이면 STATUS_CD 강제 SOLDOUT
   //이미지도 공용 FileService로 등록 (REF_TYPE='PRODUCT')
    @Override
    public void addProduct(BizProductVO product, List<OptionVO> options, MultipartFile image) throws Exception {
        int totalStock = sumStock(options);
        String statusCd = (product.getStatusCd() == null || product.getStatusCd().isBlank()) ? "NORMAL" : product.getStatusCd();
        if (totalStock == 0) statusCd = "SOLDOUT";

        Long newId = bizStoreMapper.selectNextProductId();
        String productCd = "P-" + String.format("%04d", newId);

        bizStoreMapper.insertProduct(newId, productCd, product.getProductName(), product.getBizNo(),
                product.getCategoryId(), product.getPrice(), product.getSalePrice(),
                product.getDescription(), product.getBrandName(), statusCd, product.getTags());

        saveOptions(newId, options);

        if (image != null && !image.isEmpty()) {
            fileService.uploadFile(image, "PRODUCT", newId);
        }
    }

    //지윤 26.07.15 수정: 옵션 리스트도 같이 채워서 반환 (수정 모달 프리필용)
    @Override
    public BizProductVO getProductDetail(Long productId, Long bizNo) {
        BizProductVO vo = bizStoreMapper.selectProductDetail(productId, bizNo);
        if (vo != null) {
            vo.setOptionList(bizStoreMapper.selectProductOptions(productId));
        }
        return vo;
    }

    //지윤 26.07.15 수정: 옵션 전체 삭제 후 재등록, 재고 합계 0이면 강제 SOLDOUT, 이미지 새로 올렸을 때만 교체
    @Override
    public boolean updateProduct(BizProductVO product, List<OptionVO> options, MultipartFile image) throws Exception {
        int totalStock = sumStock(options);
        String statusCd = product.getStatusCd();
        if (totalStock == 0) statusCd = "SOLDOUT";

        int updated = bizStoreMapper.updateProduct(product.getProductId(), product.getBizNo(),
                product.getProductName(), product.getCategoryId(), product.getPrice(), product.getSalePrice(),
                product.getDescription(), product.getBrandName(), statusCd, product.getTags());
        if (updated == 0) return false;

        bizStoreMapper.deleteProductOptions(product.getProductId());
        saveOptions(product.getProductId(), options);

       //지윤 26.07.15 수정: 새 이미지 올릴 때 기존 이미지 먼저 삭제 (안 그러면 옛날 이미지가 계속 썸네일로 뜸)
        if (image != null && !image.isEmpty()) {
            fileService.deleteFilesByRef("PRODUCT", product.getProductId());
            fileService.uploadFile(image, "PRODUCT", product.getProductId());
        }
        return true;
    }

    //지윤 26.07.15 옵션 리스트 저장 공통 처리 (등록/수정 둘 다 사용), 색상 비워두면 "기본"으로 저장
    private void saveOptions(Long productId, List<OptionVO> options) {
        for (OptionVO opt : options) {
            Long optId = bizStoreMapper.selectNextOptionId();
            String color = (opt.getOptionColor() == null || opt.getOptionColor().isBlank()) ? "기본" : opt.getOptionColor();
            bizStoreMapper.insertProductOption(optId, productId, color, opt.getOptionSize(), opt.getAddPrice(), opt.getStockQty());
        }
    }

    //지윤 26.07.15 옵션 재고 합계 계산
    private int sumStock(List<OptionVO> options) {
        int total = 0;
        for (OptionVO opt : options) {
            total += (opt.getStockQty() == null ? 0 : opt.getStockQty());
        }
        return total;
    }

    //지윤 26.07.14 상품 등록/수정 폼 카테고리 드롭다운 목록
    @Override
    public List<CategoryVO> getLeafCategories() {
        return bizStoreMapper.selectLeafCategories();
    }

    //지윤 26.07.15 상품목록 총 개수 (화면에 "총 N개" 표시용)
    @Override
    public int getTotalCount(Long bizNo, String keyword, Long categoryId, String statusCd) {
        return bizStoreMapper.selectProductCount(bizNo, keyword, categoryId, statusCd);
    }

    //지윤 26.07.20 추가: 사업자 주문 목록 조회
    @Override
    public List<BizOrderVO> getOrderList(Long bizNo, String statusCd) {
        return bizStoreMapper.selectOrderList(bizNo, statusCd);
    }

    //지윤 26.07.20 추가: 상태별 주문 개수를 Map으로 가공 (화면에서 statusCounts.PAID 이런 식으로 바로 꺼내쓰기 위함)
    @Override
    public java.util.Map<String, Integer> getOrderStatusCounts(Long bizNo) {
        java.util.Map<String, Integer> result = new java.util.HashMap<>();
        for (java.util.Map<String, Object> row : bizStoreMapper.selectOrderStatusCounts(bizNo)) {
            String status = (String) row.get("STATUS");
            Number cnt = (Number) row.get("CNT");
            result.put(status, cnt.intValue());
        }
        //지윤 26.07.22 추가: 취소신청 대기중 건수도 같은 Map에 넣어서 화면에서 statusCounts.CLAIM_PENDING으로 바로 사용
        result.put("CLAIM_PENDING", bizStoreMapper.selectClaimPendingCount(bizNo));
        return result;
    }

    //지윤 26.07.20 추가: 주문 상세 조회 (상품목록까지 같이 채워서 반환)
    @Override
    public BizOrderVO getOrderDetail(Long orderId, Long bizNo) {
        BizOrderVO vo = bizStoreMapper.selectOrderDetail(orderId, bizNo);
        if (vo != null) {
            vo.setItemList(bizStoreMapper.selectOrderItems(orderId));
        }
        return vo;
    }

    //지윤 26.07.22 추가: 취소신청 승인
    //순서 중요: 토스 API를 먼저 부르고, 성공했을 때만 DB를 건드림
    @Override
    public String approveOrderCancel(Long orderId, Long bizNo) {
        BizOrderVO order = bizStoreMapper.selectOrderDetail(orderId, bizNo);
        if (order == null || !"PENDING".equals(order.getClaimStatus())) {
            return "취소신청 대기중인 주문이 아닙니다.";
        }
        if (order.getTossPaymentKey() == null) {
            return "결제 정보를 찾을 수 없습니다.";
        }

        String tossError = tossPaymentService.cancelPayment(order.getTossPaymentKey(), order.getCancelReason());
        if (tossError != null) {
            return tossError;
        }

        orderCancelTxService.applyCancelToDb(order, bizNo);
        return null;
    }

    //지윤 26.07.22 추가: 취소신청 반려 (토스 호출 없이 상태만 변경)
    @Override
    public boolean rejectOrderCancel(Long orderId, Long bizNo) {
        return bizStoreMapper.updateClaimReject(orderId, bizNo) > 0;
    }

    //지윤 26.07.20 추가: 주문 상태 변경 + 배송정보(택배사/송장번호) 저장
    //송장번호가 입력되면 배송상태를 자동으로 SHIPPING으로, 이미 배송정보 있으면 UPDATE 없으면 INSERT
    @Override
    public boolean updateOrderStatus(Long orderId, Long bizNo, String orderStatus, String courierName, String trackingNo) {
        int updated = bizStoreMapper.updateOrderStatus(orderId, bizNo, orderStatus);
        if (updated == 0) return false;

        //지윤 26.07.21 추가: READY/SHIPPING/DONE으로 바뀔 때마다 해당 단계 시각 자동 기록 (배송정보 타임라인용)
        String tsColumn = switch (orderStatus) {
            case "READY" -> "READY_AT";
            case "SHIPPING" -> "SHIPPING_AT";
            case "DONE" -> "DELIVERED_AT";
            default -> null;
        };
        if (tsColumn != null) {
            bizStoreMapper.updateDeliveryTimestamp(orderId, bizNo, tsColumn);
        }

        //택배사나 송장번호를 입력한 경우에만 배송정보 저장 (둘 다 비어있으면 배송정보 자체를 안 건드림)
        if ((courierName != null && !courierName.isBlank()) || (trackingNo != null && !trackingNo.isBlank())) {
            String deliveryStatus = (trackingNo != null && !trackingNo.isBlank()) ? "SHIPPING" : "READY";
            int exists = bizStoreMapper.selectDeliveryExists(orderId);
            if (exists > 0) {
                bizStoreMapper.updateOrderDelivery(orderId, courierName, trackingNo, deliveryStatus);
            } else {
                bizStoreMapper.insertOrderDelivery(orderId, bizNo, courierName, trackingNo, deliveryStatus);
            }
        }
        return true;
    }

    //지윤 26.07.20 추가: 배송관리 목록 조회 + 지연여부(3일 이상 SHIPPING) 자바에서 계산
    @Override
    public List<BizDeliveryVO> getDeliveryList(Long bizNo, String carrier, String statusCd, String keyword) {
        List<BizDeliveryVO> list = bizStoreMapper.selectDeliveryList(bizNo, carrier, statusCd, keyword);
        for (BizDeliveryVO d : list) {
            d.setDelayed(isDelayed(d));
        }
        return list;
    }

    //지윤 26.07.20 추가: 상단 요약카드 - 필터 없이 전체 기준으로 다시 조회해서 상태별 개수 집계
    @Override
    public java.util.Map<String, Integer> getDeliverySummary(Long bizNo) {
        List<BizDeliveryVO> all = bizStoreMapper.selectDeliveryList(bizNo, null, null, null);
        java.util.Map<String, Integer> result = new java.util.HashMap<>();
        int ready = 0, shipping = 0, done = 0, delay = 0;
        for (BizDeliveryVO d : all) {
            if ("READY".equals(d.getOrderStatus())) ready++;
            else if ("SHIPPING".equals(d.getOrderStatus())) shipping++;
            else if ("DONE".equals(d.getOrderStatus())) done++;
            if (isDelayed(d)) delay++;
        }
        result.put("READY", ready);
        result.put("SHIPPING", shipping);
        result.put("DONE", done);
        result.put("DELAY", delay);
        return result;
    }

    //지윤 26.07.20 지연 판단: SHIPPING 상태이고, 송장 등록일(shipDate)로부터 3일 이상 지난 경우
    private boolean isDelayed(BizDeliveryVO d) {
        if (!"SHIPPING".equals(d.getOrderStatus()) || d.getShipDate() == null) return false;
        try {
            java.time.LocalDate shipped = java.time.LocalDate.parse(d.getShipDate());
            long diffDays = java.time.temporal.ChronoUnit.DAYS.between(shipped, java.time.LocalDate.now());
            return diffDays >= 3;
        } catch (Exception e) {
            return false;
        }
    }

    //지윤 26.07.20 추가: 송장 일괄등록 - 한 줄씩 파싱해서 주문번호로 ORDER_ID 찾고, 기존 updateOrderStatus 재사용해서 저장
    @Override
    public java.util.Map<String, Object> bulkRegisterDelivery(Long bizNo, String bulkText) {
        java.util.List<String> validCarriers = java.util.List.of("cj", "hanjin", "lotte", "post");
        int okCount = 0;
        java.util.List<String> failLines = new java.util.ArrayList<>();

        String[] lines = bulkText.split("\\r?\\n");
        for (String rawLine : lines) {
            String line = rawLine.trim();
            if (line.isEmpty()) continue;

            String[] parts = line.split(",");
            if (parts.length != 3) { failLines.add(line); continue; }

            String orderNo = parts[0].trim();
            String carrier = parts[1].trim();
            String trackingNo = parts[2].trim();

            if (!validCarriers.contains(carrier)) { failLines.add(line); continue; }

            Long orderId = bizStoreMapper.selectOrderIdByOrderNo(orderNo, bizNo);
            if (orderId == null) { failLines.add(line); continue; }

            //지윤 26.07.20 참고: 아까 주문관리(orders.jsp)용으로 만든 updateOrderStatus를 그대로 재사용
            //(택배사/송장번호 넣으면 자동으로 SHIPPING 상태 + 배송정보 upsert 처리됨)
            boolean ok = updateOrderStatus(orderId, bizNo, "SHIPPING", carrier, trackingNo);
            if (ok) okCount++; else failLines.add(line);
        }

        java.util.Map<String, Object> result = new java.util.HashMap<>();
        result.put("okCount", okCount);
        result.put("failLines", failLines);
        return result;
    }

    //지윤 26.07.20 추가: 리뷰관리 목록
    @Override
    public List<com.petcare.petcare.biz.store.vo.BizReviewVO> getBizReviewList(Long bizNo) {
        return bizStoreMapper.selectBizReviewList(bizNo);
    }

    //지윤 26.07.20 추가: 답글 작성/수정 (본인 상품 리뷰만 반영됨 - UPDATE 조건에 BIZ_NO 포함)
    @Override
    public boolean saveReviewBizReply(Long bizNo, Long reviewId, String bizReply) {
        int updated = bizStoreMapper.updateReviewBizReply(reviewId, bizNo, bizReply);
        return updated > 0;
    }

    //지윤 26.07.20 추가: 리뷰 삭제요청 - 즉시 삭제 X, TB_REVIEW_REPORT에 PENDING 등록만 (관리자 승인 후 실제 삭제)
    @Override
    public void requestReviewDelete(Long bizNo, Long reviewId, String reason) {
        if (bizStoreMapper.selectReviewOwnedByBiz(reviewId, bizNo) == 0) {
            throw new IllegalArgumentException("본인 상품의 리뷰가 아닙니다.");
        }
        if (bizStoreMapper.selectPendingReportExists(reviewId) > 0) {
            throw new IllegalStateException("이미 삭제 요청이 접수되어 관리자 승인을 기다리고 있습니다.");
        }
        bizStoreMapper.insertReviewDeleteRequest(reviewId, bizNo, reason);
    }

   //지윤 26.07.21 추가: 사이드바 "주문관리" 뱃지용 - 결제완료(PAID) 상태 주문 개수
   @Override
   public int getPaidOrderCount(Long bizNo) {
       return bizStoreMapper.selectPaidOrderCount(bizNo);
   }

   //지윤 26.07.21 추가: Q&A관리 목록
   @Override
   public List<com.petcare.petcare.biz.store.vo.BizQnaVO> getBizQnaList(Long bizNo) {
       return bizStoreMapper.selectBizQnaList(bizNo);
   }

   //지윤 26.07.21 추가: Q&A 답변 등록/수정 (본인 상품 질문만 반영됨 - UPDATE 조건에 BIZ_NO 포함)
   @Override
   public boolean saveQnaAnswer(Long bizNo, Long qnaId, String answer) {
       int updated = bizStoreMapper.updateQnaAnswer(qnaId, bizNo, answer);
       return updated > 0;
   }
}