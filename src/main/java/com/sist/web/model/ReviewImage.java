package com.sist.web.model;

import java.io.Serializable;
import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

public class ReviewImage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2274097056784146422L;
	
	private int reviewSeq;					// 리뷰 시퀀스 (기본키, 외래키)
	private short reviewImgSeq;				// 리뷰 이미지 시퀀스 (기본키)
	private String reviewImgOrigName;		// 리뷰 이미지 원본 파일명
	private String reviewImgName;			// 리뷰 이미지 저장 파일명
	private String reviewImgExt;			// 리뷰 이미지 파일 확장자
	private int imgSize;					// 이미지 파일 크기
	private Date regDt;						// 등록일
	

    // ▼▼▼ DB 테이블에 없지만 추가한 필드 ▼▼▼
	private MultipartFile file;				// 파일 데이터 운반을 위한 임시 필드
	
	public ReviewImage()
	{
		reviewSeq = 0;
		reviewImgSeq = 0;
		reviewImgOrigName = "";
		reviewImgName = "";
		reviewImgExt = "";
		imgSize = 0;
		regDt = null;
	}

	
	
	public MultipartFile getFile() {
		return file;
	}



	public void setFile(MultipartFile file) {
		this.file = file;
	}



	public int getReviewSeq() {
		return reviewSeq;
	}


	public void setReviewSeq(int reviewSeq) {
		this.reviewSeq = reviewSeq;
	}


	public short getReviewImgSeq() {
		return reviewImgSeq;
	}


	public void setReviewImgSeq(short reviewImgSeq) {
		this.reviewImgSeq = reviewImgSeq;
	}


	public String getReviewImgOrigName() {
		return reviewImgOrigName;
	}


	public void setReviewImgOrigName(String reviewImgOrigName) {
		this.reviewImgOrigName = reviewImgOrigName;
	}


	public String getReviewImgName() {
		return reviewImgName;
	}


	public void setReviewImgName(String reviewImgName) {
		this.reviewImgName = reviewImgName;
	}


	public String getReviewImgExt() {
		return reviewImgExt;
	}


	public void setReviewImgExt(String reviewImgExt) {
		this.reviewImgExt = reviewImgExt;
	}


	public int getImgSize() {
		return imgSize;
	}


	public void setImgSize(int imgSize) {
		this.imgSize = imgSize;
	}


	public Date getRegDt() {
		return regDt;
	}


	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}
	
	
}
