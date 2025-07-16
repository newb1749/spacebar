package com.sist.web.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.web.model.Facility;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Review;
import com.sist.web.model.ReviewImage;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomQna;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.model.User;
import com.sist.web.service.ReviewService;
import com.sist.web.service.RoomImgService;
import com.sist.web.service.RoomQnaCommentService;
import com.sist.web.service.RoomQnaService;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomServiceInterface;
import com.sist.web.service.RoomTypeService;
import com.sist.web.service.UserService;
import com.sist.web.service.WishlistService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.SessionUtil;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;


@Controller("roomController")
public class RoomController {
	
	private static Logger logger = LoggerFactory.getLogger(RoomController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private RoomServiceInterface roomServiceInterface;
	
	@Autowired
	private RoomService roomService;
	
	@Autowired
	private RoomImgService roomImgService;
	
	@Autowired
	private RoomTypeService roomTypeService;
	
	@Autowired
	private WishlistService wishlistService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private RoomQnaService roomQnaService;
	
	@Autowired
	private RoomQnaCommentService roomQnaCommentService;
	
	@Autowired
	private ReviewService reviewService;

	
	private static final int LIST_COUNT = 3; 	// 한 페이지의 게시물 수
	private static final int PAGE_COUNT = 3;	// 페이징 수
	private static final int QNA_LIST_COUNT = 2; 	// Qna 한 페이지의 게시물 수
	private static final int QNA_PAGE_COUNT = 2;	// Qna 페이징 수
	
    /**
     * 숙소 등록 폼 페이지로 이동
     */
	@RequestMapping(value="/room/addForm", method=RequestMethod.GET)
	public String addForm()
	{	
		return "/room/addForm";
	}
	
	
	 /**
	  * 숙소 등록 처리 (폼 데이터 및 파일 업로드)
	  * @param request
	  * @return
	  */
	 @RequestMapping(value = "/room/addProc", method = RequestMethod.POST)
	    public String addProc(MultipartHttpServletRequest request) {

	        String hostId = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
	
	        if(StringUtil.isEmpty(hostId))
	        {
	             // 로그인이 안되어 있으면 로그인 페이지로 보냅니다.
	             return "redirect:/"; // 팀원이 만든 로그인 폼 주소로 변경?
	        }
         
	        int roomCatSeq = HttpUtil.get(request, "roomCatSeq", 0);
	        // 1-1. Room 객체 설정
	        Room room = new Room();
	        room.setHostId(hostId);
	        //room.setRoomCatSeq(HttpUtil.get(request, "roomCatSeq", 0));
	        room.setRoomCatSeq(roomCatSeq);
	        room.setRoomAddr(HttpUtil.get(request, "roomAddr", ""));
	        room.setLatitude(HttpUtil.get(request, "latitude", 0.0));
	        room.setLongitude(HttpUtil.get(request, "longitude", 0.0));
	        room.setRegion(HttpUtil.get(request, "region", ""));
	        room.setAutoConfirmYn(HttpUtil.get(request, "autoConfirmYn", "Y"));
	        room.setRoomTitle(HttpUtil.get(request, "roomTitle", ""));
	        room.setRoomDesc(HttpUtil.get(request, "roomDesc", ""));
	        room.setCancelPolicy(HttpUtil.get(request, "cancelPolicy", ""));
	        room.setMinTimes(HttpUtil.get(request, "minTimes", (short) 0));
	        room.setMaxTimes(HttpUtil.get(request, "maxTimes", (short) 0));
	        room.setAverageRating(HttpUtil.get(request, "averageRating", 0.0));
	        room.setReviewCount(HttpUtil.get(request, "reviewCount", 0));
	        
	        if (roomCatSeq <= 0) {
	            // 카테고리를 선택하지 않았을 경우, 메시지와 함께 폼으로 다시 보냄
	        	logger.debug("카테고리 시퀀스 값 :", roomCatSeq);
	        	logger.debug("카테고리 get시퀀스 값 :", room.getRoomCatSeq());
	            return "redirect:/room/addForm"; // 등록 폼으로 리다이렉트
	        }
	        // 1-2. 편의시설 정보 처리(일대다)
	        String[] facilityNosStr = request.getParameterValues("facilitySeqs");
	        if(!StringUtil.isEmpty(facilityNosStr) && facilityNosStr.length > 0)
	        {
	        	List<Integer> facilityNos = new ArrayList<>();
	        	for(String facNo : facilityNosStr)
	        	{
	        		try
	        		{
	        			facilityNos.add(Integer.parseInt(facNo));
	        		}
	        		catch(NumberFormatException e)
	        		{
	        			logger.error("[RoomController] Invalid facility number format: " + facNo, e);
	        		}
	        	}
	        	room.setFacilityNos(facilityNos);
	        }
	        
	        List<RoomImage> roomImageList = new ArrayList<>();
			// 2-1. 메인 이미지 처리(단일 파일)
	        MultipartFile mainImage = request.getFile("roomMainImage");
	        if (mainImage != null && !mainImage.isEmpty()) {
	            RoomImage image = new RoomImage();
	            image.setFile(mainImage);
	            image.setImgType("main");
	            image.setSortOrder((short) 1);
	            roomImageList.add(image);
	        }

			// 2-2. 상세 이미지 처리(파일 여러개)
	        List<MultipartFile> detailImages = request.getFiles("roomDetailImages");
	        short sortOrder = 2;
	        for (MultipartFile file : detailImages) {
	            if (file != null && !file.isEmpty()) {
	                RoomImage image = new RoomImage();
	                image.setFile(file);
	                image.setImgType("detail");
	                image.setSortOrder(sortOrder++);
	                roomImageList.add(image);
	            }
	        }

	        room.setRoomImageList(roomImageList);

			// 3. 객실 타입(RoomType) (방1개) 및 해당되는 이미지 처리
	        // 객실 타입 목록 추출 (인덱스로 순회)
	        List<RoomType> roomTypeList = new ArrayList<>();
	        int index = 0;
	        while (true) {
	            String prefix = "roomTypeTitle_" + index;
	            if (request.getParameter(prefix) == null) break;
	            // jsp에 맞게 데이터 처리
	            RoomType roomType = new RoomType();
	            roomType.setRoomTypeTitle(HttpUtil.get(request, "roomTypeTitle_" + index, ""));
	            roomType.setRoomTypeDesc(HttpUtil.get(request, "roomTypeDesc_" + index, ""));
	            roomType.setWeekdayAmt(HttpUtil.get(request, "weekdayAmt_" + index, 0));
	            roomType.setWeekendAmt(HttpUtil.get(request, "weekendAmt_" + index, 0));
	            roomType.setRoomCheckInDt(HttpUtil.get(request, "roomCheckInDt_" + index, ""));
	            roomType.setRoomCheckOutDt(HttpUtil.get(request, "roomCheckOutDt_" + index, ""));
	            roomType.setRoomCheckInTime(HttpUtil.get(request, "roomCheckInTime_" + index, ""));
	            roomType.setRoomCheckOutTime(HttpUtil.get(request, "roomCheckOutTime_" + index, ""));
	            roomType.setMaxGuests(HttpUtil.get(request, "maxGuests_" + index, (short) 0));
	            roomType.setMinDay(HttpUtil.get(request, "minDay_" + index, (short) 0));
	            roomType.setMaxDay(HttpUtil.get(request, "maxDay_" + index, (short) 0));

	            // 이미지 처리
	            List<RoomTypeImage> roomTypeImageList = new ArrayList<>();
	            MultipartFile mainImg = request.getFile("roomTypeMainImage_" + index);
	            if (mainImg != null && !mainImg.isEmpty()) {
	                RoomTypeImage image = new RoomTypeImage();
	                image.setFile(mainImg);
	                image.setImgType("main");
	                image.setSortOrder((short) 1);
	                roomTypeImageList.add(image);
	            }
	            // 이미지시퀀스 부여
	            List<MultipartFile> detailImgs = request.getFiles("roomTypeDetailImages_" + index);
	            short detailOrder = 2;
	            for (MultipartFile file : detailImgs) {
	                if (file != null && !file.isEmpty()) {
	                    RoomTypeImage image = new RoomTypeImage();
	                    image.setFile(file);
	                    image.setImgType("detail");
	                    image.setSortOrder(detailOrder++);
	                    roomTypeImageList.add(image);
	                }
	            }

	            roomType.setRoomTypeImageList(roomTypeImageList);
	            roomTypeList.add(roomType);
	            index++;
	        }

	        // 저장 처리
	        // 4. 서비스 호출
	        try {
	            if (roomServiceInterface.insertRoomTransaction(room, roomTypeList) > 0) {
	                logger.debug("숙소 등록 성공");
	            } else {
	                logger.error("숙소 등록 실패");
	            }
	        } catch (Exception e) {
	            logger.error("[RoomController] addProc Exception", e);
	        }

        return "redirect:/host/main";
    }
	 
	/////////////////////////////////////////////////숙소 리스트 페이지/////////////////////////////////////////
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
//			if(!StringUtil.isEmpty(startTime) && !StringUtil.isEmpty(endTime))
//			{
//				if(!StringUtil.equals(startTime, endTime))
//				{
//					search.setStartTime(startTime);
//					search.setEndTime(endTime);
//				}
//			}
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
//			if(!StringUtil.isEmpty(startTime) && !StringUtil.isEmpty(endTime))
//			{
//				if(!StringUtil.equals(startTime, endTime))
//				{
//					search.setStartTime(startTime);
//					search.setEndTime(endTime);
//				}
//			}
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
	
//		@RequestMapping(value="/room/testSearch", method=RequestMethod.GET)
//	    public String searchPage(Model model) {
//	        // DB에서 모든 숙소 타입의 가장 빠른 체크인 가능일과 가장 늦은 체크아웃 가능일을 조회
//	        //Map<String, String> overallDates = roomService.getOverallAvailableDates(); // 이 메소드는 새로 구현해야 함
//	        
//	        // 예: overallDates.put("minDate", "2025-07-01");
//	        //     overallDates.put("maxDate", "2025-12-31");
//
//	        //model.addAttribute("minDate", overallDates.get("minDate"));
//	        //model.addAttribute("maxDate", overallDates.get("maxDate"));
//	        
//	        return "/room/testSearch"; // search.jsp
//	    }
	
	
	/////////////////////////////////////////////방 상세 페이지/////////////////////////////////////
	@RequestMapping(value="/room/roomDetail")
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
		// 리뷰 페이지
		long reviewCurPage = HttpUtil.get(request, "reviewCurPage", (long)1);
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
		
		//userType = 'G' 'H'인지 구분하여 Q&A 질문 / 답변 버튼 보여주기 위함
        String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
        
        logger.debug("ROOM 상세페이지 sessionUserId : " + sessionUserId);
        logger.debug("roomSeq : " + roomSeq);
        //logger.debug("roomQnaSeq : " + roomQnaSeq);
        logger.debug("curPage : " + curPage);
        
        String userType = null;
        if (sessionUserId != null) 
        {
            User userId = userService.userSelect(sessionUserId);
            
            if (userId != null) 
            {
                userType = userId.getUserType(); 
                model.addAttribute("user", userId);
                model.addAttribute("sessionUserId", sessionUserId);
            }
        }
        model.addAttribute("userType", userType);
        
        List<RoomQna> qnaList = null;
        RoomQna search = new RoomQna();
        int totalCount = 0;
        Paging paging = null;
		
		
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
				
				// 리뷰
		        List<Review> reviewList = null;
		        int reviewTotalCount = reviewService.getReviewCountByRoom(roomSeq);
		        Paging reviewPaging = null;
		        
		        logger.debug("[리뷰 디버그] roomSeq: " + roomSeq + ", reviewTotalCount: " + reviewTotalCount);
		        
		        // 리뷰 목록과 페이징
		        if (reviewTotalCount > 0) {
		            // 한 페이지에 5개, 페이지 블럭은 5개로 임의 지정
		            reviewPaging = new Paging("/room/roomDetail", reviewTotalCount, 3, 3, reviewCurPage, "reviewCurPage");
		            
		            Review reviewSearch = new Review();
		            reviewSearch.setRoomSeq(roomSeq);
		            reviewSearch.setStartRow((int) reviewPaging.getStartRow());
		            reviewSearch.setEndRow((int) reviewPaging.getEndRow());
		            
		            reviewList = reviewService.getReviewsByRoomWithPaging(reviewSearch);
		            
		            logger.debug("[리뷰 디버그] 조회된 reviewList 사이즈: " + (reviewList != null ? reviewList.size() : "null"));

		            // 각 리뷰에 이미지 첨부
		            if (reviewList != null && !reviewList.isEmpty()) {
		                for (Review review : reviewList) {
		                    review.setReviewImageList(reviewService.selectReviewImages(review.getReviewSeq()));
		                }
		            }
		        }
		        
				//QNA 총 개수
				search.setRoomSeq(roomSeq);
                totalCount = roomQnaService.qnaListCount(search);
                logger.debug("totalCount : " + totalCount);
                
                if(totalCount > 0)
                {
                   paging = new Paging("/room/roomDetail", totalCount, QNA_LIST_COUNT, QNA_PAGE_COUNT, curPage, "curPage");
                   
                   search.setStartRow((int)paging.getStartRow());
                   search.setEndRow((int)paging.getEndRow());
                   
                   qnaList = roomQnaService.qnaList(search);
                   
                   if(qnaList != null)
                   {
                      int i;
                      for(i=0; i<qnaList.size(); i++)
                      {
                         qnaList.get(i).setRoomQnaComment(roomQnaCommentService.roomQnaCommontSelect(qnaList.get(i).getRoomQnaSeq()));
                      }
                      
                   }
                }
                
                // review
                model.addAttribute("reviewList", reviewList);
                model.addAttribute("reviewPaging", reviewPaging);

                // qna
                model.addAttribute("qnaList", qnaList);
                model.addAttribute("paging", paging);
        		model.addAttribute("curPage",curPage);
				
				model.addAttribute("startDate",startDate);
				model.addAttribute("endDate",endDate);
				model.addAttribute("facilityList",facilityList);
			}
		}

		model.addAttribute("reviewCurPage", reviewCurPage); // ✅ 이거 빠져 있었음

		model.addAttribute("roomSeq",roomSeq);
		model.addAttribute("searchValue",searchValue);
		model.addAttribute("regionList",regionList);
		model.addAttribute("startTime",startTime);
		model.addAttribute("endTime",endTime);
		model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("category",category);
	    model.addAttribute("personCount",personCount);
	    model.addAttribute("minPrice",minPrice);
	    model.addAttribute("maxPrice",maxPrice);
		
		return "/room/roomDetail";
	} 

	//Q&A 리스트 (iframe)
	@RequestMapping(value="/room/qnaList", method=RequestMethod.GET)
	public String qnaList(Model model, HttpServletRequest request) 
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
	    int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
        logger.debug("Q&A 리스트 iframe페이지 sessionUserId : " + sessionUserId);
        logger.debug("Q&A 리스트 iframe페이지 roomSeq : " + roomSeq);
        logger.debug("curPage : " + curPage);
		
	    RoomQna search = new RoomQna();
	    search.setRoomSeq(roomSeq);
	    
	    List<RoomQna> qnaList = roomQnaService.qnaList(search);
	    User user = userService.userSelect(sessionUserId);	

    	int totalCount = roomQnaService.qnaListCount(search);
    	Paging paging = null;
	    
    	if(totalCount > 0)
    	{
    		paging = new Paging("/room/roomDetail", totalCount, QNA_LIST_COUNT, QNA_PAGE_COUNT, curPage, "curPage");
    		search.setStartRow((int)paging.getStartRow());
    		search.setEndRow((int)paging.getEndRow());
    		
    		qnaList = roomQnaService.qnaList(search);
    		
    		if(qnaList != null)
    		{
    			int i;
    			for(i = 0; i < qnaList.size(); i++)
    			{
    				qnaList.get(i).setRoomQnaComment(roomQnaCommentService.roomQnaCommontSelect(qnaList.get(i).getRoomQnaSeq()));
    			}
    		}
    	}
    	
    	model.addAttribute("sessionUserId", sessionUserId);
	    model.addAttribute("qnaList", qnaList);
	    model.addAttribute("roomSeq", roomSeq);
	    model.addAttribute("user", user);
	    model.addAttribute("curPage", curPage);
	    model.addAttribute("paging", paging);

	    return "/room/qnaList"; 
	}
	
	
    //Q&A 리스트 AJAX
    @RequestMapping(value="/room/qnaListJson", method=RequestMethod.POST)
    @ResponseBody
    public Response<Object> qnaListJson(Model model, HttpServletRequest request, HttpServletResponse response)
    {
    	Response<Object> ajaxRes = new Response<Object>();
    	int roomSeq = HttpUtil.get(request, "roomSeq", 0);
    	//int roomQnaSeq = HttpUtil.get(request, "roomQnaSeq", 0);
    	long curPage = HttpUtil.get(request, "curPage", (long)1);
    	
    	logger.debug("Q&A 리스트 AJAX roomSeq : " + roomSeq);
    	//logger.debug("roomQnaSeq : " + roomQnaSeq);
    	logger.debug("curPage : " + curPage);
    	
    	RoomQna search = new RoomQna();
    	search.setRoomSeq(roomSeq);
    	
    	int totalCount = roomQnaService.qnaListCount(search);
    	Paging paging = null;
    	
    	List<RoomQna> qnaList = new ArrayList<>();

    	if(totalCount > 0)
    	{
    		paging = new Paging("/room/roomDetail", totalCount, QNA_LIST_COUNT, QNA_PAGE_COUNT, curPage, "curPage");
    		search.setStartRow((int)paging.getStartRow());
    		search.setEndRow((int)paging.getEndRow());
    		
    		qnaList = roomQnaService.qnaList(search);
    		
    		if(qnaList != null)
    		{
    			int i;
    			for(i = 0; i < qnaList.size(); i++)
    			{
    				qnaList.get(i).setRoomQnaComment(roomQnaCommentService.roomQnaCommontSelect(qnaList.get(i).getRoomQnaSeq()));
    			}
    		}
    	}
    	
    	model.addAttribute("qnaList", qnaList);
    	model.addAttribute("totalCount", totalCount);
    	model.addAttribute("curPage", curPage);
    	model.addAttribute("paging", paging);
        
        ajaxRes.setResponse(0, "success");
        
    	return ajaxRes;
    }
}