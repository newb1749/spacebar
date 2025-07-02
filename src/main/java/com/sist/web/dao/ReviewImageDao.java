package com.sist.web.dao;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.ReviewImage;

public interface ReviewImageDao {
	
	// 리뷰 1개 : 리뷰 이미지 N개 (1부터 증가)
	public short selectMaxReviewImgSeq(@Param("reviewSeq")int reviewSeq);
	
	// 리뷰 등록
	public int insertReviewImage(ReviewImage reviewImage);
}
