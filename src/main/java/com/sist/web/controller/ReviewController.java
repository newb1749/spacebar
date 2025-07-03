package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sist.web.model.Review;
import com.sist.web.model.ReviewImage;
import com.sist.web.service.ReviewService;
import com.sist.web.util.SessionUtil;

@Controller("reviewController")
public class ReviewController {
	
	private static Logger logger = LoggerFactory.getLogger(ReviewController.class);
	
	@Autowired
	private ReviewService reviewService;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	

	
	// 리뷰 작성 폼으로 이동하는 메서드
    @GetMapping("/review/writeForm")
    public String reviewWriteForm(@RequestParam("rsvSeq") int rsvSeq, Model model) 
    {
        // 테스트를 위해 예약번호(rsvSeq)를 파라미터로 받아서 view로 전달
    	logger.debug("[ReviewController] reviewWriteForm 호출 - rsvSeq: {}", rsvSeq);
        model.addAttribute("rsvSeq", rsvSeq);
        return "/review/writeForm"; 
    }
    
    // 리뷰 작성 처리 메소드
    @PostMapping("/review/writeProc")
    public String reviewWriteProc(Review review, @RequestParam("files") List<MultipartFile> files, HttpServletRequest request, RedirectAttributes redirectAttributes)
    {
        logger.debug("[ReviewController] reviewWriteProc 시작");
        logger.debug("받은 데이터 - rsvSeq: {}, rating: {}, title: {}", review.getRsvSeq(), review.getRating(), review.getReviewTitle());
        logger.debug("파일 개수: {}", files != null ? files.size() : 0);
        
    	String userId = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
        if (userId == null || userId.isEmpty()) {
            // 비로그인 상태일 경우 로그인 페이지로 리디렉션
        	logger.warn("비로그인 사용자 접근 시도");
            return "redirect:/user/loginForm_mj"; 
        }
        
        logger.debug("로그인 사용자: {}", userId);
        review.setUserId(userId);
        
    	// 파일 처리 로직
    	if(files != null && !files.isEmpty())
    	{
    		List<ReviewImage> reviewImageList = new ArrayList<>();
    		for(MultipartFile file : files)
    		{
    			if(!file.isEmpty())
    			{
    				ReviewImage reviewImage = new ReviewImage();
    				reviewImage.setFile(file);
    				reviewImageList.add(reviewImage);
    			}
    		}
    		review.setReviewImageList(reviewImageList);
    		logger.debug("처리할 이미지 개수: {}", reviewImageList.size());
    	}
    	else
    	{
    		logger.debug("첨부된 파일이 없습니다.");
    	}
    	
    	try
    	{
    		logger.debug("ReviewService.insertReviewTransaction 호출 시작");
    		int result = reviewService.insertReviewTransaction(review);
    		logger.debug("ReviewService.insertReviewTransaction 결과: {}", result);
    		
    		if(result > 0)
    		{
    			 logger.info("리뷰 및 이미지 등록 성공 (rsvSeq: {}, userId: {}, result: {})", review.getRsvSeq(), userId, result);
    			 // model.addAttribute("message", "리뷰가 성공적으로 등록되었습니다.");
    			 //return "redirect:/user/myPage_mj";
    			 redirectAttributes.addFlashAttribute("message", "리뷰가 성공적으로 등록되었습니다.");
    			 
    		}
    		else
    		{
    			logger.warn("리뷰 등록 대상이 아님 (rsvSeq: {}, userId: {})", review.getRsvSeq(), userId);
    			/* model.addAttribute("errorMessage", "리뷰 등록 조건을 만족하지 않습니다. (예약 확정 및 결제 완료 상태가 아님)");
    			model.addAttribute("rsvSeq", review.getRsvSeq());
    			return "/review/writeForm"; */
    			redirectAttributes.addFlashAttribute("errorMessage", "리뷰 등록 조건을 만족하지 않습니다.");
    		}
    	}
    	catch(Exception e)
    	{
    		logger.error("[ReviewController] reviewWriteProc Exception", e);
       		/* model.addAttribute("errorMessage", "리뷰 등록 중 오류가 발생했습니다.");
       		model.addAttribute("rsvSeq", review.getRsvSeq());
    		return "/review/writeForm"; // 오류 시 다시 작성 폼으로 */
    		redirectAttributes.addFlashAttribute("errorMessage", "리뷰 등록 중 오류가 발생했습니다.");
    	}
 
    return "redirect:/user/myPage_mj";
    }
}
