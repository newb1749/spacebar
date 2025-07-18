package com.sist.web.service;

import java.io.File;
import java.util.List;

import javax.annotation.PostConstruct;

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

@Service("roomServiceImpl")
public class RoomServiceImpl implements RoomServiceInterface {
	
	private static Logger logger = LoggerFactory.getLogger(RoomServiceImpl.class);
	
    @Value("#{env['upload.save.dir']}")
	private String uploadSaveDirNonStatic;
    
    private static String UPLOAD_SAVE_DIR;
    
    @PostConstruct
    public void init() {
        UPLOAD_SAVE_DIR = this.uploadSaveDirNonStatic;
    }
    
	@Autowired
	private RoomDao roomDao;
	
	@Autowired
	private RoomTypeDao roomTypeDao;
	
	@Autowired
	private RoomImageDao roomImageDao;
	
	@Autowired
	private RoomTypeImageDao roomTypeImageDao;
	
	
    @Override
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
	            
           
	            // 2. 편의시설 시퀀스값 저장(db 컬럼엔 없음)
	            List<Integer> facilityNos = room.getFacilityNos();
	            if(facilityNos != null && !facilityNos.isEmpty())
	            {
	            	for(Integer facNo : facilityNos)
	            	{
	            		logger.debug("Inserting Room-Facility Map: roomSeq={}, facSeq={}", newRoomSeq, facNo);
	            		// ROOM_FACILITY : (roomSeq, facSeq) 복합키
	            		count += roomDao.insertRoomFacility(newRoomSeq, facNo);
	            	}
	            }
	            
