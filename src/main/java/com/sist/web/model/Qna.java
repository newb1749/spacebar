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
	
	public Qna()
	{
		qnaSeq = 0;
		qnaTitle = "";
		qnaContent = "";
		userId = "";
		qnaStat = "";
		regDt = "";
		updateDt = "";
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
