/**
 * 역할: StayStayService 구현체 (@Service)
 *
 * 구현 내용
 * - Controller에서 넘어온 요청 처리
 * - Mapper 호출하여 DB 조회·수정
 * - 비즈니스 규칙 검증 및 결과 반환
 *
 * 연결
 * - implements: StayStayService
 * - 사용: StayStayMapper
 *
 * 비즈니스 로직은 여기에 작성 (Controller, Mapper에 직접 작성 X)
 */

package com.petcare.petcare.stay.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.petcare.petcare.common.external.service.KakaoMessageService;
import com.petcare.petcare.stay.vo.ReservationVO;
import com.petcare.petcare.stay.vo.StayPetVO;
import com.petcare.petcare.stay.mapper.StayMapper;
import com.petcare.petcare.stay.vo.StayReviewVO;
import com.petcare.petcare.stay.vo.StayRoomVO;
import com.petcare.petcare.stay.vo.StayVO;

@Service
public class StayServiceImpl implements StayService {

    private static final Logger log = LoggerFactory.getLogger(StayServiceImpl.class);

    @Autowired
    private StayMapper stayMapper;

    @Autowired
    private KakaoMessageService kakaoMessageService;

    @Override
    public List<StayVO> getStayList() {
        return stayMapper.selectStayList();
    }

    @Override
    public List<StayVO> getStayListBySearch(StayVO searchVO) {
        return stayMapper.selectStayListBySearch(searchVO);
    }
    
    @Override
    public StayVO getStayById(Long stayId) {
        StayVO stay = stayMapper.selectStayById(stayId);
        if (stay != null) {
            List<StayRoomVO> rooms = stayMapper.selectRoomsByStayId(stayId);
            stay.setRooms(rooms);
        }
        return stay;
    }

    @Override
    public List<StayPetVO> getPetList(Long memberNo) {
        return stayMapper.selectPetListByMemberNo(memberNo);
    }

    @Override
    @Transactional(readOnly = true)
    public List<StayReviewVO> getStayReviews(Long stayId) throws Exception {
        if (stayId == null) {
            return List.of();
        }
        return stayMapper.selectStayReviews(stayId);
    }

    // HYJ 26.07.20 가용성 체크 (단순 조회 — 락 없음)
    @Override
    public boolean checkRoomAvailability(Long roomId, Date checkinDate, Date checkoutDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("roomId", roomId);
        param.put("checkinDate", checkinDate);
        param.put("checkoutDate", checkoutDate);
        int count = stayMapper.countOverlappingReservation(param);
        return count == 0;
    }

