package com.sist.web.dao;

import java.util.List;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;

public interface RoomDaoSh {
    
    //룸 리스트 총 개수
  	public long roomListCount(Room room);
  	
  	//룸 리스트
  	public List<Room> roomList(Room room);
  	
  	//룸 조회
  	public Room getRoomDetail(int roomSeq);
    
  	//상세 페이지 사진 리스트
  	public List<RoomImage> getRoomImgDetail(int roomSeq);
 
}
