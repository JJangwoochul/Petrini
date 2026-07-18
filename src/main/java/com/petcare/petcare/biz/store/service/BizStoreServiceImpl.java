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
import com.petcare.petcare.biz.store.vo.BizProductVO;
import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.store.vo.CategoryVO;
import com.petcare.petcare.store.vo.OptionVO;

@Service
public class BizStoreServiceImpl implements BizStoreService {

    @Autowired
    private BizStoreMapper bizStoreMapper;

    @Autowired
    private FileService fileService;

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
                product.getDescription(), product.getBrandName(), statusCd);

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
                product.getDescription(), product.getBrandName(), statusCd);
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
}