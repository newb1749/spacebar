package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.Reservation;
import com.sist.web.model.Review;

public interface ReviewDao {
	

	/**
	 * 내 리뷰 목록 조회
	 * @param userId
	 * @return 리뷰 리스트
	 */
    public List<Review> selectMyReviews(String userId);

    
    /**
     * 수정할 리뷰 1건 조회 (이미지 포함)
     * @param reviewSeq 리뷰시퀀스
     * @return  
     */
    public Review selectReviewForEdit(int reviewSeq);

     
    /**
     * 리뷰 수정 (제목, 내용, 평점)
     * @param review 수정할 정보를 담은 객체
     * @return 건수
     */
    public int updateReview(Review review);
    
    
    /**
     * 리뷰 상태 'N'으로 변경 (소프트 삭제)
     * @param review 리뷰 객체
     * @return 건수 
     */
    public int inactiveReview(Review review);
    
 
    /**
     * 리뷰 중복 등록 방지용
     * @param rsvSeq 예약 시퀀스
     * @param userId 
     * @return 예약과 유저로 리뷰 수 조회
     */
    public int countReviewByRsvAndUser(@Param("rsvSeq") int rsvSeq, @Param("userId") String userId);

    /**
     * 리뷰 등록용
     * @param review 등록할 정보를 담은 객체
     * @return 건수
     */
    public int insertReview(Review review);

    /**
     * 예약 상태 조회용
     * @param rsvSeq 예약 객체 확인을 위한 값
     * @return 예약 객체
     */
    public Reservation findStatbyRsvSeq(int rsvSeq);

}