	            // 3. 숙소 이미지(ROOM_IMAGE) 정보 저장
	            // Room 객체에 포함된 이미지 리스트를 가져와서 처리
	            // roomImageSeq는 mapper에서 쿼리로 만들어짐.
	            List<RoomImage> roomImageList = room.getRoomImageList();	            
	            if (roomImageList != null && roomImageList.size() > 0) 
	            {	

	                for (RoomImage roomImage : roomImageList) 
	                {	
	                    logger.debug("roomImage: {}", roomImage);
	                    logger.debug(">> roomImage.getFile(): {}", roomImage.getFile());
	                    logger.debug(">> roomImage.getFile().isEmpty(): {}", 
	                        roomImage.getFile() != null ? roomImage.getFile().isEmpty() : "null");
	                    logger.debug(">> Before saveRoomImageFile(), roomSeq: {}", room.getRoomSeq());

	                	// 위에서 설정된 roomSeq를 넣어줌.
	                	saveRoomImageFile(roomImage, newRoomSeq);

	                    logger.debug(">> Before insertRoomImage, roomImage.getRoomSeq(): {}", roomImage.getRoomSeq());
	                    count += roomImageDao.insertRoomImage(roomImage);

	                }
	            }
	        }
	 
	        logger.debug("roomTypeList is null? {}", (roomTypeList == null));
	        logger.debug("roomTypeList size: {}", (roomTypeList != null ? roomTypeList.size() : 0));
	        
	        // 4. 객실 타입(ROOM_TYPE) 정보 저장 (여러 개일 수 있음)
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
		               
		                // 5. 객실 타입별 상세 이미지(ROOM_TYPE_IMAGE) 정보 저장
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
	                    logger.error("[RoomServiceImpl] insertRoomTransaction 처리 중 오류 발생", e);
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
    	@Override
    	public void saveRoomImageFile(RoomImage roomImage, int roomSeq)
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
    	
    	
	    public void saveRoomImageFile(RoomImage roomImage, int roomSeq, short roomImgSeq)
	    {
	        logger.debug(">>> [saveRoomImageFile] 매개변수로 받은 roomSeq: {}", roomSeq);
	        logger.debug(">>> [saveRoomImageFile] roomImage 초기 상태: {}", roomImage);
	        logger.debug(">>> 파일 이름: {}", roomImage.getFile().getOriginalFilename());

	        try
	        {
	            if (roomSeq == 0) {
	                logger.warn(">>> roomSeq가 0입니다. 파일명을 만들 수 없습니다. 이미지 저장 중단.");
	                return;
	            }

	            if (roomImage == null || roomImage.getFile() == null || roomImage.getFile().isEmpty()) {
	                logger.debug(">> 파일 없음: roomImage 또는 file 이 null/empty");
	                return;
	            }

	            MultipartFile file = roomImage.getFile();
	            String imgType = roomImage.getImgType();
	            String roomImgExt = FileUtil.getFileExtension(file.getOriginalFilename());
	            String saveDir = UPLOAD_SAVE_DIR + File.separator + "room" + File.separator + imgType;
	            FileUtil.createDirectory(saveDir);

	            // 파일명 설정(main, detail 구분)
	            String fileName = (imgType.equals("main")) ?
	                    roomSeq + "." + roomImgExt :
	                    roomSeq + "_" + roomImgSeq + "." + roomImgExt;

	            File saveFile = new File(saveDir + File.separator + fileName);
	            file.transferTo(saveFile);

	            // 정보 저장
	            roomImage.setRoomSeq(roomSeq);
	            roomImage.setRoomImgSeq(roomImgSeq);
	            roomImage.setRoomImgName(fileName);
	            roomImage.setRoomImgOrigName(file.getOriginalFilename());
	            roomImage.setRoomImgExt(roomImgExt);
	            roomImage.setImgSize((int) file.getSize());

	            logger.debug(">> After setRoomSeq, roomImage.getRoomSeq(): {}", roomImage.getRoomSeq());
	            logger.debug(">> After setRoomImgSeq, roomImage.getRoomImgSeq(): {}", roomImage.getRoomImgSeq());

	        } catch (Exception e) {
	            logger.error("[RoomServiceImpl] saveRoomImageFile Exception : ", e);
	        }
	    }

    
    /**
     * RoomTypeImage 파일을 저장하고 모델에 관련 정보를 채우는 헬퍼 메소드
     */
    @Override
    public void saveRoomTypeImageFile(RoomTypeImage roomTypeImage, int roomTypeSeq) 
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
    
    
    public void saveRoomTypeImageFile(RoomTypeImage image, int roomTypeSeq, short newImgSeq) {
        logger.debug(">>> [saveRoomTypeImageFile] roomTypeSeq: {}", roomTypeSeq);
        logger.debug(">>> [saveRoomTypeImageFile] newImgSeq: {}", newImgSeq);

        if (roomTypeSeq == 0) {
            logger.warn(">>> roomTypeSeq가 0입니다. 저장 중단.");
            return;
        }

        if (image == null || image.getFile() == null || image.getFile().isEmpty()) {
            logger.debug(">>> 파일이 없음. 저장 중단.");
            return;
        }

        try {
            MultipartFile file = image.getFile();
            String imgType = image.getImgType(); // 보통 "detail"
            String roomTypeImgExt = FileUtil.getFileExtension(file.getOriginalFilename());
            String saveDir = UPLOAD_SAVE_DIR + File.separator + "roomType" + File.separator + imgType;
            FileUtil.createDirectory(saveDir);

            // 파일명 생성: 예) 55_1.jpg
            String fileName = roomTypeSeq + "_" + newImgSeq + "." + roomTypeImgExt;
            File saveFile = new File(saveDir + File.separator + fileName);
            file.transferTo(saveFile);

            // 객체에 정보 주입
            image.setRoomTypeSeq(roomTypeSeq);
            image.setRoomTypeImgSeq(newImgSeq);
            image.setRoomTypeImgName(fileName);
            image.setRoomTypeImgOrigName(file.getOriginalFilename());
            image.setRoomTypeImgExt(roomTypeImgExt);
            image.setImgSize((int) file.getSize());

            logger.debug(">>> 저장 완료 준비된 image: {}", image);

        } catch (Exception e) {
            logger.error("[RoomServiceImpl] saveRoomTypeImageFile Exception : ", e);
        }
    }

    
}
