package com.sist.web.controller;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.web.model.Paging;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.service.RoomServiceInterface;
import com.sist.web.service.SpaceService;
import com.sist.web.service.WishlistService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;


@Controller("spaceControllerSh")
public class SpaceController {
	
	private static Logger logger = LoggerFactory.getLogger(SpaceController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['auth.session.name']}") 
	private String AUTH_SESSION_NAME;
	
	@Autowired
	private SpaceService spaceService;	
	
	@Autowired
	private WishlistService wishlistService;
	
	private static final int LIST_COUNT = 9; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;	// 페이징 수
	
	//숙소 리스트 페이지
	@RequestMapping(value="/room/spaceList")
	public String spaceList(@RequestParam(required = false) String startDate, // "20250626"
		    @RequestParam(required = false) String endDate, ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue","");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//필터 값
		String regionList = HttpUtil.get(request, "regionList","");
		//인원수
		int personCount = HttpUtil.get(request, "personCount", 0);
		//최소 금액
		int minPrice = HttpUtil.get(request, "minPrice", 0);
		//최대 금액
		int maxPrice = HttpUtil.get(request, "maxPrice", 0);
		//편의시설 리스트
		String facilityListStr = HttpUtil.get(request, "facilityList", ""); // "와이파이,주차"	
		List<String> facilityList = new ArrayList<>();
		if (!facilityListStr.isEmpty()) 
		{ 
			facilityList = Arrays.stream(facilityListStr.split(","))
		                         .map(String::trim)
		                         .filter(s -> !s.isEmpty()) // Java 8에서도 사용 가능
		                         .collect(Collectors.toList());
		}
		
		//체크인 시간(대여공간)
		String startTime = HttpUtil.get(request, "startTime", "");
		//체크아웃 시간(대여공간)
		String endTime = HttpUtil.get(request, "endTime", "");
		
		//카테고리
		String category = HttpUtil.get(request, "category","");
		
		//리스트 첫페이지 오늘날짜 설정
		if(StringUtil.isEmpty(startDate) && StringUtil.isEmpty(endDate))
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Calendar cal = Calendar.getInstance();
			
			startDate = sdf.format(cal.getTime()); // 오늘 날짜
			endDate = sdf.format(cal.getTime());
		}
		
		logger.debug("==============startDate : " + startDate);
		logger.debug("==============endDate : " + endDate);
		
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
		if(!StringUtil.isEmpty(startDate) && !StringUtil.isEmpty(endDate))
		{
			search.setStartDate(startDate);
			search.setEndDate(endDate);
		}
		if(!StringUtil.isEmpty(startTime) && !StringUtil.isEmpty(endTime))
		{
			if(!StringUtil.equals(startTime, endTime))
			{
				search.setStartTime(startTime);
				search.setEndTime(endTime);
			}
		}
		if(!StringUtil.isEmpty(category))
		{
			search.setCategory(category);
		}
		if(personCount != 0)
		{
			search.setPersonCount(personCount);
		}
		
		if(minPrice != 0)
		{
			search.setMinPrice(minPrice);
		}
		if(maxPrice != 0)
		{
			search.setMaxPrice(maxPrice);
		}
		if(!facilityList.isEmpty())
		{
			search.setFacilityList(facilityList);
		}
		

		
		totalCount = spaceService.spaceTotalCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		long totalPage = 0;
		
