package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDao;
import com.sist.web.model.Facility;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;

@Service("roomService")
public class RoomService 
{
	private static Logger logger = LoggerFactory.getLogger(RoomService.class);
	
    @Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
    
	@Autowired
	private RoomDao roomDao;
	
<<<<<<< HEAD
	
	// 룸정보
	public Room getRoomDetail(int roomSeq)
	{
		Room room = null;
		
		try
		{
			room = roomDao.getRoomDetail(roomSeq);
		}
		catch(Exception e)
		{
			logger.error("[RoomService]getRoomDetail Exception", e);
		}
		
		return room;
	}
	
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
	
	// roomSeq로 hostId 조회 메서드 추가
    public String getHostIdByRoomSeq(int roomSeq) 
    {
        try
        {
            return roomDao.selectHostIdByRoomSeq(roomSeq);
        }
        catch(Exception e)
        {
            logger.error("[RoomService] getHostIdByRoomSeq Exception", e);
            return null;
        }
    }
    
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
  			logger.error("[RoomServiceSh]roomTotalCount : ",e);
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
  			logger.error("[RoomServiceSh]roomList : ",e);
  		}
  		
  		return list;
  	}
  	
  	//최신순 숙소
  	public List<Room> newRoomList()
  	{
  		List<Room> list = null;
  		
  		try
  		{
  			list = roomDao.newRoomList();
  		}
  		catch(Exception e)
  		{
  			logger.error("[RoomServiceList]newRoomList : ",e);
  		}
  		
  		return list;
  	}
  	
  	//최신순 공간
  	public List<Room> newSpaceList()
  	{
  		List<Room> list = null;
  		
  		try
  		{
  			list = roomDao.newSpaceList();
  		}
  		catch(Exception e)
  		{
  			logger.error("[RoomServiceList]newSpaceList : ",e);
  		}
  		
  		return list;
  	}
  	
	//편의시설 리스트
	public List<Facility> facilityList(int roomSeq)
	{
		List<Facility> list = null;
		
		try
		{
			list = roomDao.facilityList(roomSeq);
		}
		catch(Exception e)
		{
			logger.error("[RoomServiceSh]facilityList : ", e);
		}
		
		return list;
	}
    
=======

>>>>>>> fdeaa85 (마이페이지 수정)
}
