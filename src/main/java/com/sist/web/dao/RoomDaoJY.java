package com.sist.web.dao;

import java.util.List;

import com.sist.web.model.Room;
import com.sist.web.model.RoomImage;

public interface RoomDaoJY 
{
    public Room getRoomDetail(int roomSeq);  // 세미콜론으로 끝남

    public List<RoomImage> getRoomImgDetail(int roomSeq);
    
    List<RoomImage> getRoomImagesByRoomSeq(int roomSeq);  // 세미콜론으로 끝나야 함
    
    String selectHostIdByRoomSeq(int roomSeq);
}
