/**
 * 역할: MypageOrderService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: MypageOrderService
 * - 사용: MypageOrderMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.mypage.order.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.petcare.petcare.file.service.FileService;
import com.petcare.petcare.mypage.order.mapper.MypageOrderMapper;
import com.petcare.petcare.mypage.order.vo.MypageOrderVO;

@Service
public class MypageOrderServiceImpl implements MypageOrderService {

    @Autowired
    private MypageOrderMapper mypageOrderMapper;

    //지윤 26.07.20 추가: 리뷰 사진 첨부용 (biz 상품이미지 업로드와 동일한 서비스 재사용)
    @Autowired
    private FileService fileService;

    //지윤 26.07.20 추가: 주문 목록 조회 + 주문마다 상품목록도 같이 채워넣음 (화면에서 카드 하나에 상품 여러 개 보여줘야 해서)
  @Override
    public List<MypageOrderVO> getOrderList(Long memberNo, String statusCd) {
        List<MypageOrderVO> list = mypageOrderMapper.selectOrderList(memberNo, statusCd);
        for (MypageOrderVO o : list) {
            o.setItemList(mypageOrderMapper.selectOrderItems(o.getOrderId()));
        }
        return list;
    }

    //지윤 26.07.20 수정: 사진 첨부 처리 추가. 리뷰 등록 성공하면 REVIEW_ID 재조회해서 이미지마다 FileService로 저장
    @Override
    public boolean writeReview(Long memberNo, Long orderItemId, Double rating, String content,
                                List<MultipartFile> images) throws Exception {
        int inserted = mypageOrderMapper.insertProductReview(orderItemId, memberNo, rating, content);
        if (inserted == 0) return false;

        if (images != null && !images.isEmpty()) {
            Long reviewId = mypageOrderMapper.selectReviewIdByOrderItem(orderItemId);
            for (MultipartFile image : images) {
                if (image != null && !image.isEmpty()) {
                    fileService.uploadFile(image, "REVIEW", reviewId);
                }
            }
        }
        return true;
    }

    //지윤 26.07.20 추가: 주문상세보기 1건 + 상품목록 (본인 주문 아니면 null 그대로 반환)
    @Override
    public MypageOrderVO getOrderDetail(Long memberNo, Long orderId) {
        MypageOrderVO order = mypageOrderMapper.selectOrderDetail(orderId, memberNo);
        if (order != null) {
            order.setItemList(mypageOrderMapper.selectOrderItems(order.getOrderId()));
        }
        return order;
    }

    //지윤 26.07.22 추가: 주문취소 신청 (실제 조건 체크는 매퍼 UPDATE의 WHERE절에서 함, 여기선 결과만 판단)
    @Override
    public boolean requestCancel(Long memberNo, Long orderId, String reason) {
        int updated = mypageOrderMapper.requestCancel(orderId, memberNo, reason);
        return updated > 0;
    }
}
