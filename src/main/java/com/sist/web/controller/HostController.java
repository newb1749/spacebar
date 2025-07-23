package com.sist.web.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;

import java.util.HashMap;

import java.util.Date;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpSession;

import javax.servlet.http.HttpServletResponse;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.util.StringUtil;
import com.sist.web.dao.FacilityDao;
import com.sist.web.dao.ReviewDao;
import com.sist.web.dao.RoomDao;
import com.sist.web.model.Facility;

import com.sist.web.model.Review;

import com.sist.web.model.Reservation;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.model.User;
import com.sist.web.service.HostService;
import com.sist.web.service.ReservationServiceJY;
import com.sist.web.service.RoomImgService;
import com.sist.web.service.RoomService;
import com.sist.web.service.RoomServiceSh;
import com.sist.web.service.RoomTypeService;
import com.sist.web.service.UserService;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.SessionUtil;

@Controller("hostController")
public class HostController {
	private static Logger logger = LoggerFactory.getLogger(RoomController.class);
	
	@Value("#{env['auth.session.name']}")
	private String AUTH_SESSION_NAME;
	
	@Value("#{env['upload.save.dir']}") // env.xml에 있음
	private String UPLOAD_SAVE_DIR;
	
	
    @Autowired
    private HostService hostService;
    
    @Autowired
    private RoomService roomService;
    
    @Autowired
    private RoomDao roomDao;
	
	@Autowired
	private FacilityDao facilityDao;
    
    @Autowired
    private RoomTypeService roomTypeService;
    
    @Autowired

    private ReviewDao reviewDao;
    

    private UserService userService;
    
    @Autowired
    private RoomServiceSh roomServiceSh;
    
    @Autowired
    private ReservationServiceJY reservationService;
    
    @Autowired
    private RoomImgService roomImgService;

    
	/**
	 * 호스트 메인 페이지로 이동
	 * @return
	 */
	@RequestMapping(value="/host/main", method=RequestMethod.GET)
	public String hostPage(Model model, HttpServletRequest request, HttpServletResponse response) 
	{
	    String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
	    
	    // 예약정보 조회
	    List<Reservation> reservations = reservationService.reservationsListByHostId(sessionUserId);
	    
	    for (Reservation rsv : reservations) 
	    {
	        int roomTypeSeq = rsv.getRoomTypeSeq();
	        
	        //숙소 제목
	        RoomType roomType = roomTypeService.getRoomType(roomTypeSeq);
	        if (roomType != null) 
	        {
	            rsv.setRoomTypeTitle(roomType.getRoomTypeTitle());

	        }
	        
	        // 이미지
	        List<RoomTypeImage> roomTypeImgs = roomImgService.getRoomTypeImgDetail(roomTypeSeq);
	        if (roomTypeImgs != null && !roomTypeImgs.isEmpty()) 
	        {
	            RoomTypeImage roomTypeImg = roomTypeImgs.get(0);
	            rsv.setRoomTypeImgName(roomTypeImg.getRoomTypeImgName());
	        }
	    }
	    model.addAttribute("reservations", reservations);
	    return "/host/main";
	}

	
	// **************************************************************************************
	// *********************************** 숙소/공간 관리 ***************************************
	// **************************************************************************************

	@RequestMapping(value="/host/fragment/roomList", method=RequestMethod.GET)
	public String roomList(Model model, HttpServletRequest request)
	{
		String sessionUserId = (String)request.getSession().getAttribute(AUTH_SESSION_NAME);
		
	    List<Room> roomList = hostService.selectRoomListByHostId(sessionUserId);
	    
	    model.addAttribute("roomList", roomList);
	    return "/host/fragment/roomList";
	}
	
