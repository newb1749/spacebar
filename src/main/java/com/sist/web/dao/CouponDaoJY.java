package com.sist.web.dao;

import java.util.List;
import com.sist.web.model.CouponJY;
import org.springframework.stereotype.Repository;

@Repository("couponDaoJY")
public interface CouponDaoJY 
{
    List<CouponJY> selectAllCoupons();
}