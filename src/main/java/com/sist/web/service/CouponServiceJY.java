package com.sist.web.service;

import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.CouponDao;
import com.sist.web.model.Coupon;

@Service("couponServiceJY")
public class CouponServiceJY 
{
    private static final Logger logger = LoggerFactory.getLogger(CouponServiceJY.class);

    @Autowired
    private CouponDao couponDao;

    public List<Coupon> getAllCoupons() 
    {
        List<Coupon> coupons = null;

        try
        {
            coupons = couponDao.selectAllCoupons();

            if(coupons != null) 
            {
                logger.debug("===== [CouponServiceJY] 쿠폰 개수: " + coupons.size() + " =====");
                for(Coupon c : coupons) 
                {
                    logger.debug(">> 쿠폰명: " + c.getCpnName() + ", 할인율: " + c.getDiscountRate() + ", 할인금액: " + c.getDiscountAmt());
                }
            } 
            else 
            {
                logger.debug("===== [CouponServiceJY] 쿠폰 리스트가 0입니다 =====");
            }
        }
        catch(Exception e) 
        {
            logger.error("[CouponServiceJY] getAllCoupons Exception", e);
        }

        return coupons;
    }

    // 유저가 이미 발급받은 쿠폰인지 확인
    public boolean isAlreadyIssued(String userId, int cpnSeq) 
    {
        int count = 0;
        try  
        {
            count = couponDao.countUserCoupon(userId, cpnSeq);
        } 
        catch(Exception e)
        {
            logger.error("[CouponServiceJY] isAlreadyIssued Exception", e);
        }
        return count > 0;
    }

    // 쿠폰 발급 처리
    public void issueCouponToUser(String userId, int cpnSeq) throws Exception 
    {
        try 
        {
            couponDao.insertUserCoupon(userId, cpnSeq);
            logger.debug("[CouponServiceJY] 쿠폰 발급 완료 userId=" + userId + ", cpnSeq=" + cpnSeq);
        } 
        catch(Exception e) 
        {
            logger.error("[CouponServiceJY] issueCouponToUser Exception", e);
            throw e;  // 예외 다시 던져서 컨트롤러가 알 수 있도록
        }
    }
    
    //마이페이지용 (쿠폰 조회)
    public List<Coupon> couponListByUser(String userId)
    {
    	List<Coupon> list = null;
    	
        try 
        {
        	list = couponDao.couponListByUser(userId);
        } 
        catch(Exception e) 
        {
            logger.error("[CouponServiceJY] couponListByUser Exception", e);
        }
    	
    	return list;
    }
    public List<Coupon> getAvailableCouponsForUser(String userId) 
    {
        Date now = new Date();
        return couponDao.selectValidCouponsByUserId(userId);
    }

    public Coupon getCouponBySeq(Integer couponSeq) {
        if (couponSeq == null) return null;
        return couponDao.selectCouponBySeq(couponSeq);
    }
    
    public void markCouponAsUsed(String userId, int cpnSeq) {
        logger.debug("markCouponAsUsed called with userId={}, cpnSeq={}", userId, cpnSeq);
        int updatedRows = couponDao.markCouponAsUsed(userId, cpnSeq);
        if (updatedRows == 0) {
            logger.warn("쿠폰 사용 처리 실패: userId={}, cpnSeq={}", userId, cpnSeq);
        } else {
            logger.debug("쿠폰 사용 완료 처리 성공: userId={}, cpnSeq={}", userId, cpnSeq);
        }
    }

    //마이페이지용(쿠폰 총 갯수)
    public int couponCountByUser(String userId)
    {
    	int count = 0;
    	
        try 
        {
        	count = couponDao.couponCountByUser(userId);
        } 
        catch(Exception e) 
        {
            logger.error("[CouponServiceJY] couponCountByUser Exception", e);
        }
    	
    	return count;
    }
}