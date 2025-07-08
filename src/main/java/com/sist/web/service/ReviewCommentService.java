package com.sist.web.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.sist.web.dao.ReviewCommentDao;
import com.sist.web.model.ReviewComment;

@Service("reviewCommentService")
public class ReviewCommentService {

    @Autowired
    private ReviewCommentDao reviewCommentDao;

    /**
     * 특정 리뷰의 댓글 목록을 조회
     * @param reviewSeq 리뷰 번호
     * @return 댓글 목록
     */
    public List<ReviewComment> list(int reviewSeq) {
        return reviewCommentDao.selectCommentsByReview(reviewSeq);
    }
    
    /**
     * 댓글 작성
     * (권한 검증은 Mapper XML에서 처리)
     * @param reviewComment reviewSeq, userId, reviewCmtContent 포함
     * @return 성공 시 1, 실패 또는 권한 없을 시 0
     */
    public int insert(ReviewComment reviewComment) {
        Map<String, Object> params = new HashMap<>();
        params.put("reviewSeq", reviewComment.getReviewSeq());
        params.put("userId", reviewComment.getUserId());
        params.put("content", reviewComment.getReviewCmtContent());
        
        return reviewCommentDao.insertReviewComment(params);
    }

    /**
     * 댓글 수정
     * (권한 검증은 Mapper XML에서 처리)
     * @param reviewComment reviewCmtSeq, userId, reviewCmtContent 포함
     * @return 성공 시 1, 실패 또는 권한 없을 시 0
     */
    public int update(ReviewComment reviewComment) {
        Map<String, Object> params = new HashMap<>();
        params.put("commentSeq", reviewComment.getReviewCmtSeq());
        params.put("userId", reviewComment.getUserId());
        params.put("content", reviewComment.getReviewCmtContent());
        
        return reviewCommentDao.updateReviewComment(params);
    }

    /**
     * 댓글 삭제(상태 변경)
     * (권한 검증은 Mapper XML에서 처리)
     * @param reviewComment reviewCmtSeq, userId 포함
     * @return 성공 시 1, 실패 또는 권한 없을 시 0
     */
    public int delete(ReviewComment reviewComment) {
        Map<String, Object> params = new HashMap<>();
        params.put("commentSeq", reviewComment.getReviewCmtSeq());
        params.put("userId", reviewComment.getUserId());
        
        return reviewCommentDao.deleteReviewComment(params);
    }
}