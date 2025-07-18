package com.sist.web.service;

import com.sist.web.model.Room;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.dao.RoomTypeDao;
import com.sist.web.dao.RoomTypeImageDao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoomTypeService 
{
    @Autowired
    private RoomTypeDao roomTypeDao;
    
    @Autowired
    private RoomTypeImageDao roomTypeImageDao;

    /**
     * 특정 roomTypeSeq에 해당하는 객실 유형(RoomType) 정보를 조회합니다.
     */
    public RoomType getRoomType(int roomTypeSeq) 
    {
        return roomTypeDao.selectRoomTypeBySeq(roomTypeSeq);
    }
    
    /**
     * oomSeq로 해당 숙소(ROOM)에 속한 ROOM_TYPE 리스트 조회
     * @param room
     * @return 해당 숙소(ROOM)에 속한 ROOM_TYPE 리스트
     */
    public List<RoomType> getRoomTypesByRoomSeq(Room room) {
        List<RoomType> roomTypeList = roomTypeDao.selectRoomTypesByRoomSeq(room);

        for (RoomType rt : roomTypeList) {
            List<RoomTypeImage> imgList = roomTypeImageDao.selectRoomTypeImagesByRoomTypeSeq(rt.getRoomTypeSeq());
            rt.setRoomTypeImageList(imgList); 
        }

        return roomTypeList;
    }
	
	/**
	 * roomSeq로 해당 숙소(ROOM)에 속한 ROOM_TYPE 리스트 조회
	 * @param roomSeq
	 * @return 해당 숙소(ROOM)에 속한 ROOM_TYPE 리스트
	 */
	public List<RoomType> getRoomTypesByRoomSeq(int roomSeq) {
	    Room room = new Room();
	    room.setRoomSeq(roomSeq);
	    return getRoomTypesByRoomSeq(room);
	}
	
	

	
}
