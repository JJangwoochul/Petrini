/**
 * 역할: 마이페이지 주문 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/mypage/order/MypageOrderMapper.xml
 * namespace: com.petcare.petcare.mypage.order.mapper.MypageOrderMapper
 *
 * 쿼리 예시
 * - selectOrderList
 * - selectOrderDetail
 *
 * 참고 테이블
 * - TB_ORDER
 * - TB_ORDER_ITEM
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.mypage.order.mapper;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface MypageOrderMapper {}
