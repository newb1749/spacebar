package com.sist.web.service;

import com.sist.web.model.MileageHistory;
import java.util.List;

import org.springframework.stereotype.Service;

/**
 * 마일리지 관련 서비스 인터페이스
 */
@Service
public interface MileageHistoryService 
{
 
    /**
     * 특정 사용자의 현재 마일리지 조회
     * @param userId 사용자 ID
     * @return 현재 마일리지
     */
    int getUserMileage(String userId);

    /**
     * 특정 사용자의 마일리지 차감 처리
     * @param userId 사용자 ID
     * @param amount 차감할 마일리지 양
     * @return 차감 성공 여부
     */
    boolean deductMileage(String userId, int amount);

    /**
     * 특정 사용자의 마일리지 거래 내역 조회
     * @param userId 사용자 ID
     * @return 마일리지 거래 내역 리스트
     */
    List<MileageHistory> getMileageHistory(String userId);
}