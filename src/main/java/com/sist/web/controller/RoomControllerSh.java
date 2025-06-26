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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.web.model.Paging;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomServiceSh;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;


@Controller("roomControllerSh")
public class RoomControllerSh {
	
	private static Logger logger = LoggerFactory.getLogger(RoomController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private RoomServiceSh roomService;
	
	private static final int LIST_COUNT = 9; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;	// 페이징 수
	
	//방 리스트 페이지
	@RequestMapping(value="/room/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue","");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//필터 값
		String regionList = HttpUtil.get(request, "regionList","");
		//체크인 시간(대여공간)
		int startTime = HttpUtil.get(request, "startTime", 0);
		//체크아웃 시간(대여공간)
		int endTime = HttpUtil.get(request, "endTime", 0);
		
		// 게시물 리스트
		List<Room> list = null;
		//조회 객체
		Room search = new Room();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		if(!StringUtil.isEmpty(searchValue))
		{
			search.setSearchValue(searchValue);
		}
		if(!StringUtil.isEmpty(regionList))
		{
			search.setRegionList(regionList);
		}

		
		totalCount = roomService.roomTotalCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		long totalPage = 0;
		
		if(totalCount > 0)
		{
			paging = new Paging("/room/list",totalCount,LIST_COUNT, PAGE_COUNT, curPage,"curPage");
			
			totalPage = paging.getTotalPage();
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = roomService.roomList(search);
		}
		
		model.addAttribute("list",list);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("paging",paging);
		model.addAttribute("regionList",regionList);
		model.addAttribute("totalPage",totalPage);
		model.addAttribute("startTime",startTime);
		model.addAttribute("endTime",endTime);
		
		return "/room/list";
	}
	
	//방 리스트 페이지
	@RequestMapping(value="/room/listFragment")
	public String listFragment(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue","");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//필터 값
		String regionList = HttpUtil.get(request, "regionList", "");
		
		// 게시물 리스트
		List<Room> list = null;
		//조회 객체
		Room search = new Room();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		logger.debug(regionList);
		
		if(!StringUtil.isEmpty(searchValue))
		{
			search.setSearchValue(searchValue);
		}
		if(!StringUtil.isEmpty(regionList))
		{
			search.setRegionList(regionList);
		}
		
		totalCount = roomService.roomTotalCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		long totalPage = 0;
		
		if(totalCount > 0)
		{
			paging = new Paging("/room/list",totalCount,LIST_COUNT, PAGE_COUNT, curPage,"curPage");
			
			totalPage = paging.getTotalPage();
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = roomService.roomList(search);
		}
		
		model.addAttribute("list",list);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("paging",paging);
		model.addAttribute("regionList",regionList);
		model.addAttribute("totalPage",totalPage);
		
		return "/room/listFragment";
	}

}





















