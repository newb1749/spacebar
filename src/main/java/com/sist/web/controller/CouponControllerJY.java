package com.sist.web.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.sist.web.model.CouponJY;
import com.sist.web.service.CouponServiceJY;

@Controller("couponControllerJY")
@RequestMapping("/coupon")
public class CouponControllerJY 
{
    private static Logger logger = LoggerFactory.getLogger(CouponControllerJY.class);
    
    @Autowired
    private CouponServiceJY couponService;

    // 전체 쿠폰 목록 조회 페이지
    @RequestMapping(value = "/listJY", method = RequestMethod.GET)
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

    // 쿠폰 발급 처리 (Ajax)
    @PostMapping(value = "/issue", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> issueCoupon(@RequestParam("cpnSeq") int cpnSeq, HttpSession session) 
    {
        Map<String, Object> result = new HashMap<>();
        
        // 예시: 세션에서 userId 가져오기 (적절히 수정하세요)
        String userId = (String) session.getAttribute("userId");
        if (userId == null) 
        {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        
        try 
        {
            // 이미 발급되었는지 체크
            boolean alreadyIssued = couponService.isAlreadyIssued(userId, cpnSeq);
            if (alreadyIssued) 
            {
                result.put("success", false);
                result.put("message", "이미 발급된 쿠폰입니다.");
            } 
            else 
            {
                // 쿠폰 발급 처리
                couponService.issueCouponToUser(userId, cpnSeq);
                result.put("success", true);
                result.put("message", "쿠폰이 발급되었습니다.");
            }
        } 
        catch (Exception e) 
        {
            logger.error("[CouponControllerJY] issueCoupon Exception", e);
            result.put("success", false);
            result.put("message", "쿠폰 발급 중 오류가 발생했습니다.");
        }
        
        return ResponseEntity.ok(result);
    }
}
