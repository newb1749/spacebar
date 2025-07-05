package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDaoSh;
import com.sist.web.dao.SpaceDaoSh;
import com.sist.web.model.Room;

@Service("SpaceServiceSh")
public class SpaceServiceSh
{
	private static Logger logger = LoggerFactory.getLogger(SpaceServiceSh.class);
	
	@Autowired
	private SpaceDaoSh spaceDao;
	
	//방 총 개수
	public long spaceTotalCount(Room room)
	{
		long count = 0;
		
		try
		{
			count = spaceDao.spaceListCount(room);
		}
		catch(Exception e)
		{
			logger.error("[SpaceServiceList]spaceTotalCount : ",e);
		}
		
		return count;
	}
	
	//방 리스트
	public List<Room> spaceList(Room room)
	{
		List<Room> list = null;
		
		try
		{
			list = spaceDao.spaceList(room);
		}
		catch(Exception e)
		{
			logger.error("[SpaceServiceList]spaceList : ",e);
		}
		
		return list;
	}
	
}














