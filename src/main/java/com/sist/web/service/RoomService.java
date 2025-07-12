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
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;

public interface RoomService {
	
    /**
     * 숙소 등록에 관련된 모든 데이터(숙소, 객실타입, 편의시설, 이미지)를
     * 하나의 트랜잭션으로 묶어 DB에 저장 by nks
     * 인터페이스는 트랜잭션 기능 X 
     * @param room          숙소 정보 (List<RoomImage> roomImageList 포함)
     * @param roomTypeList  숙소타입(방1개) (List<RoomTypeImage> roomTypeImageList 포함)
     * @return 성공적으로 처리된 총 행의 수
     */	
	public int insertRoomTransaction(Room room, List<RoomType> roomTypeList);
	


@Service("roomService")
public class RoomService 
{
	private static Logger logger = LoggerFactory.getLogger(RoomService.class);
	
    @Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
    
	@Autowired
	private RoomDao roomDao;
	
	
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
    
}
