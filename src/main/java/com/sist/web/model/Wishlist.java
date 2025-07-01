package com.sist.web.model;

import java.io.Serializable;

public class Wishlist implements Serializable
{

	private static final long serialVersionUID = -1501435653756352503L;

	private int wishlistSeq;		//위시리스트 번호
	private String userId;			//사용자 아이디
	private int roomSeq;			//숙소 번호
	private String regDt;			//등록일
	
	private long startRow;
	private long endRow;
	
	 //room에있는아이들
    private String roomTitle;
    private String region;
    private double averageRating;
    private int reviewCount;
	
    private String roomImgName;
    
    private long weekdayAmt;
    
	public Wishlist()
	{
		wishlistSeq = 0;		
		userId = "";			
		roomSeq = 0;			
		regDt = "";				
		
		startRow = 0;	
		endRow = 0;	
		
		roomTitle = "";
		region = "";
		averageRating = 0;
		reviewCount = 0;
		
		roomImgName = "";
		
		weekdayAmt = 0;
	}

	public long getWishlistSeq() {
		return wishlistSeq;
	}

	public void setWishlistSeq(int wishlistSeq) {
		this.wishlistSeq = wishlistSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getRoomSeq() {
		return roomSeq;
	}

	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public String getRoomTitle() {
		return roomTitle;
	}

	public void setRoomTitle(String roomTitle) {
		this.roomTitle = roomTitle;
	}

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
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

	public String getRoomImgName() {
		return roomImgName;
	}

	public void setRoomImgName(String roomImgName) {
		this.roomImgName = roomImgName;
	}

	public long getWeekdayAmt() {
		return weekdayAmt;
	}

	public void setWeekdayAmt(long weekdayAmt) {
		this.weekdayAmt = weekdayAmt;
	}
	
	
}
