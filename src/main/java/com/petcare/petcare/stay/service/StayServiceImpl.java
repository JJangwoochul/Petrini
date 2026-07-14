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
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

    @Override
    public Long createStayReservation(ReservationVO vo) {
        vo.setResvType("STAY");
        vo.setStatusCd("PENDING");
        vo.setResvNo("S" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
        stayMapper.insertStayReservation(vo);
        return vo.getResvId();
    }

    @Override
    public ReservationVO getStayReservationById(Long resvId) {
        return stayMapper.selectStayReservationById(resvId);
    }
}
