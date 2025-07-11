package com.sist.web.dao;

import com.sist.web.model.MileageHistory;
import java.util.List;


import org.apache.ibatis.annotations.Param;


public interface MileageHistoryDao 
{
    /**
     * 특정 사용자의 마일리지 내역 조회
     * @param userId 사용자 ID
     * @return 마일리지 내역 리스트
     */
    List<MileageHistory> selectMileageHistoryByUserId(String userId);

    /**
     * 특정 사용자의 현재 마일리지 조회
     * @param userId 사용자 ID
     * @return 현재 마일리지 (null 가능)
     */
    Integer selectCurrentMileageByUserId(String userId);

    /**
     * 특정 사용자의 마일리지 차감 처리
     * @param userId 사용자 ID
     * @param amount 차감할 마일리지 양
     * @return 업데이트된 행 수
     */
    int updateMileageDeduct(@Param("userId") String userId,
            @Param("amount")  int amount);

    /**
     * 마일리지 거래 내역 추가
     * @param mileageHistory 마일리지 거래 내역 객체
     */
    void insertMileageHistory(MileageHistory mileageHistory);
    

    // 마일리지 충전 (환불 포함) 시 마일리지 증가
    int updateMileageAdd(@Param("userId") String userId, @Param("amount") int amount);


}