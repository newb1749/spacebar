package com.sist.web.model;

import java.io.Serializable;

public class QnaComment implements Serializable
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 267892718005995679L;

	private long qnaCmtSeq;
	private long qnaSeq;
	private String adminId;
	private	String qnaCmtContent;
	private String qnaCmtStat;
	private	String createDt;
	private String updateDt;
	
	public QnaComment()
	{
		qnaCmtSeq = 0;
		qnaSeq = 0;
		adminId = "";
		qnaCmtContent = "";
		qnaCmtStat = "Y";
		createDt = "";
		updateDt = "";
	}

	public long getQnaCmtSeq() {
		return qnaCmtSeq;
	}

	public void setQnaCmtSeq(long qnaCmtSeq) {
		this.qnaCmtSeq = qnaCmtSeq;
	}

	public long getQnaSeq() {
		return qnaSeq;
	}

	public void setQnaSeq(long qnaSeq) {
		this.qnaSeq = qnaSeq;
	}

	public String getAdminId() {
		return adminId;
	}

	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}

	public String getQnaCmtContent() {
		return qnaCmtContent;
	}

	public void setQnaCmtContent(String qnaCmtContent) {
		this.qnaCmtContent = qnaCmtContent;
	}

	public String getQnaCmtStat() {
		return qnaCmtStat;
	}

	public void setQnaCmtStat(String qnaCmtStat) {
		this.qnaCmtStat = qnaCmtStat;
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
