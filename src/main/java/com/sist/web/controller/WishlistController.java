package com.sist.web.controller;


import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Room;
import com.sist.web.model.Wishlist;
import com.sist.web.service.RoomService;
import com.sist.web.service.WishlistService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("wishlistController")
public class WishlistController {
	private static Logger logger = LoggerFactory.getLogger(WishlistController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Autowired
	private WishlistService wishlistService;
	
	@Autowired
	private RoomService roomService;
	
	private static final int LIST_COUNT = 10; 
	private static final int PAGE_COUNT = 3;
	
	@Value("#{env['auth.session.name']}")
    private String AUTH_SESSION_NAME;
	
	//위시리스트 추가
	@RequestMapping(value="/wishlist/add", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> wishlistAdd(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		int roomSeq = HttpUtil.get(request, "roomSeq", (int)0);
		
		if(!StringUtil.isEmpty(sessionUserId))
		{
			if(roomSeq > 0)
			{
				Room room = roomService.getRoomDetail(roomSeq);
				
				if(room != null)
				{
					Wishlist wishlist = new Wishlist();
			        wishlist.setUserId(sessionUserId);
			        wishlist.setRoomSeq(roomSeq);

					
			        if(wishlistService.countWish(roomSeq, sessionUserId) == 0)
			        {
			            wishlistService.insertWish(wishlist);
			            ajaxResponse.setResponse(0, "위시리스트 등록 성공");
			        }
			        else
			        {
			            ajaxResponse.setResponse(400, "이미 위시리스트에 등록된 숙소입니다.");
			            return ajaxResponse;
			        }
				}
				else
				{
					 ajaxResponse.setResponse(404, "존재하지 않는 숙소입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(99, "숙소번호 전달안됨");
			}
		}
		else
		{
			ajaxResponse.setResponse(500, "로그인 후 이용하세요.");
		}
		
		return ajaxResponse;
	}
	
	//위시리스트 페이지
	@RequestMapping(value="/wishlist/list")
	public String wishlist(ModelMap model ,HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		int roomSeq = HttpUtil.get(request, "roomSeq", (int)0);
		long curPage = HttpUtil.get(request, "curPage", (int)1);
		
		List<Wishlist> list = null;
		Wishlist wishlist = new Wishlist();
		long totalCount = 0;
		int cnt = 0;
		Paging paging = null;
		
		wishlist.setUserId(sessionUserId);
		wishlist.setRoomSeq(roomSeq);
		
		totalCount = wishlistService.wishTotalCount(wishlist);
		
		if(totalCount > 10)
		{
			paging = new Paging("/wishlist/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			wishlist.setStartRow(paging.getStartRow());
			wishlist.setEndRow(paging.getEndRow());
		}
		

		list = wishlistService.wishlist(wishlist);
		

		
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/wishlist/list";
	}
	
	//위시리스트 해제
	// 수정된 방식 ✅
	@RequestMapping(value="/wishlist/remove", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> wishlistRemove(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();

		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		int roomSeq = HttpUtil.get(request, "roomSeq", (int)0);

		if(!StringUtil.isEmpty(sessionUserId))
		{
			if(roomSeq > 0)
			{
				Room room = roomService.getRoomDetail(roomSeq);

				if(room != null)
				{
					Wishlist wishlist = new Wishlist();
			        wishlist.setUserId(sessionUserId);
			        wishlist.setRoomSeq(roomSeq);

					
			        if(wishlistService.wishRemove(roomSeq, sessionUserId) > 0)
			        {		            
			            ajaxResponse.setResponse(0, "위시리스트 삭제 성공");
			        }
			        else
			        {
			            ajaxResponse.setResponse(400, "삭제실패");
			            return ajaxResponse;
			        }
				}
				else
				{
					ajaxResponse.setResponse(404, "존재하지 않는 숙소입니다.");
				}
			}
			else
			{
				ajaxResponse.setResponse(99, "숙소번호 전달안됨");
			}
		}
		else
		{
			ajaxResponse.setResponse(500, "로그인 후 이용하세요.");
		}

		return ajaxResponse;
	}

	
}
