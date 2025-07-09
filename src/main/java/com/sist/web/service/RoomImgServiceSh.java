package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDao;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;

@Service("roomImgServiceSh")
public class RoomImgServiceSh 
{
	private static Logger logger = LoggerFactory.getLogger(RoomService.class);
	
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
			logger.error("[RoomService]getRoomImgDetail Exception", e);
		}
		
		return room;
	}
}
