package com.sist.web.model;

import java.io.Serializable;
import java.util.List;

public class RoomType implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2236801206479844894L;
	
	
	private int roomTypeSeq;			// 객실 유형의 고유 식별자 (PK)
	private int roomSeq;				// 이 객실 유형이 속한 부모 숙소(ROOM)의 기본 키 (FK)
	private String roomTypeTitle;		// 객실 유형의 이름 (예: '디럭스 더블룸', '스탠다드 오션뷰')
	private String roomTypeDesc;		// 객실 유형에 대한 상세 설명
	private int weekdayAmt;				// 주중(월-목) 1박을 기준으로 하는 기본 가격
	private int weekendAmt;				// 주말(금-일) 1박을 기준으로 하는 기본 가격
	private String roomCheckInDt;		// 예약 가능 시작 일자 (YYYYMMDD) 8자
	private String roomCheckOutDt;		// 예약 가능 종료 일자 (YYYYMMDD) 8자
	private String roomCheckInTime;		// 해당 객실 유형의 체크인 시작 시간 (HH24MI) 4자
	private String roomCheckOutTime;	// 해당 객실 유형의 체크아웃 마감 시간 (HH24MI) 4자
	private short maxGuests;			// 해당 객실 유형에 숙박 가능한 최대 인원 수
	private short minDay;				// 숙박 예약 시 최소로 예약해야 하는 일수
	private short maxDay;				// 숙박 예약 시 최대로 예약할 수 있는 일수
	private String regDt;				// 데이터 등록일
	private String updateDt;			// 데이터 최종 수정일
	
	private List<RoomTypeImage> RoomTypeImageList; // list로 RoomTypeImage 관리
	
	public RoomType()
	{
		roomTypeSeq = 0;
		roomSeq = 0;
		roomTypeTitle = "";
		roomTypeDesc = "";
		weekdayAmt = 0;
		weekendAmt = 0;
		roomCheckInDt = "";
		roomCheckOutDt = "";
		roomCheckInTime = "";
		roomCheckOutTime = "";
		maxGuests = 0;
		minDay = 0;
		maxDay = 0;
		regDt = "";
		updateDt = "";
	}

	
	
	public List<RoomTypeImage> getRoomTypeImageList() {
		return RoomTypeImageList;
	}



	public void setRoomTypeImageList(List<RoomTypeImage> roomTypeImageList) {
		RoomTypeImageList = roomTypeImageList;
	}



	public int getRoomTypeSeq() {
		return roomTypeSeq;
	}

	public void setRoomTypeSeq(int roomTypeSeq) {
		this.roomTypeSeq = roomTypeSeq;
	}

	public int getRoomSeq() {
		return roomSeq;
	}

	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}

	public String getRoomTypeTitle() {
		return roomTypeTitle;
	}

	public void setRoomTypeTitle(String roomTypeTitle) {
		this.roomTypeTitle = roomTypeTitle;
	}

	public String getRoomTypeDesc() {
		return roomTypeDesc;
	}

	public void setRoomTypeDesc(String roomTypeDesc) {
		this.roomTypeDesc = roomTypeDesc;
	}

	public int getWeekdayAmt() {
		return weekdayAmt;
	}

	public void setWeekdayAmt(int weekdayAmt) {
		this.weekdayAmt = weekdayAmt;
	}

	public int getWeekendAmt() {
		return weekendAmt;
	}

	public void setWeekendAmt(int weekendAmt) {
		this.weekendAmt = weekendAmt;
	}

	public String getRoomCheckInDt() {
		return roomCheckInDt;
	}

	public void setRoomCheckInDt(String roomCheckInDt) {
		this.roomCheckInDt = roomCheckInDt;
	}

	public String getRoomCheckOutDt() {
		return roomCheckOutDt;
	}

	public void setRoomCheckOutDt(String roomCheckOutDt) {
		this.roomCheckOutDt = roomCheckOutDt;
	}

	public String getRoomCheckInTime() {
		return roomCheckInTime;
	}

	public void setRoomCheckInTime(String roomCheckInTime) {
		this.roomCheckInTime = roomCheckInTime;
	}

	public String getRoomCheckOutTime() {
		return roomCheckOutTime;
	}

	public void setRoomCheckOutTime(String roomCheckOutTime) {
		this.roomCheckOutTime = roomCheckOutTime;
	}

	public short getMaxGuests() {
		return maxGuests;
	}

	public void setMaxGuests(short maxGuests) {
		this.maxGuests = maxGuests;
	}

	public short getMinDay() {
		return minDay;
	}

	public void setMinDay(short minDay) {
		this.minDay = minDay;
	}

	public short getMaxDay() {
		return maxDay;
	}

	public void setMaxDay(short maxDay) {
		this.maxDay = maxDay;
	}

	public String getRegDt() {
		return regDt;
	}

	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}

	public String getUpdateDt() {
		return updateDt;
	}

	public void setUpdateDt(String updateDt) {
		this.updateDt = updateDt;
	}
	
	
}
