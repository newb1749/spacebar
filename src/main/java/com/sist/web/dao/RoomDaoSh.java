package com.sist.web.dao;

import java.util.List;

import com.sist.web.model.Room;

public interface RoomDaoSh {
    
    //룸 리스트 총 개수
  	public long roomListCount(Room room);
  	
  	//룸 리스트
  	public List<Room> roomList(Room room);
    
}
