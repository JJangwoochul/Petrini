/**
 * 역할: 펫호텔 DB 접근 (MyBatis interface)
 *
 * XML: resources/mybatis/mapper/stay/StayStayMapper.xml
 * namespace: com.petcare.petcare.stay.mapper.StayStayMapper
 *
 * 쿼리 예시
 * - selectStayList
 * - selectStayDetail
 * - insertReservation
 *
 * 참고 테이블
 * - TB_STAY
 * - TB_RESERVATION
 *
 * SQL은 XML에만 작성 (@Select 등 어노테이션 사용 X)
 * 메서드명은 Service에서 호출하는 이름과 동일하게
 */

package com.petcare.petcare.stay.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.petcare.petcare.hospital.vo.HospitalPetVO;
import com.petcare.petcare.hospital.vo.ReservationVO;
import com.petcare.petcare.stay.vo.StayRoomVO;
import com.petcare.petcare.stay.vo.StayVO;


@Mapper
public interface StayMapper {
    // 숙소 목록 (최저가 포함)
    List<StayVO> selectStayList();

    // 숙소 검색 목록 (필터 조건 적용)
    List<StayVO> selectStayListBySearch(StayVO searchVO);
    
    // 숙소 상세
    StayVO selectStayById(Long stayId);

    // 해당 숙소의 객실 목록
    List<StayRoomVO> selectRoomsByStayId(Long stayId);   
    
    // 예약
    List<HospitalPetVO> selectPetListByMemberNo(Long memberNo);
    void insertReservation(ReservationVO vo);
    ReservationVO selectReservationById(Long resvId);

    // HYJ 26.07.20 가용성 체크
    StayRoomVO selectRoomForUpdate(Long roomId);
    int countOverlappingReservation(Map<String, Object> param);

    // HYJ 26.07.20 예약 상태 변경
    void updateReservationStatus(Map<String, Object> param);

    // HYJ 26.07.20 결제
    void insertPayment(Map<String, Object> param);
}
