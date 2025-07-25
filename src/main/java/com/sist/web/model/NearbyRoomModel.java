package com.sist.web.model;

import java.io.Serializable;

public class NearbyRoomModel implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 6414190190581317842L;
	
    private int roomSeq;
    private String roomTitle;
    private double latitude;
    private double longitude;
    private double distance; // km 단위?
    private String thumbnailImg; // 대표 이미지?
    private double averageRating;  // 숙소 평균 평점
    private int reviewCount;       // 리뷰 개수
    
    public NearbyRoomModel()
    {
        roomSeq = 0;
        roomTitle = "";
        latitude = 0;
        longitude = 0;
        distance = 0; // km 단위?
        thumbnailImg = ""; // 대표 이미지?
        averageRating = 0;
        reviewCount = 0;
    }

    
    
	public double getAverageRating() {
		return averageRating;
	}



	public void setAverageRating(double averageRating) {
		this.averageRating = averageRating;
	}



	public int getReviewCount() {
		return reviewCount;
	}



	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}



	public int getRoomSeq() {
		return roomSeq;
	}

	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}

	public String getRoomTitle() {
		return roomTitle;
	}

	public void setRoomTitle(String roomTitle) {
		this.roomTitle = roomTitle;
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

	public double getDistance() {
		return distance;
	}

	public void setDistance(double distance) {
		this.distance = distance;
	}

	public String getThumbnailImg() {
		return thumbnailImg;
	}

	public void setThumbnailImg(String thumbnailImg) {
		this.thumbnailImg = thumbnailImg;
	}
    
    
    
}
