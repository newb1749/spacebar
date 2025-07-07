package com.sist.web.service;

import com.sist.web.dao.RoomDaoSh;
import com.sist.web.dao.RoomTypeDaoSh;
import com.sist.web.model.RoomType;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoomTypeServiceSh 
{
    @Autowired
    private RoomTypeDaoSh roomTypeDao;

    /**
     * 특정 roomTypeSeq에 해당하는 객실 유형(RoomType) 정보를 조회합니다.
     */
    public RoomType getRoomType(int roomTypeSeq) 
    {
        return roomTypeDao.selectRoomTypeBySeq(roomTypeSeq);
    }
    
	public List<RoomType> getRoomTypesByRoomSeq(int roomSeq) 
	{
	    return roomTypeDao.selectRoomTypesByRoomSeq(roomSeq);
	}
}
