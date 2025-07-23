package com.sist.web.dao;

import java.util.List;
import java.util.Map;

import com.sist.web.model.Room;
import com.sist.web.model.User;

public interface HostDao {
	
	/**
	 * 본인(HOST_ID) 소유 숙소/공간 리스트
	 * @param hostId
	 * @return 숙소(ROOM) 리스트
	 */
	public List<Room> selectRoomListByHostId(String hostId);
	// 소프트 삭제
	public int softDeleteRoom(int roomSeq);
	// 판매 중지
	public int stopSellingRoom(int roomSeq); 
	// 판매 중지 해제
	public int resumeSellingRoom(int roomSeq);
	
	
	/** [기간별 통계]
	 * host/main.jpg 에서 쓰임. 총 판매 건수 (결제 완료 건수)
	 * @param map  hostId, startDate, endDate
	 * @return
	 */
	public int selectTotalSalesCountByPeriod(Map<String, Object> map);
	
	
	// 
	/** [기간별 통계]
	 * host/main.jpg 에서 쓰임. 총 정산 금액 (FINAL_AMT 기준)
	 * 정산 기준 금액(FINAL_AMT)
	 * @param map hostId, startDate, endDate
	 * @return
	 */
	public int selectTotalSalesAmountByPeriod(Map<String, Object> map);
	
	// 날짜로 3개 검색. 이거 안씀
	/**
	 * 
	 * @param param  hostId, startDate, endDate
	 * @return salesCount, salesAmount, avgRating 포함된 Map 반환
	 */
	public Map<String, Object> getStatsByPeriod(Map<String, Object> param);
	
    /**
     * 기간별(주/월) 통계 데이터를 가져옴
     * @param param hostId, startDate, endDate, groupBy 포함
     * @return label, salesCount, salesAmount, avgRating 컬럼 포함된 리스트
     */
    public List<Map<String, Object>> selectStatsByGroup(Map<String, Object> param);
	
}
