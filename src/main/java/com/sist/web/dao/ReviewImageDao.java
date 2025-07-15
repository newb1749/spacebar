package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.ReviewImage;

public interface ReviewImageDao {
	
	/**
	 * 리뷰 1개 : 리뷰 이미지 N개 (1부터 증가)
	 * @param reviewSeq
	 * @return 이미지시퀀스 
	 */
	public short selectMaxReviewImgSeq(@Param("reviewSeq")int reviewSeq);
	

	/**
	 * 리뷰 등록
	 * @param reviewImage 리뷰이미지 객체
	 * @return 건수
	 */
	public int insertReviewImage(ReviewImage reviewImage);
	

	/**
	 * 리뷰에 포함된 이미지 목록 조회
	 * @param reviewSeq 리뷰시퀀스
	 * @return 리뷰이미지 리스트
	 */
    public List<ReviewImage> selectReviewImages(int reviewSeq);

    /**
     * 수정 시 개별 이미지 삭제를 위해 1건의 정보 조회 (파일 이름 필요) 
     * @param reviewImage 리뷰이미지(상태값 = 'Y')
     * @return 리뷰이미지 객체(상태값 = 'N')
     */
    public ReviewImage selectReviewImage(ReviewImage reviewImage);
    
 
    /**
     * 리뷰 이미지 1건 삭제
     * @param reviewImage 리뷰이미지
     * @return 건수
     */
    public int deleteReviewImage(ReviewImage reviewImage);



}
