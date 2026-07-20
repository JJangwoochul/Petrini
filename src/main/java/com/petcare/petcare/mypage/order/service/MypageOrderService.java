/**
 * 역할: 마이페이지 주문 내역 비즈니스 로직 (interface)
 *
 * 담당 화면
 * - mypage/orders.jsp         주문 내역
 *
 * 구현할 기능 예시
 * - 주문 목록·상세 조회
 * - 주문 취소 요청
 *
 * 연결
 * - 구현: MypageOrderServiceImpl
 * - 호출: MypageOrderController
 * - DB: MypageOrderMapper
 *
 * 참고 테이블
 * - TB_ORDER
 * - TB_ORDER_ITEM
 */

package com.petcare.petcare.mypage.order.service;

import java.util.List;

import com.petcare.petcare.mypage.order.vo.MypageOrderVO;

public interface MypageOrderService {

    //지윤 26.07.20 추가: 회원 본인 주문 목록 조회 (상태 필터, 상품목록까지 채워서 반환)
    List<MypageOrderVO> getOrderList(Long memberNo, String statusCd);
}
