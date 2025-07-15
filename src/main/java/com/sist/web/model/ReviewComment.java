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
	private String createDt;
	private String updateDt;
	
	// ▼▼▼ DB 테이블에 없지만 추가한 필드 ▼▼▼
	private String userNickname;
	private String profImgExt;
	
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
	
	
	

	public String getProfImgExt() {
		return profImgExt;
	}




	public void setProfImgExt(String profImgExt) {
		this.profImgExt = profImgExt;
	}




	public String getUserNickname() {
		return userNickname;
	}



	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
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
