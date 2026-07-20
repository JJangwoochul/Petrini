/**
 * 역할: 마이페이지 주문 데이터 객체
 *
 * 필드 예시
 * - orderId, orderDate, totalAmount, orderStatus
 *
 * 참고 테이블
 * - TB_ORDER
 * - TB_ORDER_ITEM
 *
 * DB 컬럼명은 팀 VO 규칙(camelCase)에 맞게 작성
 */

package com.petcare.petcare.mypage.order.vo;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;

//지윤 26.07.20 마이페이지 주문내역 조회용 VO
@Getter @Setter
@ToString
@NoArgsConstructor
public class MypageOrderVO {
    private Long orderId;
    private String orderNo;
    private String orderDate;
    private String orderStatus;   //PAID/READY/SHIPPING/DONE/CANCEL
    private Integer payAmount;
    private List<MypageOrderItemVO> itemList;
}