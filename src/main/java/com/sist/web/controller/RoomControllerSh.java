package com.sist.web.controller;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.Map;
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

import com.sist.web.model.Facility;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.service.RoomImgServiceSh;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomServiceSh;
import com.sist.web.service.WishlistService;
import com.sist.web.service.RoomTypeServiceSh;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.SessionUtil;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;

@Controller("roomControllerSh")
public class RoomControllerSh {
	
	private static Logger logger = LoggerFactory.getLogger(RoomControllerSh.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['auth.session.name']}") 
	private String AUTH_SESSION_NAME;
	
	@Autowired
	private RoomService roomservice;
	
	@Autowired
	private RoomServiceSh roomService;
	
	@Autowired
	private RoomImgServiceSh roomImgService;
	
	@Autowired
	private RoomTypeServiceSh roomTypeService;
	
	@Autowired
	private WishlistService wishlistService;
	
	private static final int LIST_COUNT = 3; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;	// 페이징 수
	
	//숙소 리스트 페이지
	@RequestMapping(value="/room/roomList")
	public String roomList(@RequestParam(required = false) String startDate, // "20250626"
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
		//String startTime = HttpUtil.get(request, "startTime", "");
		//체크아웃 시간(대여공간)
		//String endTime = HttpUtil.get(request, "endTime","");
		
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
//		if(!StringUtil.isEmpty(startTime) && !StringUtil.isEmpty(endTime))
//		{
//			if(!StringUtil.equals(startTime, endTime))
//			{
//				search.setStartTime(startTime);
//				search.setEndTime(endTime);
//			}
//		}
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
		
		

		
		totalCount = roomService.roomTotalCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		long totalPage = 0;
		
		if(totalCount > 0)
		{
			paging = new Paging("/room/roomList",totalCount,LIST_COUNT, PAGE_COUNT, curPage,"curPage");
			
			totalPage = paging.getTotalPage();
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = roomService.roomList(search);
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
		//model.addAttribute("startTime",startTime);
		//model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
	    model.addAttribute("facilityList",facilityList);
		return "/room/roomList";
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//방 리스트 페이지
	@RequestMapping(value="/room/roomListFragment")
	public String roomListFragment(@RequestParam(required = false) String startDate, // "20250626"
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
		//String startTime = HttpUtil.get(request, "startTime", "");
		//체크아웃 시간(대여공간)
		//String endTime = HttpUtil.get(request, "endTime","");
		
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
//		if(!StringUtil.isEmpty(startTime) && !StringUtil.isEmpty(endTime))
//		{
//			if(!StringUtil.equals(startTime, endTime))
//			{
//				search.setStartTime(startTime);
//				search.setEndTime(endTime);
//			}
//		}
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
		

		
		totalCount = roomService.roomTotalCount(search);
		
		logger.debug("================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("================================");
		
		long totalPage = 0;
		
		if(totalCount > 0)
		{
			paging = new Paging("/room/roomListFragment",totalCount,LIST_COUNT, PAGE_COUNT, curPage,"curPage");
			
			totalPage = paging.getTotalPage();
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = roomService.roomList(search);
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
		//model.addAttribute("startTime",startTime);
		//model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
	    model.addAttribute("facilityList",facilityList);
		return "/room/roomListFragment";
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
	
	
	//////////////////////////////////////////////
	@RequestMapping(value="/room/roomDetailSh")
	public String roomDetailSh(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		//방 Seq
		int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		//체크인 날짜
		String startDate = HttpUtil.get(request, "startDate","");
		//체크아웃 날짜
		String endDate = HttpUtil.get(request, "endDate","");
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
		//카테고리
		String category = HttpUtil.get(request, "category","");

		//체크인 시간(대여공간)
		String startTime = HttpUtil.get(request, "startTime", "");
		//체크아웃 시간(대여공간)
		String endTime = HttpUtil.get(request, "endTime","");
		
		
		if(roomSeq > 0)
		{
			Room room = roomService.getRoomDetail(roomSeq);
			
			if(room != null)
			{
				List<RoomImage> roomImg = roomImgService.getRoomImgDetail(roomSeq);
				List<Facility> facilityList = roomService.facilityList(roomSeq);
				if(roomImg != null)
				{
					room.setStartDate(startDate);
					room.setEndDate(endDate);
					room.setRoomImageList(roomImg);
					RoomImage mainImages = null;
					List<RoomImage> detailImages = new ArrayList<>();
					
					for(RoomImage img : roomImg)
					{
						if("main".equals(img.getImgType()))
						{
							mainImages = img;
						}
						else
						{
							detailImages.add(img);
						}
					}
					
					model.addAttribute("mainImages",mainImages);
					model.addAttribute("detailImages",detailImages);
				}
				
				model.addAttribute("room",room);
				model.addAttribute("roomCatSeq",room.getRoomCatSeq());
				
				List<RoomType> roomTypes = roomTypeService.getRoomTypesByRoomSeq(room);
				model.addAttribute("roomTypes",roomTypes);
				
				model.addAttribute("startDate",startDate);
				model.addAttribute("endDate",endDate);
				model.addAttribute("facilityList",facilityList);
			}
		}

		
		model.addAttribute("roomSeq",roomSeq);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("regionList",regionList);
		model.addAttribute("startTime",startTime);
		model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
		
		return "/room/roomDetailSh";
	}

	
	//호스트 숙소/공간 정보 관리 수정화면(마이페이지에서 수정버튼 눌렀을때) 
	@RequestMapping(value="/room/hostUpdateForm", method=RequestMethod.GET)
	public String hostUpdateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("숙소/공간 룸 정보 수정 화면 sessionUserId : " + sessionUserId);
		//방 Seq
		int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		//체크인 날짜
		String startDate = HttpUtil.get(request, "startDate","");
		//체크아웃 날짜
		String endDate = HttpUtil.get(request, "endDate","");
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
		//카테고리
		String category = HttpUtil.get(request, "category","");

		//체크인 시간(대여공간)
		String startTime = HttpUtil.get(request, "startTime", "");
		//체크아웃 시간(대여공간)
		String endTime = HttpUtil.get(request, "endTime","");
		
		
		if(roomSeq > 0)
		{
			Room room = roomService.getRoomDetail(roomSeq);
			
			if(room != null)
			{
				List<RoomImage> roomImg = roomImgService.getRoomImgDetail(roomSeq);
				List<Facility> facilityList = roomService.facilityList(roomSeq);
				if(roomImg != null)
				{
					room.setStartDate(startDate);
					room.setEndDate(endDate);
					room.setRoomImageList(roomImg);
					RoomImage mainImages = null;
					List<RoomImage> detailImages = new ArrayList<>();
					
					for(RoomImage img : roomImg)
					{
						if("main".equals(img.getImgType()))
						{
							mainImages = img;
						}
						else
						{
							detailImages.add(img);
						}
					}
					
					model.addAttribute("mainImages",mainImages);
					model.addAttribute("detailImages",detailImages);
				}
				
				model.addAttribute("room",room);
				model.addAttribute("roomCatSeq",room.getRoomCatSeq());
				
				List<RoomType> roomTypes = roomTypeService.getRoomTypesByRoomSeq(room);
				model.addAttribute("roomTypes",roomTypes);
				
				model.addAttribute("startDate",startDate);
				model.addAttribute("endDate",endDate);
				model.addAttribute("facilityList",facilityList);
			}
		}

		
		model.addAttribute("roomSeq",roomSeq);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("curPage",curPage);
		model.addAttribute("regionList",regionList);
		model.addAttribute("startTime",startTime);
		model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
		
		return "/room/hostUpdateForm";
	}
	
	//마이페이지 호스트 숙소/공간 룸 정보 삭제
	@RequestMapping(value="/room/hostDeleteProc", method=RequestMethod.POST)
	public Response<Object> hostDeleteProc(Model model, HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxRes = new Response<Object>();
		
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		
		logger.debug("숙소/공간 룸 정보 삭제  sessionUserId : " + sessionUserId);
        logger.debug("roomSeq : " + roomSeq);
        
        if(roomSeq > 0)
        {
        	
        }
        else
        {
        	
        }
		
		return ajaxRes;
	}
	
	//호스트 숙소/공간 detail 수정화면
	@RequestMapping(value="/room/hostDetailUpdateForm", method=RequestMethod.GET)
	public String hostDetailUpdateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		logger.debug("숙소/공간 룸 타입 정보 수정 화면  sessionUserId : " + sessionUserId);
		
		return "/room/hostDetailUpdateForm";
	}
	
}





















