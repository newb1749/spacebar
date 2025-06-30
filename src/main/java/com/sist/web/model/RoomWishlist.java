package com.sist.web.model;

import java.io.Serializable;

public class RoomWishlist implements Serializable
{

	private static final long serialVersionUID = -1501435653756352503L;

	private long wishlistSeq;		//위시리스트 번호
	private String userId;			//사용자 아이디
	private long roomSeq;			//숙소 번호
	private String regDt;			//등록일
	
	private long startRow;
	private long endRow;
	
	public RoomWishlist()
	{
		wishlistSeq = 0;		
		userId = "";			
		roomSeq = 0;			
		regDt = "";				
		
		startRow = 0;	
		endRow = 0;	
	}

	public long getWishlistSeq() {
		return wishlistSeq;
	}

	public void setWishlistSeq(long wishlistSeq) {
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

	public void setRoomSeq(long roomSeq) {
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
	
}
