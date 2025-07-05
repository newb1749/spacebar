package com.sist.web.model;

import java.io.Serializable;

public class RoomQna_mj implements Serializable
{
	private static final long serialVersionUID = 4457820316358527392L;
	
	private int roomQnaSeq;			//숙소 문의사항 시퀀스 (기본키)
	private int roomSeq;			//숙소 시퀀스 (외래키)
	private String roomQnaTitle;	//숙소 문의사항 제목
	private String roomQnaContent;	//숙소 문의사항 내용
	private String userId;			//작성자 사용자 ID (외래키)
	private String roomQnaStat;		//숙소 문의사항 상태
	private String regDt;			//등록일
	private String updateDt;		//마지막 업데이트 일시
	
	private int startRow;			//시작페이지 rownum	
	private int endRow;				//끝페이지 rownum
	private String nickName;		//회원 닉네임
	
	private RoomQnaComment_mj roomQnaComment;	//Q&A 답글
	
	public RoomQna_mj()
	{
		roomQnaSeq = 0;
		roomSeq = 0;
		roomQnaTitle = "";
		roomQnaContent = "";
		userId = "";
		roomQnaStat = "";
		regDt = "";
		updateDt = "";
		
		startRow = 0;
		endRow = 0;
		nickName = "";
		
		roomQnaComment = null;
	}

	public RoomQnaComment_mj getRoomQnaComment() {
		return roomQnaComment;
	}

	public void setRoomQnaComment(RoomQnaComment_mj roomQnaComment) {
		this.roomQnaComment = roomQnaComment;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public int getStartRow() {
		return startRow;
	}

	public void setStartRow(int startRow) {
		this.startRow = startRow;
	}

	public int getEndRow() {
		return endRow;
	}

	public void setEndRow(int endRow) {
		this.endRow = endRow;
	}

	public int getRoomQnaSeq() {
		return roomQnaSeq;
	}

	public void setRoomQnaSeq(int roomQnaSeq) {
		this.roomQnaSeq = roomQnaSeq;
	}

	public int getRoomSeq() {
		return roomSeq;
	}

	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}

	public String getRoomQnaTitle() {
		return roomQnaTitle;
	}

	public void setRoomQnaTitle(String roomQnaTitle) {
		this.roomQnaTitle = roomQnaTitle;
	}

	public String getRoomQnaContent() {
		return roomQnaContent;
	}

	public void setRoomQnaContent(String roomQnaContent) {
		this.roomQnaContent = roomQnaContent;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRoomQnaStat() {
		return roomQnaStat;
	}

	public void setRoomQnaStat(String roomQnaStat) {
		this.roomQnaStat = roomQnaStat;
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
