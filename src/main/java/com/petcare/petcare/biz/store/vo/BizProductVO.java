package com.petcare.petcare.biz.store.vo;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

import com.petcare.petcare.store.vo.OptionVO;

//지윤 26.07.15 사업자 상품관리(BIZ-04) 목록/등록/수정 공용 VO
//상태값(statusCd): NORMAL(판매중) / SOLDOUT(품절) / WAITING(입고대기) / STOPPED(판매중지)
//옵션별 재고 표시를 위해 optionList 필드 추가
@Getter @Setter
@ToString
@NoArgsConstructor
public class BizProductVO {
    private Long productId;
    private String productCd;
    private String productName;
    private Long bizNo;
    private Long categoryId;
    private String categoryName;
    private Integer price;
    private Integer salePrice;
    private Integer discountRate;
    private Integer stockQty;
    private String description;
    private String statusCd;
    private String thumbnailUrl;
    private String brandName;
    private String regDate;
    private List<OptionVO> optionList;
}