    // HYJ 26.07.20 예약 생성 (비관적 락 + 가용성 검증)
    @Override
    public Long createStayReservation(ReservationVO vo) {
        // 1. 객실 행 잠금
        StayRoomVO room = stayMapper.selectRoomForUpdate(vo.getRoomId());
        if (room == null) {
            throw new RuntimeException("존재하지 않는 객실입니다.");
        }

        // 2. 날짜 겹침 확인
        Map<String, Object> param = new HashMap<>();
        param.put("roomId", vo.getRoomId());
        param.put("checkinDate", vo.getCheckinDate());
        param.put("checkoutDate", vo.getCheckoutDate());
        int overlap = stayMapper.countOverlappingReservation(param);
        if (overlap > 0) {
            throw new RuntimeException("해당 날짜에 이미 예약이 있습니다.");
        }

        // 3. 금액 계산 (서버에서 재계산)
        int nightCnt = vo.getNightCnt();
        long totalAmount = (long) room.getPricePerNight() * nightCnt;
        vo.setTotalAmount(totalAmount);

        // 4. PENDING 상태로 예약 INSERT
        vo.setResvType("STAY");
        vo.setStatusCd("PENDING");
        vo.setResvNo("S" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
        stayMapper.insertReservation(vo);
        return vo.getResvId();
    }

    // HYJ 26.07.20 결제 확정 (PENDING → CONFIRMED + TB_PAYMENT INSERT + 포인트 차감)
    @Override
    @Transactional
    public void confirmPayment(Long resvId, String tossPaymentKey, String tossOrderId, String payMethod, String kakaoAccessToken, Long memberNo, long usedPoint) {
        // 예약 조회
        ReservationVO resv = stayMapper.selectReservationById(resvId);
        if (resv == null) {
            throw new RuntimeException("예약 정보를 찾을 수 없습니다.");
        }
        if (!"PENDING".equals(resv.getStatusCd())) {
            throw new RuntimeException("결제할 수 없는 예약 상태입니다.");
        }

        // 포인트 사용 처리
        if (usedPoint > 0) {
            if (memberNo == null) {
                throw new RuntimeException("회원 정보가 없습니다.");
            }
            // 보유 포인트 확인
            Long currentBalance = stayMapper.selectMemberPointBalance(memberNo);
            if (currentBalance == null || currentBalance < usedPoint) {
                throw new RuntimeException("보유 포인트가 부족합니다.");
            }

            // 포인트 잔액 차감
            Map<String, Object> deductParam = new HashMap<>();
            deductParam.put("memberNo", memberNo);
            deductParam.put("pointAmount", usedPoint);
            stayMapper.deductMemberPointBalance(deductParam);

            // 차감 후 잔액 조회
            Long balanceAfter = stayMapper.selectMemberPointBalance(memberNo);

            // 포인트 이력 INSERT
            Map<String, Object> pointParam = new HashMap<>();
            pointParam.put("memberNo", memberNo);
            pointParam.put("pointAmount", String.valueOf(usedPoint));
            pointParam.put("balanceAfter", String.valueOf(balanceAfter));
            pointParam.put("refType", "STAY_PAYMENT");
            pointParam.put("refId", String.valueOf(resvId));
            stayMapper.insertPointHistory(pointParam);
        }

        // 예약 상태 → CONFIRMED
        Map<String, Object> statusParam = new HashMap<>();
        statusParam.put("resvId", resvId);
        statusParam.put("statusCd", "CONFIRMED");
        stayMapper.updateReservationStatus(statusParam);

        // 결제 정보 INSERT
        Map<String, Object> payParam = new HashMap<>();
        payParam.put("resvId", resvId);
        payParam.put("payMethod", payMethod);
        payParam.put("payAmount", resv.getTotalAmount());
        payParam.put("tossPaymentKey", tossPaymentKey);
        payParam.put("tossOrderId", tossOrderId);
        payParam.put("payStatus", "DONE");
        stayMapper.insertPayment(payParam);

        // HYJ 26.07.20 카카오톡 "나에게 보내기" 알림 발송
        // 카카오 로그인 사용자만 (accessToken 있을 때) + 실패해도 결제는 정상 유지
        if (kakaoAccessToken != null && !kakaoAccessToken.isBlank()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
                String ciStr = sdf.format(resv.getCheckinDate());
                String coStr = sdf.format(resv.getCheckoutDate());

                // 숙소명·객실명·반려동물명 조회 (JOIN 포함)
                ReservationVO fullResv = stayMapper.selectReservationById(resvId);
                String stayName = fullResv.getStayName()    != null ? fullResv.getStayName()    : "숙소";
                String roomName = fullResv.getServiceName() != null ? fullResv.getServiceName() : "객실";
                String petName  = fullResv.getPetName()      != null ? fullResv.getPetName()      : "";

                kakaoMessageService.sendStayReservationMessage(
                    kakaoAccessToken,
                    resv.getResvNo(),
                    stayName,
                    roomName,
                    ciStr,
                    coStr,
                    resv.getNightCnt(),
                    resv.getTotalAmount(),
                    petName
                );
            } catch (Exception e) {
                log.warn("[Stay] 카카오톡 알림 발송 실패 — resvId={}, 예약은 정상 처리됨", resvId, e);
            }
        }
    }
        
    @Override
    public ReservationVO getReservationById(Long resvId) {
        return stayMapper.selectReservationById(resvId);
    }
}
