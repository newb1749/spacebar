package com.sist.web.dao;

import java.util.List;

public interface FacilityDao {
	
	
    /**
     * ROOM에 속한 편의시설 조회
     * @param roomSeq
     * @return
     */
	public List<Integer> selectFacilitiesByRoomSeq(int roomSeq);

    
    // 숙소별 편의시설 전체 삭제
    public int deleteFacilitiesByRoomSeq(int roomSeq);

    // 숙소별 편의시설 추가
    // 이건 UserDao에 있음!!!!!!!!
    // public int insertRoomFacility(int roomSeq, int facSeq);
    
}	
