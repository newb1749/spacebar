package com.sist.web.service;

import com.sist.web.model.RoomTypeJY;
import com.sist.web.dao.RoomTypeDaoJY;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoomTypeServiceJY 
{
    @Autowired
    private RoomTypeDaoJY roomTypeDaoJY;

    /**
     * 특정 roomTypeSeq에 해당하는 객실 유형(RoomType) 정보를 조회합니다.
     */
    public RoomTypeJY getRoomType(int roomTypeSeq) 
    {
        return roomTypeDaoJY.selectRoomTypeBySeq(roomTypeSeq);
    }
    
	public List<RoomTypeJY> getRoomTypesByRoomSeq(int roomSeq) 
	{
	    return roomTypeDaoJY.selectRoomTypesByRoomSeq(roomSeq);
	}
}