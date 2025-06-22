package com.sist.web.model;

import java.io.Serializable;

import org.springframework.web.multipart.MultipartFile;

public class RoomImage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7066583491100434302L;
	
	
	private int roomSeq; 					// 숙소 시퀀스 (기본키, 외래키)
	private short roomImgSeq;				// 숙소 이미지 시퀀스 (기본키)
	private String roomImgOrigName;			// 숙소 이미지 원본 파일명
	private String roomImgName;				// 숙소 이미지 저장 파일명
	private String imgType;					// 이미지 타입 (예: main, detail, sub)
	private String roomImgExt;				// 숙소 이미지 파일 확장자
	private int imgSize;					// 이미지 파일 크기
	private short sortOrder;				// 정렬 순서
	private String regDt;					// 등록일
	
	// [추가] 파일 데이터 운반을 위한 임시 필드 (DB 컬럼 아님)
	private MultipartFile file;
	
	public RoomImage()
	{
		roomSeq = 0;
		roomImgSeq = 0;
		roomImgOrigName = "";
		roomImgName = "";
		imgType = "";
		roomImgExt = "";
		imgSize = 0;
		sortOrder = 0;
		regDt = "";
	}
	
	
	

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public int getRoomSeq() {
		return roomSeq;
	}


	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}


	public short getRoomImgSeq() {
		return roomImgSeq;
	}


	public void setRoomImgSeq(short roomImgSeq) {
		this.roomImgSeq = roomImgSeq;
	}


	public String getRoomImgOrigName() {
		return roomImgOrigName;
	}


	public void setRoomImgOrigName(String roomImgOrigName) {
		this.roomImgOrigName = roomImgOrigName;
	}


	public String getRoomImgName() {
		return roomImgName;
	}


	public void setRoomImgName(String roomImgName) {
		this.roomImgName = roomImgName;
	}


	public String getImgType() {
		return imgType;
	}


	public void setImgType(String imgType) {
		this.imgType = imgType;
	}


	public String getRoomImgExt() {
		return roomImgExt;
	}


	public void setRoomImgExt(String roomImgExt) {
		this.roomImgExt = roomImgExt;
	}


	public int getImgSize() {
		return imgSize;
	}


	public void setImgSize(int imgSize) {
		this.imgSize = imgSize;
	}


	public short getSortOrder() {
		return sortOrder;
	}


	public void setSortOrder(short sortOrder) {
		this.sortOrder = sortOrder;
	}


	public String getRegDt() {
		return regDt;
	}


	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}
	
	
}
