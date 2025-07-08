package com.sist.web.dao;

import java.util.List;

import com.sist.web.model.Room;

public interface SpaceDao {
	
	//룸 리스트 총 개수
  	public long spaceListCount(Room room);
  	
  	//룸 리스트
  	public List<Room> spaceList(Room room);

}
