package com.sist.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.AlarmDao;
import com.sist.web.model.Alarm;

@Service("alarmService")
public class AlarmService {
	
	@Autowired
	private AlarmDao alarmDao;

    // 알림 등록
    public void insertAlarm(Alarm alarm) {
        alarmDao.insertAlarm(alarm);
    }
    
	// 사용자 알림 목록 조회
	public void inserAlarm(Alarm alarm)
	{
		alarmDao.insertAlarm(alarm);
	}
	
	// 특정 알림 읽음 처리
	public void readAlarm(int alarmSeq)
	{
		alarmDao.updateReadYn(alarmSeq);
	}
	
	// 안 읽은 알림 개수 조회
	public int getUnreadCount(String userId)
	{
		 return alarmDao.countUnread(userId);
	}
}
