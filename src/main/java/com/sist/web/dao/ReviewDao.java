package com.sist.web.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Reservation;
import com.sist.web.model.Review;
import com.sist.web.model.ReviewImage;

@Repository("reviewDao")
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
    
    /**
     * 특정 숙소의 모든 리뷰 목록 조회 
     * @param roomSeq 숙소 확인을 위한 값
     * @return 한 숙소에 해당하는 List<리뷰 객체>  
     */
    public List<Review> selectReviewsByRoom(int roomSeq);
    
    
    /**
     * 리뷰 1개의 상세 정보 조회 (댓글 페이지용)
     * @param reviewSeq
     * @return ReviewImageList 포함된 Review 객체 
     */
    public Review selectReviewDetail(int reviewSeq);
    
    /**
     * 숙소 제목 조회 (페이지 제목 표시용)
     * @param roomSeq
     * @return 숙소명
     */
    public String selectRoomTitle(int roomSeq);
    
    // 메인페이지 모든 리뷰 조회용
    public List<Review> allReviewList();
    
    // 특정 숙소의 리뷰 총 개수 조회 (페이징용)
    public int getReviewCountByRoom(int roomSeq);
    
    //  특정 숙소의 리뷰 목록 조회 (페이징 적용)
    public List<Review> getReviewsByRoomWithPaging(Review review);
    
    // 	호스트가 등록한 모든 숙소(ROOM)에 작성된 리뷰 전체
    public List<Review> selectAllReviewsByHost(String hostId);
    
    // 리뷰 평균 평점 조회 (누적, 연간, 월간, 주간)
    public Double selectAvgRatingByHostWithPeriod(Map<String, Object> paramMap);
    
    //리뷰 유무확인
    public int reservationReviewUpdate(int rsvSeq);

}
