package com.sist.web.dao;

import com.sist.web.model.RoomImage;

public interface RoomImageDao {
	
	
    /**
     * ROOM_IMAGE 테이블에서 사용할 새로운 시퀀스 값을 조회
     * @return short 새로 발행된 시퀀스 번호
     */
    public short getRoomImageSeq();

    /**
     * 숙소 등록 시 업로드된 숙소 이미지들을 저장할 때 사용
     * @param roomImage DB에 저장할 숙소 이미지 정보가 담긴 RoomImage 객체.
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoomImage(RoomImage roomImage);
}
