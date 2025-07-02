package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDaoJY;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;


@Service("roomService")
public class RoomService 
{
	private static Logger logger = LoggerFactory.getLogger(RoomService.class);
	
	@Autowired
	private RoomDaoJY roomDao;
    /**
     * 숙소 등록에 관련된 모든 데이터(숙소, 객실타입, 편의시설, 이미지)를
     * 하나의 트랜잭션으로 묶어 DB에 저장 by nks
     * 인터페이스는 트랜잭션 기능 X 
     * @param room          숙소 정보 (List<RoomImage> roomImageList 포함)
     * @param roomTypeList  숙소타입(방1개) (List<RoomTypeImage> roomTypeImageList 포함)
     * @return 성공적으로 처리된 총 행의 수
     */	
	//public int insertRoomTransaction(Room room, List<RoomType> roomTypeList);
	
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

}
