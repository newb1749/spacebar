package com.sist.web.model;

import java.io.Serializable;

public class RoomQnaComment_mj implements Serializable
{

	private static final long serialVersionUID = -6402477444156413581L;

	private int	roomQnaCmtSeq;			//숙소 문의사항 댓글 시퀀스 (기본키)
	private int	roomQnaSeq;				//숙소 문의사항 시퀀스 (외래키)
	private String userId;				//작성자 사용자 ID (외래키)
	private String roomQnaCmtContent;	//댓글 내용
	private String rooQnaCmtStat;		//댓글 상태
	private String createDt;			//작성일
	private String updateDt;			//마지막 업데이트 일시
	
	public RoomQnaComment_mj()
	{
		roomQnaCmtSeq = 0;
		roomQnaSeq = 0;
		userId = "";
		roomQnaCmtContent = "";
		rooQnaCmtStat = "";
		createDt = "";
		updateDt = "";
	}

	public int getRoomQnaCmtSeq() {
		return roomQnaCmtSeq;
	}

	public void setRoomQnaCmtSeq(int roomQnaCmtSeq) {
		this.roomQnaCmtSeq = roomQnaCmtSeq;
	}

	public int getRoomQnaSeq() {
		return roomQnaSeq;
	}

	public void setRoomQnaSeq(int roomQnaSeq) {
		this.roomQnaSeq = roomQnaSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRoomQnaCmtContent() {
		return roomQnaCmtContent;
	}

	public void setRoomQnaCmtContent(String roomQnaCmtContent) {
		this.roomQnaCmtContent = roomQnaCmtContent;
	}

	public String getRooQnaCmtStat() {
		return rooQnaCmtStat;
	}

	public void setRooQnaCmtStat(String rooQnaCmtStat) {
		this.rooQnaCmtStat = rooQnaCmtStat;
	}

	public String getCreateDt() {
		return createDt;
	}

	public void setCreateDt(String createDt) {
		this.createDt = createDt;
	}

	public String getUpdateDt() {
		return updateDt;
	}

	public void setUpdateDt(String updateDt) {
		this.updateDt = updateDt;
	}
	
}
