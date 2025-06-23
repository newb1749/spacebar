package com.sist.web.model;

import java.io.Serializable;

import org.springframework.web.multipart.MultipartFile;

public class RoomTypeImage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8268135432660230641L;
	
	
	private int roomTypeSeq;					// 이미지가 속한 객실 유형(ROOM_TYPE)의 기본 키 (FK)
	private short roomTypeImgSeq;				// 객실 유형 내 이미지의 고유 순번 (PK의 일부)
	private String roomTypeImgOrigName;			// 사용자가 업로드한 이미지의 원본 파일명
	private String roomTypeImgName;				// 서버에 저장되는 실제 이미지 파일명 (중복 방지를 위해 변환됨)
	private String imgType;						// 이미지의 용도 구분 (예: 'MAIN', 'BEDROOM', 'BATHROOM')
	private String roomTypeImgExt;				// 이미지 파일의 확장자 (예: 'jpg', 'png')
	private int imgSize;						// 이미지 파일의 크기 (Byte 단위)
	private short sortOrder;					// 이미지 목록에 표시될 정렬 순서
	private String regDt;						// 데이터 등록일
	
	// [추가] 파일 데이터 운반을 위한 임시 필드 (DB 컬럼 아님)
	private MultipartFile file;
	
	public RoomTypeImage()
	{
		roomTypeSeq = 0;
		roomTypeImgSeq = 0;
		roomTypeImgOrigName = "";
		roomTypeImgName = "";
		imgType = "";
		roomTypeImgExt = "";
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



	public int getRoomTypeSeq() {
		return roomTypeSeq;
	}

	public void setRoomTypeSeq(int roomTypeSeq) {
		this.roomTypeSeq = roomTypeSeq;
	}

	public short getRoomTypeImgSeq() {
		return roomTypeImgSeq;
	}

	public void setRoomTypeImgSeq(short roomTypeImgSeq) {
		this.roomTypeImgSeq = roomTypeImgSeq;
	}

	public String getRoomTypeImgOrigName() {
		return roomTypeImgOrigName;
	}

	public void setRoomTypeImgOrigName(String roomTypeImgOrigName) {
		this.roomTypeImgOrigName = roomTypeImgOrigName;
	}

	public String getRoomTypeImgName() {
		return roomTypeImgName;
	}

	public void setRoomTypeImgName(String roomTypeImgName) {
		this.roomTypeImgName = roomTypeImgName;
	}

	public String getImgType() {
		return imgType;
	}

	public void setImgType(String imgType) {
		this.imgType = imgType;
	}

	public String getRoomTypeImgExt() {
		return roomTypeImgExt;
	}

	public void setRoomTypeImgExt(String roomTypeImgExt) {
		this.roomTypeImgExt = roomTypeImgExt;
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
