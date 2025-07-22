package com.sist.web.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import com.sist.web.model.Coupon;

public interface CouponDao 
{
    List<Coupon> selectAllCoupons();

    // 유저가 쿠폰 이미 발급했는지 확인
    int countUserCoupon(@Param("userId") String userId, @Param("cpnSeq") int cpnSeq);

    // 쿠폰 발급(user_coupon 테이블에 insert)
    int insertUserCoupon(@Param("userId") String userId, @Param("cpnSeq") int cpnSeq);
    
    //마이페이지용 (쿠폰 조회)
    List<Coupon> couponListByUser(String userId);

    // 로그인한 사용자의 현재 날짜 기준 유효 쿠폰 조회
    //List<Coupon> selectValidCouponsByUserId(@Param("now") Date now, @Param("userId") String userId);
    List<Coupon> selectValidCouponsByUserId(String userId);
    
    Coupon selectCouponBySeq(@Param("cpnSeq") Integer couponSeq);

    int markCouponAsUsed(@Param("userId") String userId, @Param("cpnSeq") int cpnSeq);
}