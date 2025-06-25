package com.sist.web.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.web.model.CouponJY;
import com.sist.web.service.CouponServiceJY;

@Controller("couponControllerJY")
public class CouponControllerJY 
{
	private static Logger logger = LoggerFactory.getLogger(CouponControllerJY.class);
	
    @Autowired
    private CouponServiceJY couponService;

    // 전체 쿠폰 목록 조회 페이지
    @RequestMapping(value = "/coupon/listJY", method = RequestMethod.GET)
    public String couponList(Model model) 
    {
        List<CouponJY> couponList = null;
        
        try 
        {
            couponList = couponService.getAllCoupons();
        } 
        catch (Exception e) 
        {
            logger.error("[CouponControllerJY] couponList Exception", e);
        }
        
        model.addAttribute("couponList", couponList);
        return "/coupon/listJY";
    }
}
