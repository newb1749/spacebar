package com.sist.web.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class NearbyRoomsResponse implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8148269621856097941L;
	
    private List<NearbyRoomModel> rooms;
    private int totalCount;
    private double userLatitude;
    private double userLongitude;
    
    public NearbyRoomsResponse()
    {
        rooms = new ArrayList<>();
        totalCount = 0;
        userLatitude = 0;
        userLongitude = 0;
    }
    
    
    public NearbyRoomsResponse(List<NearbyRoomModel> rooms, double userLatitude, double userLongitude) 
    {
        this.rooms = rooms;
        this.totalCount = (rooms != null) ? rooms.size() : 0;
        this.userLatitude = userLatitude;
        this.userLongitude = userLongitude;
    }


	public List<NearbyRoomModel> getRooms() {
		return rooms;
	}

	public void setRooms(List<NearbyRoomModel> rooms) {
		this.rooms = rooms;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public double getUserLatitude() {
		return userLatitude;
	}

	public void setUserLatitude(double userLatitude) {
		this.userLatitude = userLatitude;
	}

	public double getUserLongitude() {
		return userLongitude;
	}

	public void setUserLongitude(double userLongitude) {
		this.userLongitude = userLongitude;
	}
    
    
}
