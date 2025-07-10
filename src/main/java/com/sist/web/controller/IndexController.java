/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale.Category;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.web.model.Review;
import com.sist.web.model.Room;
import com.sist.web.model.RoomCategory;
import com.sist.web.service.ReviewService;
import com.sist.web.service.RoomCategoryService;
import com.sist.web.service.RoomServiceSh;
import com.sist.web.service.WishlistService;
import com.sist.web.util.CookieUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * 설명       : 인덱스 컨트롤러
 * </pre>
 */
@Controller("indexController")
public class IndexController
{
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	/**
	 * <pre>
	 * 메소드명   : index
	 * 작성일     : 2021. 1. 21.
	 * 작성자     : daekk
	 * 설명       : 인덱스 페이지 
	 * </pre>
	 * @param request  HttpServletRequest
	 * @param response HttpServletResponse
	 * @return String
	 */
	
	
	@Autowired
    private RoomCategoryService roomategoryService;
	
	@Autowired
	private RoomServiceSh roomService;
	
	@Autowired
	private WishlistService wishlistService;
	
	@Autowired
	private ReviewService reviewService;
	
	@Value("#{env['auth.session.name']}") 
	private String AUTH_SESSION_NAME;

	@RequestMapping(value = "/index", method=RequestMethod.GET)
	public String index(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		List<Room> rooms = roomService.newRoomList();
		
		List<Room> spaces = roomService.newSpaceList();
		
        List<RoomCategory> cats = roomategoryService.roomCategoryList();
        
        List<RoomCategory> cats2 = roomategoryService.spaceCategoryList();
        
        List<Review> reviews = reviewService.allReviewList();
        
        String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
	    if (sessionUserId != null && !sessionUserId.isEmpty()) {
	        List<Integer> wishSeqs = wishlistService.getWishRoomSeqs(sessionUserId);
	        model.addAttribute("wishSeqs", wishSeqs);
	    } else {
	        // 비로그인 시 빈 리스트라도 넘겨주기
	        model.addAttribute("wishSeqs", Collections.emptyList());
	    }
        
	    model.addAttribute("spaceCategoryList", cats2);
	    model.addAttribute("spaceList", spaces);
        model.addAttribute("roomList", rooms);
        model.addAttribute("roomCategoryList", cats);
        model.addAttribute("reviewList", reviews);
        
        return "/index";  // /WEB-INF/views/index.jsp
    }
	
}





