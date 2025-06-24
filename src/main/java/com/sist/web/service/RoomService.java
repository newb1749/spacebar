package com.sist.web.service;

import java.io.File;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.dao.RoomDao;
import com.sist.web.dao.RoomImageDao;
import com.sist.web.dao.RoomTypeDao;
import com.sist.web.dao.RoomTypeImageDao;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;

@Service("roomService")
public class RoomService {
	
	private static Logger logger = LoggerFactory.getLogger(RoomService.class);
	
    @Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
    
	@Autowired
	private RoomDao roomDao;
	
	@Autowired
	private RoomTypeDao roomTypeDao;
	
	@Autowired
	private RoomImageDao roomImageDao;
	
	@Autowired
	private RoomTypeImageDao roomTypeImageDao;
	
	
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public int insertRoomTransaction(Room room, List<RoomType> roomTypeList)
    {
        int count = 0;
        
        try 
        {   
        	// 1. 숙소 기본 정보(ROOM) 저장
	        if (room != null) 
	        {	        
	            count += roomDao.insertRoom(room);
	            int newRoomSeq = room.getRoomSeq();
	            // 이 시점에 room 객체의 roomSeq 필드에는 새로 생성된 시퀀스 값이 채워짐
	            logger.debug("==================================");
	            logger.debug("New Room Seq: " + newRoomSeq);
	            logger.debug("room.getRoomSeq(): {}", room.getRoomSeq()); // 진짜 세팅됐는지 확인
	            logger.debug("==================================");
	            
	            // 2. 숙소 이미지(ROOM_IMAGE) 정보 저장
	            // Room 객체에 포함된 이미지 리스트를 가져와서 처리
	            // roomImageSeq는 mapper에서 쿼리로 만들어짐.
	            List<RoomImage> roomImageList = room.getRoomImageList();
		        logger.debug("이건찍히겠지11111111111111");	            
	            if (roomImageList != null && roomImageList.size() > 0) 
	            {	
	    	        logger.debug("이건찍히겠지22222222222222222");
	                for (RoomImage roomImage : roomImageList) 
	                {	
	                    logger.debug("roomImage: {}", roomImage);
	                    logger.debug(">> roomImage.getFile(): {}", roomImage.getFile());
	                    logger.debug(">> roomImage.getFile().isEmpty(): {}", 
	                        roomImage.getFile() != null ? roomImage.getFile().isEmpty() : "null");
	                    logger.debug(">> Before saveRoomImageFile(), roomSeq: {}", room.getRoomSeq());
	        	        logger.debug("이건찍히겠지333333333333333333");
	                	// 위에서 설정된 roomSeq를 넣어줌.
	                	saveRoomImageFile(roomImage, newRoomSeq);
	                	logger.debug("이건찍히겠지444444444444444444");
	                    logger.debug(">> Before insertRoomImage, roomImage.getRoomSeq(): {}", roomImage.getRoomSeq());
	                    count += roomImageDao.insertRoomImage(roomImage);
	                	logger.debug("이건찍히겠지55555555555555555555");
	                }
	            }
	        }
	        logger.debug("이건찍히겠지666666666666666666666");
	        logger.debug("roomTypeList is null? {}", (roomTypeList == null));
	        logger.debug("roomTypeList size: {}", (roomTypeList != null ? roomTypeList.size() : 0));
	        
	        // 3. 객실 타입(ROOM_TYPE) 정보 저장 (여러 개일 수 있음)
	        if (roomTypeList != null && roomTypeList.size() > 0) {
	            for (RoomType roomType : roomTypeList) {
	            	try
	            	{        	
		                // 부모 숙소의 roomSeq를 설정해줍니다.
		                roomType.setRoomSeq(room.getRoomSeq());
		                count += roomTypeDao.insertRoomType(roomType);
		                int newRoomTypeSeq = roomType.getRoomTypeSeq();
		                // 이 시점에 각 roomType 객체의 roomTypeSeq 필드에도 새로운 시퀀스 값이 채워짐
		                logger.debug("==================================");
		                logger.debug("New RoomType Seq: " + newRoomTypeSeq);
		                logger.debug("==================================");
		               
		                // 4. 객실 타입별 상세 이미지(ROOM_TYPE_IMAGE) 정보 저장
		                // roomTypeImageSeq는 mapper에서 쿼리로 만들어짐.
		                // RoomType 객체에 포함된 이미지 리스트를 가져와서 처리.
		                List<RoomTypeImage> roomTypeImageList = roomType.getRoomTypeImageList();
		                if (roomTypeImageList != null && roomTypeImageList.size() > 0) 
		                {
		                    for (RoomTypeImage roomTypeImage : roomTypeImageList) 
		                    {
		                    	// 위에서 설정된 roomTypeSeq를 넣어줌.
		                    	saveRoomTypeImageFile(roomTypeImage, newRoomTypeSeq);
		                        count += roomTypeImageDao.insertRoomTypeImage(roomTypeImage);
		                    }
		                }
	            	}
	            	catch(Exception e)
	            	{
	                    logger.error("[insertRoomTransaction] RoomType 처리 중 오류 발생", e);
	                    throw e;	            		
	            	}
	            }
	        }
        
        }
        catch(Exception e)
        {
        	logger.error("[RoomServiceImpl] insertRoomTransaction Exception : ", e);
          	throw new RuntimeException(e);
        }

        return count;
    }
    
