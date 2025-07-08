package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

public class ReviewComment implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6288634042560398637L;
	
	
	private int reviewCmtSeq;
	private int reviewSeq;
	private String userId;
	private String reviewCmtContent;
	private String reviewCmtStat;
	private Date createDt;
	private Date updateDt;
	
	
	public ReviewComment()
	{
		reviewCmtSeq = 0;
		reviewSeq = 0;
		userId = "";
		reviewCmtContent = "";
		reviewCmtStat = "";
		createDt = null;
		updateDt = null;
	}


	public int getReviewCmtSeq() {
		return reviewCmtSeq;
	}


	public void setReviewCmtSeq(int reviewCmtSeq) {
		this.reviewCmtSeq = reviewCmtSeq;
	}


	public int getReviewSeq() {
		return reviewSeq;
	}


	public void setReviewSeq(int reviewSeq) {
		this.reviewSeq = reviewSeq;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getReviewCmtContent() {
		return reviewCmtContent;
	}


	public void setReviewCmtContent(String reviewCmtContent) {
		this.reviewCmtContent = reviewCmtContent;
	}


	public String getReviewCmtStat() {
		return reviewCmtStat;
	}


	public void setReviewCmtStat(String reviewCmtStat) {
		this.reviewCmtStat = reviewCmtStat;
	}


	public Date getCreateDt() {
		return createDt;
	}


	public void setCreateDt(Date createDt) {
		this.createDt = createDt;
	}


	public Date getUpdateDt() {
		return updateDt;
	}


	public void setUpdateDt(Date updateDt) {
		this.updateDt = updateDt;
	}
	
	
}
