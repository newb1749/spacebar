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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Paging;
import com.sist.web.model.Review;
import com.sist.web.model.ReviewComment;
import com.sist.web.model.ReviewImage;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.ReviewCommentService;
import com.sist.web.service.ReviewService;
import com.sist.web.service.RoomService;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.SessionUtil;

@Controller("reviewController")
public class ReviewController {
	
	private static Logger logger = LoggerFactory.getLogger(ReviewController.class);
	
	@Autowired
	private ReviewService reviewService;
	
	@Autowired
	private ReviewCommentService reviewCommentService;
	
	@Autowired
	private RoomService roomService;

	@Autowired
	private ReservationServiceJY reservationService;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	

	
	/**
	 * 리뷰 작성 페이지
	 * @param rsvSeq 예약 시퀀스
	 * @param model ("rsvSeq", rsvSeq)
	 * @return
	 */
    @GetMapping("/review/writeForm")
    public String reviewWriteForm(@RequestParam("rsvSeq") int rsvSeq, Model model) 
    {
        // 테스트를 위해 예약번호(rsvSeq)를 파라미터로 받아서 view로 전달
    	logger.debug("[ReviewController] reviewWriteForm 호출 - rsvSeq: {}", rsvSeq);
        model.addAttribute("rsvSeq", rsvSeq) ;
        return "/review/writeForm"; 
    }
    
  
    /**
     * 리뷰 작성 처리 메소드
     * @param review 데이터를 담은 리뷰 객체
     * @param files 리뷰의 이미지
     * @param request 
     * @param redirectAttributes
     * @return 리다이렉션 페이지
     */
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
    	
