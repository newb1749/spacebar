package com.sist.web.model;

import java.io.Serializable;

public class Qna implements Serializable
{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6054015095571684801L;

	private long qnaSeq;
	private String qnaTitle;
	private	String qnaContent;
	private String userId;
	private	String qnaStat;
	private String regDt;
	private String updateDt;
	
	private String userName;			//사용자명
	private String userEmail;			//사용자 이메일
	
	private String searchValue;
	private long startRow;
	private long endRow;
	
	private int ansCount;	//답변수 답변유무확인용
	private long qnaCmtSeq;
	
	public Qna()
	{
		qnaSeq = 0;
		qnaTitle = "";
		qnaContent = "";
		userId = "";
		qnaStat = "Y";
		regDt = "";
		updateDt = "";
		
		userName = "";			
		userEmail = "";
		
		searchValue = "";
		startRow = 0;
		endRow = 0;
		
		ansCount = 0;
		qnaCmtSeq = 0;
	}
	
	

	public long getQnaCmtSeq() {
		return qnaCmtSeq;
	}



	public void setQnaCmtSeq(long qnaCmtSeq) {
		this.qnaCmtSeq = qnaCmtSeq;
	}



	public int getAnsCount() {
		return ansCount;
	}



	public void setAnsCount(int ansCount) {
		this.ansCount = ansCount;
	}



	public String getUserName() {
		return userName;
	}



	public void setUserName(String userName) {
		this.userName = userName;
	}



	public String getUserEmail() {
		return userEmail;
	}



	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}



	public String getSearchValue() {
		return searchValue;
	}



	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
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



	public long getQnaSeq() {
		return qnaSeq;
	}

	public void setQnaSeq(long qnaSeq) {
		this.qnaSeq = qnaSeq;
	}

	public String getQnaTitle() {
		return qnaTitle;
	}

	public void setQnaTitle(String qnaTitle) {
		this.qnaTitle = qnaTitle;
	}

	public String getQnaContent() {
		return qnaContent;
	}

	public void setQnaContent(String qnaContent) {
		this.qnaContent = qnaContent;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getQnaStat() {
		return qnaStat;
	}

	public void setQnaStat(String qnaStat) {
		this.qnaStat = qnaStat;
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