		if(totalCount > 0)
		{
			paging = new Paging("/room/spaceList",totalCount,LIST_COUNT, PAGE_COUNT, curPage,"curPage");
			
			totalPage = paging.getTotalPage();
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = spaceService.spaceList(search);
		}
		
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
	    if (sessionUserId != null && !sessionUserId.isEmpty()) {
	        List<Integer> wishSeqs = wishlistService.getWishRoomSeqs(sessionUserId);
	        model.addAttribute("wishSeqs", wishSeqs);
	    } else {
	        // 비로그인 시 빈 리스트라도 넘겨주기
	        model.addAttribute("wishSeqs", Collections.emptyList());
	    }

		
		model.addAttribute("list",list);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("paging",paging);
		model.addAttribute("regionList",regionList);
		model.addAttribute("totalPage",totalPage);
		model.addAttribute("startTime",startTime);
		model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
	    model.addAttribute("facilityList",facilityList);
		return "/room/spaceList";
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//방 리스트 페이지
	@RequestMapping(value="/room/spaceListFragment")
	public String spaceListFragment(@RequestParam(required = false) String startDate, // "20250626"
		    @RequestParam(required = false) String endDate, ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue","");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//필터 값
		String regionList = HttpUtil.get(request, "regionList","");
		//인원수
		int personCount = HttpUtil.get(request, "personCount", 0);
		//최소 금액
		int minPrice = HttpUtil.get(request, "minPrice", 0);
		//최대 금액
		int maxPrice = HttpUtil.get(request, "maxPrice", 0);
		//편의시설 리스트
		String facilityListStr = HttpUtil.get(request, "facilityList", ""); // "와이파이,주차"	
		List<String> facilityList = new ArrayList<>();
		if (!facilityListStr.isEmpty()) 
		{ 
			facilityList = Arrays.stream(facilityListStr.split(","))
		                         .map(String::trim)
		                         .filter(s -> !s.isEmpty()) // Java 8에서도 사용 가능
		                         .collect(Collectors.toList());
		}
		
		//체크인 시간(대여공간)
		String startTime = HttpUtil.get(request, "startTime", "");
		//체크아웃 시간(대여공간)
		String endTime = HttpUtil.get(request, "endTime","");
		
		//카테고리
		String category = HttpUtil.get(request, "category","");
		
		//리스트 첫페이지 오늘날짜 설정
		if(StringUtil.isEmpty(startDate) && StringUtil.isEmpty(endDate))
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Calendar cal = Calendar.getInstance();
			
			startDate = sdf.format(cal.getTime()); // 오늘 날짜
			
			cal.add(Calendar.DATE, 1); // 내일 날짜
			endDate = sdf.format(cal.getTime());
		}
		
		logger.debug("==============startDate : " + startDate);
		logger.debug("==============endDate : " + endDate);
		
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
		if(!StringUtil.isEmpty(startDate) && !StringUtil.isEmpty(endDate))
		{
			search.setStartDate(startDate);
			search.setEndDate(endDate);
		}
		if(!StringUtil.isEmpty(startTime) && !StringUtil.isEmpty(endTime))
		{
			if(!StringUtil.equals(startTime, endTime))
			{
				search.setStartTime(startTime);
				search.setEndTime(endTime);
			}
		}
		if(!StringUtil.isEmpty(category))
		{
			search.setCategory(category);
		}
		if(personCount != 0)
		{
			search.setPersonCount(personCount);
		}
		
		if(minPrice != 0)
		{
			search.setMinPrice(minPrice);
		}
		if(maxPrice != 0)
		{
			search.setMaxPrice(maxPrice);
		}
		if(!facilityList.isEmpty())
		{
			search.setFacilityList(facilityList);
		}
		

		
		totalCount = spaceService.spaceTotalCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		long totalPage = 0;
		
		if(totalCount > 0)
		{
			paging = new Paging("/room/spaceListFragment",totalCount,LIST_COUNT, PAGE_COUNT, curPage,"curPage");
			
			totalPage = paging.getTotalPage();
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = spaceService.spaceList(search);
		}
		
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
	    if (sessionUserId != null && !sessionUserId.isEmpty()) {
	        List<Integer> wishSeqs = wishlistService.getWishRoomSeqs(sessionUserId);
	        model.addAttribute("wishSeqs", wishSeqs);
	    } else {
	        // 비로그인 시 빈 리스트라도 넘겨주기
	        model.addAttribute("wishSeqs", Collections.emptyList());
	    }
		
		model.addAttribute("list",list);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("paging",paging);
		model.addAttribute("regionList",regionList);
		model.addAttribute("totalPage",totalPage);
		model.addAttribute("startTime",startTime);
		model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
	    model.addAttribute("facilityList",facilityList);
		return "/room/spaceListFragment";
	}
	
//	@RequestMapping(value="/room/testSearch", method=RequestMethod.GET)
//    public String searchPage(Model model) {
//        // DB에서 모든 숙소 타입의 가장 빠른 체크인 가능일과 가장 늦은 체크아웃 가능일을 조회
//        //Map<String, String> overallDates = roomService.getOverallAvailableDates(); // 이 메소드는 새로 구현해야 함
//        
//        // 예: overallDates.put("minDate", "2025-07-01");
//        //     overallDates.put("maxDate", "2025-12-31");
//
//        //model.addAttribute("minDate", overallDates.get("minDate"));
//        //model.addAttribute("maxDate", overallDates.get("maxDate"));
//        
//        return "/room/testSearch"; // search.jsp
//    }

}