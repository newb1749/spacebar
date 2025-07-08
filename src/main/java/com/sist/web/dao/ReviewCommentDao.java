package com.sist.web.dao;

import java.util.List;
import java.util.Map;

import com.sist.web.model.ReviewComment;

public interface ReviewCommentDao {
	
	// 댓글 목록 조회
	public List<ReviewComment> list(int reviewSeq);
	
	// 댓글 작성
	public int insertReviewComment(Map<String, Object> params);
	// 댓글수정
    public int updateReviewComment(Map<String, Object> params);
    // 댓글 삭제(비활성화)
    public int deleteReviewComment(Map<String, Object> params);
    
    // 목록 조회 쿼리의 id는 selectCommentsByReview 이므로 맞춰줍니다.
    public List<ReviewComment> selectCommentsByReview(int reviewSeq);
}
