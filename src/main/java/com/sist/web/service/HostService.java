package com.sist.web.service;


import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.sist.web.dao.HostDao;
import com.sist.web.model.Room;

@Service
public class HostService {
    @Autowired
    private HostDao hostDao;
    
    /**
     * 판매자 본인이 등록한 숙소 리스트 조회
     * @param hostId
     * @return
     */
    public List<Room> selectRoomListByHostId(String hostId)
    {
    	return hostDao.selectRoomListByHostId(hostId);
    }
}
