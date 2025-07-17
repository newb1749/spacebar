package com.sist.web.dao;

import java.util.List;

import com.sist.web.model.Alarm;

public interface AlarmDao {
    public void insertAlarm(Alarm alarm);               // 알림 등록
    public List<Alarm> selectAlarmList(String userId);  // 사용자 알림 전체 조회
    public void updateReadYn(int alarmSeq);             // 알림 읽음 처리
    public int countUnread(String userId);              // 읽지 않은 알림 수
}