        // 실패 시 다시 작성폼으로, 성공 시 마이페이지로 이동
        if (redirectAttributes.getFlashAttributes().containsKey("errorMessage")) 
        {
            return "redirect:/review/writeForm?rsvSeq=" + review.getRsvSeq();
        } 
        else 
        {
            return "redirect:/user/myPage_mj";
        }
    }
    
    
    /**
     * 나의 리뷰 목록 페이지
     * @param model ("myReviews", myReviews)
     * @param request
     * @return 리다이렉션 페이지
     */
    @GetMapping("/review/myList")
    public String myList(Model model, HttpServletRequest request)
    {
    	String sessionUserId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	if(StringUtil.isEmpty(sessionUserId))
    	{
    		return "redirect:/user/loginForm_mj";
    	}
    	
    	List<Review> myReviews = reviewService.selectMyReviews(sessionUserId);
    	model.addAttribute("myReviews", myReviews);
    	
    	return "/review/myList";
    }
    
    /**
     * 리뷰 수정 페이지
     * @param reviewSeq 수정할 리뷰 시퀀스
     * @param model  ("review", review)
     * @param request
     * @return 리다이렉션 페이지
     */
    @GetMapping("/review/updateForm")
    public String updateForm(@RequestParam("reviewSeq") int reviewSeq, Model model, HttpServletRequest request)
    {
    	String sessionUserId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	if(StringUtil.isEmpty(sessionUserId))
    	{
    		return "redirect:/user/loginForm_mj";
    	}
    	
    	Review review = reviewService.selectReviewForEdit(reviewSeq);
    	
    	if(review == null || !StringUtil.equals(review.getUserId(), sessionUserId))
    	{
    		return "redirect:/review/myList";
    	}
    	
    	model.addAttribute("review", review);
    	return "/review/updateForm";
    }
    
    
    /**
     * 리뷰 수정 처리
     * @param review 수정할 리뷰 객체
     * @param deleteImgSeqs 삭제할 이미지들(list)
     * @param files 새로 업로드할 파일
     * @param redirectAttributes
     * @param request
     * @return 리다이렉션 페이지
     */
    @PostMapping("/review/updateProc")
    public String updateProc(Review review, @RequestParam(value="deleteImgSeqs", required=false) List<Short> deleteImgSeqs,
    		@RequestParam("files") List<MultipartFile> files, RedirectAttributes redirectAttributes, HttpServletRequest request)
    {
    	String sessionUserId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	if(StringUtil.isEmpty(sessionUserId))
    	{
    		return "redirect:/user/loginForm_mj";
    	}
    	
    	review.setUserId(sessionUserId);
    	
    	// 새로 추가된 파일 처리
    	if(files != null && !files.isEmpty())
    	{
    		List<ReviewImage> newImageList = new ArrayList<>();
    		for(MultipartFile file : files)
    		{
    			if(!file.isEmpty())
    			{
    				ReviewImage newImage =  new ReviewImage();
    				newImage.setFile(file);
    				newImageList.add(newImage);
    			}
    		}
    		review.setReviewImageList(newImageList);
    	}
    	
    	try
    	{
    		reviewService.updateReviewTransaction(review, deleteImgSeqs);
    		redirectAttributes.addFlashAttribute("message", "리뷰가 수정되었습니다.");
    	}
    	catch(Exception e)
    	{
    		 logger.error("[ReviewController] updateProc Exception", e);
             redirectAttributes.addFlashAttribute("errorMessage", "수정 중 오류가 발생했습니다.");	
    	}
    	
    	return "redirect:/review/myList";
    }
    
    /**
     * 리뷰 비활성화(삭제) 처리 
     * @param reviewSeq 삭제할 리뷰 시퀀스
     * @param redirectAttributes
     * @param request 
     * @return 리다이렉션 페이지
     */
    @PostMapping("/review/inactiveProc")
    public String inactiveProc(@RequestParam("reviewSeq") int reviewSeq, RedirectAttributes redirectAttributes, HttpServletRequest request)
    {
    	String sessionUserId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
    	if(StringUtil.isEmpty(sessionUserId))
    	{
    		return "redirect:/user/loginForm_mj";
    	}
    	
    	Review review = new Review();
    	review.setReviewSeq(reviewSeq);
    	review.setUserId(sessionUserId);
    	
    	try
    	{
    		reviewService.inactiveReview(review);
    		redirectAttributes.addFlashAttribute("message", "리뷰가 삭제되었습니다.");
    	}
    	catch(Exception e)
    	{
            logger.error("[ReviewController] inactiveProc Exception", e);
            redirectAttributes.addFlashAttribute("errorMessage", "삭제 중 오류가 발생했습니다.");   		
    	}
    	
    	return "redirect:/review/myList";
    }
    
    
    /**
     * 숙소에 대한 리뷰 페이지
     * @param roomSeq
     * @param model
     * @return
     */
    @GetMapping("/room/reviews/{roomSeq}")
    public String roomReviews(@PathVariable("roomSeq") int roomSeq, Model model)
    {	
   	
        logger.debug("===== [Controller] roomReviews 진입 =====");
        logger.debug(">>> roomSeq : {}", roomSeq);
        
        String roomTitle = reviewService.getRoomTitle(roomSeq);
        List<Review> reviewList = reviewService.getReviewsByRoom(roomSeq);
        
        logger.debug(">>> roomTitle : {}", roomTitle);
        logger.debug(">>> reviewList.size : {}", reviewList.size());

        for (Review r : reviewList) {
            logger.debug(">>> review #{} - title: {}, images: {}", 
                         r.getReviewSeq(), 
                         r.getReviewTitle(),
                         (r.getReviewImageList() != null ? r.getReviewImageList().size() : "null"));
        }
        
        model.addAttribute("roomTitle", roomTitle);
        model.addAttribute("reviewList", reviewList);
        
       
        
        return "/review/roomReviewList";
    }


    /**
     * 리뷰 1개 상세 보기 페이지 (댓글 기능 포함)
     */
    @GetMapping("/review/view/{reviewSeq}")
    public String reviewView(@PathVariable("reviewSeq") int reviewSeq, Model model) {
        Review review = reviewService.getReviewDetail(reviewSeq);

    	
        if (review == null) {
            // 리뷰가 없거나 삭제된 경우 목록으로 리다이렉트
            return "redirect:/"; // 혹은 다른 적절한 페이지
        }
        
        model.addAttribute("review", review);
        
        return "/review/reviewDetail"; // 새로운 JSP 파일
    }
    
    
    /**
     * [AJAX] 리뷰 목록과 페이징 HTML을 반환하는 메소드
     * @param model
     * @param request
     * @return
     */
    /*
    @GetMapping("/room/reviewListAjax")
    public String reviewListAjax(Model model, HttpServletRequest request) {
        int roomSeq = HttpUtil.get(request, "roomSeq", 0);
        long reviewCurPage = HttpUtil.get(request, "reviewCurPage", (long) 1);
        
        // 리뷰 데이터 조회 로직 (기존 roomDetailSh 메소드에 있던 것과 동일)
        List<Review> reviewList = null;
        Paging reviewPaging = null;
        int reviewTotalCount = reviewService.getReviewCountByRoom(roomSeq);

        if (reviewTotalCount > 0) {
            reviewPaging = new Paging("/room/roomDetail", reviewTotalCount, 3, 3, reviewCurPage, "reviewCurPage");
            //Paging paging = new Paging("/room/reviewListAjax", totalReviewCount, REVIEW_LIST_COUNT, REVIEW_PAGE_COUNT, reviewCurPage, "reviewCurPage");
            
            Review reviewSearch = new Review();
            reviewSearch.setRoomSeq(roomSeq);
            reviewSearch.setStartRow((int) reviewPaging.getStartRow());
            reviewSearch.setEndRow((int) reviewPaging.getEndRow());
            
            reviewList = reviewService.getReviewsByRoomWithPaging(reviewSearch);

            if (reviewList != null && !reviewList.isEmpty()) {
                for (Review review : reviewList) {
                    review.setReviewImageList(reviewService.selectReviewImages(review.getReviewSeq()));
                }
            }
        }
        
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("reviewPaging", reviewPaging);
        model.addAttribute("reviewCurPage", reviewCurPage);
        

        return "/review/reviewListWithDetail"; 
    }
   
    @RequestMapping(value="/review/listDetail", method=RequestMethod.GET)
    public String reviewListDetail(Model model, 
                                   @RequestParam("roomSeq") int roomSeq,
                                   @RequestParam(value="curPage", defaultValue="1") long curPage) {

        int totalReviewCount = reviewService.getReviewCountByRoom(roomSeq);
        long REVIEW_LIST_COUNT = 3; // 한 페이지당 리뷰 수
        long REVIEW_PAGE_COUNT = 3; // 한 번에 보일 페이지 버튼 수

        Paging paging = new Paging(
            "/review/listDetail", // form action
            null, // form name (auto 생성)
            totalReviewCount,
            REVIEW_LIST_COUNT,
            REVIEW_PAGE_COUNT,
            curPage,
            "curPage"
        );

        Review review = new Review();
        review.setRoomSeq(roomSeq);
        review.setStartRow(paging.getStartRow());
        review.setEndRow(paging.getEndRow());

        List<Review> reviewList = reviewService.getReviewsByRoomWithPaging(review);

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("paging", paging);
        model.addAttribute("roomSeq", roomSeq);

        return "/review/reviewListWithDetail"; // JSP 파일명
    }
    */
    
    /**
     * 
     * @param request
     * @param model ("reviewList", reviewList)("reviewPaging", reviewPaging) ("roomSeq", roomSeq)
     * @return
     */
    @RequestMapping(value="/review/list", method=RequestMethod.GET)
    public String ajaxReviewList(HttpServletRequest request, Model model) {

        int roomSeq = HttpUtil.get(request, "roomSeq", 0);
        long reviewCurPage = HttpUtil.get(request, "reviewCurPage", 1L);
        String sessionUserId  = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
        // 리뷰 총 개수
        int reviewTotalCount = reviewService.getReviewCountByRoom(roomSeq);
        // 리뷰 페이징 처리
        Paging reviewPaging = new Paging("/review/list", reviewTotalCount, 3, 3, reviewCurPage, "reviewCurPage");

        Review reviewSearch = new Review();
        reviewSearch.setRoomSeq(roomSeq);
        reviewSearch.setStartRow((int) reviewPaging.getStartRow());
        reviewSearch.setEndRow((int) reviewPaging.getEndRow());
        
        // 해당 숙소에 대한 리뷰 목록
        List<Review> reviewList = reviewService.getReviewsByRoomWithPaging(reviewSearch);
        
        logger.debug("[ReviewController] ajaxReviewList() roomSeq" + roomSeq);
        
        if (reviewList != null && !reviewList.isEmpty()) {
            for (Review review : reviewList) {
                // 이미지
                review.setReviewImageList(reviewService.selectReviewImages(review.getReviewSeq()));
                
                // 댓글 목록
                List<ReviewComment> commentList = reviewCommentService.getCommentsByReview(review.getReviewSeq());
                review.setReviewCommentList(commentList); // review에 세터가 있어야 함
                
                // 호스트 여부 판단 로직 시작
                int rsvSeq = review.getRsvSeq(); // 리뷰에 예약 번호 있어야 함
                int reviewRoomSeq = reservationService.getRoomSeqByRsvSeq(rsvSeq); // 예약번호로 room_seq 찾기
                String hostId = roomService.getHostIdByRoomSeq(reviewRoomSeq); // ROOM 테이블에서 HOST_ID 찾기
                
                logger.debug("ajaxReviewList... rsvSeq" + rsvSeq);
                logger.debug("ajaxReviewList... hostId" + hostId);
                
                boolean isHostAuthor = sessionUserId != null && sessionUserId.equals(hostId);
                logger.debug("ajaxReviewList... isHostAuthor" + isHostAuthor);
                review.setHostAuthor(isHostAuthor); // Review 클래스에 boolean 필드 있어야 함
                
            }
        }

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("reviewPaging", reviewPaging);
        model.addAttribute("roomSeq", roomSeq);

        return "/review/reviewList"; 
    }


}
