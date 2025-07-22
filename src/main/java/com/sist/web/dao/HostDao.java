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
	
	// host/main.jpg 에서 쓰임. 총 판매 건수 (결제 완료 건수)
	public int selectTotalSalesCountByPeriod(Map<String, Object> map);
	
	// host/main.jpg 에서 쓰임. 총 정산 금액 (FINAL_AMT 기준)
	public int selectTotalSalesAmountByPeriod(Map<String, Object> map);
	
	// 날짜로 3개 검색
	public Map<String, Object> getStatsByPeriod(Map<String, Object> param);


}
