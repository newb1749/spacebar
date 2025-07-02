package com.sist.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.MileageDaoJY;

@Service
public class MileageServiceJY {

    @Autowired
    private MileageDaoJY MileageDaoJY;

    /**
     * 현재 로그인된 사용자의 마일리지 조회
     */
    public int getUserMileage(String userId) {
        return MileageDaoJY.getMileageByUserId(userId);
    }

    /**
     * 마일리지 차감 처리
     */
    public boolean deductMileage(String userId, int amount) {
        int updated = MileageDaoJY.deductMileage(userId, amount);
        return updated > 0;
    }

    /**
     * 마일리지 충전 처리
     */
    public void chargeMileage(String userId, int amount) {
    	MileageDaoJY.addMileage(userId, amount);
    }

    /**
     * 마일리지 사용/충전 내역 기록
     */
    public void insertMileageHistory(String userId, int amount, String type, String description) {
    	MileageDaoJY.insertMileageHistory(userId, amount, type, description);
    }
}