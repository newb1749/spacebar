package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Review implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7696173612932529706L;
	
	private int reviewSeq;						// 리뷰 시퀀스 (기본키)
	private int rsvSeq;							// 예약 시퀀스 (외래키)
	private String userId;						// 작성자, 사용자 ID (외래키)
	private String reviewTitle;					// 리뷰 제목
	private String reviewContent;				// 리뷰 내용
	private double rating;						// 평점(0.5 ~ 5.0)
	private String reviewStat;					// 리뷰 상태 (Y: 활성, N: 비활성/블라인드)
	private String regDt;							// 등록일
	private String updateDt;						// 마지막 업데이트 일시
	
    // ▼▼▼ DB 테이블에 없지만 추가한 필드 ▼▼▼
	private List<ReviewImage> ReviewImageList;  // 리스트로 ReviewImage

    private String roomTitle;       			// 숙소명 (JOIN)
    private String roomTypeTitle;   			// 객실명 (JOIN)
    private String userNickname;				// 닉네임
    
    private String profImgExt;					// 프로필이미지타입
    private String roomAddr;					// 숙소주소
    private String reviewImgName;				// 최초등록리뷰이미지
    private int roomSeq;
    
	private long startRow;
	private long endRow;
	
	private List<ReviewComment> reviewCommentList;
	private boolean hostAuthor;
	
	public Review()
	{
		reviewSeq = 0;
		rsvSeq = 0;
		userId = "";
		reviewTitle = "";
		reviewContent = "";
		rating = 0;
		reviewStat = "";
		regDt = null;
		updateDt = null;
		
		profImgExt = "";
		roomAddr = "";
		reviewImgName = "";
		roomSeq = 0;
	}

	
	
	
	
	
	public boolean isHostAuthor() {
	    return hostAuthor;
	}

	public void setHostAuthor(boolean hostAuthor) {
	    this.hostAuthor = hostAuthor;
	}





	public List<ReviewComment> getReviewCommentList() {
		return reviewCommentList;
	}






	public void setReviewCommentList(List<ReviewComment> reviewCommentList) {
		this.reviewCommentList = reviewCommentList;
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






	public int getRoomSeq() {
		return roomSeq;
	}




	public void setRoomSeq(int roomSeq) {
		this.roomSeq = roomSeq;
	}




	public String getProfImgExt() {
		return profImgExt;
	}




	public void setProfImgExt(String profImgExt) {
		this.profImgExt = profImgExt;
	}




	public String getRoomAddr() {
		return roomAddr;
	}




	public void setRoomAddr(String roomAddr) {
		this.roomAddr = roomAddr;
	}




	public String getReviewImgName() {
		return reviewImgName;
	}




	public void setReviewImgName(String reviewImgName) {
		this.reviewImgName = reviewImgName;
	}




	public String getUserNickname() {
		return userNickname;
	}




	public void setUserNickname(String userNickname) {
		this.userNickname = userNickname;
	}




	public String getRoomTitle() {
		return roomTitle;
	}




	public void setRoomTitle(String roomTitle) {
		this.roomTitle = roomTitle;
	}




	public String getRoomTypeTitle() {
		return roomTypeTitle;
	}




	public void setRoomTypeTitle(String roomTypeTitle) {
		this.roomTypeTitle = roomTypeTitle;
	}




	public List<ReviewImage> getReviewImageList() {
		return ReviewImageList;
	}



	public void setReviewImageList(List<ReviewImage> reviewImageList) {
		ReviewImageList = reviewImageList;
	}



	public int getReviewSeq() {
		return reviewSeq;
	}


	public void setReviewSeq(int reviewSeq) {
		this.reviewSeq = reviewSeq;
	}


	public int getRsvSeq() {
		return rsvSeq;
	}


	public void setRsvSeq(int rsvSeq) {
		this.rsvSeq = rsvSeq;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getReviewTitle() {
		return reviewTitle;
	}


	public void setReviewTitle(String reviewTitle) {
		this.reviewTitle = reviewTitle;
	}


	public String getReviewContent() {
		return reviewContent;
	}


	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}


	public double getRating() {
		return rating;
	}


	public void setRating(double rating) {
		this.rating = rating;
	}


	public String getReviewStat() {
		return reviewStat;
	}


	public void setReviewStat(String reviewStat) {
		this.reviewStat = reviewStat;
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

