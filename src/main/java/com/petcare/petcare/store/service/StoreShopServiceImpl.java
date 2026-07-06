/**
 * 역할: StoreShopService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: StoreShopService
 * - 사용: StoreShopMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.store.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.petcare.petcare.store.mapper.StoreShopMapper;
import com.petcare.petcare.store.vo.StoreShopVO;
import com.petcare.petcare.store.vo.CategoryVO;

@Service
public class StoreShopServiceImpl implements StoreShopService {

    @Autowired
    private StoreShopMapper storeShopMapper;

    //지윤 26.07.06 페이지당 상품 개수 (요구사항 고정값)
    private static final int PAGE_SIZE = 12;

    //지윤 26.07.06 카테고리/검색어/정렬/페이지네이션 파라미터(pageNo) 추가
    @Override
    public List<StoreShopVO> getProductList(Long categoryId, String keyword, String sort, int pageNo) {
        int offset = (pageNo - 1) * PAGE_SIZE;
        List<StoreShopVO> list = storeShopMapper.selectProductList(categoryId, keyword, sort, offset, PAGE_SIZE);
        for (StoreShopVO p : list) {
            if (p.getPrice() != null && p.getSalePrice() != null && p.getPrice() > 0) {
                int rate = (int) Math.round((p.getPrice() - p.getSalePrice()) * 100.0 / p.getPrice());
                p.setDiscountRate(rate);
            } else {
                p.setDiscountRate(0);
            }
        }
        return list;
    }

  //지윤 26.07.06 총 페이지 수 계산 (전체개수 / 12, 나머지 있으면 올림)
  @Override
  public int getTotalPages(Long categoryId, String keyword) {
      int totalCount = storeShopMapper.selectProductCount(categoryId, keyword);
      return (int) Math.ceil(totalCount / (double) PAGE_SIZE);
  }

  //지윤 26.07.06 카테고리 트리는 가공 없이 그대로 전달
  @Override
  public List<CategoryVO> getCategoryTree() {
      return storeShopMapper.selectCategoryTree();
  }
}
