package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDaoSh;
import com.sist.web.model.Room;

@Service("RoomServiceSh")
public class RoomServiceSh
{
	private static Logger logger = LoggerFactory.getLogger(RoomServiceSh.class);
	
	@Autowired
	private RoomDaoSh roomDao;
	
	//방 총 개수
	public long roomTotalCount(Room room)
	{
		long count = 0;
		
		try
		{
			count = roomDao.roomListCount(room);
		}
		catch(Exception e)
		{
			logger.error("[RoomServiceList]roomTotalCount : ",e);
		}
		
		return count;
	}
	
	//방 리스트
	public List<Room> roomList(Room room)
	{
		List<Room> list = null;
		
		try
		{
			list = roomDao.roomList(room);
		}
		catch(Exception e)
		{
			logger.error("[RoomServiceList]roomList : ",e);
		}
		
		return list;
	}
	
}














