package com.sist.web.service;

import com.sist.web.dao.MileageHistoryDao;
import com.sist.web.model.MileageHistory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 마일리지 관련 서비스 클래스
 */
@Service
public class MileageHistoryService 
{

    @Autowired
    private MileageHistoryDao mileageHistoryDao;

    /**
     * 특정 사용자의 현재 마일리지 조회
     * @param userId 사용자 ID
     * @return 현재 마일리지
     */
    public int getUserMileage(String userId) 
    {
        Integer mileage = mileageHistoryDao.selectCurrentMileageByUserId(userId);
        return mileage != null ? mileage : 0;
    }

    /**
     * 특정 사용자의 마일리지 차감 처리
     * @param userId 사용자 ID
     * @param amount 차감할 마일리지 양
     * @return 차감 성공 여부
     */
    public boolean deductMileage(String userId, int amount)
    {
        int updated = mileageHistoryDao.updateMileageDeduct(userId, amount);
        if(updated > 0) 
        {
            MileageHistory history = new MileageHistory();
            history.setUserId(userId);
            history.setTrxType("DEDUCT");
            history.setTrxAmt(-amount);
            history.setTrxDt(new java.util.Date());
            history.setBalanceAfterTrx(getUserMileage(userId));
            mileageHistoryDao.insertMileageHistory(history);
            return true;
        }
        return false;
    }

    /**
     * 특정 사용자의 마일리지 거래 내역 조회
     * @param userId 사용자 ID
     * @return 마일리지 거래 내역 리스트
     */
    public List<MileageHistory> getMileageHistory(String userId) 
    {
        return mileageHistoryDao.selectMileageHistoryByUserId(userId);
    }
}
