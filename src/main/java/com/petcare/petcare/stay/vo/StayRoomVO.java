package com.petcare.petcare.stay.vo;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class StayRoomVO {
    private Long   roomId;
    private Long   lodgeId;
    private String roomName;
    private int    pricePerNight;
    private int    capacity;
    private int    petLimit;
    private String statusCd;    
}
