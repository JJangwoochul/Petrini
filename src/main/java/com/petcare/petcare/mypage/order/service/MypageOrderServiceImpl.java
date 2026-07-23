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
import com.petcare.petcare.mypage.notify.service.MypageNotifyService;

@Service
public class MypageOrderServiceImpl implements MypageOrderService {

    //지윤 26.07.23 추가: 취소신청 시 사업자에게 알림 보내기 위함
    @Autowired
    private MypageNotifyService mypageNotifyService;

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
    //지윤 26.07.23 수정: 50자 미만 리뷰는 등록 자체를 막음 + 등록 성공 시 텍스트/포토 적립금 지급
    @Override
    public Integer writeReview(Long memberNo, Long orderItemId, Double rating, String content,
                                List<MultipartFile> images) throws Exception {
        int minLength = Integer.parseInt(mypageOrderMapper.selectPolicyValue("REVIEW_MIN_LENGTH"));
        if (content == null || content.trim().length() < minLength) {
            return null;
        }

        int inserted = mypageOrderMapper.insertProductReview(orderItemId, memberNo, rating, content);
        if (inserted == 0) return null;

        Long reviewId = mypageOrderMapper.selectReviewIdByOrderItem(orderItemId);
        boolean hasImage = false;
        if (images != null && !images.isEmpty()) {
            for (MultipartFile image : images) {
                if (image != null && !image.isEmpty()) {
                    fileService.uploadFile(image, "REVIEW", reviewId);
                    hasImage = true;
                }
            }
        }

        String policyKey = hasImage ? "REVIEW_PHOTO" : "REVIEW_TEXT";
        int earnPoint = Integer.parseInt(mypageOrderMapper.selectPolicyValue(policyKey));
        int currentBalance = mypageOrderMapper.selectMemberPointBalance(memberNo);
        int newBalance = currentBalance + earnPoint;
        mypageOrderMapper.addMemberPoint(memberNo, newBalance);
        mypageOrderMapper.insertPointEarnHistory(memberNo, earnPoint, newBalance, "REVIEW", "REVIEW", reviewId);

        return earnPoint;
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
    //지윤 26.07.23 수정: 성공하면 사업자에게 알림도 같이 전송
    @Override
    public boolean requestCancel(Long memberNo, Long orderId, String reason) {
        int updated = mypageOrderMapper.requestCancel(orderId, memberNo, reason);
        if (updated > 0) {
            Long bizMemberNo = mypageOrderMapper.selectBizMemberNoByOrderId(orderId);
            MypageOrderVO order = mypageOrderMapper.selectOrderDetail(orderId, memberNo);
            mypageNotifyService.sendCancelRequestNotification(bizMemberNo, order.getOrderNo(), reason);
        }
        return updated > 0;
    }

    //지윤 26.07.23 추가: 구매확정 처리 (DONE 상태 주문만, 결제금액의 정책 % 만큼 적립)
    @Override
    public Integer confirmPurchase(Long memberNo, Long orderId) {
        int updated = mypageOrderMapper.confirmPurchaseOrder(orderId, memberNo);
        if (updated == 0) return null;

        MypageOrderVO order = mypageOrderMapper.selectOrderDetail(orderId, memberNo);
        int rate = Integer.parseInt(mypageOrderMapper.selectPolicyValue("PURCHASE_RATE"));
        int earnPoint = order.getPayAmount() * rate / 100;

        int currentBalance = mypageOrderMapper.selectMemberPointBalance(memberNo);
        int newBalance = currentBalance + earnPoint;
        mypageOrderMapper.addMemberPoint(memberNo, newBalance);
        mypageOrderMapper.insertPointEarnHistory(memberNo, earnPoint, newBalance, "PURCHASE_CONFIRM", "ORDER", orderId);

        return earnPoint;
    }
}