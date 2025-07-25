package com.sist.web.dao;

import java.util.List;
import java.util.Map;

import com.sist.web.model.NearbyRoomModel;
import com.sist.web.model.Room;

public interface LocationDao {
	
	public List<NearbyRoomModel> selectNearbyRooms(Map<String, Object> param);
	
    /**
     * 
     * @param param 위도, 경도, 제한수
     * @return
     */
    public List<Room> selectAllRoomsWithMainImage(Map<String, Object> param);
}
