package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.ReviewComment;
import com.sist.web.service.ReviewCommentService;
import com.sist.web.util.SessionUtil;

@RestController
public class ReviewCommentController {
	
	@Autowired
	private ReviewCommentService reviewCommentService;
	
    @Value("#{env['auth.session.name']}")	
    private String AUTH_SESSION_NAME;
    
    
    /**
     * 특정 리뷰의 댓글 목록을 조회
     * @param reviewSeq 리뷰 번호
     * @return 댓글 목록을 담은 JSON 응답
     */
    @GetMapping("/review/comment/list")
    public ResponseEntity<Response<List<ReviewComment>>> list(@RequestParam("reviewSeq") int reviewSeq)
    {
    	List<ReviewComment> list = reviewCommentService.list(reviewSeq);
    	return ResponseEntity.ok(new Response<>(0, "success", list));
    }
    
    
    /**
     * 댓글 작성 (호스트, 자신의 숙소에만 가능)
     * @param reviewComment reviewSeq, reviewCmtContent 포함
     * @return 성공/실패 JSON 응답
     */    
    @PostMapping("/review/comment/write")
    public ResponseEntity<Response<Object>> write(@RequestBody ReviewComment reviewComment, HttpServletRequest request)
    {
    	String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	if(StringUtil.isEmpty(userId))
    	{
    		return ResponseEntity.status(401).body(new Response<>(401, "로그인이 필요합니다."));
    	}
    	
    	reviewComment.setUserId(userId);
    	
    	if(reviewCommentService.insert(reviewComment) > 0)
    	{
    		return ResponseEntity.ok(new Response<>(0, "댓글이 등록되었습니다."));
    	}
    	else
    	{
    		return ResponseEntity.status(403).body(new Response<>(403, "댓글을 작성할 권리가 없습니다."));
    	}
    }
    
    
    /**
     * 댓글 수정 (호스트, 자신의 댓글만 가능)
     * @param reviewComment reviewCmtSeq, reviewCmtContent 포함
     * @return 성공/실패 JSON 응답
     */    
    @PostMapping("/review/comment/update")
    public ResponseEntity<Response<Object>> update(@RequestBody ReviewComment reviewComment, HttpServletRequest request)
    {
    	String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
        if (StringUtil.isEmpty(userId)) {
            return ResponseEntity.status(401).body(new Response<>(401, "로그인이 필요합니다."));
        }
        
        reviewComment.setUserId(userId);
        
        if(reviewCommentService.update(reviewComment) > 0)
        {
        	return ResponseEntity.ok(new Response<>(0, "댓글이 수정되었습니다."));
        } 
        else
        {
        	return ResponseEntity.status(403).body(new Response<>(403, "삭제 권한이 없거나 댓글이 존재하지 않습니다."));
        }
    }
    
    
    /**
     * 댓글 삭제(비활성화) (호스트, 자신의 댓글만 가능)
     * @param reviewComment reviewCmtSeq 포함
     * @return 성공/실패 JSON 응답
     */ 
    @PostMapping("/review/comment/delete")
    public ResponseEntity<Response<Object>> delete(@RequestBody ReviewComment reviewComment, HttpServletRequest request)
    {
        String userId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
        if (StringUtil.isEmpty(userId)) {
            return ResponseEntity.status(401).body(new Response<>(401, "로그인이 필요합니다."));
        }
        
        reviewComment.setUserId(userId);
        
        if(reviewCommentService.delete(reviewComment) > 0)
        {
            return ResponseEntity.ok(new Response<>(0, "댓글이 삭제되었습니다."));
        } 
        else 
        {
            return ResponseEntity.status(403).body(new Response<>(403, "삭제 권한이 없거나 댓글이 존재하지 않습니다."));
        }
    }
}
