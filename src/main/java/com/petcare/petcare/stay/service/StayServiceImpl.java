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

import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.stay.mapper.StayMapper;
import com.petcare.petcare.stay.vo.StayRoomVO;
import com.petcare.petcare.stay.vo.StayVO;

@Service
public class StayServiceImpl implements StayService {

    @Autowired
    private StayMapper stayMapper;

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
    public List<HospitalPetVO> getPetList(Long memberNo) {
        return stayMapper.selectPetListByMemberNo(memberNo);
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

    // HYJ 26.07.20 결제 확정 (PENDING → CONFIRMED + TB_PAYMENT INSERT)
    @Override
    @Transactional
    public void confirmPayment(Long resvId, String tossPaymentKey, String tossOrderId, String payMethod) {
        // 예약 조회
        ReservationVO resv = stayMapper.selectReservationById(resvId);
        if (resv == null) {
            throw new RuntimeException("예약 정보를 찾을 수 없습니다.");
        }
        if (!"PENDING".equals(resv.getStatusCd())) {
            throw new RuntimeException("결제할 수 없는 예약 상태입니다.");
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
    }
        
    @Override
    public ReservationVO getReservationById(Long resvId) {
        return stayMapper.selectReservationById(resvId);
    }
}
