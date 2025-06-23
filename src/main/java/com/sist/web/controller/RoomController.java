package com.sist.web.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;
import com.sist.web.service.RoomService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;


@Controller("roomController")
public class RoomController {
	
	private static Logger logger = LoggerFactory.getLogger(RoomController.class);
	
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	
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
     */	
	@RequestMapping(value="/room/addProc", method=RequestMethod.POST)
	public String addProc(MultipartHttpServletRequest request)
	{
		
//		String hostId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
//		
//		if(hostId == null || !StringUtil.isEmpty(hostId))
//		{
//			return "";
//		}
		// 임시!!!!!!!!!!!!!!!!!!!!!!
		String hostId = "nks";
		int roomCatSeq = 990;
		
		// 1-1. 화면에서 받은 Room 객체 관련 데이터 추출
		// 임시!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		// int roomCatSeq = HttpUtil.get(request, "roomCatSeq", 0);
		String roomAddr = HttpUtil.get(request, "roomAddr", "");
		double latitude = HttpUtil.get(request, "latitude", (double)0);
		double longitude = HttpUtil.get(request, "longitude", (double)0);
		String region = HttpUtil.get(request, "region", "");
		String regDt = HttpUtil.get(request, "regDt", "");
		String updateDt = HttpUtil.get(request, "updateDt", "");
		String autoConfirmYn = HttpUtil.get(request, "autoConfirmYn", "Y");
		String roomTitle = HttpUtil.get(request, "roomTitle", "");
		String roomDesc = HttpUtil.get(request, "roomDesc", "");
		String cancelPolicy = HttpUtil.get(request, "cancelPolicy", "");		
		short minTimes = HttpUtil.get(request, "minTimes", (short)0); 
		short maxTimes = HttpUtil.get(request, "maxTimes", (short)0);
		double averageRating = HttpUtil.get(request, "averageRating", (double)0);
		int reviewCount = HttpUtil.get(request, "reviewCount", 0);
		
		// 1-2. 객체 만들기
		Room room = new Room();
		room.setHostId(hostId);
		room.setRoomCatSeq(roomCatSeq);
		room.setRoomAddr(roomAddr);
		room.setLatitude(latitude);
		room.setLongitude(longitude);
		room.setRegion(region);
		room.setRegDt(regDt);
		room.setUpdateDt(updateDt);
		room.setAutoConfirmYn(autoConfirmYn);
		room.setRoomTitle(roomTitle);
		room.setRoomDesc(roomDesc);
		room.setCancelPolicy(cancelPolicy);
		room.setMinTimes(minTimes);
		room.setMaxTimes(maxTimes);
		room.setAverageRating(averageRating);
		room.setReviewCount(reviewCount);
		
		
		// 2. 숙소 이미지(RoomImage) 처리 (main/detail 분리)
		List<RoomImage> roomImageList = new ArrayList<>();
		String roomImgTypeMain = "main";
		String roomImgTypeDetail = "detail"; 
		
		// 2-1. 메인 이미지 처리(단일 파일)
		MultipartFile mainImageFile = request.getFile("roomMainImage");
		if(mainImageFile != null && !mainImageFile.isEmpty())
		{
            RoomImage mainRoomImage = new RoomImage();
            //mainRoomImage.setRoomImgName(mainImageFile.getFileName());
            //mainRoomImage.setRoomImgOrigName(mainImageFile.getFileOrgName());
            //mainRoomImage.setRoomImgExt(mainImageFile.getFileExt());
            //mainRoomImage.setImgSize((int)mainImageFile.getFileSize());
            mainRoomImage.setFile(mainImageFile); // [중요] MultipartFile 객체를 모델에 담음
//            mainRoomImage.setRoomImgOrigName(mainImageFile.getOriginalFilename());
//            mainRoomImage.setRoomImgExt(mainImageFile.getContentType());
//            mainRoomImage.setImgSize((int)mainImageFile.getSize());
            mainRoomImage.setImgType(roomImgTypeMain);
            mainRoomImage.setSortOrder((short)1);
            roomImageList.add(mainRoomImage);	
		}
		
		// 2-2. 상세 이미지 처리(파일 여러개)
		List<MultipartFile> detailImageFiles = request.getFiles("roomDetailImages");
		if(detailImageFiles != null && detailImageFiles.size() > 0)
		{
			short sortOrder = 2;
			for(MultipartFile file : detailImageFiles)
			{
//				RoomImage detailRoomImage = new RoomImage();
				//detailRoomImage.setRoomImgName(`.getFileName());
//				detailRoomImage.setRoomImgOrigName(fileData.getFileOrgName());
//				detailRoomImage.setRoomImgExt(fileData.getFileExt());
//				detailRoomImage.setImgSize((int)fileData.getFileSize());
//				detailRoomImage.setImgType(roomImgTypeDetail);
//				detailRoomImage.setSortOrder(sortOrder++);
//				roomImageList.add(detailRoomImage);	
                RoomImage detailRoomImage = new RoomImage();
                detailRoomImage.setFile(file); // [중요] MultipartFile 객체를 모델에 담음
                detailRoomImage.setImgType("detail");
                detailRoomImage.setSortOrder(sortOrder++);
                roomImageList.add(detailRoomImage);
			}
		}
		// room에 추가함. List<RoomImage> RoomImageList
		room.setRoomImageList(roomImageList);
		
		
		// 3. 객실 타입(RoomType) (방1개) 및 해당되는 이미지 처리
		List<RoomType> roomTypeList = new ArrayList<>();
		// 데이터 가져오기		
		String[] roomTypeTitles = HttpUtil.gets(request, "roomTypeTitle");
		String[] roomTypeDescs = HttpUtil.gets(request, "roomTypeDesc");		
		int[] weekdayAmts = HttpUtil.getInts(request, "weekdayAmt");
		int[] weekendAmts = HttpUtil.getInts(request, "weekendAmt");			
		String[] roomCheckInDts = HttpUtil.gets(request, "roomCheckInDt");
		String[] roomCheckOutDts = HttpUtil.gets(request, "roomCheckOutDt");
		String[] roomCheckInTimes = HttpUtil.gets(request, "roomCheckInTime");
		String[] roomCheckOutTimes = HttpUtil.gets(request, "roomCheckOutTime");
		
		short[] maxGuestsArr = HttpUtil.getShorts(request, "maxGuest");
		short[] minDays = HttpUtil.getShorts(request, "minDay");
		short[] maxDays = HttpUtil.getShorts(request, "maxDay");
		

		if (roomTypeTitles != null && roomTypeTitles.length > 0) {
            for (int i = 0; i < roomTypeTitles.length; i++) {
                RoomType roomType = new RoomType();
                // 각 배열의 i번째 값을 가져와 RoomType 객체에 설정합니다.
                roomType.setRoomTypeTitle(roomTypeTitles[i]);
                if (roomTypeDescs != null && roomTypeDescs.length > i) roomType.setRoomTypeDesc(roomTypeDescs[i]);
                if (weekdayAmts != null && weekdayAmts.length > i) roomType.setWeekdayAmt(weekdayAmts[i]);
                if (weekendAmts != null && weekendAmts.length > i) roomType.setWeekendAmt(weekendAmts[i]);
                if (roomCheckInDts != null && roomCheckInDts.length > i) roomType.setRoomCheckInDt(roomCheckInDts[i]);
                if (roomCheckOutDts != null && roomCheckOutDts.length > i) roomType.setRoomCheckOutDt(roomCheckOutDts[i]);
                if (roomCheckInTimes != null && roomCheckInTimes.length > i) roomType.setRoomCheckInTime(roomCheckInTimes[i]);
                if (roomCheckOutTimes != null && roomCheckOutTimes.length > i) roomType.setRoomCheckOutTime(roomCheckOutTimes[i]);
                if (maxGuestsArr != null && maxGuestsArr.length > i) roomType.setMaxGuests(maxGuestsArr[i]);
                if (minDays != null && minDays.length > i) roomType.setMinDay(minDays[i]);
                if (maxDays != null && maxDays.length > i) roomType.setMaxDay(maxDays[i]);

                // 각 객실 타입의 이미지도 HttpUtil로 처리합니다.
                List<RoomTypeImage> roomTypeImageList = new ArrayList<>();
                MultipartFile rtMainImage = request.getFile("roomTypeMainImage_" + i);
                if (rtMainImage != null) {
                    RoomTypeImage image = new RoomTypeImage();
                    
                    image.setFile(rtMainImage);
                    image.setImgType("main");
                    image.setSortOrder((short)1);
                    roomTypeImageList.add(image);                  
                }
                
                List<MultipartFile> rtDetailImages = request.getFiles("roomTypeDetailImages_" + i);
                if (rtDetailImages != null && rtDetailImages.size() > 0) {
                    short sortOrder = 2;
                    for (MultipartFile file : rtDetailImages) {
                        if (file != null && !file.isEmpty()) {
                            RoomTypeImage image = new RoomTypeImage();
                            image.setFile(file);
                            image.setImgType("detail");
                            image.setSortOrder(sortOrder++);
                            roomTypeImageList.add(image);
                        }
                    }
                }
                roomType.setRoomTypeImageList(roomTypeImageList);
                roomTypeList.add(roomType);
            }
        }

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
