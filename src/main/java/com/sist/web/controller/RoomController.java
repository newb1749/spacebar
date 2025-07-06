package com.sist.web.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.web.model.Paging;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.service.RoomImgService;
import com.sist.web.service.RoomService;
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
	private RoomService roomService;

	
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
	            if (roomService.insertRoomTransaction(room, roomTypeList) > 0) {
	                logger.debug("숙소 등록 성공");
	            } else {
	                logger.error("숙소 등록 실패");
	            }
	        } catch (Exception e) {
	            logger.error("[RoomController] addProc Exception", e);
	        }

        return "redirect:/";
    }
}
