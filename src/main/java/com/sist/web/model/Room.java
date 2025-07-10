package com.sist.web.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

public class Room implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1239575109179546912L;
	
	
	private int roomSeq;					// 숙소 시퀀스 (기본키)
	private int roomCatSeq;					// 숙소 카테고리 시퀀스 (외래키)
	private String hostId;					// 호스트 ID (외래키)
	private String roomAddr;				// 숙소 주소
	private double latitude;				// 위도 (11,9)
	private double longitude;				// 경도 (12,9)
	private String region;					// 지역
	private String regDt;					// 숙소 등록일
	private String updateDt;				// 마지막 업데이트 일시
	private String autoConfirmYn;			// 자동 예약 확정 여부 (Y: 예, N: 아니오)
	private String roomTitle;				// 숙소 제목
	private String roomDesc;				// 숙소 상세 설명
	private String cancelPolicy;			// 취소 정책
	private short minTimes;					// 최소 이용시간
	private short maxTimes;					// 최대 이용시간
	private double averageRating;			// 숙소 평균 평점 (2,1)
	private int reviewCount;				// 숙소 전체 리뷰수
	

	
    // ▼▼▼ DB 테이블에 없지만 추가한 필드 ▼▼▼
	private List<RoomImage> RoomImageList; // 리스트로 RoomImage
	private List<Integer> facilityNos;	   // 리스트로 FacilitySeq 값 저장
	private String searchValue;
	private int roomTypeSeq;
	
	private long startRow;
	private long endRow;
	
	private long amt;
	private String roomImageName;

	private String regionList;
	
	private String startDate;
	private String endDate;
	private String startTime;
	private String endTime;
	
	private String category;
	private int personCount;
	private int minPrice;
	private int maxPrice;
	private List<String> facilityList;
	
	private String roomImgName;
	private long weekdayAmt;
	
	public Room()
	{
		roomSeq = 0;
		roomCatSeq = 0;
		hostId = "";
		roomAddr = "";
		latitude = 0;
		longitude = 0;
		region = "";
		regDt = "";
		updateDt = "";
		autoConfirmYn = "N";
		roomTitle = "";
		roomDesc = "";
		cancelPolicy = "";
		minTimes = 0;
		maxTimes = 0;
		averageRating = 0;
		reviewCount = 0;
		
		searchValue = "";
		startRow = 0;
		endRow = 0;
		
		amt = 0;
		roomImageName = "";
		regionList = "";
		
		startDate = "";
		endDate = "";
		startTime = "";
		endTime = "";
		
		category = "";
		personCount = 0;
		minPrice = 0;
		maxPrice = 0;
		
		roomImgName = "";
		weekdayAmt = 0;
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



	// getter / setter
    public int getRoomTypeSeq() {
        return roomTypeSeq;
    }

    public void setRoomTypeSeq(int roomTypeSeq) {
        this.roomTypeSeq = roomTypeSeq;
    }

	
	
	public List<Integer> getFacilityNos() {
		return facilityNos;
	}




	public void setFacilityNos(List<Integer> facilityNos) {
		this.facilityNos = facilityNos;
	}




	public int getMinPrice() {
		return minPrice;
	}




	public void setMinPrice(int minPrice) {
		this.minPrice = minPrice;
	}




	public int getMaxPrice() {
		return maxPrice;
	}




	public void setMaxPrice(int maxPrice) {
		this.maxPrice = maxPrice;
	}




	public List<String> getFacilityList() {
		return facilityList;
	}




	public void setFacilityList(List<String> facilityList) {
		this.facilityList = facilityList;
	}




	public int getPersonCount() {
		return personCount;
	}




	public void setPersonCount(int personCount) {
		this.personCount = personCount;
	}




	public String getCategory() {
		return category;
	}




	public void setCategory(String category) {
		this.category = category;
	}




	public String getStartDate() {
		return startDate;
	}




	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}




	public String getEndDate() {
		return endDate;
	}




	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}




	public String getStartTime() {
		return startTime;
	}




	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}




	public String getEndTime() {
		return endTime;
	}




	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}




	public String getRegionList() {
		return regionList;
	}




	public void setRegionList(String regionList) {
		this.regionList = regionList;
	}




	public String getRoomImageName() {
		return roomImageName;
	}




	public void setRoomImageName(String roomImageName) {
		this.roomImageName = roomImageName;
	}




	public long getAmt() {
		return amt;
	}




	public void setAmt(long amt) {
		this.amt = amt;
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




	public String getSearchValue() {
		return searchValue;
	}



	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}



	public List<RoomImage> getRoomImageList() {
		return RoomImageList;
	}


	public void setRoomImageList(List<RoomImage> roomImageList) {
		RoomImageList = roomImageList;
	}

	public int getRoomSeq() {
		return roomSeq;
	}

	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}

	public int getRoomCatSeq() {
		return roomCatSeq;
	}

	public void setRoomCatSeq(int roomCatSeq) {
		this.roomCatSeq = roomCatSeq;
	}

	public String getHostId() {
		return hostId;
	}

	public void setHostId(String hostId) {
		this.hostId = hostId;
	}

	public String getRoomAddr() {
		return roomAddr;
	}

	public void setRoomAddr(String roomAddr) {
		this.roomAddr = roomAddr;
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

	public String getRegion() {
		return region;
	}

	public void setRegion(String region) {
		this.region = region;
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

	public String getAutoConfirmYn() {
		return autoConfirmYn;
	}

	public void setAutoConfirmYn(String autoConfirmYn) {
		this.autoConfirmYn = autoConfirmYn;
	}

	public String getRoomTitle() {
		return roomTitle;
	}

	public void setRoomTitle(String roomTitle) {
		this.roomTitle = roomTitle;
	}

	public String getRoomDesc() {
		return roomDesc;
	}

	public void setRoomDesc(String roomDesc) {
		this.roomDesc = roomDesc;
	}

	public String getCancelPolicy() {
		return cancelPolicy;
	}

	public void setCancelPolicy(String cancelPolicy) {
		this.cancelPolicy = cancelPolicy;
	}

	public short getMinTimes() {
		return minTimes;
	}

	public void setMinTimes(short minTimes) {
		this.minTimes = minTimes;
	}

	public short getMaxTimes() {
		return maxTimes;
	}

	public void setMaxTimes(short maxTimes) {
		this.maxTimes = maxTimes;
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
	
	
	
}