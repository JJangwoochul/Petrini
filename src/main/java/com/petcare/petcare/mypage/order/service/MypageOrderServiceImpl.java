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

import com.petcare.petcare.mypage.order.mapper.MypageOrderMapper;
import com.petcare.petcare.mypage.order.vo.MypageOrderVO;

@Service
public class MypageOrderServiceImpl implements MypageOrderService {

    @Autowired
    private MypageOrderMapper mypageOrderMapper;

    //지윤 26.07.20 추가: 주문 목록 조회 + 주문마다 상품목록도 같이 채워넣음 (화면에서 카드 하나에 상품 여러 개 보여줘야 해서)
    @Override
    public List<MypageOrderVO> getOrderList(Long memberNo, String statusCd) {
        List<MypageOrderVO> list = mypageOrderMapper.selectOrderList(memberNo, statusCd);
        for (MypageOrderVO o : list) {
            o.setItemList(mypageOrderMapper.selectOrderItems(o.getOrderId()));
        }
        return list;
    }
}
