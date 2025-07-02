package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.sist.web.model.Review;
import com.sist.web.model.ReviewImage;
import com.sist.web.service.ReviewService;
import com.sist.web.util.SessionUtil;

@Controller("reviewController")
public class ReviewController {
	
	private static Logger logger = LoggerFactory.getLogger(ReviewController.class);
	
	@Autowired
	private ReviewService reviewService;
	
	// 리뷰 작성 폼으로 이동하는 메서드
    @GetMapping("/review/writeForm")
    public String reviewWriteForm(@RequestParam("rsvSeq") int rsvSeq, Model model) 
    {
        // 테스트를 위해 예약번호(rsvSeq)를 파라미터로 받아서 view로 전달
        model.addAttribute("rsvSeq", rsvSeq);
        return "review/writeForm"; 
    }
    
    // 리뷰 작성 처리 메소드
    @PostMapping("/review/writeProc")
    public String reviewWriteProc(Review review, @RequestParam("files") List<MultipartFile> files, HttpServletRequest request, Model model)
    {
    	String userId = (String)SessionUtil.getSession(request.getSession(), "AUTH_SESSION_NAME");
        if (userId == null || userId.isEmpty()) {
            // 비로그인 상태일 경우 로그인 페이지로 리디렉션
            return "redirect:/user/loginForm_mj"; 
        }
        
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
    	}
    	
    	try
    	{
    		int result =  reviewService.insertReviewTransaction(review);
    		if(result > 0)
    		{
    			logger.debug("리뷰 및 이미지 등록 성공");
    		}
    		else
    		{
    			logger.warn("리뷰 등록 대상이 아님 (예약/결제 상태 불일치 또는 기타 사유)");
    		}
    	}
    	catch(Exception e)
    	{
    		logger.error("[ReviewController] reviewWriteProc Exception", e);
    	}

    	return "redirect:/"; // 등록 후 어디로?
    }
}
