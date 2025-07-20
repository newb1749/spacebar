package com.sist.web.service;


import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.FacilityDao;
import com.sist.web.dao.HostDao;
import com.sist.web.dao.RoomDao;
import com.sist.web.dao.RoomImageDao;
import com.sist.web.dao.RoomTypeDao;
import com.sist.web.dao.RoomTypeImageDao;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomType;
import com.sist.web.model.RoomTypeImage;



@Service
public class HostService {
	
	private static Logger logger = LoggerFactory.getLogger(HostService.class);
	
    @Autowired
    private HostDao hostDao;
    
	@Autowired
	private RoomDao roomDao;
	
	@Autowired
	private FacilityDao facilityDao;
	
	@Autowired
	private RoomImageDao roomImageDao;
	
	@Autowired
	private RoomTypeDao roomTypeDao;
	
	@Autowired
	private RoomTypeImageDao roomTypeImageDao;
	
	@Autowired
	private RoomServiceInterface roomService; 
		
	
	
    /**
     * 판매자 본인이 등록한 숙소 리스트 조회
     * @param hostId
     * @return
     */
    public List<Room> selectRoomListByHostId(String hostId)
    {
    	return hostDao.selectRoomListByHostId(hostId);
    }
    
    
    /**
     * 숙소 수정 로직
     * RoomServiceImpl에 있는 saveRoomImageFile,saveRoomTypeImageFile 메서드 사용
     * @param room
     * @param roomTypeList
     * @return
     */
    @Transactional
    public int updateRoomTransaction(Room room, List<RoomType> roomTypeList) {
        int count = 0;

        try {
            // 1-1. 숙소 정보 업데이트
            count += roomDao.updateRoom(room);

            // 1-2. 숙소 이미지 삭제 및 재등록
            // 이미지가 없는 경우에만 진행
            if (room.getRoomImageList() != null && !room.getRoomImageList().isEmpty()) {
            	// 삭제
                roomImageDao.deleteImagesByRoomSeq(room.getRoomSeq());
                
                short imgIndex = 0;
                
                // 이미지 재등록
                for (RoomImage image : room.getRoomImageList()) {
                    if (image.getFile() == null || image.getFile().isEmpty()) {
                        continue; // 파일이 없으면 건너뜀
                    }
                    
                    image.setRoomSeq(room.getRoomSeq());
                    
                	logger.debug(">>> room.getRoomSeq() before calling saveRoomImageFile: {}", room.getRoomSeq());
                	logger.debug(">>> [HostService] insert 전 roomImage.getRoomSeq(): {}", image.getRoomSeq());
                	
                    short imgSeq = (short)(imgIndex + 1);
                    roomService.saveRoomImageFile(image, room.getRoomSeq(), imgSeq);
                    
                    logger.debug(">>> [HostService] insert 전 roomImage 상태: {}", image);

                    count += roomImageDao.insertRoomImage(image);
                    imgIndex++;
                }
            }


            // 2-1. 객실 타입 및 이미지 업데이트
            if (roomTypeList != null && !roomTypeList.isEmpty()) {
            	for (RoomType rt : roomTypeList) {
            	    roomTypeDao.updateRoomType(rt);

            	    if (rt.getRoomTypeImageList() != null && !rt.getRoomTypeImageList().isEmpty()) {
            	        // 기존 이미지 삭제
            	        roomTypeImageDao.deleteImagesByRoomTypeSeq(rt.getRoomTypeSeq());

            	        // max 조회
            	        Short maxSeqObj = roomTypeImageDao.selectMaxRoomTypeImgSeq(rt.getRoomTypeSeq());
            	        short imgIdx = (maxSeqObj == null) ? 0 : maxSeqObj;

            	        for (RoomTypeImage image : rt.getRoomTypeImageList()) {
            	            short imgTypeSeq = ++imgIdx; // 여기부터 증가
            	            roomService.saveRoomTypeImageFile(image, rt.getRoomTypeSeq(), imgTypeSeq);
            	            count += roomTypeImageDao.insertRoomTypeImage(image);
            	        }
            	    }
            	}

            }
            logger.debug(">> [HostService] updateRoomTransaction 재삽입할 편의시설 목록: {}", room.getFacilityNos());

            // 3. 편의시설 재설정
            facilityDao.deleteFacilitiesByRoomSeq(room.getRoomSeq());	// 삭제
            if (room.getFacilityNos() != null) {
                for (int facNo : room.getFacilityNos()) {
                    count += facilityDao.insertRoomFacility(room.getRoomSeq(), facNo);
                }
            }

        } catch (Exception e) {
            logger.error("[HostService] updateRoomTransaction Exception : ", e);
            throw new RuntimeException("숙소 수정 중 오류 발생", e);
        }

        return count;
    }
    
    
    public int softDeleteRoom(int roomSeq) {
        return hostDao.softDeleteRoom(roomSeq);
    }

    public int stopSellingRoom(int roomSeq) {
        return hostDao.stopSellingRoom(roomSeq);
    }
    
    
    
    
}
