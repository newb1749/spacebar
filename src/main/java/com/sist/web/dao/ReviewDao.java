package com.sist.web.dao;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.Reservation;
import com.sist.web.model.Review;

public interface ReviewDao {
	
	
	// 1. 리뷰 쓰기 전 예약 상태, 결제 상태 확인 
	public Reservation findStatbyRsvSeq(@Param("rsvSeq")int rsvSeq);
	
	// 2. 리뷰 등록
	public int insertReview(Review review);
	
}
