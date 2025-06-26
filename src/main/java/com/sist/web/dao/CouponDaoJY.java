package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import com.sist.web.model.CouponJY;

public interface CouponDaoJY 
{
    List<CouponJY> selectAllCoupons();

    // 유저가 쿠폰 이미 발급했는지 확인
    int countUserCoupon(@Param("userId") String userId, @Param("cpnSeq") int cpnSeq);

    // 쿠폰 발급 (user_coupon 테이블에 insert)
    int insertUserCoupon(@Param("userId") String userId, @Param("cpnSeq") int cpnSeq);
}
