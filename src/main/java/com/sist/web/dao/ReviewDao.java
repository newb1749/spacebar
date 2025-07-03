package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.Reservation;
import com.sist.web.model.Review;

public interface ReviewDao {
	
	
	// 1. 리뷰 쓰기 전 예약 상태, 결제 상태 확인 
	public Reservation findStatbyRsvSeq(@Param("rsvSeq")int rsvSeq);
	
	// 2. 리뷰 등록
	public int insertReview(Review review);
	
	// 3. 본인 리뷰 목록 조회 
	public List<Review> selectMyReviews(String userId);
	
	// 4. 수정할 리뷰 1건 조회 (이미지 포함)
    public Review selectReview(int reviewSeq);
	
	// 5. 리뷰 조회
	public int selectReview(Review review);
	
	// 6. 리뷰 상태 비활성화(삭제)
	public int inactiveReview(Review review);
	

    

}
