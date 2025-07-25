package com.sist.web.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.sist.web.model.Facility;
import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;
import com.sist.web.model.RoomTypeImage;

public interface RoomDao {
	
    /**
     * * @param room DB에 저장할 숙소 정보가 담긴 Room 객체.
     * <selectKey>에 의해 insert 실행 후, room 객체의 roomSeq 필드에는
     * 새로 생성된 시퀀스 값이 자동으로 채워집니다. b
     * 숙소 등록 by nks
     * @return INSERT가 성공적으로 수행된 행의 수 (일반적으로 1)
     */
    public int insertRoom(Room room);
    
    /**
     * 숙소 편의시설 매핑 정보 삽입
     * @param roomSeq 숙소 번호 (FK)
     * @param facSeq 편의시설 번호 (FK)
     * @return 추가된 행의 수
     */
    public int insertRoomFacility(@Param("roomSeq") int roomSeq, @Param("facSeq") int facSeq);

    
    
    public Room getRoomDetail(int roomSeq); 
    // roomSeq로 룸 
    public List<RoomImage> getRoomImgDetail(int roomSeq);
    
    public List<RoomImage> getRoomImagesByRoomSeq(int roomSeq);  
    
    public String selectHostIdByRoomSeq(int roomSeq);
    
    //룸 리스트 총 개수
  	public long roomListCount(Room room);
  	
  	//룸 리스트
  	public List<Room> roomList(Room room);
  	
  	//최신순 숙소
  	public List<Room> newRoomList();
  	

  	//최신순 공간
  	public List<Room> newSpaceList();

  	//편의시설 리스트
  	public List<Facility> facilityList(int roomSeq);
  	
  	//마이페이지용 호스트의 숙소 리스트 조회
  	public List<Room> selectHostRoomList(String hostId);
  	
  	//룸 타입 이미지 리스트
  	public List<RoomTypeImage> getRoomTypeImgDetail(int roomTypeSeq);
  	
  	public RoomTypeImage getRoomTypeImgMain(int roomTypeSeq);

    /**
     * 숙소 정보 수정
     */
    public int updateRoom(Room room);
    
    /**
     * 판매자가 등록한 숙소 목록 조회
     * @param hostId
     * @return
     */
    public List<Room> selectRoomsByHostId(String hostId);
    
    /**
     * 좌표가 없는 숙소 목록을 조회하는 메서드
     * @return 좌표 없는 숙소의 SEQ, 주소(ADDRESS)가 담긴 Map의 리스트
     */
    public List<Map<String, Object>> findRoomsWithoutCoordinates();

    /**
     * 특정 숙소(roomSeq)의 위도, 경도 좌표를 업데이트하는 메서드
     * @param roomSeq 업데이트할 숙소의 기본 키 (PK)
     * @param latitude 새로운 위도
     * @param longitude 새로운 경도
     */
    public void updateRoomCoordinates(@Param("roomSeq") long roomSeq,
                                      @Param("latitude") double latitude,
                                      @Param("longitude") double longitude);
    
}