	/**
	 * 숙소 수정 페이지
	 * @param roomSeq
	 * @param model
	 * @return
	 */
	@GetMapping("/host/updateRoom")
	public String updateRoom(@RequestParam("roomSeq") int roomSeq, Model model) {
	    // 1. 숙소 기본 정보
	    Room room = roomService.getRoomDetail(roomSeq);
	    model.addAttribute("room", room);

	    // 2. 숙소 이미지 (대표/상세 분리)
	    List<RoomImage> images = roomService.getRoomImgDetail(roomSeq);
	    String mainImageName = null;
	    List<String> detailImageNames = new ArrayList<>();

	    for (RoomImage img : images) {
	        if ("main".equalsIgnoreCase(img.getImgType())) {
	            mainImageName = img.getRoomImgName();
	        } else if ("detail".equalsIgnoreCase(img.getImgType())) {
	            detailImageNames.add(img.getRoomImgName());
	        }
	    }

	    model.addAttribute("mainImageName", mainImageName);
	    model.addAttribute("detailImageNames", detailImageNames);

	    // 3. 편의시설 (List<Facility>)

	    // 4. 체크된 시설 번호만 String 리스트로 추출
	    List<Facility> facilityList = facilityDao.selectFacilitiesByRoomSeq(roomSeq);
	    List<Integer> checkedList = facilityList.stream()
	            .map(Facility::getFacSeq) // f -> f.getFacSeq() 와 동일
	            .collect(Collectors.toList());

	   

	    logger.debug(">> [HostController] updateRoom 재삽입할 편의시설 목록: {}", room.getFacilityNos());

	    System.out.println("roomSeq = " + roomSeq);
	    System.out.println("facilityList = " + facilityList);
	    System.out.println("checkedList = " + checkedList);
	    
	        
	    model.addAttribute("facilityList", facilityList);
	    model.addAttribute("checkedList", checkedList);

	    
	    // 5. 객실 타입 목록
	    List<RoomType> roomTypes = roomTypeService.getRoomTypesByRoomSeq(roomSeq);
	    model.addAttribute("roomTypes", roomTypes);

	    return "/host/updateRoom";
	}


	
	/**
	 * 숙소 수정 로직
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/host/updateProc", method= RequestMethod.POST)
	public String updateProc(MultipartHttpServletRequest request)
	{
		String hostId = (String)SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
		if (StringUtil.isEmpty(hostId)) return "redirect:/";
		
		int roomSeq = HttpUtil.get(request, "roomSeq", 0);
		int roomCatSeq = HttpUtil.get(request, "roomCatSeq", 0);
		
		Room room = new Room();
	    room.setRoomSeq(roomSeq);
	    room.setHostId(hostId);
	    room.setRoomCatSeq(roomCatSeq);
	    room.setRoomAddr(HttpUtil.get(request, "roomAddr", ""));
	    room.setLatitude(HttpUtil.get(request, "latitude", 0.0));
	    room.setLongitude(HttpUtil.get(request, "longitude", 0.0));
	    room.setRegion(HttpUtil.get(request, "region", ""));
	    room.setAutoConfirmYn(HttpUtil.get(request, "autoConfirmYn", "N"));
	    room.setRoomTitle(HttpUtil.get(request, "roomTitle", ""));
	    room.setRoomDesc(HttpUtil.get(request, "roomDesc", ""));
	    room.setCancelPolicy(HttpUtil.get(request, "cancelPolicy", ""));
	    room.setMinTimes(HttpUtil.get(request, "minTimes", (short) 0));
	    room.setMaxTimes(HttpUtil.get(request, "maxTimes", (short) 0));
	    
	    // 편의시설
	    String[] facilityNosStr =  request.getParameterValues("facilitySeqs");
	    logger.debug(">>> request.getParameterValues(facilitySeqs): {}", Arrays.toString(facilityNosStr));
	    if (!StringUtil.isEmpty(facilityNosStr) && facilityNosStr.length > 0) {
	        List<Integer> facilityNos = Arrays.stream(facilityNosStr)
	            .filter(StringUtils::hasText)
	            .map(s -> Integer.parseInt(s.trim())) // ← 여기 trim 추가!
	            .collect(Collectors.toList());
	        room.setFacilityNos(facilityNos);
	    }

	    
	    // 기존 숙소 이미지 삭제 후 새로운 이미지 등록
	    // 2-1. 메인 이미지 처리(단일 파일)
	    List<RoomImage> roomImageList = new ArrayList<>();
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
		
	    // 객실 타입 수정
	    List<RoomType> roomTypeList = new ArrayList<>();
	    int index = 0;
	    while (true) {
	        String prefix = "roomTypeTitle_" + index;
	        if (request.getParameter(prefix) == null) break;

	        RoomType roomType = new RoomType();
	        roomType.setRoomTypeSeq(HttpUtil.get(request, "roomTypeSeq_" + index, 0));
	        roomType.setRoomSeq(roomSeq);
	        roomType.setRoomTypeTitle(HttpUtil.get(request, prefix, ""));
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

	       
	        List<RoomTypeImage> roomTypeImageList = new ArrayList<>();
	        
	        
	        // [👈 추가해야 할 메인 이미지 처리]
	        MultipartFile mainImage2 = request.getFile("roomTypeMainImage_" + index);
	        if (mainImage2 != null && !mainImage2.isEmpty()) {
	            RoomTypeImage image = new RoomTypeImage();
	            image.setFile(mainImage2);
	            image.setImgType("main");
	            image.setSortOrder((short) 1); // main 이미지니까 우선순위 1
	            roomTypeImageList.add(image);
	        }
	        
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

	    try {
	        if (hostService.updateRoomTransaction(room, roomTypeList) > 0) {
	        	logger.debug(">>> BEFORE111111 updateRoomTransaction - roomSeq: {}", room.getRoomSeq());
	            logger.debug("숙소 수정 성공");
	        } else {
	        	logger.debug(">>> BEFORE222222222222 updateRoomTransaction - roomSeq: {}", room.getRoomSeq());

	            logger.error("숙소 수정 실패");
	        }
	    } catch (Exception e) {
	    	logger.debug(">>> BEFORE33333333333333 updateRoomTransaction - roomSeq: {}", room.getRoomSeq());

	        logger.error("[RoomController] updateProc Exception", e);
	    }

	    return "redirect:/host/main";
	}
	
	
	@PostMapping("/host/room/delete")
	@ResponseBody
	public String deleteRoom(@RequestParam("roomSeq") int roomSeq) {
	    int result = hostService.softDeleteRoom(roomSeq);
	    return (result > 0) ? "success" : "fail";
	}

	@PostMapping("/host/room/stopSelling")
	@ResponseBody
	public String stopSelling(@RequestParam int roomSeq) {
	    hostService.stopSellingRoom(roomSeq);
	    return "success";
	}

	
	@PostMapping("/host/room/resumeSelling")
	@ResponseBody
	public String resumeSelling(@RequestParam("roomSeq") int roomSeq) {
	    int result = hostService.resumeSellingRoom(roomSeq);
	    return (result > 0) ? "success" : "fail";
	}


	// **************************************************************************************
	// ************************************* 리뷰 관리 *****************************************
	// **************************************************************************************
	/**
	 * 호스트ㅎ 리뷰 관리 페이지
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/host/fragment/reviewManage")
	public String reviewManage(HttpServletRequest request, Model model) {
	    String hostId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
	    if (StringUtil.isEmpty(hostId)) return "redirect:/";

	    List<Room> roomList = hostService.getRoomsByHost(hostId);
	    List<Review> reviewList = hostService.getAllReviewsByHost(hostId);

	    model.addAttribute("roomList", roomList);
	    model.addAttribute("reviewList", reviewList);

	    return "/host/fragment/reviewManage";
	}

	
	
	
	/** 호스트가 등록한 모든 숙소(ROOM)에 작성된 리뷰 전체
	 * AJAX 컨트롤러 (리뷰 목록 가져오기)
	 * @param roomSeq
	 * @param request
	 * @param model
	 * @return

	@RequestMapping("/host/fragment/reviewTable")
	public String ajaxReviews(@RequestParam(required = false) Integer roomSeq,
	                          HttpServletRequest request, Model model) {
	    String hostId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
	    if (StringUtil.isEmpty(hostId)) return "redirect:/";

	    List<Review> reviewList;

	    if (roomSeq == null || roomSeq == 0) {
	        reviewList = hostService.getAllReviewsByHost(hostId);
	    } else {
	        reviewList = reviewDao.selectReviewsByRoom(roomSeq);
	    }

	    model.addAttribute("reviewList", reviewList);
	    return "/host/fragment/reviewTable";
	}
	*/
	