    /**
     * RoomImage 파일을 저장하고 모델에 관련 정보를 채우는 헬퍼 메소드
     */
	    private void saveRoomImageFile(RoomImage roomImage, int roomSeq)
	    {	
	    	try
	    	{	
	    		if(roomImage == null || roomImage.getFile() == null || roomImage.getFile().isEmpty())
	    		{	
	    			logger.debug(">> 파일 없음: roomImage 또는 file 이 null/empty");
	    			return;
	    		}
	    		MultipartFile file = roomImage.getFile();
	    		// 이미지 타입(폴더명 : main, detail)
	    		String imgType = roomImage.getImgType();
	    		// 확장자 추출
	    		String roomImgExt = FileUtil.getFileExtension(file.getOriginalFilename());
	    		// 아마도 "C:upload\room\main"
	    		String saveDir = UPLOAD_SAVE_DIR + File.separator + "room" + File.separator + imgType;
	    		logger.debug(">> 이미지 ROOM_IMAGE 저장 경로: {}", saveDir);
	    		// 디렉토리가 존재하면 구분하는 코드가 포함되어 있음
	    		FileUtil.createDirectory(saveDir);
	    		logger.debug(">> saveRoomImageFile() set roomSeq1111: {}", roomImage.getRoomSeq());

	    		// RoomImage의 Seq 값 조회
	            // short newRoomImgSeq = roomImageDao.getRoomImageSeq();
	            short maxSeq = roomImageDao.selectMaxRoomImgSeq(roomSeq); // ex: 2
	            short newRoomImgSeq = (short) (maxSeq + 1); // 다음 이미지의 순번 = 3 
	    		// 파일명 설정(main, detail 구분)
	    		String fileName = (imgType.equals("main")) ?  
	    						  roomSeq + "." + roomImgExt :
	    					      roomSeq + "_" + newRoomImgSeq + "." + roomImgExt;
	    		
	    		File saveFile = new File(saveDir + File.separator + fileName);
	    		// 파일 저장
	    		file.transferTo(saveFile);
	    		// 데이터 채우기
	    		roomImage.setRoomSeq(roomSeq);
	    		logger.debug(">> saveRoomImageFile() set roomSeq2222: {}", roomImage.getRoomSeq());

	    		roomImage.setRoomImgSeq(newRoomImgSeq); 
	    		roomImage.setRoomImgName(fileName);
	    		roomImage.setRoomImgOrigName(file.getOriginalFilename());
	    		roomImage.setRoomImgExt(roomImgExt);
	    		roomImage.setImgSize((int)file.getSize()); // getSize는 long이여서 형변환
	    		
	    	}
	    	catch(Exception e)
	    	{
	    		logger.error("[RoomServiceImpl] saveRoomImageFile Exception : ", e);
	    	}
	    	logger.debug(">> After setRoomSeq, roomImage.getRoomSeq(): {}", roomImage.getRoomSeq());
	    	logger.debug(">> After setRoomImgSeq, roomImage.getRoomImgSeq(): {}", roomImage.getRoomImgSeq());

	    }
    
    
    
    /**
     * RoomTypeImage 파일을 저장하고 모델에 관련 정보를 채우는 헬퍼 메소드
     */
    private void saveRoomTypeImageFile(RoomTypeImage roomTypeImage, int roomTypeSeq) 
    {
    	try
    	{	
    		if(roomTypeImage == null || roomTypeImage.getFile() == null || roomTypeImage.getFile().isEmpty())
    		{
    			return;
    		}
    		
    		MultipartFile file = roomTypeImage.getFile();
    		// 이미지 타입(폴더명 : main, detail)
            String imgType = roomTypeImage.getImgType();
    		// 확장자 추출
    		String roomImgExt = FileUtil.getFileExtension(file.getOriginalFilename());
    		// 아마도 "C: upload\roomType\main"
    		String saveDir = UPLOAD_SAVE_DIR + File.separator + "roomType" + File.separator + imgType;
    		logger.debug(">> 이미지 IROOM_TYPE_IMAGE 저장 경로: {}", saveDir);
    		// 디렉토리가 존재하면 구분하는 코드가 포함되어 있음
    		FileUtil.createDirectory(saveDir);  		
    		
    		// RoomTypeImage의 Seq 값 조회
    		// short newRoomTypeImgSeq = roomTypeImageDao.getRoomTypeImageSeq();
            short maxSeq = roomTypeImageDao.selectMaxRoomTypeImgSeq(roomTypeSeq); // ex: 1
            short newRoomTypeImgSeq = (short) (maxSeq + 1); // 다음 이미지의 순번 = 2
    		// 파일명 설정(main, detail 구분)
    		String fileName = (imgType.equals("main")) ?  
    						  roomTypeSeq + "." + roomImgExt :
    					      roomTypeSeq + "_" + newRoomTypeImgSeq + "." + roomImgExt;
    		
    		File saveFile = new File(saveDir + File.separator + fileName);
    		// 파일 저장
    		file.transferTo(saveFile);
    		// 데이터 채우기
            roomTypeImage.setRoomTypeSeq(roomTypeSeq);
            roomTypeImage.setRoomTypeImgSeq(newRoomTypeImgSeq); 
            roomTypeImage.setRoomTypeImgName(fileName);
            roomTypeImage.setRoomTypeImgOrigName(file.getOriginalFilename());
            roomTypeImage.setRoomTypeImgExt(roomImgExt);
            roomTypeImage.setImgSize((int)file.getSize());   		
    		
    	}
    	catch(Exception e)
    	{
    		logger.error("[RoomServiceImpl] saveRoomTypeImageFile Exception : ", e);
    	}
    }
}
