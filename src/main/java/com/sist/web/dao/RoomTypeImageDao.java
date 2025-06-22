package com.sist.web.dao;

import com.sist.web.model.RoomTypeImage;

public interface RoomTypeImageDao {
	
    /**
     * ROOM_TYPE_IMAGE 테이블에서 사용할 새로운 시퀀스 값을 조회
     * @return short 새로 발행된 시퀀스 번호
     */
    public short getRoomTypeImageSeq();
    
    /**
     * 객실 타입별 상세 이미지를 저장할 때 사용
     * 방1개에 해당하는 이미지 by nks
     * @param roomTypeImage DB에 저장할 객실 타입 이미지 정보가 담긴 RoomTypeImage 객체.
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoomTypeImage(RoomTypeImage roomTypeImage);


}