	/**
	 * 판매자의 총 평균 평점 조회(누적, 연간, 월간, 주간)
	 * @param period
	 * @param session
	 * @return 
	 */
	@RequestMapping("/host/stat/avgRating")
	@ResponseBody
	public double getAvgRating(@RequestParam String period,
	                           @RequestParam(required = false) String periodDetail,
	                           HttpServletRequest request) {
	    String hostId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);

	    logger.debug("[HostController] getAvgRating hostId: {}", hostId);
	    logger.debug("[HostController] getAvgRating period: {}", period);
	    logger.debug("[HostController] getAvgRating periodDetail: {}", periodDetail);

	    // Java 8 기준 null 또는 빈 문자열 처리
	    String safePeriodDetail = (periodDetail != null && !periodDetail.trim().isEmpty()) 
	                                ? periodDetail 
	                                : "";

	    return hostService.getAvgRatingByHostWithPeriod(hostId, period, safePeriodDetail);
	}



	/**
	 * 기간(누적, 연간, 월간, 주간) 별로 총 판매 건수, 총 판매 금액, 평균 리뷰 평점 조회 d
	 * @param period
	 * @param session
	 * @return
	 */
	@RequestMapping("/host/statistics")
	@ResponseBody
	public Map<String, Object> getStatsByPeriod(@RequestParam String period, 
			@RequestParam(required = false) String periodDetail, 
			HttpServletRequest request) {
		String hostId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
	    if (hostId == null) {
	    	Map<String, Object> result = new HashMap<>();
	    	result.put("totalSales", 0);
	    	result.put("totalAmount", 0);
	    	result.put("avgRating", 0.0);
	    }	    

	    logger.debug("📊 [host/statistics 요청]");
	    logger.debug(" - hostId       : {}", hostId);
	    logger.debug(" - period        : {}", period);
	    logger.debug(" - periodDetail  : {}", periodDetail);
	    
	    Map<String, Object> result = new HashMap<>();
	    result.put("totalSales", hostService.getTotalSalesCount(hostId, period));
	    result.put("totalAmount", hostService.getTotalSalesAmount(hostId, period));
	    result.put("avgRating", hostService.getAvgRatingByHostWithPeriod(hostId, period, periodDetail));
	    
	    logger.debug("[호스트 통계 요청] hostId={}, period={}, periodDetail={}", hostId, period, periodDetail);
	    logger.debug("[호스트 통계 응답] result={}", result);

	    return result;
	}
	
	/**
	 * 날짜(연간, 월간, 주간)로 3개 검색
	 * @param period
	 * @param periodDetail
	 * @param request
	 * @return
	 */
	/*
	@GetMapping("/host/statistics")
	@ResponseBody
	public Map<String, Object> getStatsByPeriod(@RequestParam String period,
	                                            @RequestParam(required = false) String periodDetail,
	                                            HttpServletRequest request) {

	    String hostId = (String) SessionUtil.getSession(request.getSession(), AUTH_SESSION_NAME);
	    logger.debug("[호스트 통계 요청] hostId={}, period={}, periodDetail={}", hostId, period, periodDetail);

	    Map<String, Object> result = hostService.getStatsByPeriod(hostId, period, periodDetail);
	    logger.debug("[호스트 통계 응답] result={}", result);

	    return result;
	}
	*/


	
	
	
	
	
	
	
}
