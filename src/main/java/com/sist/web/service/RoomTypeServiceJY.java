package com.sist.web.service;

import com.sist.web.model.Room;
import com.sist.web.model.RoomType;
import com.sist.web.dao.RoomTypeDao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoomTypeServiceJY 
{
    @Autowired
    private RoomTypeDao roomTypeDao;

    /**
     * 특정 roomTypeSeq에 해당하는 객실 유형(RoomType) 정보를 조회합니다.
     */
    public RoomType getRoomType(int roomTypeSeq) 
    {
        return roomTypeDao.selectRoomTypeBySeq(roomTypeSeq);
    }
    
	public List<RoomType> getRoomTypesByRoomSeq(Room room) 
	{
	    return roomTypeDao.selectRoomTypesByRoomSeq(room);
	}
}
