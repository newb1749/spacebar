package com.sist.web.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.LocationDao;
import com.sist.web.model.NearbyRoomModel;
import com.sist.web.model.Room;

@Service
public class LocationService {
	
    @Autowired
    private LocationDao locationDao;

    public List<NearbyRoomModel> getNearbyRooms(Map<String, Object> param) {
        return locationDao.selectNearbyRooms(param);
    }
    
    public List<Room> getAllRoomsWithMainImage(Map<String, Object> param) {
        return locationDao.selectAllRoomsWithMainImage(param);
    }
}
