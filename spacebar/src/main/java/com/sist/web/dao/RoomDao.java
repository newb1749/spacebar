package com.sist.web.dao;

import com.sist.web.model.Room;

public interface RoomDao {
	
    /**
     * * @param room DB에 저장할 숙소 정보가 담긴 Room 객체.
     * <selectKey>에 의해 insert 실행 후, room 객체의 roomSeq 필드에는
     * 새로 생성된 시퀀스 값이 자동으로 채워집니다. b
     * 숙소 등록 by nks
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoom(Room room);
    

    
}
