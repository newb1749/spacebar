package com.sist.web.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.FacilityDao;
import com.sist.web.dao.HostDao;
import com.sist.web.dao.ReviewDao;
import com.sist.web.dao.RoomDao;
import com.sist.web.dao.RoomImageDao;
import com.sist.web.dao.RoomTypeDao;
import com.sist.web.dao.RoomTypeImageDao;
import com.sist.web.model.Review;
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
		
    @Autowired
    private ReviewDao reviewDao;
    
	
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
        
	// 판매 중지 해제
	public int resumeSellingRoom(int roomSeq) {
		return hostDao.resumeSellingRoom(roomSeq);
	}
    
	// 판매자가 등록한 방 목록 조회
    public List<Room> getRoomsByHost(String hostId) {
        return roomDao.selectRoomsByHostId(hostId);
    }
    
    // 호스트가 등록한 모든 숙소(ROOM)에 작성된 리뷰 전체
    public List<Review> getAllReviewsByHost(String hostId) {
        List<Review> list = reviewDao.selectAllReviewsByHost(hostId);
        System.out.println("📋 hostId = " + hostId + ", 리뷰 개수 = " + list.size());
        return list;
    }
    
    /**
     * 판매자의 총 평균 평점 조회(누적, 연간, 월간, 주간)
     * @param hostId 판매자
     * @param period 누적, 연간, 월간, 주간
     * @return 총 평균 평점
     */
    public double getAvgRatingByHostWithPeriod(String hostId, String period, String periodDetail) {
        Map<String, Object> map = new HashMap<>();
        map.put("hostId", hostId);
        map.put("period", period);
        map.put("periodDetail", periodDetail != null ? periodDetail : "");

        logger.debug("[HostService] getAvgRatingByHostWithPeriod hostId: {}", hostId);
        logger.debug("[HostService] getAvgRatingByHostWithPeriod period: {}", period);
        logger.debug("[HostService] getAvgRatingByHostWithPeriod periodDetail: {}", periodDetail);

        Double result = reviewDao.selectAvgRatingByHostWithPeriod(map);
        return result != null ? result : 0.0;
    }

    
    	
    /**
     * 총 판매 건수 (결제 완료 건수)
     * @param hostId
     * @param period
     * @return
     */
    public int getTotalSalesCount(String hostId, String period) {
        Map<String, Object> map = new HashMap<>();
        map.put("hostId", hostId);
        map.put("period", period);
        return hostDao.selectTotalSalesCountByPeriod(map);
    }
    
    /**
     * 총 정산 금액 (FINAL_AMT 기준)
     * @param hostId
     * @param period
     * @return
     */
    public int getTotalSalesAmount(String hostId, String period) {
        Map<String, Object> map = new HashMap<>();
        map.put("hostId", hostId);
        map.put("period", period);
        return hostDao.selectTotalSalesAmountByPeriod(map);
    }
    
    /**
     * 
     * @param hostId
     * @param period
     * @param periodDetail
     * @return
     */
    public Map<String, Object> getStatsByPeriod(String hostId, String period, String periodDetail) {
        Map<String, Object> param = new HashMap<>();
        param.put("hostId", hostId);
        param.put("period", period);
        param.put("periodDetail", periodDetail != null ? periodDetail : "");

        logger.debug("[Service - getStatsByPeriod] 파라미터: {}", param);

        Map<String, Object> result = hostDao.getStatsByPeriod(param);
        logger.debug("[Service - getStatsByPeriod] 결과: {}", result);

        return result;
    }



}
