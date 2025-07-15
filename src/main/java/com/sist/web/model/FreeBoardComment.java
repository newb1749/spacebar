package com.sist.web.model;

import java.io.Serializable;

public class FreeBoardComment implements Serializable
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5168316477835624092L;
	
	private long freeBoardCmtSeq;			//댓글번호 시퀀스
	private long freeBoardSeq;				//게시물번호 시퀀스
	private String userId;					//사용자 아이디
	private String freeBoardCmtContent;		//댓글내용
	private long parentCmtSeq;				//부모댓글시퀀스
	private String freeBoardCmtStat;		//댓글상태
	private String createDt;				//댓글생성일
	private String updateDt;				//댓글수정일
	private int depth;						//들여쓰기
	private long groupSeq;					//그룹번호
	private int orderNo;					//그룹내 순서
	
	private String userName;				//사용자명(쓸지안쓸지모름)
	
	public FreeBoardComment()
	{
		freeBoardCmtSeq = 0;			
		freeBoardSeq = 0;				
		userId = "";					
		freeBoardCmtContent = "";		
		parentCmtSeq = 0;				
		freeBoardCmtStat = "";		
		createDt = "";				
		updateDt = "";				
		depth = 0;						
		groupSeq = 0;					
		orderNo = 0;
		
		userName = "";
	}

	public long getFreeBoardCmtSeq() {
		return freeBoardCmtSeq;
	}

	public void setFreeBoardCmtSeq(long freeBoardCmtSeq) {
		this.freeBoardCmtSeq = freeBoardCmtSeq;
	}

	public long getFreeBoardSeq() {
		return freeBoardSeq;
	}

	public void setFreeBoardSeq(long freeBoardSeq) {
		this.freeBoardSeq = freeBoardSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFreeBoardCmtContent() {
		return freeBoardCmtContent;
	}

	public void setFreeBoardCmtContent(String freeBoardCmtContent) {
		this.freeBoardCmtContent = freeBoardCmtContent;
	}

	public long getParentCmtSeq() {
		return parentCmtSeq;
	}

	public void setParentCmtSeq(long parentCmtSeq) {
		this.parentCmtSeq = parentCmtSeq;
	}

	public String getFreeBoardCmtStat() {
		return freeBoardCmtStat;
	}

	public void setFreeBoardCmtStat(String freeBoardCmtStat) {
		this.freeBoardCmtStat = freeBoardCmtStat;
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

	public int getDepth() {
		return depth;
	}

	public void setDepth(int depth) {
		this.depth = depth;
	}

	public long getGroupSeq() {
		return groupSeq;
	}

	public void setGroupSeq(long groupSeq) {
		this.groupSeq = groupSeq;
	}

	public int getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	
}
