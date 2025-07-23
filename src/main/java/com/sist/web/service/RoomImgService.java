package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDao;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomTypeImage;

@Service("roomImgService")
public class RoomImgService 
{
	private static Logger logger = LoggerFactory.getLogger(RoomServiceInterface.class);
	
	@Autowired
	private RoomDao roomDao;
	
	// 룸에 대한 전체 이미지 정보
	public List<RoomImage> getRoomImgDetail(int roomSeq)
	{
		List<RoomImage> room = null;
		
		try
		{
			room = roomDao.getRoomImgDetail(roomSeq);
		}
		catch(Exception e)
		{
			logger.error("[RoomImgService]getRoomImgDetail Exception", e);
		}
		
		return room;
	}
	
	//룹타입에 대한 전체 이미지 정보
	public List<RoomTypeImage> getRoomTypeImgDetail(int roomTypeSeq)
	{
		List<RoomTypeImage> imgs = null;
		
		try
		{
			imgs = roomDao.getRoomTypeImgDetail(roomTypeSeq);
		}
		catch(Exception e)
		{
			logger.error("[RoomImgService]getRoomTypeImgDetail Exception", e);
		}
		
		return imgs;
	}
	
	//룹타입에 대한 전체 이미지 정보
	public RoomTypeImage getRoomTypeImgMain(int roomTypeSeq)
	{
		RoomTypeImage imgs = null;
		
		try
		{
			imgs = roomDao.getRoomTypeImgMain(roomTypeSeq);
		}
		catch(Exception e)
		{
			logger.error("[RoomImgService]getRoomTypeImgDetail Exception", e);
		}
		
		return imgs;
	}
}
