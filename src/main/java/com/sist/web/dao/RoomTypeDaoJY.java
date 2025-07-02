package com.sist.web.dao;

import java.util.List;

import com.sist.web.model.RoomTypeJY;  // 반드시 import

public interface RoomTypeDaoJY 
{

    /**
     * @param roomType DB에 저장할 객실 타입 정보가 담긴 RoomType 객체.
     * <selectKey>에 의해 insert 실행 후, roomType 객체의 roomTypeSeq 필드에는
     * 새로 생성된 시퀀스 값이 자동으로 채워집니다. 
     * 숙소 방1개 등록하기 by nks
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoomType(RoomTypeJY roomType);

    /**
     * roomTypeSeq로 객실 타입 정보 조회
     */
    RoomTypeJY selectRoomTypeBySeq(int roomTypeSeq);

    List<RoomTypeJY> selectRoomTypesByRoomSeq(int roomSeq);
}
