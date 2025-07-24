package com.sist.web.model;

import java.io.Serializable;

public class NearbyRoomsRequest implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8300259926501167767L;
	
    private double latitude;       // 사용자 위도
    private double longitude;      // 사용자 경도
    private int radius;        // 반경 (미터?)
    private Integer categorySeq;   // 카테고리 ROOM_CAT_SEQ
    private int limit;         // 최대 숙소 수 제한 (예: 20)
    
    
    public NearbyRoomsRequest()
    {
        latitude = 0;        // 사용자 위도
        longitude = 0;     	 // 사용자 경도 
        radius = 0;       	 // 반경 (미터?)
        categorySeq = 0;  	 // 카테고리 ROOM_CAT_SEQ
        limit = 0;         	 // 최대 숙소 수 제한 (예: 20)
    }


	public double getLatitude() {
		return latitude;
	}


	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}


	public double getLongitude() {
		return longitude;
	}


	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}


	public int getRadius() {
		return radius;
	}


	public void setRadius(int radius) {
		this.radius = radius;
	}


	public Integer getCategorySeq() {
		return categorySeq;
	}


	public void setCategorySeq(Integer categorySeq) {
		this.categorySeq = categorySeq;
	}


	public int getLimit() {
		return limit;
	}


	public void setLimit(int limit) {
		this.limit = limit;
	}
	
    
}
