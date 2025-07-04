package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.web.dao.RoomDao;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;

@Service("roomService_mj")
public class RoomService_mj
{
	private static Logger logger = LoggerFactory.getLogger(RoomService_mj.class);
	
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

}