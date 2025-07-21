package com.sist.web.dao;

import java.util.List;
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
}
