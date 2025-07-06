package com.sist.web.service;

import java.util.List;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;

public interface RoomService {
	
    /**
     * 숙소 등록에 관련된 모든 데이터(숙소, 객실타입, 편의시설, 이미지)를
     * 하나의 트랜잭션으로 묶어 DB에 저장 by nks
     * 인터페이스는 트랜잭션 기능 X 
     * @param room          숙소 정보 (List<RoomImage> roomImageList 포함)
     * @param roomTypeList  숙소타입(방1개) (List<RoomTypeImage> roomTypeImageList 포함)
     * @return 성공적으로 처리된 총 행의 수
     */	
	public int insertRoomTransaction(Room room, List<RoomType> roomTypeList);
	
}
