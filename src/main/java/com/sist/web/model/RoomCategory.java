package com.sist.web.model;

import java.io.Serializable;

public class RoomCategory implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 79682214049392292L;
	
	
	private int roomCatSeq;
	private String roomCatName;
	private String roomCatIconExt;
	
	public RoomCategory()
	{
		roomCatSeq = 0;
		roomCatName = "";
		roomCatIconExt = "";    
	}

	public int getRoomCatSeq() {
		return roomCatSeq;
	}

	public void setRoomCatSeq(int roomCatSeq) {
		this.roomCatSeq = roomCatSeq;
	}

	public String getRoomCatName() {
		return roomCatName;
	}

	public void setRoomCatName(String roomCatName) {
		this.roomCatName = roomCatName;
	}

	public String getRoomCatIconExt() {
		return roomCatIconExt;
	}

	public void setRoomCatIconExt(String roomCatIconExt) {
		this.roomCatIconExt = roomCatIconExt;
	}
	
	
	
}
