package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Room;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;

@Repository
public interface RoomTypeDao {

    /**
     * @param roomType DB에 저장할 객실 타입 정보가 담긴 RoomType 객체.
     * <selectKey>에 의해 insert 실행 후, roomType 객체의 roomTypeSeq 필드에는
     * 새로 생성된 시퀀스 값이 자동으로 채워집니다. 
     * 숙소 방1개 등록하기 by nks
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoomType(RoomType roomType);

    public List<Integer> selectAvailableRoomType(
    	    @Param("roomCheckInDt") String roomCheckInDt, 
    	    @Param("roomCheckOutDt") String roomCheckOutDt
    	);
    
    /**
     * roomTypeSeq로 객실 타입 정보 조회
     */
    public RoomType selectRoomTypeBySeq(int roomTypeSeq);
    
    /**
     * ROOM에 속한 ROOM_TYPE 조회
     * @param room 객체
     * @return ROOM에 속한 ROOM_TYPE 리스트
     */
    public List<RoomType> selectRoomTypesByRoomSeq(Room room);
    
    /**
     * RoomType 업데이트
     * @param roomType
     * @return
     */
    public int updateRoomType(RoomType roomType);
    
    /**
     * roomType 삭제
     * @param roomSeq
     * @return
     */
    public int deleteRoomTypeByRoomSeq(int roomSeq);
}
