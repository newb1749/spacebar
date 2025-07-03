package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.ReviewImage;

public interface ReviewImageDao {
	
	// 리뷰 1개 : 리뷰 이미지 N개 (1부터 증가)
	public short selectMaxReviewImgSeq(@Param("reviewSeq")int reviewSeq);
	
	// 리뷰 등록
	public int insertReviewImage(ReviewImage reviewImage);
	
    // 리뷰에 포함된 이미지 목록 조회
    public List<ReviewImage> selectReviewImages(int reviewSeq);

    // 리뷰에 포함된 이미지 모두 삭제
    public int deleteReviewImages(int reviewSeq);
}
