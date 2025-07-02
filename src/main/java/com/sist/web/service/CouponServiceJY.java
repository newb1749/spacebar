package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.CouponDaoJY;
import com.sist.web.model.CouponJY;

@Service("couponServiceJY")
public class CouponServiceJY 
{
    private static final Logger logger = LoggerFactory.getLogger(CouponServiceJY.class);

    @Autowired
    private CouponDaoJY couponDao;

    public List<CouponJY> getAllCoupons() 
    {
        List<CouponJY> coupons = null;

        try
        {
            coupons = couponDao.selectAllCoupons();

            if(coupons != null) 
            {
                logger.debug("===== [CouponServiceJY] 쿠폰 개수: " + coupons.size() + " =====");
                for(CouponJY c : coupons) 
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
}