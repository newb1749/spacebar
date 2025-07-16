package com.sist.web.dao;

import com.sist.web.model.RoomImage;

public interface RoomImageDao {
	
	
    /**
     * ROOM_IMAGE 테이블에서 사용할 새로운 시퀀스 값을 조회
     * @return short 새로 발행된 시퀀스 번호
     */
    //public short getRoomImageSeq();

    
    /**
     * ROOM_IMAGE_SEQ에 넣을 숫자 부여
     * @return short 숙소 이미지에 넣을 숫자 부여
     */   
    public short selectMaxRoomImgSeq(int roomSeq);
    
    
    /**
     * 숙소 등록 시 업로드된 숙소 이미지들을 저장할 때 사용
     * @param roomImage DB에 저장할 숙소 이미지 정보가 담긴 RoomImage 객체.
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoomImage(RoomImage roomImage);
    
    /**
     * ROOM에 해당하는 이미지 DB에서 삭제
     * @param roomSeq 해당 ROOM
     * @return
     */
    public int deleteImagesByRoomSeq(int roomSeq);
}